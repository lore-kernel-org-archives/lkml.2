Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2LHXLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 18:11:44 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38913 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2LHXLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 18:11:43 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Michael Buesch <m@bues.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] ssb: use WARN in main.c
Date: Sat,  8 Dec 2012 23:11:06 +0000
Message-Id: <1355008266-5419-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/ssb/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index bd7115c..c82c5c9 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1133,8 +1133,7 @@ static u32 ssb_tmslow_reject_bitmask(struct ssb_device *dev)
 	case SSB_IDLOW_SSBREV_27:     /* same here */
 		return SSB_TMSLOW_REJECT;	/* this is a guess */
 	default:
-		printk(KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
-		WARN_ON(1);
+		WARN(1, KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
 	}
 	return (SSB_TMSLOW_REJECT | SSB_TMSLOW_REJECT_23);
 }
-- 
1.7.4.5

