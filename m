Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab1JEJiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:38:11 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56207 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161Ab1JEJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/16] drbd: rename variable sc to res_opts
Date: Wed,  5 Oct 2011 11:37:52 +0200
Message-Id: <1317807484-24628-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

sc was short for syncer conf, which does not exist anymore anyways.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 51dc869..addd175 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2335,7 +2335,7 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 	cpumask_var_t new_cpu_mask;
 	struct drbd_tconn *tconn;
 	int *rs_plan_s = NULL;
-	struct res_opts sc;
+	struct res_opts res_opts;
 	int err;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
@@ -2351,11 +2351,11 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	sc = tconn->res_opts;
+	res_opts = tconn->res_opts;
 	if (should_set_defaults(info))
-		drbd_set_res_opts_default(&sc);
+		drbd_set_res_opts_default(&res_opts);
 
-	err = res_opts_from_attrs(&sc, info);
+	err = res_opts_from_attrs(&res_opts, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
@@ -2363,8 +2363,8 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* silently ignore cpu mask on UP kernel */
-	if (nr_cpu_ids > 1 && sc.cpu_mask[0] != 0) {
-		err = __bitmap_parse(sc.cpu_mask, 32, 0,
+	if (nr_cpu_ids > 1 && res_opts.cpu_mask[0] != 0) {
+		err = __bitmap_parse(res_opts.cpu_mask, 32, 0,
 				cpumask_bits(new_cpu_mask), nr_cpu_ids);
 		if (err) {
 			conn_warn(tconn, "__bitmap_parse() failed with %d\n", err);
@@ -2374,7 +2374,7 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 
-	tconn->res_opts = sc;
+	tconn->res_opts = res_opts;
 
 	if (!cpumask_equal(tconn->cpu_mask, new_cpu_mask)) {
 		cpumask_copy(tconn->cpu_mask, new_cpu_mask);
-- 
1.7.4.1

