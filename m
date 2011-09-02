Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1IBP7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1IBP7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:59:14 -0400
Date: Fri, 2 Sep 2011 17:55:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, neilb@suse.de, paul@paulmenage.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: +
	cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
	added to -mm tree
Message-ID: <20110902155534.GA4595@redhat.com>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org> <20110902123706.GB26764@redhat.com> <20110902140015.GA31530@redhat.com> <20110902141550.GA24012@unix33.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902141550.GA24012@unix33.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Ben Blum wrote:
>
> On Fri, Sep 02, 2011 at 04:00:15PM +0200, Oleg Nesterov wrote:
> > Forgot to mention, sorry...
> >
> > That said, I believe the patch is correct and should fix the problem.
>
> Thanks!
>
> But I don't think the check becomes pointless? If a sub-thread execs
> right before read_lock(&tasklist_lock) (but after the find_task_by_vpid
> in attach_task_by_pid), that causes the case that the comment refers to.

How so? The comment says:

	* a race with de_thread from another thread's exec() may strip
	* us of our leadership, making while_each_thread unsafe

This is not true.

And. Given that ->group_leader can be changed right after we drop tasklist
this check is pointless. Yes, it can detect the case when this task_struct
has nothing to do with this process sometimes, but not in general. (This
connects to other problems I mentioned).

IOW, personally I think it would be better to update the patch. But I
won't insist.

Oleg.

