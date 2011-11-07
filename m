Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab1KGScZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:32:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45923 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1KGScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:32:24 -0500
Date: Mon, 7 Nov 2011 18:32:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107183208.GG15294@n2100.arm.linux.org.uk>
References: <1320688617-4543-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320688617-4543-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 07:56:57PM +0200, Felipe Balbi wrote:
> commit d6504acd (OMAP2+: hwmod: remove OMAP_CHIP*) has
> mistakenly added MUSB as a hwmod available only on ES2.0
> of OMAP3430.
> 
> MUSB hwmod has always be available on all OMAP revisions
> since OMAP2430.

This doesn't seem to solve it:

dpll3_m2_clk rate change failed: -22
------------[ cut here ]------------
WARNING: at arch/arm/mach-omap2/usb-musb.c:141 usb_musb_init+0xc0/0x174()
usb_musb_init: could not find omap_hwmod for usb_otg_hs
Modules linked in:
Backtrace:
[<c0017920>] (dump_backtrace+0x0/0x10c) from [<c02d9898>] (dump_stack+0x18/0x1c) r7:c181ff20 r6:c03ceb54 r5:c037547b r4:0000008d
[<c02d9880>] (dump_stack+0x0/0x1c) from [<c003ae08>] (warn_slowpath_common+0x58/0x70)
[<c003adb0>] (warn_slowpath_common+0x0/0x70) from [<c003aec4>] (warn_slowpath_fmt+0x38/0x40)
 r8:00000000 r7:00000013 r6:c0374b09 r5:c03f06e4 r4:c03741b0
[<c003ae8c>] (warn_slowpath_fmt+0x0/0x40) from [<c03ceb54>] (usb_musb_init+0xc0/0x174)
 r3:c02df894 r2:c03707f9
[<c03cea94>] (usb_musb_init+0x0/0x174) from [<c03ce02c>] (omap_ldp_init+0xb0/0x100)
 r6:c003e7e4 r5:c03f06e4 r4:c04053e4
[<c03cdf7c>] (omap_ldp_init+0x0/0x100) from [<c03c6788>] (customize_machine+0x24/0x30)
 r4:c03f03a8
[<c03c6764>] (customize_machine+0x0/0x30) from [<c0008710>] (do_one_initcall+0x9c/0x164)
[<c0008674>] (do_one_initcall+0x0/0x164) from [<c03c3284>] (kernel_init+0x7c/0x120)
[<c03c3208>] (kernel_init+0x0/0x120) from [<c003e7e4>] (do_exit+0x0/0x62c)
 r5:c03c3208 r4:00000000
---[ end trace 1b75b31a2719ed1c ]---
