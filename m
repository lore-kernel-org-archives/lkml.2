Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab1IHXcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:32:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab1IHXcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:32:36 -0400
Date: Thu, 8 Sep 2011 23:31:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, neilb@suse.de, paul@paulmenage.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: +
	cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
	added to -mm tree
Message-ID: <20110908213130.GA3924@redhat.com>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org> <20110902123706.GB26764@redhat.com> <20110902140015.GA31530@redhat.com> <20110902141550.GA24012@unix33.andrew.cmu.edu> <20110902155534.GA4595@redhat.com> <20110907235931.GA22545@unix33.andrew.cmu.edu> <20110908173559.GA26492@redhat.com> <20110908185805.GB15434@ghc03.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908185805.GB15434@ghc03.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Ben Blum wrote:
>
> As for the patch below (which is the same as it was last time?):

It is the same, yes, I simply copied it from my old email. BTW, it
wasn't tested at all, even compiled.

> did you
> mean for Andrew to replace the old tasklist_lock patch with this one, or
> should one of us rewrite this against it?

This is up to you. And just in case, please feel free to do nothing and
keep the current fix.

> either way, it should have
> something like the comment I proposed in the first thread.

Confused... Aha, I missed another email from you. You mean

	/* If the leader exits, its links on the thread_group list become
	 * invalid. One way this can happen is if a sub-thread does exec() when
	 * de_thread() calls release_task(leader) (and leader->sighand gets set
	 * to NULL, in which case lock_task_sighand will fail). Since in that
	 * case the threadgroup is still around, cgroup_procs_write should try
	 * again (finding the new leader), which EAGAIN indicates here. This is
	 * "double-double-toil-and-trouble-check locking". */

Agreed.





Off-topic question... Looking at this code, it seems that
attach_task_by_pid(zombie_pid, threadgroup => true) returns 0.
single-task-only case fails with -ESRCH in this case. I am not
saying this is wrong, just this looks a bit strange (unless I
misread the code).

Oleg.

