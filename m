Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1HXN15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:27:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41267 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1HXN1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:27:55 -0400
Date: Wed, 24 Aug 2011 15:27:40 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, David Jander <david@protonic.nl>
Subject: [PATCH 0/6] mc13783 cleanup
Message-ID: <20110824132740.GA28197@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this series removes the long obsolte mc13783 API after fixing all
remaining users.

The patches touch many subsystems and have some interdependencies:

 - patches 3 and 5 depend on patch 2
 - patch 6 depends on patches 1-5

So we have to think about how to merge them when everyone is OK that
they are merged.

Best regards
Uwe

The following changes since commit 14c62e78dc1379185515be41903c4a667efc6d54:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-08-23 18:09:08 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/ukl/linux-2.6.git mc13xxx

David Jander (1):
      led/mc13783: convert to mc13xxx MFD

Uwe Kleine-König (5):
      mfd/mc13xxx: provide a generic version of adc_do_conversion
      input/mc13783-ts: convert to mc13xxx API
      ARM: imx: use mc13xxx constants instead of mc13783
      hwmon/mc13783-adc: convert to mc13xxx API
      mfd/mc13xxx: remove mc13783 API functions and symbols

 arch/arm/mach-imx/mach-mx27_3ds.c      |    4 +-
 arch/arm/mach-imx/mach-mx31_3ds.c      |    2 +-
 arch/arm/mach-imx/mach-pcm038.c        |    4 +-
 drivers/hwmon/mc13783-adc.c            |   12 ++--
 drivers/input/touchscreen/mc13783_ts.c |   34 +++++-----
 drivers/leds/leds-mc13783.c            |   52 ++++++++--------
 drivers/mfd/mc13xxx-core.c             |   97 ++++++++++++----------------
 include/linux/mfd/mc13783.h            |  111 --------------------------------
 include/linux/mfd/mc13xxx.h            |   19 ++++++
 9 files changed, 115 insertions(+), 220 deletions(-)

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
