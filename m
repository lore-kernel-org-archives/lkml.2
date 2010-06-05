Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab0FERVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:21:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48757 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab0FERVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=OuVi/Ff4NUXM+zYOsHU/NnD4+SQctQ712zqXNPQ5k44rbag/WxQDdyqJ4areBNcfuK
         8+a+Rqy9zgFGfEf5VkIPUZvC1gcPuZ1a2zWkgO+DE12JeC9XlZ84Gd88A3dq9iTjWB2r
         eYAAt/foDIDj6B/ESnZSDEckn9K+i4y5N1yEo=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: pxa300 - DDRAM base value
Date: Sat, 5 Jun 2010 19:19:17 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: balakrishnan <balakrishnan@e-consystems.com>, linux-kernel@vger.kernel.org,
       Maharajan <maharajan@e-consystems.com>,
       Eric Miao <eric.y.miao@gmail.com>
References: <1275371058.7001.35.camel@balakrishnan-desktop>
In-Reply-To: <1275371058.7001.35.camel@balakrishnan-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006051919.17738.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 1. června 2010 07:44:18 balakrishnan napsal(a):
> I am working on pxa300 based development board and using Linux 2.6.34.
> This Linux kernel already has support for following boards
> 1. zylonite_pxa300
> 2. cm-x300
> 3. colibri-pxa300
> 4. littleton
> 
> My doubt is that pxa300 based boards are using "0xa0000000"  as DDRAM
> base and PHYS_OFFSET is also defined in
> "arch/arm/mach-pxa/include/mach/memory.h" as 0xa0000000.
> But in our board  DDR is mapped in 0x80000000. Does it make any
> problem?. Because after mmu is turned ON, my board is hanging.
> 
> "zreladdr-y   := 0x80008000" is defined in
> "arch/arm/mach-pxa/Makefile.boot" file .
> my machine_desc is as follows
> .phys_io        = 0x40000000,
> .io_pg_offst    = (io_p2v(0x40000000) >> 18) & 0xfffc,
> .boot_params    = 0x80000100,
> 

Try editing both arch/arm/mach-pxa/Makefile.boot and 
arch/arm/mach/pxa/include/mach/memory.h

> With Thanks
> J.Balakrishnan

The 0x80000000 should be aliased to 0xa0000000, but looking into the PXA docs, 
it is only on pxa320. Eric, any ideas on this ?
