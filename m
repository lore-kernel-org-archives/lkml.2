Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2JVRti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:49:38 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:52175 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab2JVRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:49:37 -0400
Message-ID: <1350928182.15043.0.camel@gitbox>
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 23 Oct 2012 06:49:42 +1300
In-Reply-To: <20121022150835.GA31704@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
	 <201210221150.22004.arnd@arndb.de>
	 <20121022120706.GA19467@avionic-0098.mockup.avionic-design.de>
	 <201210221352.08352.arnd@arndb.de>
	 <20121022150835.GA31704@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 17:08 +0200, Thierry Reding wrote:
> On Mon, Oct 22, 2012 at 01:52:08PM +0000, Arnd Bergmann wrote:
> > On Monday 22 October 2012, Thierry Reding wrote:
> > > > As long as we get build warnings for leaving out the __devinit/__devexit
> > > > annotations, I would generally recommend putting them in. If we do a
> > > > patch to remove all of them, a couple extra instances will not cause
> > > > any more troubles than we already have.
> > > 
> > > I've never seen any build warnings for leaving __devinit/__devexit out.
> > > Where does that happen?
> > 
> > Section mismatches usually result into warnings from modpost, like
> > 
> > WARNING: modpost: Found 1 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > 
> > Actually doing that gives you an output like this (currently on exynos_defconfig):
> > 
> > $ make CONFIG_DEBUG_SECTION_MISMATCH=y
> > WARNING: drivers/pinctrl/built-in.o(.devinit.text+0x124): Section mismatch in reference from the function samsung_pinctrl_probe() to the function .init.text:samsung_gpiolib_register()
> > The function __devinit samsung_pinctrl_probe() references
> > a function __init samsung_gpiolib_register().
> > If samsung_gpiolib_register is only used by samsung_pinctrl_probe then
> > annotate samsung_gpiolib_register with a matching annotation.
> > 
> > or like this (now fixed in socfpga_defconfig):
> > 
> > WARNING: drivers/net/ethernet/stmicro/stmmac/stmmac.o(.text+0x5d4c): Section mismatch in reference from the function stmmac_pltfr_probe() to the function .devinit.text:stmmac_probe_config_dt()
> > The function stmmac_pltfr_probe() references
> > the function __devinit stmmac_probe_config_dt().
> > This is often because stmmac_pltfr_probe lacks a __devinit 
> > annotation or the annotation of stmmac_probe_config_dt is wrong.
> > 
> > I believe you normally don't get warnings for functions that could be
> > marked __devinit and only call regular functions, but there are
> > a couple of __devinit infrastructure functions that you can't call
> > from a function that isn't __init or __devinit.
> 
> Right. If you get those warnings you shouldn't be dropping the
> annotations. But I don't think that is the case for this driver. Tony,
> can you confirm that the driver still builds properly without warnings
> if you drop the __devinit/__devexit?
> 
> Thierry
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Correct - it builds without warnings without __devinit/__devexit.

If it had introduced warnings when I tested it, I would have mentioned
it :)

Regards
Tony P

