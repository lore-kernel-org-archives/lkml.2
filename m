Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab0HUNuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:50:16 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:25261 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751459Ab0HUNuO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:50:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=a3vxVuo5riau5jaJm6QUHiV0M8SEC1YgoY2LNhpAo8Zd655+J+i3y/7T0wdM+fy0+OIcX2P1LF7MZBejKY5QjHBS1yaafYp7MPyF8whQefP2voz006Lc69bsIwWH+5wdj3VElV7wC0PPJeLYwivOwJCptfN7sAIhGpG8JaSCr70=;
Message-ID: <292036.65081.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: owVRwo8VM1nIjgxavTgBlVjhUwdo5c_.HBRvkRCsRJeAgL7
 i0X2.t9iTsceIhm4x.GApo5icBxgsbgEECaTjCb1iz1hUCvgZ6GmpB3bj_9b
 jkNCTHv7Uje3ugeUJMLN.rHIMFsiMdWnR5N0J0etxOIx2J0vMhVkNDtKcPaV
 g8VXdvn._u7_cmW59LWAJTl2HF8OxmPo8ie5UqXDig_POxixFovsot1LqsQ8
 y9e7uqHd5wRz72GyYmeXnYUMVjELjO23qiLnVT.uPGBEa2PyPVRCE3luXyrU
 pgVCr12JrmHe5Yai0DtvRrB.r.lD2S4RZ69ezwVZi.kv70peHAavwAVc-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 21 Aug 2010 06:50:12 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] My work on MemoryStick system
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1282352917.13597.5.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I just tested this series with Jmicron, and unfortunelly
> there are bugs.
> 
> * driver refuses to handle 26 byte TPC I use to read regs
> (sizeof(ms_registers). If I bump it to 32, it works.

It will work with any multiply of 4 (24 and 28 work as well). It's a known
"feature".

> 
> * With this fix first few reads still fail.
> That means that card isn't detected always because boot
> blocks might not
> be read.
> Later card works fine.
> 
> * Also I found out that msproblk.c allocates memory for
> attributes IO
> using stock kmalloc, and hangs that to driver.
> However if driver doesn't support such address, it will
> fail.

Why would hardware do anything at all with attribute memory space?

> I fixed that in my driver by properly calling dma_unmap_sg,
> and thus
> using SWIOTLB if necessary.
> But Jmicron driver doesn't unmap its sg.
> (Yet the system with Jmicron device has just one GB, so
> this isn't the
> problem I am seeing).
> 



      
