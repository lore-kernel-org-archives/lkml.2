Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0F1L55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:57:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0F1Lyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IDt7LqVY0Dt6Yb9+AzkCZtfDQC9/OCluggB08FLVNrj/q1qK7+dQZ5Vyox4UFsYIxa
         DnWkto7VYLp6k4vtA/tsZatfZEBslL+/E7/ZfUQqZZf9Kznw5y5TRUgm3snksuPguSgX
         5JkA/kNJJE29ATjQlhdit7mgwQvPr3eWAi78o=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
       Adam Jackson <ajax@redhat.com>, Zhao Yakui <yakui.zhao@intel.com>,
       dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:54:52 +0400
Message-Id: <1277726093-24500-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/gpu/drm/drm_edid.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index c198186..da06476 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -929,13 +929,11 @@ drm_mode_do_interlace_quirk(struct drm_display_mode *mode,
 		{ 1440,  576 },
 		{ 2880,  576 },
 	};
-	static const int n_sizes =
-		sizeof(cea_interlaced)/sizeof(cea_interlaced[0]);
 
 	if (!(pt->misc & DRM_EDID_PT_INTERLACED))
 		return;
 
-	for (i = 0; i < n_sizes; i++) {
+	for (i = 0; i < ARRAY_SIZE(cea_interlaced); i++) {
 		if ((mode->hdisplay == cea_interlaced[i].w) &&
 		    (mode->vdisplay == cea_interlaced[i].h / 2)) {
 			mode->vdisplay *= 2;
@@ -1375,7 +1373,6 @@ static const struct {
 	{ 1920, 1440, 60, 0 },
 	{ 1920, 1440, 75, 0 },
 };
-static const int num_est3_modes = sizeof(est3_modes) / sizeof(est3_modes[0]);
 
 static int
 drm_est3_modes(struct drm_connector *connector, struct detailed_timing *timing)
@@ -1387,7 +1384,7 @@ drm_est3_modes(struct drm_connector *connector, struct detailed_timing *timing)
 	for (i = 0; i < 6; i++) {
 		for (j = 7; j > 0; j--) {
 			m = (i * 8) + (7 - j);
-			if (m >= num_est3_modes)
+			if (m >= ARRAY_SIZE(est3_modes))
 				break;
 			if (est[i] & (1 << j)) {
 				mode = drm_mode_find_dmt(connector->dev,
-- 
1.7.0.4

