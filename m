Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2HOUQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:16:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:36921 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab2HOTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: hank <pyu@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 083/165] time: Change jiffies_to_clock_t() argument type to unsigned long
Date: Wed, 15 Aug 2012 15:47:07 -0400
Message-ID: <1345060109-9187-84-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hank <pyu@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cbbc719fccdb8cbd87350a05c0d33167c9b79365 upstream.

The parameter's origin type is long. On an i386 architecture, it can
easily be larger than 0x80000000, causing this function to convert it
to a sign-extended u64 type.

Change the type to unsigned long so we get the correct result.

Signed-off-by: hank <pyu@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
[ build fix ]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/jiffies.h | 2 +-
 kernel/time.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 6811f4b..284c13d 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -303,7 +303,7 @@ extern void jiffies_to_timespec(const unsigned long jiffies,
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
-extern clock_t jiffies_to_clock_t(long x);
+extern clock_t jiffies_to_clock_t(unsigned long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
diff --git a/kernel/time.c b/kernel/time.c
index 656dccf..82e83b0 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -592,7 +592,7 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-clock_t jiffies_to_clock_t(long x)
+clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
-- 
1.7.12.rc2

