Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab1GMUZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:25:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55521 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1GMUZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:25:01 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-watchdog@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, tim.bird@am.sony.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 0/6] watchdog drivers converted to the new framework
Date: Wed, 13 Jul 2011 22:26:00 +0200
Message-Id: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As promised, here is a RFC with two examples demonstrating how watchdog drivers
can be converted to use the new watchdog framework (using the current version
Wim posted two days ago). There is also conversion guide put to the
documentation folder. Being RFC, all this is not final yet, but presentable, I
hope.

Although there are a few more consolidation options left, there is already a
gain of ~100 lines per driver. Promising, but there are a few issues to be
sorted out, too, yet nothing which can be dealt with.

I have two other drivers in the making (stmp3xxx and imx2), but they need some
more preparation; the first one needs some internal cleanups (like a lot of
watchdog drivers); the latter one needs an addition to the framework
(installing a timer for non-stoppable devices). I will also prepare a new
driver (mx1) to show how small new drivers can be now :) The aim for all these
driver conversions is inclusion in Linux 3.2. I still hope we can get the basic
framework into Linux 3.1.

Many thanks to CELF/LF for supporting this work and to Wim and Alan for making
the framework!

Looking forward to comments,

   Wolfram

They are also available in the git repository at:
  git://git.pengutronix.de/git/wsa/linux-2.6.git generic-watchdog-with-drivers

Wolfram Sang (6):
  Documentation: watchdog: add guide how to convert drivers to new framework
  watchdog: s3c2410: convert to use the watchdog framework
  watchdog: pnx4008: cleanup resource handling using managed devices
  watchdog: pnx4008: don't use __raw_-accessors
  watchdog: pnx4008: convert driver to use the watchdog framework
  watchdog: pnx4008: WIP refactor disabling device

 .../watchdog/convert_drivers_to_kernel_api.txt     |  195 ++++++++++++++++
 drivers/watchdog/Kconfig                           |    2 +
 drivers/watchdog/pnx4008_wdt.c                     |  246 +++++++-------------
 drivers/watchdog/s3c2410_wdt.c                     |  176 +++-----------
 4 files changed, 313 insertions(+), 306 deletions(-)
 create mode 100644 Documentation/watchdog/convert_drivers_to_kernel_api.txt

-- 
1.7.2.5

