Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2HNVlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:41:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46834 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2HNVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:41:23 -0400
From: Emil Goode <emilgoode@gmail.com>
To: mchehab@infradead.org, s.nawrocki@samsung.com, p.zabel@pengutronix.de,
        javier.martin@vista-silicon.com, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] [media] media: coda: add const qualifiers
Date: Tue, 14 Aug 2012 23:44:42 +0200
Message-Id: <1344980682-23075-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 98d7bbb9 changed *of_device_id.data to const
which introduced warnings in various places that have mostly
been fixed. This patch fixes one such warning by introducing
two const qualifiers.

GCC warning:
drivers/media/video/coda.c:1785:16: warning:
        assignment discards ‘const’ qualifier
        from pointer target type [enabled by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/media/video/coda.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index 0d6e0a0..6908514 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -118,7 +118,7 @@ struct coda_dev {
 	struct v4l2_device	v4l2_dev;
 	struct video_device	vfd;
 	struct platform_device	*plat_dev;
-	struct coda_devtype	*devtype;
+	const struct coda_devtype *devtype;
 
 	void __iomem		*regs_base;
 	struct clk		*clk_per;
@@ -1687,7 +1687,7 @@ enum coda_platform {
 	CODA_IMX27,
 };
 
-static struct coda_devtype coda_devdata[] = {
+static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX27] = {
 		.firmware    = "v4l-codadx6-imx27.bin",
 		.product     = CODA_DX6,
-- 
1.7.10.4

