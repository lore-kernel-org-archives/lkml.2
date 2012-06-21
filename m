Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab2FUX3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:29:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883Ab2FUX3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:29:02 -0400
Date: Thu, 21 Jun 2012 16:29:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
Message-Id: <20120621162900.e8f3e108.akpm@linux-foundation.org>
In-Reply-To: <4FE3ACCA.5000705@zytor.com>
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com>
	<tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org>
	<20120621154334.05a74517.akpm@linux-foundation.org>
	<4FE3A495.1030008@zytor.com>
	<20120621155159.239aa972.akpm@linux-foundation.org>
	<4FE3A9DF.20303@zytor.com>
	<20120621161558.824d7c6b.akpm@linux-foundation.org>
	<20120621161842.9319cb99.akpm@linux-foundation.org>
	<4FE3ACCA.5000705@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 16:22:50 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/21/2012 04:18 PM, Andrew Morton wrote:
> >>
> >> So why is ktime_t unsigned?
> > 
> > err, actually, it isn't.  But lots of the APIs to manipulate ktime_t
> > use u64.  Reason?
> > 
> > I do agree that time quantities should be signed.
> 
> No idea... probably because when representing an actual wall time since
> the POSIX epoch that can happen during the poweron time on the system,
> the number will be positive since the POSIX epoch predates Linux.
> 

hm.

I'll stick this in my tree and see what happens:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/time.h: make NSEC_PER_SEC 64-bit on 32-bit architectures	

Nanoseconds are usually represented with 64-bit types (s64 and sometimes
u64).  The 32-bit definition of NSEC_PER_SEC can lead to compile-time and
runtime arithmetic overflows on 32-bit systems.

So switch NSEC_PER_SEC to a 64-bit type using "LL".

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@tglx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/time.h~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures include/linux/time.h
--- a/include/linux/time.h~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/include/linux/time.h
@@ -37,7 +37,7 @@ extern struct timezone sys_tz;
 #define NSEC_PER_USEC	1000L
 #define NSEC_PER_MSEC	1000000L
 #define USEC_PER_SEC	1000000L
-#define NSEC_PER_SEC	1000000000L
+#define NSEC_PER_SEC	1000000000LL
 #define FSEC_PER_SEC	1000000000000000LL
 
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
_

