Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2LSCWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 21:22:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:1771 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab2LSCWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 21:22:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="264187889"
Date: Wed, 19 Dec 2012 10:22:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: arch/arm/mach-omap2/i2c.c:130:2: error: implicit declaration of
 function 'omap_pm_set_max_mpu_wakeup_lat'
Message-ID: <20121219022247.GA11170@localhost>
References: <20121219021102.GA9472@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219021102.GA9472@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add more CC]

On Wed, Dec 19, 2012 at 10:11:02AM +0800, Fengguang Wu wrote:
> Hi Linus, Wolfram,
> 
> FYI, kernel build failed on
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
> head:   752451f01c4567b506bf4343082682dbb8fb30dd
> commit: 752451f01c4567b506bf4343082682dbb8fb30dd Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux
> date:   56 minutes ago
> config: make ARCH=arm omap2plus_defconfig
> 
> All error/warnings:
> 
> arch/arm/mach-omap2/i2c.c: In function 'omap_pm_set_max_mpu_wakeup_lat_compat':
> arch/arm/mach-omap2/i2c.c:130:2: error: implicit declaration of function 'omap_pm_set_max_mpu_wakeup_lat' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> The root cause is, i2c.c (which is always compiled in arch/arm/mach-omap2/Makefile)
> uses omap_pm_set_max_mpu_wakeup_lat() which is defined in omap-pm-noop.c (which
> is compiled only on CONFIG_OMAP_PM_NOOP).
> 
> 
> vim +/omap_pm_set_max_mpu_wakeup_lat +130 arch/arm/mach-omap2/i2c.c
> 
> 752451f0 Linus Torvalds 2012-12-18  124   * XXX This function is a temporary compatibility wrapper - only
> 752451f0 Linus Torvalds 2012-12-18  125   * needed until the I2C driver can be converted to call
> 752451f0 Linus Torvalds 2012-12-18  126   * omap_pm_set_max_dev_wakeup_lat() and handle a return code.
> 752451f0 Linus Torvalds 2012-12-18  127   */
> 752451f0 Linus Torvalds 2012-12-18  128  static void omap_pm_set_max_mpu_wakeup_lat_compat(struct device *dev, long t)
> 752451f0 Linus Torvalds 2012-12-18  129  {
> 752451f0 Linus Torvalds 2012-12-18 @130  	omap_pm_set_max_mpu_wakeup_lat(dev, t);
> 752451f0 Linus Torvalds 2012-12-18  131  }
> 752451f0 Linus Torvalds 2012-12-18  132  
> 3a8761c0 Tony Lindgren  2012-10-08  133  static const char name[] = "omap_i2c";
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Center
> Fengguang Wu, Yuanhan Liu                              Intel Corporation
