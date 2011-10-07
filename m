Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412Ab1JGL3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:29:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35872 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920Ab1JGL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/12] drbd: Also define the default values of boolean flags in a single place
Date: Fri,  7 Oct 2011 13:27:38 +0200
Message-Id: <1317986865-3706-6-git-send-email-philipp.reisner@linbit.com>
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
 include/linux/drbd_genl.h   |   16 ++++++++--------
 include/linux/drbd_limits.h |   10 ++++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 601334b..eba635a 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -124,10 +124,10 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	__u32_field_def(14,	GENLA_F_MANDATORY,	c_max_rate, DRBD_C_MAX_RATE_DEF)
 	__u32_field_def(15,	GENLA_F_MANDATORY,	c_min_rate, DRBD_C_MIN_RATE_DEF)
 
-	__flg_field_def(16, GENLA_F_MANDATORY,	disk_barrier, 1)
-	__flg_field_def(17, GENLA_F_MANDATORY,	disk_flushes, 1)
-	__flg_field_def(18, GENLA_F_MANDATORY,	disk_drain, 1)
-	__flg_field_def(19, GENLA_F_MANDATORY,	md_flushes, 1)
+	__flg_field_def(16, GENLA_F_MANDATORY,	disk_barrier, DRBD_DISK_BARRIER_DEF)
+	__flg_field_def(17, GENLA_F_MANDATORY,	disk_flushes, DRBD_DISK_FLUSHES_DEF)
+	__flg_field_def(18, GENLA_F_MANDATORY,	disk_drain, DRBD_DISK_DRAIN_DEF)
+	__flg_field_def(19, GENLA_F_MANDATORY,	md_flushes, DRBD_MD_FLUSHES_DEF)
 )
 
 GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
@@ -162,12 +162,12 @@ GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	__u32_field_def(23,	GENLA_F_MANDATORY,	on_congestion, DRBD_ON_CONGESTION_DEF)
 	__u32_field_def(24,	GENLA_F_MANDATORY,	cong_fill, DRBD_CONG_FILL_DEF)
 	__u32_field_def(25,	GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
-	__flg_field_def(26, GENLA_F_MANDATORY,	two_primaries, 0)
+	__flg_field_def(26, GENLA_F_MANDATORY,	two_primaries, DRBD_ALLOW_TWO_PRIMARIES_DEF)
 	__flg_field(27, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	want_lose)
-	__flg_field_def(28, GENLA_F_MANDATORY,	tcp_cork, 1)
-	__flg_field_def(29, GENLA_F_MANDATORY,	always_asbp, 0)
+	__flg_field_def(28, GENLA_F_MANDATORY,	tcp_cork, DRBD_TCP_CORK_DEF)
+	__flg_field_def(29, GENLA_F_MANDATORY,	always_asbp, DRBD_ALWAYS_ASBP_DEF)
 	__flg_field(30, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	dry_run)
-	__flg_field_def(31,	GENLA_F_MANDATORY,	use_rle, 0)
+	__flg_field_def(31,	GENLA_F_MANDATORY,	use_rle, DRBD_USE_RLE_DEF)
 )
 
 GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 52530aa..f44a0b3 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -168,4 +168,14 @@
 
 #define DRBD_PROTOCOL_DEF DRBD_PROT_C
 
+#define DRBD_DISK_BARRIER_DEF	1
+#define DRBD_DISK_FLUSHES_DEF	1
+#define DRBD_DISK_DRAIN_DEF	1
+#define DRBD_MD_FLUSHES_DEF	1
+#define DRBD_TCP_CORK_DEF	1
+
+#define DRBD_ALLOW_TWO_PRIMARIES_DEF	0
+#define DRBD_ALWAYS_ASBP_DEF	0
+#define DRBD_USE_RLE_DEF	0
+
 #endif
-- 
1.7.4.1

