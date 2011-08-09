Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1HINVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:21:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60787 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab1HINVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:21:45 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Paul Walmsley <paul@pwsan.com>, Daniel Morsing <daniel.morsing@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: Re: Build failure: bisected: v3.1-rc1 with config ARCH_OMAP && !ARCH_OMAP4 fails with linker error
Date: Tue, 9 Aug 2011 16:21:45 +0300
Message-ID: <1789641.q69g0yHCiG@barack>
User-Agent: KMail/4.7.0  (Linux/3.0.0-gentoo; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110809131453.GR1866@atomide.com>
References: <1312819724.14483.29.camel@morsingpad> <alpine.DEB.2.00.1108081435340.4764@utopia.booyaka.com> <20110809131453.GR1866@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Paul,

On Tuesday 09 August 2011 15:14:53 Tony Lindgren wrote:
> * Paul Walmsley <paul@pwsan.com> [110808 13:31]:
> > Hi
> > 
> > On Mon, 8 Aug 2011, Daniel Morsing wrote:
> > > Building the v3.1-rc1 kernel with ARCH_OMAP && !ARCH_OMAP4 support
> > > fails on linking with the following error
> > > 
> > > ...
> > > 
> > >   LD      .tmp_vmlinux1
> > > 
> > > arch/arm/mach-omap2/built-in.o:(.data+0xf7d8): undefined reference
> > > to `omap4430_phy_init'
> > > arch/arm/mach-omap2/built-in.o:(.data+0xf7dc): undefined reference
> > > to `omap4430_phy_exit'
> > > arch/arm/mach-omap2/built-in.o:(.data+0xf7e0): undefined reference
> > > to `omap4430_phy_power'
> > > arch/arm/mach-omap2/built-in.o:(.data+0xf7e4): undefined reference
> > > to `omap4430_phy_set_clk'
> > > arch/arm/mach-omap2/built-in.o:(.data+0xf7e8): undefined reference
> > > to `omap4430_phy_suspend'
> > > 
> > > I've bisected the first bad commit to "OMAP4: Move common twl6030
> > > configuration to twl-common" (commit-id
> > > b22f954bae35be115a10c6426dc070f7d652b32e). The problem seems to be
> > > unconditionally taking a function pointer to an omap4430 specific
> > > function in arch/arm/mach-omap2/twl-common.c. The definition for
> > > omap4430_phy_init and friends is in
> > > arch/arm/mach-omap2/omap_phy_internal.c, which is only compiled when
> > > building with support for one of the omap4430 boards.
> > 
> > Thanks for the bisect; this should be fixed by
> > 
> > https://patchwork.kernel.org/patch/963462/
> 
> Hmm, there are also these when CONFIG_ARCH_OMAP4 is not selected:
> 
> arch/arm/mach-omap2/built-in.o: In function `_enable_module':
> arch/arm/mach-omap2/omap_hwmod.c:701: undefined reference to
> `omap4_cminst_module_enable' arch/arm/mach-omap2/built-in.o: In function
> `_disable_module':
> arch/arm/mach-omap2/omap_hwmod.c:726: undefined reference to
> `omap4_cminst_module_disable' arch/arm/mach-omap2/built-in.o: In function
> `_wait_target_disable': arch/arm/mach-omap2/omap_hwmod.c:1179: undefined
> reference to `omap4_cminst_wait_module_idle' distcc[27594] ERROR: compile
> (null) on localhost failed
> make: *** [.tmp_vmlinux1] Error 1
> 
> Care to take a look?

I just sent a patch fixing this:
http://marc.info/?l=linux-omap&m=131289342114258&w=2

-- 
Péter
