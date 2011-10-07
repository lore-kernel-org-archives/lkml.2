Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965431Ab1JGL2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:28:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35999 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965118Ab1JGL1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/12] drbd: Convert resync-after into a signed netlink field
Date: Fri,  7 Oct 2011 13:27:44 +0200
Message-Id: <1317986865-3706-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_genl.h         |    2 +-
 include/linux/genl_magic_func.h   |    3 +++
 include/linux/genl_magic_struct.h |    2 ++
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 40606ad..4b446af 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -116,7 +116,7 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	__u32_field_def(7, GENLA_F_MANDATORY,	fencing, DRBD_FENCING_DEF)
 
 	__u32_field_def(8,	GENLA_F_MANDATORY,	resync_rate, DRBD_RESYNC_RATE_DEF)
-	__u32_field_def(9,	GENLA_F_MANDATORY,	resync_after, DRBD_RESYNC_AFTER_DEF)
+	__s32_field_def(9,	GENLA_F_MANDATORY,	resync_after, DRBD_RESYNC_AFTER_DEF)
 	__u32_field_def(10,	GENLA_F_MANDATORY,	al_extents, DRBD_AL_EXTENTS_DEF)
 	__u32_field_def(11,	GENLA_F_MANDATORY,	c_plan_ahead, DRBD_C_PLAN_AHEAD_DEF)
 	__u32_field_def(12,	GENLA_F_MANDATORY,	c_delay_target, DRBD_C_DELAY_TARGET_DEF)
diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index ce02500..e8e1220 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -431,6 +431,9 @@ static inline int s_name ## _to_unpriv_skb(struct sk_buff *skb,		\
 #undef __u32_field_def
 #define __u32_field_def(attr_nr, attr_flag, name, default)		\
 	x->name = default;
+#undef __s32_field_def
+#define __s32_field_def(attr_nr, attr_flag, name, default)		\
+	x->name = default;
 #undef __flg_field_def
 #define __flg_field_def(attr_nr, attr_flag, name, default)		\
 	x->name = default;
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index b1ddbb5..0fca21f 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -115,6 +115,8 @@ enum {
 	__flg_field(attr_nr, attr_flag, name)
 #define __u32_field_def(attr_nr, attr_flag, name, default) \
 	__u32_field(attr_nr, attr_flag, name)
+#define __s32_field_def(attr_nr, attr_flag, name, default) \
+	__s32_field(attr_nr, attr_flag, name)
 #define __str_field_def(attr_nr, attr_flag, name, maxlen) \
 	__str_field(attr_nr, attr_flag, name, maxlen)
 
-- 
1.7.4.1

