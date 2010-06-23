Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0FWKH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:07:26 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51616 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0FWKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:36 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH 30/40] trace syscalls: Convert remaining kernel/compat.c syscalls to COMPAT_SYSCALL_DEFINE
Date: Wed, 23 Jun 2010 20:03:11 +1000
Message-Id: <1277287401-28571-31-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch converts the remaining system calls from kernel/compat.c to
use the COMPAT_SYSCALL_DEFINE family of macros.

The particular system calls in question did not originally have the
asmlinkage tag which will be added by this conversion.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/compat.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 7ab99e1..81762e4 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -535,9 +535,9 @@ int put_compat_itimerspec(struct compat_itimerspec __user *dst,
 	return 0;
 }
 
-long compat_sys_timer_create(clockid_t which_clock,
-			struct compat_sigevent __user *timer_event_spec,
-			timer_t __user *created_timer_id)
+COMPAT_SYSCALL_DEFINE3(timer_create, clockid_t, which_clock,
+			struct compat_sigevent __user *, timer_event_spec,
+			timer_t __user *, created_timer_id)
 {
 	struct sigevent __user *event = NULL;
 
@@ -553,9 +553,9 @@ long compat_sys_timer_create(clockid_t which_clock,
 	return sys_timer_create(which_clock, event, created_timer_id);
 }
 
-long compat_sys_timer_settime(timer_t timer_id, int flags,
-			  struct compat_itimerspec __user *new,
-			  struct compat_itimerspec __user *old)
+COMPAT_SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
+			  struct compat_itimerspec __user *, new,
+			  struct compat_itimerspec __user *, old)
 {
 	long err;
 	mm_segment_t oldfs;
@@ -576,8 +576,8 @@ long compat_sys_timer_settime(timer_t timer_id, int flags,
 	return err;
 }
 
-long compat_sys_timer_gettime(timer_t timer_id,
-		struct compat_itimerspec __user *setting)
+COMPAT_SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
+		struct compat_itimerspec __user *, setting)
 {
 	long err;
 	mm_segment_t oldfs;
@@ -593,8 +593,8 @@ long compat_sys_timer_gettime(timer_t timer_id,
 	return err;
 }
 
-long compat_sys_clock_settime(clockid_t which_clock,
-		struct compat_timespec __user *tp)
+COMPAT_SYSCALL_DEFINE2(clock_settime, clockid_t, which_clock,
+		struct compat_timespec __user *, tp)
 {
 	long err;
 	mm_segment_t oldfs;
@@ -610,8 +610,8 @@ long compat_sys_clock_settime(clockid_t which_clock,
 	return err;
 }
 
-long compat_sys_clock_gettime(clockid_t which_clock,
-		struct compat_timespec __user *tp)
+COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
+		struct compat_timespec __user *, tp)
 {
 	long err;
 	mm_segment_t oldfs;
@@ -627,8 +627,8 @@ long compat_sys_clock_gettime(clockid_t which_clock,
 	return err;
 }
 
-long compat_sys_clock_getres(clockid_t which_clock,
-		struct compat_timespec __user *tp)
+COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
+		struct compat_timespec __user *, tp)
 {
 	long err;
 	mm_segment_t oldfs;
@@ -668,9 +668,9 @@ static long compat_clock_nanosleep_restart(struct restart_block *restart)
 	return err;
 }
 
-long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
-			    struct compat_timespec __user *rqtp,
-			    struct compat_timespec __user *rmtp)
+COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
+			    struct compat_timespec __user *, rqtp,
+			    struct compat_timespec __user *, rmtp)
 {
 	long err;
 	mm_segment_t oldfs;
-- 
1.7.1

