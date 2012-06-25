Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab2FYKil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:38:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:42263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2FYKik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:38:40 -0400
Subject: Re: [BUG] sched: clock wrap bug in 2.6.35-stable kills scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Lange <thomas@corelatus.se>
Cc: mingo@redhat.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1340617541.2507.50.camel@laptop>
References: <4FE74F1B.6070803@corelatus.se>
	 <1340617541.2507.50.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 12:38:26 +0200
Message-ID: <1340620706.2507.51.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 11:45 +0200, Peter Zijlstra wrote:
> On Sun, 2012-06-24 at 19:32 +0200, Thomas Lange wrote:
> > Bug was introduced in 2.6.35.12 and is still present in linux-2.6.35.y HEAD.
> 
> Ok, so nobody cares about that.. what does something recent like 3.5-rc4
> do?
> 
> If that's fixed, find the patch that fixes it. If not, we'll have a
> look.


If anything, I think something like the below ought to cure things.

---
 kernel/sched/clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c685e31..a1a128a 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -74,7 +74,7 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
+	return (unsigned long long)(get_jiffies_64() - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
 }
 EXPORT_SYMBOL_GPL(sched_clock);


