Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2LMOIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44574 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab2LMOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>, Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 126/241] radeon: add AGPMode 1 quirk for RV250
Date: Thu, 13 Dec 2012 11:58:11 -0200
Message-Id: <1355407206-17100-127-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 45171002b01b2e2ec4f991eca81ffd8430fd0aec upstream.

The Intel 82855PM host bridge / Mobility FireGL 9000 RV250 combination
in an (outdated) ThinkPad T41 needs AGPMode 1 for suspend/resume (under
KMS, that is). So add a quirk for it.

(Change R250 to RV250 in comment for preceding quirk too.)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_agp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
index bd2f33e..bc6b64f 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -70,9 +70,12 @@ static struct radeon_agpmode_quirk radeon_agpmode_quirk_list[] = {
 	/* Intel 82830 830 Chipset Host Bridge / Mobility M6 LY Needs AGPMode 2 (fdo #17360)*/
 	{ PCI_VENDOR_ID_INTEL, 0x3575, PCI_VENDOR_ID_ATI, 0x4c59,
 		PCI_VENDOR_ID_DELL, 0x00e3, 2},
-	/* Intel 82852/82855 host bridge / Mobility FireGL 9000 R250 Needs AGPMode 1 (lp #296617) */
+	/* Intel 82852/82855 host bridge / Mobility FireGL 9000 RV250 Needs AGPMode 1 (lp #296617) */
 	{ PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4c66,
 		PCI_VENDOR_ID_DELL, 0x0149, 1},
+	/* Intel 82855PM host bridge / Mobility FireGL 9000 RV250 Needs AGPMode 1 for suspend/resume */
+	{ PCI_VENDOR_ID_INTEL, 0x3340, PCI_VENDOR_ID_ATI, 0x4c66,
+		PCI_VENDOR_ID_IBM, 0x0531, 1},
 	/* Intel 82852/82855 host bridge / Mobility 9600 M10 RV350 Needs AGPMode 1 (deb #467460) */
 	{ PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4e50,
 		0x1025, 0x0061, 1},
-- 
1.7.9.5

