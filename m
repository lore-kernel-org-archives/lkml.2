Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2LTR5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:57:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2LTR4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:56:55 -0500
Date: Thu, 20 Dec 2012 17:56:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, maxime.ripard@free-electrons.com
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
Message-ID: <20121220175639.GA14363@n2100.arm.linux.org.uk>
References: <20121220163814.GA29557@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220163814.GA29557@quad.lixom.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 08:38:14AM -0800, Olof Johansson wrote:
> One of the sunxi patches from the last pull request was misapplied (I
> realized what happened -- git am -s didn't apply cleanly so I had done it
> through regular patch, thus not catching the renames properly). Here's
> a fresh version of the pull request with a couple more OMAP and Samsung
> patches included.
> 
> There's a chance that a couple of the OMAP patches will also go in through
> Russell, since my connectivity has been crap so far this trip and it
> causes build breaks for the platform. It's a branch pull from Tony,
> it should be a no-op either way.

Olof,

Not sure what's going on, but my recent pull from arm-soc for-next still
hasn't solved the OMAP build failures in my kbuild - I'm still getting:

arch/arm/mach-omap2/timer.c: In function 'omap_get_timer_dt':
arch/arm/mach-omap2/timer.c:178:3: error: implicit declaration of function 'prom_add_property'
arch/arm/mach-omap2/i2c.c: In function 'omap_pm_set_max_mpu_wakeup_lat_compat':
arch/arm/mach-omap2/i2c.c:130:2: error: implicit declaration of function 'omap_pm_set_max_mpu_wakeup_lat'

This is the top commit I have from you:

commit aad05c3602ba5c42ff8d0e572b2f614f25779ede
Merge: eccf4b3 f64d204
Author: Olof Johansson <olof@lixom.net>
Date:   Mon Dec 17 18:44:26 2012 -0800

    Merge branch 'late/omap-cleanup' into for-next
    
    By Tony Lindgren (3) and others
    via Tony Lindgren
    * late/omap-cleanup:
      arch/arm/mach-omap2/dpll3xxx.c: drop if around WARN_ON
      OMAP2: Fix a typo - replace regist with register.
      ARM/omap: use module_platform_driver macro
      ARM: OMAP2+: PMU: Remove unused header
      ARM: OMAP4: remove duplicated include from omap_hwmod_44xx_data.c
      ARM: OMAP2+: omap2plus_defconfig: enable twl4030 SoC audio
      ARM: OMAP2+: omap2plus_defconfig: Add tps65217 support
      ARM: OMAP2+: enable devtmpfs and devtmpfs automount
      ARM: OMAP2+: omap_twl: Change TWL4030_MODULE_PM_RECEIVER to TWL_MODULE_PM_RECEIVER
      ARM: OMAP2+: Drop plat/cpu.h for omap2plus
      ARM: OMAP: Split fb.c to remove last remaining cpu_is_omap usage
      MAINTAINERS: Add an entry for omap related .dts files

