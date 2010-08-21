Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab0HUBIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 21:08:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38927 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0HUBIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 21:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=llp7yILXuX5JiD3lOkmlXSys9xgYU43Th7rC6At8BVHq279JcSAB70VqwyWo2y1iFO
         w0m/0xIjOuFikETGcTuGHYRfaZDc/Xt4P8iy9ISnm2MqI30ZWm/d+WjnFo2t0/rtUc9e
         yKpYVzMMjzBw3MCJiSWMke4prbSNICLZoCCJ8=
Subject: Re: [PATCH] My work on MemoryStick system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1282263305-4048-1-git-send-email-maximlevitsky@gmail.com>
References: <1282263305-4048-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 04:08:37 +0300
Message-ID: <1282352917.13597.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 03:15 +0300, Maxim Levitsky wrote: 
> Hi,
> 
> This patch series contains the work I did for memorystick subsystem.
> 
> I resend slightly cleaned up driver for my card reader in patch #2
> patch #1 and #3 are new and add support for Legacy MemorySticks (<= 128MB)
> 
> Everything works and more or less tested.
> 
> Best regards,
> 	Maxim Levitsky
> 
> 

I just tested this series with Jmicron, and unfortunelly there are bugs.

* driver refuses to handle 26 byte TPC I use to read regs
(sizeof(ms_registers). If I bump it to 32, it works.

* With this fix first few reads still fail.
That means that card isn't detected always because boot blocks might not
be read.
Later card works fine.

* Also I found out that msproblk.c allocates memory for attributes IO
using stock kmalloc, and hangs that to driver.
However if driver doesn't support such address, it will fail.
I fixed that in my driver by properly calling dma_unmap_sg, and thus
using SWIOTLB if necessary.
But Jmicron driver doesn't unmap its sg.
(Yet the system with Jmicron device has just one GB, so this isn't the
problem I am seeing).


Best regards,
Maxim Levitsky


