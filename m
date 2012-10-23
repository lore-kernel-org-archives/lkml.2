Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab2JWT7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:59:37 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62157 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab2JWT7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:33 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 23/23] wl128x: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:26 -0300
Message-Id: <1351022246-8201-23-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index bf867a6..902f19d 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1563,8 +1563,7 @@ int fmc_prepare(struct fmdev *fmdev)
 	fmdev->irq_info.mask = FM_MAL_EVENT;
 
 	/* Region info */
-	memcpy(&fmdev->rx.region, &region_configs[default_radio_region],
-			sizeof(struct region_info));
+	fmdev->rx.region = region_configs[default_radio_region];
 
 	fmdev->rx.mute_mode = FM_MUTE_OFF;
 	fmdev->rx.rf_depend_mute = FM_RX_RF_DEPENDENT_MUTE_OFF;
-- 
1.7.4.4

