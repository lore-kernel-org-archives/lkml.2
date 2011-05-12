Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1ELR0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:26:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab1ELR0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:26:48 -0400
Date: Thu, 12 May 2011 19:25:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110512172506.GA23033@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-10-git-send-email-tj@kernel.org> <20110511154854.GB23688@redhat.com> <20110511192902.GC24245@mtj.dyndns.org> <20110512154247.GC18599@redhat.com> <20110512160253.GK1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512160253.GK1030@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Tejun Heo wrote:
>
> Hello,
>
> On Thu, May 12, 2011 at 05:42:47PM +0200, Oleg Nesterov wrote:
> > On 05/11, Tejun Heo wrote:
> > >
> > > > Can't we push this patch ahead of these changes? I can merge it into
> > > > ptrace branch.
> > >
> > > It doesn't really fix the problem tho.  The whole thing is full of
> > > holes
> >
> > Hmm. Could you explain?  (unless you mean ptrace holes)
>
> I meant other cases, RUNNING -> STOPPED and EXIT_* transitions.
> Sleeping wait(2) is reliable without grabbing siglock thanks to
> setting TASK_INTERRUPTIBLE on start and events waking up the waiter
> after updating the state, so wait(2) is guaranteed to check the states
> at least once after change actually has happened.
>
> WNOHANG disables that mechanism.

Yes, this is clear. WNOHANG can "race" with the transitions above.
But we do not care, this is like reading the word which can be
changed by another thread, no?

But this bug is different. Say, the parent does wait(WNOWAIT) and
gets CLD_STOPPED. After that it has all rights to assume that
wait(WNOHANG) must report either STOPPED or CONTINUED.

Oleg.

