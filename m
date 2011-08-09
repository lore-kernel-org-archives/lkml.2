Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1HINO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:14:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20538 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751812Ab1HINO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:14:57 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wbNaHYRdvtCfmqAhtzCDd
Date: Tue, 9 Aug 2011 06:14:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Daniel Morsing <daniel.morsing@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: Build failure: bisected: v3.1-rc1 with config ARCH_OMAP &&
 !ARCH_OMAP4 fails with linker error
Message-ID: <20110809131453.GR1866@atomide.com>
References: <1312819724.14483.29.camel@morsingpad>
 <alpine.DEB.2.00.1108081435340.4764@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108081435340.4764@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [110808 13:31]:
> Hi
> 
> On Mon, 8 Aug 2011, Daniel Morsing wrote:
> 
> > Building the v3.1-rc1 kernel with ARCH_OMAP && !ARCH_OMAP4 support fails
> > on linking with the following error
> > 
> > ...
> >   LD      .tmp_vmlinux1
> > arch/arm/mach-omap2/built-in.o:(.data+0xf7d8): undefined reference to `omap4430_phy_init'
> > arch/arm/mach-omap2/built-in.o:(.data+0xf7dc): undefined reference to `omap4430_phy_exit'
> > arch/arm/mach-omap2/built-in.o:(.data+0xf7e0): undefined reference to `omap4430_phy_power'
> > arch/arm/mach-omap2/built-in.o:(.data+0xf7e4): undefined reference to `omap4430_phy_set_clk'
> > arch/arm/mach-omap2/built-in.o:(.data+0xf7e8): undefined reference to `omap4430_phy_suspend'
> > 
> > I've bisected the first bad commit to "OMAP4: Move common twl6030
> > configuration to twl-common" (commit-id
> > b22f954bae35be115a10c6426dc070f7d652b32e). The problem seems to be
> > unconditionally taking a function pointer to an omap4430 specific
> > function in arch/arm/mach-omap2/twl-common.c. The definition for
> > omap4430_phy_init and friends is in
> > arch/arm/mach-omap2/omap_phy_internal.c, which is only compiled when
> > building with support for one of the omap4430 boards.
> 
> Thanks for the bisect; this should be fixed by 
> 
> https://patchwork.kernel.org/patch/963462/

Hmm, there are also these when CONFIG_ARCH_OMAP4 is not selected:

arch/arm/mach-omap2/built-in.o: In function `_enable_module':
arch/arm/mach-omap2/omap_hwmod.c:701: undefined reference to `omap4_cminst_module_enable'
arch/arm/mach-omap2/built-in.o: In function `_disable_module':
arch/arm/mach-omap2/omap_hwmod.c:726: undefined reference to `omap4_cminst_module_disable'
arch/arm/mach-omap2/built-in.o: In function `_wait_target_disable':
arch/arm/mach-omap2/omap_hwmod.c:1179: undefined reference to `omap4_cminst_wait_module_idle'
distcc[27594] ERROR: compile (null) on localhost failed
make: *** [.tmp_vmlinux1] Error 1

Care to take a look?

Tony
