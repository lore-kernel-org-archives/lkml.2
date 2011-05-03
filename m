Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1ECTxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:53:30 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38954 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1ECTx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:26 -0400
Subject: [PATCH 07/16] cciss: get rid of message related magic numbers
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:26 -0500
Message-ID: <20110503195326.5154.11431.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c     |    8 ++++----
 drivers/block/cciss_cmd.h |    8 ++++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d604489..1a4dff0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2569,7 +2569,7 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 		}
 	} else if (cmd_type == TYPE_MSG) {
 		switch (cmd) {
-		case 0:	/* ABORT message */
+		case CCISS_ABORT_MSG:
 			c->Request.CDBLen = 12;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
 			c->Request.Type.Direction = XFER_WRITE;
@@ -2579,16 +2579,16 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 			/* buff contains the tag of the command to abort */
 			memcpy(&c->Request.CDB[4], buff, 8);
 			break;
-		case 1:	/* RESET message */
+		case CCISS_RESET_MSG:
 			c->Request.CDBLen = 16;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
 			c->Request.Type.Direction = XFER_NONE;
 			c->Request.Timeout = 0;
 			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
 			c->Request.CDB[0] = cmd;	/* reset */
-			c->Request.CDB[1] = 0x03;	/* reset a target */
+			c->Request.CDB[1] = CCISS_RESET_TYPE_TARGET;
 			break;
-		case 3:	/* No-Op message */
+		case CCISS_NOOP_MSG:
 			c->Request.CDBLen = 1;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
 			c->Request.Type.Direction = XFER_WRITE;
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index a2e68d2..3b20c31 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -142,6 +142,14 @@ typedef struct _ReadCapdata_struct_16
 #define BMIC_CACHE_FLUSH 0xc2
 #define CCISS_CACHE_FLUSH 0x01	/* C2 was already being used by CCISS */
 
+#define CCISS_ABORT_MSG 0x00
+#define CCISS_RESET_MSG 0x01
+#define CCISS_RESET_TYPE_CONTROLLER 0x00
+#define CCISS_RESET_TYPE_BUS 0x01
+#define CCISS_RESET_TYPE_TARGET 0x03
+#define CCISS_RESET_TYPE_LUN 0x04
+#define CCISS_NOOP_MSG 0x03
+
 /* Command List Structure */
 #define CTLR_LUNID "\0\0\0\0\0\0\0\0"
 

