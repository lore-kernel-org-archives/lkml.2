Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1JJLz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:55:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45065 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1JJLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/13] drbd: Don't use empty nested netlink attributes
Date: Mon, 10 Oct 2011 13:55:06 +0200
Message-Id: <1318247706-7732-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Before mainline commit ea5693cc (v2.6.29-rc1), empty nested netlink attributes
were not allowed.  Fix that by leaving out nested attributes if they are empty
and by allowing the top-level attributes to be missing.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 011f7f4..f142380 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1204,7 +1204,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		set_disk_conf_defaults(new_disk_conf);
 
 	err = disk_conf_from_attrs(new_disk_conf, info);
-	if (err) {
+	if (err && err != -ENOMSG) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 	}
@@ -1960,7 +1960,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		set_net_conf_defaults(new_conf);
 
 	err = net_conf_from_attrs(new_conf, info);
-	if (err) {
+	if (err && err != -ENOMSG) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
@@ -2395,7 +2395,7 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		set_res_opts_defaults(&res_opts);
 
 	err = res_opts_from_attrs(&res_opts, info);
-	if (err) {
+	if (err && err != -ENOMSG) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
-- 
1.7.4.1

