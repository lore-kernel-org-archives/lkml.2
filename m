Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0GNNVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:21:52 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45272 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757103Ab0GNNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:21:50 -0400
Date: Wed, 14 Jul 2010 15:21:48 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 4/4] drivers/media/video: Remove dead CONFIG_OLPC_X0_1
Message-ID: <966ac7deeee8b102b9b8d829ca14e177f9368f21.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_OLPC_X0_1 doesn't exist in Kconfig and is never defined anywhere
else, therefore removing all references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/media/video/ov7670.c |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 91c886a..309b272 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -409,42 +409,6 @@ static struct regval_list ov7670_fmt_raw[] = {
 
 /*
  * Low-level register I/O.
- *
- * Note that there are two versions of these.  On the XO 1, the
- * i2c controller only does SMBUS, so that's what we use.  The
- * ov7670 is not really an SMBUS device, though, so the communication
- * is not always entirely reliable.
- */
-#ifdef CONFIG_OLPC_XO_1
-static int ov7670_read(struct v4l2_subdev *sd, unsigned char reg,
-		unsigned char *value)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret;
-
-	ret = i2c_smbus_read_byte_data(client, reg);
-	if (ret >= 0) {
-		*value = (unsigned char)ret;
-		ret = 0;
-	}
-	return ret;
-}
-
-
-static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
-		unsigned char value)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret = i2c_smbus_write_byte_data(client, reg, value);
-
-	if (reg == REG_COM7 && (value & COM7_RESET))
-		msleep(5);  /* Wait for reset to run */
-	return ret;
-}
-
-#else /* ! CONFIG_OLPC_XO_1 */
-/*
- * On most platforms, we'd rather do straight i2c I/O.
  */
 static int ov7670_read(struct v4l2_subdev *sd, unsigned char reg,
 		unsigned char *value)
@@ -498,7 +462,6 @@ static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
 		msleep(5);  /* Wait for reset to run */
 	return ret;
 }
-#endif /* CONFIG_OLPC_XO_1 */
 
 
 /*
-- 
1.7.0.4

