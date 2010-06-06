Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0FFQgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:36:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35233 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab0FFQgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Dl7b/2Gd0G0y6VhgZwo45cDvVB+vJEsHDghu6wCqTLvaYaK+/5Ap8fBJvPX3kt3rvv
         d/ibN0LKoVPvs87g2w8InZ6MgI+80fxgAHW4Wt4TpKQi7fT5rk24wP+sbTw5eBF2V28U
         vnsW3hqH0s+z1Ux86HpPYNU/zzvxzxZddiGkI=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: pxa300 - DDRAM base value
Date: Sun, 6 Jun 2010 18:34:50 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
       balakrishnan <balakrishnan@e-consystems.com>,
       linux-kernel@vger.kernel.org, Maharajan <maharajan@e-consystems.com>
References: <1275371058.7001.35.camel@balakrishnan-desktop> <201006051919.17738.marek.vasut@gmail.com> <AANLkTil5TWYILcdp872as8S8LMqQWhPYWLt7cxs2lUm5@mail.gmail.com>
In-Reply-To: <AANLkTil5TWYILcdp872as8S8LMqQWhPYWLt7cxs2lUm5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006061834.50297.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Ne 6. června 2010 10:17:00 Eric Miao napsal(a):
> On Sun, Jun 6, 2010 at 1:19 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > Dne Út 1. června 2010 07:44:18 balakrishnan napsal(a):
> >> I am working on pxa300 based development board and using Linux 2.6.34.
> >> This Linux kernel already has support for following boards
> >> 1. zylonite_pxa300
> >> 2. cm-x300
> >> 3. colibri-pxa300
> >> 4. littleton
> >> 
> >> My doubt is that pxa300 based boards are using "0xa0000000"  as DDRAM
> >> base and PHYS_OFFSET is also defined in
> >> "arch/arm/mach-pxa/include/mach/memory.h" as 0xa0000000.
> >> But in our board  DDR is mapped in 0x80000000. Does it make any
> >> problem?. Because after mmu is turned ON, my board is hanging.
> >> 
> >> "zreladdr-y   := 0x80008000" is defined in
> >> "arch/arm/mach-pxa/Makefile.boot" file .
> >> my machine_desc is as follows
> >> .phys_io        = 0x40000000,
> >> .io_pg_offst    = (io_p2v(0x40000000) >> 18) & 0xfffc,
> >> .boot_params    = 0x80000100,
> > 
> > Try editing both arch/arm/mach-pxa/Makefile.boot and
> > arch/arm/mach/pxa/include/mach/memory.h
> > 
> >> With Thanks
> >> J.Balakrishnan
> > 
> > The 0x80000000 should be aliased to 0xa0000000, but looking into the PXA
> > docs, it is only on pxa320. Eric, any ideas on this ?
> 
> Should be working on pxa300/310 as well. If it doesn't, check you
> bootloader to make sure the mapping is OK, and memory doesn't exceed
> (0xa000_0000 - 0x8000_0000).

It worked last time I used the pxa310 littleton board, but I can't check on the 
pxa300 zylonite board just yet.

Could you give us your bootloader details ?
