Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1HHUgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:36:50 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:38784 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1HHUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:36:49 -0400
Date: Mon, 8 Aug 2011 14:36:47 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Daniel Morsing <daniel.morsing@gmail.com>
cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: Build failure: bisected: v3.1-rc1 with config ARCH_OMAP &&
 !ARCH_OMAP4 fails with linker error
In-Reply-To: <1312819724.14483.29.camel@morsingpad>
Message-ID: <alpine.DEB.2.00.1108081435340.4764@utopia.booyaka.com>
References: <1312819724.14483.29.camel@morsingpad>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, 8 Aug 2011, Daniel Morsing wrote:

> Building the v3.1-rc1 kernel with ARCH_OMAP && !ARCH_OMAP4 support fails
> on linking with the following error
> 
> ...
>   LD      .tmp_vmlinux1
> arch/arm/mach-omap2/built-in.o:(.data+0xf7d8): undefined reference to `omap4430_phy_init'
> arch/arm/mach-omap2/built-in.o:(.data+0xf7dc): undefined reference to `omap4430_phy_exit'
> arch/arm/mach-omap2/built-in.o:(.data+0xf7e0): undefined reference to `omap4430_phy_power'
> arch/arm/mach-omap2/built-in.o:(.data+0xf7e4): undefined reference to `omap4430_phy_set_clk'
> arch/arm/mach-omap2/built-in.o:(.data+0xf7e8): undefined reference to `omap4430_phy_suspend'
> 
> I've bisected the first bad commit to "OMAP4: Move common twl6030
> configuration to twl-common" (commit-id
> b22f954bae35be115a10c6426dc070f7d652b32e). The problem seems to be
> unconditionally taking a function pointer to an omap4430 specific
> function in arch/arm/mach-omap2/twl-common.c. The definition for
> omap4430_phy_init and friends is in
> arch/arm/mach-omap2/omap_phy_internal.c, which is only compiled when
> building with support for one of the omap4430 boards.

Thanks for the bisect; this should be fixed by 

https://patchwork.kernel.org/patch/963462/


- Paul
