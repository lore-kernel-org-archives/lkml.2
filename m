Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1DZM0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57304 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1DZM0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:34 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, maximilian attems <max@stro.at>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 09/21] drm/radeon/kms: add workaround for dce3 ddc line vbios bug" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:31 +0200
Message-Id: <1303820791-3649-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 09/21] drm/radeon/kms: add workaround for dce3 ddc line vbios bug

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 19175e158c883cb5ffed5af8dda69cecfd11eca0 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 30 Nov 2010 00:15:10 -0500
Subject: [PATCH 09/21] drm/radeon/kms: add workaround for dce3 ddc line vbios bug

commit 3074adc8b6d9bf28b574a58241b958057a69a7a0 upstream.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=23752

[AK: Dropped hunk for non existing i2c code in .35]
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ backported -maks ]
Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 7c9b013..cddf2c9 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -83,6 +83,14 @@ static inline struct radeon_i2c_bus_rec radeon_lookup_i2c_gpio(struct radeon_dev
 	for (i = 0; i < ATOM_MAX_SUPPORTED_DEVICE; i++) {
 		gpio = &i2c_info->asGPIO_Info[i];

+			/* some DCE3 boards have bad data for this entry */
+			if (ASIC_IS_DCE3(rdev)) {
+				if ((i == 4) &&
+				    (gpio->usClkMaskRegisterIndex == 0x1fda) &&
+				    (gpio->sucI2cId.ucAccess == 0x94))
+					gpio->sucI2cId.ucAccess = 0x14;
+			}
+
 		if (gpio->sucI2cId.ucAccess == id) {
 			i2c.mask_clk_reg = le16_to_cpu(gpio->usClkMaskRegisterIndex) * 4;
 			i2c.mask_data_reg = le16_to_cpu(gpio->usDataMaskRegisterIndex) * 4;
--
1.7.0.4

