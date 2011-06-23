Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305Ab1FWSYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:24:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:34142 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891Ab1FWRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 073/247] drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
Date: Thu, 23 Jun 2011 13:32:21 -0400
Message-Id: <1308850515-15242-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f598aa7593427ffe3a61e7767c34bd695a5e7ed0 upstream.

Reported-by: 屋国遥 <hyagni@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 05ef0c4..8e4031f 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -272,6 +272,17 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 			*line_mux = 0x90;
 	}
 
+	/* mac rv630 */
+	if ((dev->pdev->device == 0x9588) &&
+	    (dev->pdev->subsystem_vendor == 0x106b) &&
+	    (dev->pdev->subsystem_device == 0x00a6)) {
+		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
+		}
+	}
+
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x9598) &&
 	    (dev->pdev->subsystem_vendor == 0x1043) &&
-- 
1.7.4.4

