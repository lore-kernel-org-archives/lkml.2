Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2HFGvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:51:04 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:19249
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab2HFGvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 02:51:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839he5bhf0ah)
From: Liu Ying <Ying.liu@freescale.com>
To: <mchehab@redhat.com>
CC: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <liu.y.ying@gmail.com>, Liu Ying <Ying.liu@freescale.com>,
        Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 1/1] media: mx3_camera: Improve data bus width check code for probe
Date: Mon, 6 Aug 2012 14:02:08 +0800
Message-ID: <1344232928-17361-1-git-send-email-Ying.liu@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains code change only to use the present macro-
MX3_CAMERA_DATAWIDTH_MASK to check valid camera platform data
bus width instead of enumerating every possible data bus width.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/media/video/mx3_camera.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index f96f92f..346e2cd 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -1173,9 +1173,7 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
 
 	mx3_cam->pdata = pdev->dev.platform_data;
 	mx3_cam->platform_flags = mx3_cam->pdata->flags;
-	if (!(mx3_cam->platform_flags & (MX3_CAMERA_DATAWIDTH_4 |
-			MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10 |
-			MX3_CAMERA_DATAWIDTH_15))) {
+	if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_MASK)) {
 		/*
 		 * Platform hasn't set available data widths. This is bad.
 		 * Warn and use a default.
-- 
1.7.1


