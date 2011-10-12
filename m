Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1JLM3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:29:37 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33949 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1JLM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/13] drbd: Rename DRBD_ADM_NEED_{CONN -> RESOURCE}
Date: Wed, 12 Oct 2011 14:27:30 +0200
Message-Id: <1318422455-17539-9-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_nl.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0c07baf..a834097 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -165,7 +165,7 @@ int drbd_msg_put_info(const char *info)
  * If it returns successfully, adm_ctx members are valid.
  */
 #define DRBD_ADM_NEED_MINOR	1
-#define DRBD_ADM_NEED_CONN	2
+#define DRBD_ADM_NEED_RESOURCE	2
 static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		unsigned flags)
 {
@@ -230,18 +230,18 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		drbd_msg_put_info("unknown minor");
 		return ERR_MINOR_INVALID;
 	}
-	if (!adm_ctx.tconn && (flags & DRBD_ADM_NEED_CONN)) {
-		drbd_msg_put_info("unknown connection");
+	if (!adm_ctx.tconn && (flags & DRBD_ADM_NEED_RESOURCE)) {
+		drbd_msg_put_info("unknown resource");
 		return ERR_INVALID_REQUEST;
 	}
 
 	/* some more paranoia, if the request was over-determined */
 	if (adm_ctx.mdev && adm_ctx.tconn &&
 	    adm_ctx.mdev->tconn != adm_ctx.tconn) {
-		pr_warning("request: minor=%u, conn=%s; but that minor belongs to connection %s\n",
+		pr_warning("request: minor=%u, resource=%s; but that minor belongs to connection %s\n",
 				adm_ctx.minor, adm_ctx.resource_name,
 				adm_ctx.mdev->tconn->name);
-		drbd_msg_put_info("minor exists in different connection");
+		drbd_msg_put_info("minor exists in different resource");
 		return ERR_INVALID_REQUEST;
 	}
 	if (adm_ctx.mdev &&
@@ -1909,7 +1909,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	int rsr; /* re-sync running */
 	struct crypto crypto = { };
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
@@ -2042,7 +2042,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	int i;
 	int err;
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
@@ -2219,7 +2219,7 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 	enum drbd_ret_code retcode;
 	int err;
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
@@ -2371,7 +2371,7 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 	struct res_opts res_opts;
 	int err;
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
@@ -3063,7 +3063,7 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 	struct drbd_genlmsghdr *dh = info->userhdr;
 	enum drbd_ret_code retcode;
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
@@ -3207,7 +3207,7 @@ int drbd_adm_del_resource(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_RESOURCE);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
-- 
1.7.4.1

