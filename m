Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab1KYQ7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 11:59:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1KYQ7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 11:59:03 -0500
Date: Fri, 25 Nov 2011 17:54:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
	given pids
Message-ID: <20111125165409.GA19238@redhat.com>
References: <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com> <20111124173121.GA23260@redhat.com> <4ECF6AA0.80006@parallels.com> <20111125162220.GA17173@redhat.com> <4ECFC5E3.5090900@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECFC5E3.5090900@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Pavel Emelyanov wrote:
>
> On 11/25/2011 08:22 PM, Oleg Nesterov wrote:
> > On 11/25, Pavel Emelyanov wrote:
> >>
> >> The proposal is to implement the PR_RESERVE_PID prctl which allocates and puts a
> >> pid on the current. The subsequent fork() uses this pid,
> >
> > Oh. This is subjective, yes, but this doesn't clean to me.
> >
> > Amd why?? On the running system PR_RESERVE_PID can obviously fail anyway.
> > It only helps to avoid the race with another fork.
>
> No. It can fail if you try to allocate a pid with given number. The API allows for
> pid generation. AFAIU this can help with Pedro's requirements to resurrect task with
> the same pid value it used to have before.

Yes gdb can do fork() in a row (until it unreserves the pid) and the
pid will be the same.

OK, I misunderstood. I thought you insist that PR_RESERVE_PID itself
is reliable.

But this can only work in the simplest case. How you can restore the
multithread tracee? You need to unreserve/reserve the previous pid,
and we have the same problems again, no?

> > Yes, and this task_struct->rsv_pid acts as implicit parameter for the
> > next clone(). Doesn't look very nice to me. Plus the code complications.
>
> Well, the last_pid is also an implicit parameter for the next clone() with sysctl
> approach :)

Yes. but it is already here ;)

Oleg.

