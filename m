Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1DZM1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:27:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57483 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1DZM0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:49 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 17/21] drm/radeon/kms: add quirk to make HP DV5000 laptop resume" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:44 +0200
Message-Id: <1303820804-3905-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 17/21] drm/radeon/kms: add quirk to make HP DV5000 laptop resume

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From ae446ebe5e4ba01dc58deef6c5eba58e5f4a3fd7 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 21 Jul 2010 23:54:35 -0400
Subject: [PATCH 17/21] drm/radeon/kms: add quirk to make HP DV5000 laptop resume

commit 52fa2bbc8ec46255039e2048d616bbd0852ee292 upstream.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=29062

Reported-by:  Andres Cimmarusti <acimmarusti@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index fafe652..16024e2 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2857,6 +2857,14 @@ void radeon_combios_asic_init(struct drm_device *dev)
 	    rdev->pdev->subsystem_device == 0x308b)
 		return;

+	/* quirk for rs4xx HP dv5000 laptop to make it resume
+	 * - it hangs on resume inside the dynclk 1 table.
+	 */
+	if (rdev->family == CHIP_RS480 &&
+	    rdev->pdev->subsystem_vendor == 0x103c &&
+	    rdev->pdev->subsystem_device == 0x30a4)
+		return;
+
 	/* DYN CLK 1 */
 	table = combios_get_table_offset(dev, COMBIOS_DYN_CLK_1_TABLE);
 	if (table)
--
1.7.0.4

