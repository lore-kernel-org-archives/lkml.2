Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2AOSde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:33:34 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22578 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2AOSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:33:32 -0500
Date: Sun, 15 Jan 2012 19:33:30 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Grover <agrover@redhat.com>,
        Dan Carpenter <error27@gmail.com>, Roland Dreier <roland@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] target, iscsi: Fix up a few assignments
Message-ID: <alpine.LNX.2.00.1201151929400.13069@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A statement such as
  struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
has undefined behaviour since there are two assignments to 'na', strictly 
speaking (the order in which side-effects from the assignments take place 
is undefined since there's no intervening sequence point), and it looks 
unintentional in any case.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/target/iscsi/iscsi_target_erl1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

 compile tested only.

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 101b1be..af18cb8 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1238,7 +1238,7 @@ void iscsit_mod_dataout_timer(struct iscsi_cmd *cmd)
 {
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_session *sess = conn->sess;
-	struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
+	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	spin_lock_bh(&cmd->dataout_timeout_lock);
 	if (!(cmd->dataout_timer_flags & ISCSI_TF_RUNNING)) {
@@ -1261,7 +1261,7 @@ void iscsit_start_dataout_timer(
 	struct iscsi_conn *conn)
 {
 	struct iscsi_session *sess = conn->sess;
-	struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
+	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
 		return;
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

