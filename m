Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab1IIQol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab1IIQok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:44:40 -0400
Date: Fri, 9 Sep 2011 18:41:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, neilb@suse.de, paul@paulmenage.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: +
	cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
	added to -mm tree
Message-ID: <20110909164122.GA25095@redhat.com>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org> <20110902123706.GB26764@redhat.com> <20110902140015.GA31530@redhat.com> <20110902141550.GA24012@unix33.andrew.cmu.edu> <20110902155534.GA4595@redhat.com> <20110907235931.GA22545@unix33.andrew.cmu.edu> <20110908173559.GA26492@redhat.com> <20110908185805.GB15434@ghc03.ghc.andrew.cmu.edu> <20110908213130.GA3924@redhat.com> <20110909021122.GC16771@unix33.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909021122.GC16771@unix33.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Ben Blum wrote:
>
> On Thu, Sep 08, 2011 at 11:31:30PM +0200, Oleg Nesterov wrote:
> > On 09/08, Ben Blum wrote:
> > >
> > > As for the patch below (which is the same as it was last time?):
> >
> > It is the same, yes, I simply copied it from my old email. BTW, it
> > wasn't tested at all, even compiled.
>
> Testing is recommended ;)

Heh, that is why I didn't send the patch "officially". Not to mention
I never used cgroups.

> If you polished this patch off, I'd be happier, since I have a lot else
> on my plate.

Same here ;)

> > Off-topic question... Looking at this code, it seems that
> > attach_task_by_pid(zombie_pid, threadgroup => true) returns 0.
> > single-task-only case fails with -ESRCH in this case. I am not
> > saying this is wrong, just this looks a bit strange (unless I
> > misread the code).
>
> yeah, this is a side-effect of cgroup_attach_proc continuing to iterate
> in case any one of the sub-threads be still alive. you could keep track
> of whether all threads were zombies and return -ESRCH then,

Yes I see. Although PF_EXITING && thread_group_empty() could help.

> but it
> shouldn't matter, since the user-facing behaviour is indistinguishable
> from if the user had sent the command just before the task turned zombie
> but while it was still about to exit.

Not sure. A task can spend a lot of time being zombie. In this case
we return success or -ESRCH depending on threadgroup.

But I agree, this is minor.

Oleg.

