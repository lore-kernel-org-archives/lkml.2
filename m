Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2GKJOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:14:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47842 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab2GKJN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:13:59 -0400
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH 0/2] gpio/omap: few code realignment and update of missing code
Date: Wed, 11 Jul 2012 14:43:13 +0530
Message-ID: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in reponse to comments provided to [gpio/omap: add clk_prepare
and clk_unprepare] and is available here for reference:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/105762.html

Patch-1 moves the debounce clock handle initialization from gpio_debounce()
to omap_gpio_mod_init(). Since this is a one time initialization it makes
sense to keep it here. Though proposal was to keep in omap_gpio_chip_init()
I found more appropriate to keep in omap_gpio_mod_init() because it is more
related to bank specific initialization.

Patch-2 adds *.remove* callback which is missing in current implementation.
Along with other cleanup operations this function is used for releasing the
clock handle and of course calling clk_unprepare().

Reference:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
Commit: bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a (Linux 3.5-rc6)

Tested on: OMAP3630/ZOOM3, BLAZE

Tarun Kanti DebBarma (2):
  gpio/omap: move bank->dbck initialization to omap_gpio_mod_init()
  gpio/omap: add *remove* callback in platform_driver

 drivers/gpio/gpio-omap.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

