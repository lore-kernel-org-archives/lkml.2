Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab2IGI01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:26:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4936 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2IGI0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:26:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 07 Sep 2012 01:19:06 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] pwm_backlight: use power sequences
Date: Fri, 7 Sep 2012 17:28:17 +0900
Message-ID: <2360396.YKI4EihrfI@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <50478B07.4080708@wwwdotorg.org>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <1346412846-17102-3-git-send-email-acourbot@nvidia.com> <50478B07.4080708@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2012 01:25:27 Stephen Warren wrote:
> On 08/31/2012 05:34 AM, Alexandre Courbot wrote:
> > Make use of the power sequences specified in the device tree or platform
> > data to control how the backlight is powered on and off.
> > 
> > +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > 
> >  Optional properties:
> > -  - pwm-names: a list of names for the PWM devices specified in the
> > -               "pwms" property (see PWM binding[0])
> > +  - pwm-names: name for the PWM device specified in the "pwms" property
> > (see PWM +      binding[0]). Necessary if power sequences are used
> 
> So this implies that power sequence are completely optional in the pwm
> binding...
> 
> > diff --git a/drivers/video/backlight/Kconfig
> > b/drivers/video/backlight/Kconfig> 
> >  config BACKLIGHT_PWM
> >  
> >  	tristate "Generic PWM based Backlight Driver"
> >  	depends on PWM
> > 
> > +	select POWER_SEQ
> 
> ... but that implies they're basically mandatory.
> 
> Briefly looking at the code, power sequences don't appear to be
> optional, at least for the DT case, so perhaps you just need to update
> the documentation to make "pwm-names" non-optional?

This has to do with how power sequences are enabled during the build. Instead 
of providing yet-another-kernel-option, I thought it would be better to make 
it invisible and let drivers that take advantage of power seqs enable the 
option by themselves when they are selected. That's why power sequences are 
unconditionally compiled when pwm-backlight is selected.

But on the other hand, pwm-backlight already has a DT interface that does not 
use power sequences, and its current users are still relying on the legacy 
platform data interface (with one PWM and some callback functions). Making the 
power sequences mandatory in the DT bindings would make it impossible to use 
that legacy interface.

We could make power sequences an option of its own and add #ifdefs to drivers 
that use it to lift this ambiguity, but I like the transparency of the current 
way. It also seems hard (illegal?) to get rid of the legacy DT interface.

Alex.

