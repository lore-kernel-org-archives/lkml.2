Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1JKRER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:04:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab1JKREN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:04:13 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:09 2011
Message-Id: <20111011165709.681634347@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:19 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [09/38] sched: Fix up wchan borkage
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Simon Kirby <sim@hostway.ca>

commit 6ebbe7a07b3bc40b168d2afc569a6543c020d2e3 upstream.

Commit c259e01a1ec ("sched: Separate the scheduler entry for
preemption") contained a boo-boo wrecking wchan output. It forgot to
put the new schedule() function in the __sched section and thereby
doesn't get properly ignored for things like wchan.

Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110923000346.GA25425@hostway.ca
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4335,7 +4335,7 @@ static inline void sched_submit_work(str
 		blk_schedule_flush_plug(tsk);
 }
 
-asmlinkage void schedule(void)
+asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 


