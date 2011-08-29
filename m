Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1H2SYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab1H2SYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:24:06 -0400
Date: Mon, 29 Aug 2011 20:20:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: linux-next: build warning after merge of the ptrace tree
Message-ID: <20110829182018.GA14729@redhat.com>
References: <20110829152704.e533760bfb83fc7480333b20@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829152704.e533760bfb83fc7480333b20@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 08/29, Stephen Rothwell wrote:
>
> After merging the ptrace tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>
> fs/autofs4/waitq.c: In function 'autofs4_wait':
> fs/autofs4/waitq.c:462:17: warning: unused variable 'irqflags'
>
> Introduced by commit 33ee1d9bc213 ("autofs4: Use set_current_blocked()").

Argh. Thanks again.

I've committed the trivial fix.

Oleg.

commit 2efd0a8f5a5e981022faaec780ee00c05eeee8aa
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Mon Aug 29 20:17:24 2011 +0200

    autofs4_wait: remove the unused irqflags variable
    
    irqflags is not used since 33ee1d9bc213, remove it.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 58ba49a..09fb503 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -459,7 +459,6 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	if (wq->name.name) {
 		/* Block all but "shutdown" signals while waiting */
 		sigset_t oldset, blocked;
-		unsigned long irqflags;
 
 		oldset = current->blocked;
 		siginitsetinv(&blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);

