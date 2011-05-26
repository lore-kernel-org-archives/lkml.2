Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab1EZSse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:48:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:43277 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab1EZSsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:48:33 -0400
Date: Thu, 26 May 2011 20:48:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] Core updates for ....
Message-ID: <alpine.LFD.2.02.1105262042360.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	tglx

------------------>
Eric Dumazet (1):
      seqlock: Get rid of SEQLOCK_UNLOCKED


 arch/ia64/kernel/time.c         |    2 +-
 arch/x86/kernel/vsyscall_64.c   |    2 +-
 include/linux/seqlock.h         |    3 ---
 net/ipv4/inet_connection_sock.c |    2 +-
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 04440cc..85118df 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -36,7 +36,7 @@
 static cycle_t itc_get_cycles(struct clocksource *cs);
 
 struct fsyscall_gtod_data_t fsyscall_gtod_data = {
-	.lock = SEQLOCK_UNLOCKED,
+	.lock = __SEQLOCK_UNLOCKED(fsyscall_gtod_data.lock),
 };
 
 struct itc_jitter_data_t itc_jitter_data;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index dcbb28c..59be48d 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -59,7 +59,7 @@ int __vgetcpu_mode __section_vgetcpu_mode;
 
 struct vsyscall_gtod_data __vsyscall_gtod_data __section_vsyscall_gtod_data =
 {
-	.lock = SEQLOCK_UNLOCKED,
+	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 	.sysctl_enabled = 1,
 };
 
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 06d6964..e981189 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -41,9 +41,6 @@ typedef struct {
 #define __SEQLOCK_UNLOCKED(lockname) \
 		 { 0, __SPIN_LOCK_UNLOCKED(lockname) }
 
-#define SEQLOCK_UNLOCKED \
-		 __SEQLOCK_UNLOCKED(old_style_seqlock_init)
-
 #define seqlock_init(x)					\
 	do {						\
 		(x)->sequence = 0;			\
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 61fac4c..c14d88a 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(inet_csk_timer_bug_msg);
  * This struct holds the first and last local port number.
  */
 struct local_ports sysctl_local_ports __read_mostly = {
-	.lock = SEQLOCK_UNLOCKED,
+	.lock = __SEQLOCK_UNLOCKED(sysctl_local_ports.lock),
 	.range = { 32768, 61000 },
 };
 
