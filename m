Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2DWQXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:23:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38427 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2DWQXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:23:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 23 Apr 2012 18:23:59 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH v4 0/2] i2c-s3c2410: Updates for exynos4210 and DT-based systems
To: w.sang@pengutronix.de
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1335198241-19344-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v3:
 - Replace DT-visible quirks with new controller type
   [Suggested by Wolfram Sang]
 - Dropped already merged of_match_ptr()-patch

Changes since v2:
 - Merge device type and flags into flat bitmask named quirks -
   Consequently, treat s3c24xx as baseline hardware platform and
   support all hw variations via quirks [Suggested by Mark Brown]

Changes since v1:
 - Move unrelated code fragment to separate patch (of_match_ptr())
   [Suggested by Thomas Abracham]
 - Move device-type handling to separate function and rework its
   internals a bit [likewise]

This patchset reworks i2c-s3c2410 driver a bit to better handle
device tree-enabled platforms and adds two quirks required by
exynos4210-specific I2C controller used by s5p-hdmi driver.

This patchset is based on "i2c-bjdooks/for-34/i2c/i2c-samsung" branch
taken from:

  git://git.fluff.org/bjdooks/linux.git


Karol Lewandowski (2):
  i2c-s3c2410: Rework device type handling
  i2c-s3c2410: Add HDMIPHY quirk for S3C2440

 .../devicetree/bindings/i2c/samsung-i2c.txt        |    8 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |  105 ++++++++++++--------
 2 files changed, 70 insertions(+), 43 deletions(-)

-- 
1.7.9.5

