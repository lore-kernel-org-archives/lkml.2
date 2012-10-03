Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2JCGdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:33:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2JCGdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:33:09 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] davinci: vpbe: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with V4L2_OUT_CAP_DV_TIMINGS
Date: Wed,  3 Oct 2012 12:02:53 +0530
Message-Id: <1349245973-7377-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch replaces V4L2_OUT_CAP_CUSTOM_TIMINGS macro with
V4L2_OUT_CAP_DV_TIMINGS. As V4L2_OUT_CAP_CUSTOM_TIMINGS is being phased
out.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 arch/arm/mach-davinci/board-dm644x-evm.c |    2 +-
 drivers/media/platform/davinci/vpbe.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 3baf56d..a79dc1e 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -699,7 +699,7 @@ static struct vpbe_output dm644xevm_vpbe_outputs[] = {
 			.index		= 1,
 			.name		= "Component",
 			.type		= V4L2_OUTPUT_TYPE_ANALOG,
-			.capabilities	= V4L2_OUT_CAP_CUSTOM_TIMINGS,
+			.capabilities	= V4L2_OUT_CAP_DV_TIMINGS,
 		},
 		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
 		.default_mode	= "480p59_94",
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index d03f452..9b623bc 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -340,7 +340,7 @@ static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
 
 
 	if (!(cfg->outputs[out_index].output.capabilities &
-	    V4L2_OUT_CAP_CUSTOM_TIMINGS))
+	    V4L2_OUT_CAP_DV_TIMINGS))
 		return -EINVAL;
 
 	for (i = 0; i < output->num_modes; i++) {
@@ -408,7 +408,7 @@ static int vpbe_enum_dv_timings(struct vpbe_device *vpbe_dev,
 	int j = 0;
 	int i;
 
-	if (!(output->output.capabilities & V4L2_OUT_CAP_CUSTOM_TIMINGS))
+	if (!(output->output.capabilities & V4L2_OUT_CAP_DV_TIMINGS))
 		return -EINVAL;
 
 	for (i = 0; i < output->num_modes; i++) {
-- 
1.7.4.1

