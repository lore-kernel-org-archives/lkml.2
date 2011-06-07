Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1FGKkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:40:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44697 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1FGKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Bxlt4xEDibaZZwInehYhbN6FVoZEdN/F4QSIW+UrK4jery5N8YIXjHJ9ioFphLXqJL
         PrcERBKw0cNsAUXWj1EQR9R667XqsiZd4ZCgOfxt6jC7Vt9JS4Jy1EqNmWJzIKIXYFcs
         kNJ0+kuOe4x3g0XRlrcssnm9IZHbJCAUVrpIY=
From: Akshay Joshi <me@akshayjoshi.com>
Cc: Akshay Joshi <me@akshayjoshi.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Kernel: add spaces where required by the coding style in acct.c.
Date: Tue,  7 Jun 2011 06:39:38 -0400
Message-Id: <1307443181-22278-5-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
References: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds spaces where required by the kernel coding style. Most
of these changes are for precompiler statements.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 kernel/acct.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index fa7eb3d..c946fdc 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -144,7 +144,7 @@ static int check_free_space(struct bsd_acct_struct *acct, struct file *file)
 	spin_lock(&acct_lock);
 	if (file != acct->file) {
 		if (act)
-			res = act>0;
+			res = act > 0;
 		goto out;
 	}
 
@@ -396,7 +396,7 @@ static comp_t encode_comp_t(unsigned long value)
 	return exp;
 }
 
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 /*
  * encode an u64 into a comp2_t (24 bits)
  *
@@ -440,7 +440,7 @@ static comp2_t encode_comp2_t(u64 value)
 }
 #endif
 
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -449,8 +449,9 @@ static u32 encode_float(u64 value)
 	unsigned exp = 190;
 	unsigned u;
 
-	if (value==0) return 0;
-	while ((s64)value > 0){
+	if (value == 0)
+		return 0;
+	while ((s64)value > 0) {
 		value <<= 1;
 		exp--;
 	}
@@ -510,13 +511,13 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 		       + current->group_leader->start_time.tv_nsec;
 	/* convert nsec -> AHZ */
 	elapsed = nsec_to_AHZ(run_time);
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 	ac.ac_etime = encode_float(elapsed);
 #else
 	ac.ac_etime = encode_comp_t(elapsed < (unsigned long) -1l ?
 	                       (unsigned long) elapsed : (unsigned long) -1l);
 #endif
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 	{
 		/* new enlarged etime field */
 		comp2_t etime = encode_comp2_t(elapsed);
@@ -529,15 +530,15 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	/* we really need to bite the bullet and change layout */
 	ac.ac_uid = orig_cred->uid;
 	ac.ac_gid = orig_cred->gid;
-#if ACCT_VERSION==2
+#if ACCT_VERSION == 2
 	ac.ac_ahz = AHZ;
 #endif
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 	/* backward-compatible 16 bit fields */
 	ac.ac_uid16 = ac.ac_uid;
 	ac.ac_gid16 = ac.ac_gid;
 #endif
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 	ac.ac_pid = task_tgid_nr_ns(current, ns);
 	rcu_read_lock();
 	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
-- 
1.7.4.4

