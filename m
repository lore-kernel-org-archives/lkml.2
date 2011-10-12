Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1JLMbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:31:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33924 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1JLM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/13] drbd: Use the terminology suggested by the command names in the source code and messages
Date: Wed, 12 Oct 2011 14:27:27 +0200
Message-Id: <1318422455-17539-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   16 ++++++++--------
 include/linux/drbd.h         |    4 ++--
 include/linux/drbd_genl.h    |   17 ++++-------------
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 261b512..8be3bef 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -71,8 +71,8 @@ err_out:
 int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info);
 
-int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info);
-int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_down(struct sk_buff *skb, struct genl_info *info);
 
 int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info);
@@ -3021,7 +3021,7 @@ drbd_check_conn_name(const char *name)
 	return NO_ERROR;
 }
 
-int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info)
+int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 
@@ -3038,7 +3038,7 @@ int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info)
 	if (adm_ctx.tconn) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL) {
 			retcode = ERR_INVALID_REQUEST;
-			drbd_msg_put_info("connection exists");
+			drbd_msg_put_info("resource exists");
 		}
 		/* else: still NO_ERROR */
 		goto out;
@@ -3133,7 +3133,7 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 
 	if (!adm_ctx.tconn) {
-		retcode = ERR_CONN_NOT_KNOWN;
+		retcode = ERR_RES_NOT_KNOWN;
 		goto out;
 	}
 
@@ -3187,7 +3187,7 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		retcode = NO_ERROR;
 	} else {
 		/* "can not happen" */
-		retcode = ERR_CONN_IN_USE;
+		retcode = ERR_RES_IN_USE;
 		drbd_msg_put_info("failed to delete connection");
 	}
 	goto out;
@@ -3196,7 +3196,7 @@ out:
 	return 0;
 }
 
-int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
+int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 
@@ -3213,7 +3213,7 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 
 		retcode = NO_ERROR;
 	} else {
-		retcode = ERR_CONN_IN_USE;
+		retcode = ERR_RES_IN_USE;
 	}
 
 	if (retcode == NO_ERROR)
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index fedda00..161cd41 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -155,8 +155,8 @@ enum drbd_ret_code {
 	ERR_CONG_NOT_PROTO_A	= 155,
 	ERR_PIC_AFTER_DEP	= 156,
 	ERR_PIC_PEER_DEP	= 157,
-	ERR_CONN_NOT_KNOWN      = 158,
-	ERR_CONN_IN_USE         = 159,
+	ERR_RES_NOT_KNOWN	= 158,
+	ERR_RES_IN_USE		= 159,
 	ERR_MINOR_CONFIGURED    = 160,
 	ERR_MINOR_EXISTS	= 161,
 	ERR_INVALID_REQUEST	= 162,
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 4ceecb9..47ef324 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -253,25 +253,16 @@ GENL_op(
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_GENLA_F_MANDATORY)
 )
 
-#if 0
-	/* TO BE DONE */
-	/* create or destroy resources, aka replication groups */
-GENL_op(DRBD_ADM_CREATE_RESOURCE, 3, GENL_doit(drbd_adm_create_resource),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
-GENL_op(DRBD_ADM_DELETE_RESOURCE, 4, GENL_doit(drbd_adm_delete_resource),
-	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
-#endif
-
 	/* add DRBD minor devices as volumes to resources */
-GENL_op(DRBD_ADM_ADD_MINOR, 5, GENL_doit(drbd_adm_add_minor),
+GENL_op(DRBD_ADM_NEW_MINOR, 5, GENL_doit(drbd_adm_add_minor),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 GENL_op(DRBD_ADM_DEL_MINOR, 6, GENL_doit(drbd_adm_delete_minor),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 
-	/* add or delete replication links to resources */
-GENL_op(DRBD_ADM_ADD_LINK, 7, GENL_doit(drbd_adm_create_connection),
+	/* add or delete resources */
+GENL_op(DRBD_ADM_NEW_RESOURCE, 7, GENL_doit(drbd_adm_new_resource),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
-GENL_op(DRBD_ADM_DEL_LINK, 8, GENL_doit(drbd_adm_delete_connection),
+GENL_op(DRBD_ADM_DEL_RESOURCE, 8, GENL_doit(drbd_adm_del_resource),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, DRBD_F_REQUIRED))
 
 GENL_op(DRBD_ADM_RESOURCE_OPTS, 9,
-- 
1.7.4.1

