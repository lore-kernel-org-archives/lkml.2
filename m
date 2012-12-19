Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2LSGxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 01:53:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36978 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2LSGx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 01:53:27 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: arch/arm/mach-omap2/i2c.c:130:2: error: implicit declaration of
 function 'omap_pm_set_max_mpu_wakeup_lat'
Thread-Topic: arch/arm/mach-omap2/i2c.c:130:2: error: implicit declaration
 of function 'omap_pm_set_max_mpu_wakeup_lat'
Thread-Index: AQHN3ZBhzpadx7Uq7kmiSr1nZpia85gfrmQQ
Date: Wed, 19 Dec 2012 06:53:10 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC9A322@DBDE01.ent.ti.com>
References: <20121219021102.GA9472@localhost>
 <20121219022247.GA11170@localhost>
In-Reply-To: <20121219022247.GA11170@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 07:52:47, Fengguang Wu wrote:
> [add more CC]
> 
> On Wed, Dec 19, 2012 at 10:11:02AM +0800, Fengguang Wu wrote:
> > Hi Linus, Wolfram,
> > 
> > FYI, kernel build failed on
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
> > head:   752451f01c4567b506bf4343082682dbb8fb30dd
> > commit: 752451f01c4567b506bf4343082682dbb8fb30dd Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux
> > date:   56 minutes ago
> > config: make ARCH=arm omap2plus_defconfig
> > 
> > All error/warnings:
> > 
> > arch/arm/mach-omap2/i2c.c: In function 'omap_pm_set_max_mpu_wakeup_lat_compat':
> > arch/arm/mach-omap2/i2c.c:130:2: error: implicit declaration of function 'omap_pm_set_max_mpu_wakeup_lat' [-Werror=implicit-function-declaration]
> > cc1: some warnings being treated as errors
> > 
> > The root cause is, i2c.c (which is always compiled in arch/arm/mach-omap2/Makefile)
> > uses omap_pm_set_max_mpu_wakeup_lat() which is defined in omap-pm-noop.c (which
> > is compiled only on CONFIG_OMAP_PM_NOOP).

CONFIG_OMAP_PM_NOOP is defined. The build breakage is due to a missing header inclusion.
I just sent a patch for this [1]

There are still a couple of patches missing before omap2plus_defconfig compiles
https://patchwork.kernel.org/patch/1810481/
https://patchwork.kernel.org/patch/1810441/

I guess they are on the way from some other tree.

Regards,
Vaibhav

[1] http://marc.info/?l=linux-arm-kernel&m=135589966017628&w=2

