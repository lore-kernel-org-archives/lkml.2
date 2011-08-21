Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1HUXAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:00:15 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:34628 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077Ab1HUXAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:00:11 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] [media] pac207: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:54 -0700
Message-Id: <b754661a8efb88ec06ff5c400c8ddad85e2f4887.1313966090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert usb style logging macros to pr_<level>.
Coalesce formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/gspca/pac207.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/gspca/pac207.c b/drivers/media/video/gspca/pac207.c
index 81739a2..1600df1 100644
--- a/drivers/media/video/gspca/pac207.c
+++ b/drivers/media/video/gspca/pac207.c
@@ -23,6 +23,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "pac207"
 
 #include <linux/input.h>
@@ -178,8 +180,8 @@ static int pac207_write_regs(struct gspca_dev *gspca_dev, u16 index,
 			0x00, index,
 			gspca_dev->usb_buf, length, PAC207_CTRL_TIMEOUT);
 	if (err < 0)
-		err("Failed to write registers to index 0x%04X, error %d)",
-			index, err);
+		pr_err("Failed to write registers to index 0x%04X, error %d\n",
+		       index, err);
 
 	return err;
 }
@@ -194,8 +196,8 @@ static int pac207_write_reg(struct gspca_dev *gspca_dev, u16 index, u16 value)
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			value, index, NULL, 0, PAC207_CTRL_TIMEOUT);
 	if (err)
-		err("Failed to write a register (index 0x%04X,"
-			" value 0x%02X, error %d)", index, value, err);
+		pr_err("Failed to write a register (index 0x%04X, value 0x%02X, error %d)\n",
+		       index, value, err);
 
 	return err;
 }
@@ -210,8 +212,8 @@ static int pac207_read_reg(struct gspca_dev *gspca_dev, u16 index)
 			0x00, index,
 			gspca_dev->usb_buf, 1, PAC207_CTRL_TIMEOUT);
 	if (res < 0) {
-		err("Failed to read a register (index 0x%04X, error %d)",
-			index, res);
+		pr_err("Failed to read a register (index 0x%04X, error %d)\n",
+		       index, res);
 		return res;
 	}
 
-- 
1.7.6.405.gc1be0

