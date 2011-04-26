Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1DZM0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57458 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1DZM0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:48 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 16/21] drm/radeon: add quirk to make HP nx6125 laptop resume." has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:42 +0200
Message-Id: <1303820802-3873-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 16/21] drm/radeon: add quirk to make HP nx6125 laptop resume.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From dd0e8b2a1e2fb0bcc3ee612ae64e2f8243b46058 Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Wed, 30 Jun 2010 13:26:11 +1000
Subject: [PATCH 16/21] drm/radeon: add quirk to make HP nx6125 laptop resume.

commit 580b4fffbbdc3c899ee1f8189ba321bd60b48840 upstream.

For some reason on resume, executing the BIOS scripts locks up the whole chipset, by avoiding the dynclk table the machine resumes properly and seems to function okay.

Signed-off-by: Dave Airlie <airlied@redhat.com>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 44770b9..fafe652 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2849,6 +2849,14 @@ void radeon_combios_asic_init(struct drm_device *dev)
 		combios_write_ram_size(dev);
 	}

+	/* quirk for rs4xx HP nx6125 laptop to make it resume
+	 * - it hangs on resume inside the dynclk 1 table.
+	 */
+	if (rdev->family == CHIP_RS480 &&
+	    rdev->pdev->subsystem_vendor == 0x103c &&
+	    rdev->pdev->subsystem_device == 0x308b)
+		return;
+
 	/* DYN CLK 1 */
 	table = combios_get_table_offset(dev, COMBIOS_DYN_CLK_1_TABLE);
 	if (table)
--
1.7.0.4

