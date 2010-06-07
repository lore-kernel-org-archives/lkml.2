Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0FGHAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:00:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38955 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab0FGHAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=duuxvOn1KC6+i2r6x8LjGSK0LLv9wv/b0hEJInZU5ZOVOMHCyC0Ad7A+j4sq6iTapS
         TvlH4uI9yqyMnx9MQ7S3sbVoZdMgHaG3s59oBZ3JIlLM00Zo6gECJK87YwlyF2Sj5hNZ
         hF6GF9BSM/+Q3b7SMkpPqri2h5vE/5IYC5UAU=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: balakrishnan <balakrishnan@e-consystems.com>
Subject: Re: pxa300 - DDRAM base value
Date: Mon, 7 Jun 2010 08:58:36 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, Maharajan <maharajan@e-consystems.com>
References: <1275371058.7001.35.camel@balakrishnan-desktop> <201006061834.50297.marek.vasut@gmail.com> <1275892191.3501.17.camel@balakrishnan-desktop>
In-Reply-To: <1275892191.3501.17.camel@balakrishnan-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006070858.36341.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 7. června 2010 08:29:51 balakrishnan napsal(a):
> On Sun, 2010-06-06 at 18:34 +0200, Marek Vasut wrote:
> > Dne Ne 6. června 2010 10:17:00 Eric Miao napsal(a):
> > > On Sun, Jun 6, 2010 at 1:19 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > > > Dne Út 1. června 2010 07:44:18 balakrishnan napsal(a):
> > > >> I am working on pxa300 based development board and using Linux
> > > >> 2.6.34. This Linux kernel already has support for following boards
> > > >> 1. zylonite_pxa300
> > > >> 2. cm-x300
> > > >> 3. colibri-pxa300
> > > >> 4. littleton
> > > >> 
> > > >> My doubt is that pxa300 based boards are using "0xa0000000"  as
> > > >> DDRAM base and PHYS_OFFSET is also defined in
> > > >> "arch/arm/mach-pxa/include/mach/memory.h" as 0xa0000000.
> > > >> But in our board  DDR is mapped in 0x80000000. Does it make any
> > > >> problem?. Because after mmu is turned ON, my board is hanging.
> > > >> 
> > > >> "zreladdr-y   := 0x80008000" is defined in
> > > >> "arch/arm/mach-pxa/Makefile.boot" file .
> > > >> my machine_desc is as follows
> > > >> .phys_io        = 0x40000000,
> > > >> .io_pg_offst    = (io_p2v(0x40000000) >> 18) & 0xfffc,
> > > >> .boot_params    = 0x80000100,
> > > > 
> > > > Try editing both arch/arm/mach-pxa/Makefile.boot and
> > > > arch/arm/mach/pxa/include/mach/memory.h
> > > > 
> > > >> With Thanks
> > > >> J.Balakrishnan
> > > > 
> > > > The 0x80000000 should be aliased to 0xa0000000, but looking into the
> > > > PXA docs, it is only on pxa320. Eric, any ideas on this ?
> > > 
> > > Should be working on pxa300/310 as well. If it doesn't, check you
> > > bootloader to make sure the mapping is OK, and memory doesn't exceed
> > > (0xa000_0000 - 0x8000_0000).
> > 
> > It worked last time I used the pxa310 littleton board, but I can't check
> > on the pxa300 zylonite board just yet.
> > 
> > Could you give us your bootloader details ?
> 
> hi,
>       Now, I can able to boot after editing following files
> arch/arm/mach-pxa/Makefile.boot and
> arch/arm/mach/pxa/include/mach/memory.h (0x80000000 changed to
> 0xa0000000). My doubt is

It was always set to 0xa0000000, both of them.

> 1.why 0x80000000 (DDR phy address) is aliased to 0xa0000000 in pxa
> architecture?

Because that's how the HW guys did it and because it's written in TRM (which is 
the holy bible(substitute any other holy object) of the CPU) ;-)

> 2.In my development board two DDRAMs mapped at 0x80000000-0x88000000 and
> 0xc0000000-0xc8000000, how can I inform to kernel about this different
> bank and size?.

Check LAKML and look for:
"[PATCH] pxa/vpac270: Enable SparseMEM for 256 MB of RAM"

This might give you an idea ... though it's a hack. All this goo about 
PHYS_OFFSET etc. will be gone in hopefully near future.

Cheers!

> 
> My Boot loader details,
> ------------------------------
> =>bdi
> arch_number = 0x00000B04
> env_t       = 0x00000000
> boot_params = 0x80000100
> DRAM bank   = 0x00000000
> -> start    = 0x80000000
> -> size     = 0x08000000
> DRAM bank   = 0x00000001
> -> start    = 0xC0000000
> -> size     = 0x08000000
> ethaddr     = 08:00:3e:26:0a:5b
> ip_addr     = 192.168.0.21
> baudrate    = 115200 bps
> =>ver
> U-Boot 2010.03 (Jun 01 2010 - 14:27:43)
> 
> 
> With Thanks
> J.Balakrishnan
