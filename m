Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0F1LzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:55:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:29378 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0F1Ly7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y0L/iZaaaDldNhj9TLG6YvS6XmQmBr2urGhAlK13nPU6ZpN2sZR0apTzMoSs6mcd5G
         hrxy0fmM3P6c4Hg97HbsvAMzAk3L/Qth+ZcTi1Hg166AfRxyZ1GjY2OQLNVe7KIR37gt
         kTOEtU4foowQu74hQlewPMGcBrJh1uJExmlNU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       Zhao Yakui <yakui.zhao@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Ma Ling <ling.ma@intel.com>,
       Ian Romanick <ian.d.romanick@intel.com>,
       dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:54:56 +0400
Message-Id: <1277726097-24534-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 76993ac..03c231b 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -392,13 +392,13 @@ static void intel_sdvo_debug_write(struct intel_encoder *intel_encoder, u8 cmd,
 		DRM_LOG_KMS("%02X ", ((u8 *)args)[i]);
 	for (; i < 8; i++)
 		DRM_LOG_KMS("   ");
-	for (i = 0; i < sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(sdvo_cmd_names); i++) {
 		if (cmd == sdvo_cmd_names[i].cmd) {
 			DRM_LOG_KMS("(%s)", sdvo_cmd_names[i].name);
 			break;
 		}
 	}
-	if (i == sizeof(sdvo_cmd_names)/ sizeof(sdvo_cmd_names[0]))
+	if (i == ARRAY_SIZE(sdvo_cmd_names))
 		DRM_LOG_KMS("(%02X)", cmd);
 	DRM_LOG_KMS("\n");
 }
-- 
1.7.0.4

