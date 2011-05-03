Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1ECUDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:03:36 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25783 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab1ECUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:03:35 -0400
Subject: [PATCH 10/16] cciss: increase timeouts for post-reset no-ops
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:41 -0500
Message-ID: <20110503195341.5154.24039.stgit@beardog.cce.hp.com>
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

Just to reduce the messages about timeouts that appear.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 +-
 drivers/block/cciss.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 3b55723..b9f8658 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4353,7 +4353,7 @@ static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, u
 		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
 		if ((tag & ~3) == paddr32)
 			break;
-		schedule_timeout_uninterruptible(HZ);
+		msleep(CCISS_POST_RESET_NOOP_TIMEOUT_MSECS);
 	}
 
 	iounmap(vaddr);
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 21ec628..16b4d58 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -209,8 +209,9 @@ struct ctlr_info
 	((CCISS_BOARD_NOT_READY_WAIT_SECS * 1000) / \
 		CCISS_BOARD_READY_POLL_INTERVAL_MSECS)
 #define CCISS_POST_RESET_PAUSE_MSECS (3000)
-#define CCISS_POST_RESET_NOOP_INTERVAL_MSECS (1000)
+#define CCISS_POST_RESET_NOOP_INTERVAL_MSECS (4000)
 #define CCISS_POST_RESET_NOOP_RETRIES (12)
+#define CCISS_POST_RESET_NOOP_TIMEOUT_MSECS (10000)
 
 /* 
 	Send the command to the hardware 

