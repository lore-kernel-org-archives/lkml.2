Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab2ABFvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 00:51:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61180 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2ABFvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 00:51:43 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-87-4f0145ed08ae
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: [RFC][PATCH 0/4] lcd: platform-lcd: Add lcd panel and device tree
 support
Date: Mon, 02 Jan 2012 11:24:31 +0530
Message-id: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform-lcd driver depends on platform-specific callbacks to setup the
lcd panel. These callbacks are supplied using driver's platform data. But
for adding device tree support for platform-lcd driver, providing such
callbacks is not possible (without using auxdata).

Since the callbacks are usually lcd panel specific, it is possible to include
the lcd panel specific setup and control functionality in the platform-lcd
driver itself, thereby eliminating the need for supplying platform specific
callbacks to the driver. The platform-lcd driver can include support for
multiple lcd panels.

This patchset removes the need for platform data for platform-lcd driver and
adds support which can be used to implement lcd panel specific functionality
in the driver. As an example, the support for Hydis hv070wsa lcd panel is added
to the platform-lcd driver which is then used on the Exynos4 based Origen board.
This currently breaks build for other users of platform-lcd driver. Those can be
fixed if this approach is acceptable.

Thomas Abraham (4):
  lcd: platform-lcd: Eliminate need for platform data
  lcd: platform-lcd: Add support for Hydis hv070wsa lcd panel
  ARM: Exynos: Remove platform data of platform-lcd driver
  lcd: platform-lcd: Add device tree support

 arch/arm/mach-exynos/mach-origen.c     |   25 +-----
 drivers/video/backlight/Kconfig        |    6 ++
 drivers/video/backlight/platform_lcd.c |  128 ++++++++++++++++++++++++++++---
 include/video/platform_lcd.h           |   11 +--
 4 files changed, 129 insertions(+), 41 deletions(-)

