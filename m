Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab2CUTMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:12:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17677 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2CUTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:12:03 -0400
Date: Wed, 21 Mar 2012 20:11:50 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH v3 0/3] i2c-s3c2410: Updates for exynos4210 and DT-based systems
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Karol Lewandowski (3):
  i2c-s3c2410: Drop unused define
  i2c-s3c2410: Rework device type handling
  i2c-s3c2410: Add HDMIPHY quirk for S3C2440

 .../devicetree/bindings/i2c/samsung-i2c.txt        |   11 ++-
 drivers/i2c/busses/i2c-s3c2410.c                   |   86 +++++++++++++------
 2 files changed, 68 insertions(+), 29 deletions(-)

-- 
1.7.9

