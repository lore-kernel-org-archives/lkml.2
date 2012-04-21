Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2DUK5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 06:57:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40452 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2DUK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 06:57:04 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] kernel: acct.c: fixed minor coding style issues
Date: Sat, 21 Apr 2012 13:56:46 +0300
Message-Id: <1335005806-12198-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed minor coding style issues. (Detected by checkpatch).

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 kernel/acct.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 02e6167..a796ede 100644
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
-	                       (unsigned long) elapsed : (unsigned long) -1l);
+				(unsigned long) elapsed : (unsigned long) -1l);
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
1.7.9.5

