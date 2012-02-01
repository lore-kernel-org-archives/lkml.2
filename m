Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2BAKid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:38:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35818 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2BAKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:38:32 -0500
Message-ID: <1328092698.2326.1.camel@phoenix>
Subject: [PATCH] backlight: lp855x_bl: Add missing mutex_unlock in
 lp855x_read_byte error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 01 Feb 2012 18:38:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/lp855x_bl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 8f628b8..8bd0d75 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -41,6 +41,7 @@ static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
 	mutex_lock(&lp->xfer_lock);
 	ret = i2c_smbus_read_byte_data(lp->client, reg);
 	if (ret < 0) {
+		mutex_unlock(&lp->xfer_lock);
 		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
 		return ret;
 	}
-- 
1.7.5.4



