Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1GEOye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:54:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50613 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1GEOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:54:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 47/49] gma500: Workaround for Medfield/Cedarview cursor bug
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:44:46 +0100
Message-ID: <20110705144444.23872.19208.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_display.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index bd0a4bc..8b84462 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1278,6 +1278,19 @@ const struct drm_crtc_funcs psb_intel_crtc_funcs = {
 	.destroy = psb_intel_crtc_destroy,
 };
 
+/*
+ * Set the default value of cursor control and base register
+ * to zero. This is a workaround for h/w defect on Oaktrail
+ */
+static void psb_intel_cursor_init(struct drm_device *dev, int pipe)
+{
+        u32 control[3] = { CURACNTR, CURBCNTR, CURCCNTR };
+        u32 base[3] = { CURABASE, CURBBASE, CURCBASE };
+        
+	REG_WRITE(control[pipe], 0);
+	REG_WRITE(base[pipe], 0);
+}
+
 void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 		     struct psb_intel_mode_device *mode_dev)
 {
@@ -1341,6 +1354,7 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	psb_intel_crtc->mode_set.connectors =
 	    (struct drm_connector **) (psb_intel_crtc + 1);
 	psb_intel_crtc->mode_set.num_connectors = 0;
+	psb_intel_cursor_init(dev, pipe);
 }
 
 int psb_intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,

