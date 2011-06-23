Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936Ab1FWXUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:20:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16517 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519Ab1FWXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:20:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 23 Jun 2011 16:19:59 -0700
From: <achew@nvidia.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>, <olof@lixom.net>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 2/6 v3] [media] ov9740: Correct print in ov9740_reg_rmw()
Date: Thu, 23 Jun 2011 16:19:40 -0700
Message-ID: <1308871184-6307-2-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308871184-6307-1-git-send-email-achew@nvidia.com>
References: <1308871184-6307-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

The register width of the ov9740 is 16-bits, so correct the debug print
to reflect this.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/media/video/ov9740.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 96811e4..d5c9061 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -537,7 +537,8 @@ static int ov9740_reg_rmw(struct i2c_client *client, u16 reg, u8 set, u8 unset)
 	ret = ov9740_reg_read(client, reg, &val);
 	if (ret < 0) {
 		dev_err(&client->dev,
-			"[Read]-Modify-Write of register %02x failed!\n", reg);
+			"[Read]-Modify-Write of register 0x%04x failed!\n",
+			reg);
 		return ret;
 	}
 
@@ -547,7 +548,8 @@ static int ov9740_reg_rmw(struct i2c_client *client, u16 reg, u8 set, u8 unset)
 	ret = ov9740_reg_write(client, reg, val);
 	if (ret < 0) {
 		dev_err(&client->dev,
-			"Read-Modify-[Write] of register %02x failed!\n", reg);
+			"Read-Modify-[Write] of register 0x%04x failed!\n",
+			reg);
 		return ret;
 	}
 
-- 
1.7.5.4

