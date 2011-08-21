Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1HUXAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:00:07 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:58205 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077Ab1HUXAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:00:01 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, Frank Zago <frank@zago.net>,
        Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] [media] finepix: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:53 -0700
Message-Id: <74571fd780c71f5dd4d4d03a9845c0c9b9ef395f.1313966090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert usb style logging macros to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/gspca/finepix.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/finepix.c b/drivers/media/video/gspca/finepix.c
index 987b4b6..ea48200 100644
--- a/drivers/media/video/gspca/finepix.c
+++ b/drivers/media/video/gspca/finepix.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "finepix"
 
 #include "gspca.h"
@@ -182,7 +184,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* Init the device */
 	ret = command(gspca_dev, 0);
 	if (ret < 0) {
-		err("init failed %d", ret);
+		pr_err("init failed %d\n", ret);
 		return ret;
 	}
 
@@ -194,14 +196,14 @@ static int sd_start(struct gspca_dev *gspca_dev)
 			FPIX_MAX_TRANSFER, &len,
 			FPIX_TIMEOUT);
 	if (ret < 0) {
-		err("usb_bulk_msg failed %d", ret);
+		pr_err("usb_bulk_msg failed %d\n", ret);
 		return ret;
 	}
 
 	/* Request a frame, but don't read it */
 	ret = command(gspca_dev, 1);
 	if (ret < 0) {
-		err("frame request failed %d", ret);
+		pr_err("frame request failed %d\n", ret);
 		return ret;
 	}
 
-- 
1.7.6.405.gc1be0

