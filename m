Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0JOPOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:14:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:36534 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703Ab0JOPN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:13:59 -0400
Message-ID: <4CB86F94.7080702@kernel.org>
Date: Fri, 15 Oct 2010 17:13:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v2.6.36-rc7] init: don't call flush_scheduled_work() from
 do_initcalls()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 15:13:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unclear what flush_scheduled_work() in do_initcalls() tries to
achieve.  The call doesn't make much sense - there already are
multiple system workqueues which aren't affected by
flush_scheduled_wokr() and subsystems are free to create and use their
own.  Ordering requirements are and should be expressed explicitly.

Drop the call to prepare for deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
If no one objects, I'll route this through wq tree.

Thank you.

 init/main.c |    3 ---
 1 file changed, 3 deletions(-)

Index: work/init/main.c
===================================================================
--- work.orig/init/main.c
+++ work/init/main.c
@@ -778,9 +778,6 @@ static void __init do_initcalls(void)

 	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
 		do_one_initcall(*fn);
-
-	/* Make sure there is no pending stuff from the initcall sequence */
-	flush_scheduled_work();
 }

 /*
