Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab2EHIVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:21:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45641 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2EHIVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:21:12 -0400
From: Cristian Chilipirea <cristian.chilipirea@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: daniel.baluta@gmail.com,
        Cristian Chilipirea <cristian.chilipirea@gmail.com>
Subject: [PATCH] Kernel: acct.c: fixed checkpatch warnings
Date: Tue,  8 May 2012 11:21:06 +0300
Message-Id: <1336465266-7505-1-git-send-email-cristian.chilipirea@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some checkpatch warnings and errors.

Signed-off-by: Cristian Chilipirea <cristian.chilipirea@gmail.com>
---
 kernel/acct.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)
 mode change 100644 => 100755 kernel/acct.c

diff --git a/kernel/acct.c b/kernel/acct.c
old mode 100644
new mode 100644
index 02e6167..882c915
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -134,7 +134,7 @@ static int check_free_space(struct bsd_acct_struct *acct, struct file *file)
 	spin_lock(&acct_lock);
 	if (file != acct->file) {
 		if (act)
-			res = act>0;
+			res = act > 0;
 		goto out;
 	}
 
@@ -262,7 +262,7 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 	if (name) {
 		char *tmp = getname(name);
 		if (IS_ERR(tmp))
-			return (PTR_ERR(tmp));
+			return PTR_ERR(tmp);
 		error = acct_on(tmp);
 		putname(tmp);
 	} else {
@@ -376,7 +376,7 @@ static comp_t encode_comp_t(unsigned long value)
 	return exp;
 }
 
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 /*
  * encode an u64 into a comp2_t (24 bits)
  *
@@ -389,7 +389,7 @@ static comp_t encode_comp_t(unsigned long value)
 #define MANTSIZE2       20                      /* 20 bit mantissa. */
 #define EXPSIZE2        5                       /* 5 bit base 2 exponent. */
 #define MAXFRACT2       ((1ul << MANTSIZE2) - 1) /* Maximum fractional value. */
-#define MAXEXP2         ((1 <<EXPSIZE2) - 1)    /* Maximum exponent. */
+#define MAXEXP2         ((1 << EXPSIZE2) - 1)    /* Maximum exponent. */
 
 static comp2_t encode_comp2_t(u64 value)
 {
@@ -420,7 +420,7 @@ static comp2_t encode_comp2_t(u64 value)
 }
 #endif
 
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -429,8 +429,9 @@ static u32 encode_float(u64 value)
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
@@ -490,13 +491,13 @@ static void do_acct_process(struct bsd_acct_struct *acct,
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
@@ -509,15 +510,15 @@ static void do_acct_process(struct bsd_acct_struct *acct,
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
1.7.5.4

