Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2DNJND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:13:03 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:41321 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2DNJM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:12:59 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 1/2] sbp-target: minor cleanups after merging into single file
Date: Sat, 14 Apr 2012 10:12:25 +0100
Message-Id: <1334394746-31738-2-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334394746-31738-1-git-send-email-bootc@bootc.net>
References: <1334394746-31738-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few minor cleanups to make a couple more elements static and
remove some extern definitions from the header which are not exported.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/sbp/sbp_target.c |    6 +++---
 drivers/target/sbp/sbp_target.h |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index d7c9ac9..37c6098 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -43,10 +43,10 @@
 #include "sbp_target.h"
 
 /* Local pointer to allocated TCM configfs fabric module */
-struct target_fabric_configfs *sbp_fabric_configfs;
+static struct target_fabric_configfs *sbp_fabric_configfs;
 
 /* FireWire address region for management and command block address handlers */
-const struct fw_address_region sbp_register_region = {
+static const struct fw_address_region sbp_register_region = {
 	.start	= CSR_REGISTER_BASE + 0x10000,
 	.end	= 0x1000000000000ULL,
 };
@@ -1435,7 +1435,7 @@ static void sbp_sense_mangle(struct sbp_target_request *req)
 		STATUS_BLOCK_SBP_STATUS(SBP_STATUS_OK));
 }
 
-int sbp_send_sense(struct sbp_target_request *req)
+static int sbp_send_sense(struct sbp_target_request *req)
 {
 	struct se_cmd *se_cmd = &req->se_cmd;
 
diff --git a/drivers/target/sbp/sbp_target.h b/drivers/target/sbp/sbp_target.h
index 1ec2269..6d0d74a 100644
--- a/drivers/target/sbp/sbp_target.h
+++ b/drivers/target/sbp/sbp_target.h
@@ -193,9 +193,6 @@ struct sbp_tport {
 	int max_logins_per_lun;
 };
 
-extern struct target_fabric_configfs *sbp_fabric_configfs;
-extern const struct fw_address_region sbp_register_region;
-
 static inline u64 sbp2_pointer_to_addr(const struct sbp2_pointer *ptr)
 {
 	return (u64)(be32_to_cpu(ptr->high) & 0x0000ffff) << 32 |
-- 
1.7.9.5

