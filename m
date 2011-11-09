Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936007Ab1KJEXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:23:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965243Ab1KJDkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:52 2011
Message-Id: <20111109213152.688291716@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, hank <pyu@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [105/264] time: Change jiffies_to_clock_t() argument type to unsigned long
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hank <pyu@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/jiffies.h |    2 +-
 kernel/time.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -303,7 +303,7 @@ extern void jiffies_to_timespec(const un
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
-extern clock_t jiffies_to_clock_t(long x);
+extern clock_t jiffies_to_clock_t(unsigned long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -575,7 +575,7 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-clock_t jiffies_to_clock_t(long x)
+clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ


