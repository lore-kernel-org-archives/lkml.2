Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1KKMZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:25:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1KKMZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:25:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Fri, 11 Nov 2011 13:27:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111110133106.12e519d17f6a28adfee3b883@canb.auug.org.au>
In-Reply-To: <20111110133106.12e519d17f6a28adfee3b883@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111111327.58960.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 10, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> mm/oom_kill.c: In function 'select_bad_process':
> mm/oom_kill.c:326:5: error: implicit declaration of function 'thaw_process'
> 
> Caused by commit 944e192db53c ("freezer: rename thaw_process() to
> __thaw_task() and simplify the implementation").
> 
> I have used the pm tree from next-20111109 for today.

The appended patch fixes the build problem for me.  I've added it to my
linux-next branch already.

Tejun, please let me know if that's OK.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Freezer: Fix fallout of thaw_process() -> __thaw_task() rename

The changset that renamed thaw_process() to __thaw_task() forgot to
modify oom_kill.c in accordance with that change and introduced
a build problem.  Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/oom_kill.c
===================================================================
--- linux.orig/mm/oom_kill.c
+++ linux/mm/oom_kill.c
@@ -323,7 +323,7 @@ static struct task_struct *select_bad_pr
 		 */
 		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
 			if (unlikely(frozen(p)))
-				thaw_process(p);
+				__thaw_task(p);
 			return ERR_PTR(-1UL);
 		}
 		if (!p->mm)
