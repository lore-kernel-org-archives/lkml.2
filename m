Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1ITSVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:21:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1ITSVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:21:44 -0400
Date: Tue, 20 Sep 2011 20:17:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110920181751.GC22317@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920153944.GA11531@peqn> <20110920162455.GB18891@redhat.com> <20110920164524.GA8214@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920164524.GA8214@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> >
> > I didn't really check, but afaics send_sigio_to_task/etc never use
> > SEND_SIG_NOINFO. And they shouldn't, there is no the sending process.
>
> (I'm sure you're right -

I am not that sure, please recheck ;)

> > I guess ptrace_signal() can even do
> >
> > 	info->si_pid = task_pid_vnr(current->parent);
> >
> > 	if (info->si_pid)	// same namespace
> > 		info->si_uid = current_uid();
> > 	else			// can't see the tracer, we are from the sub-namespace
> > 		info->si_uid = 0;
> >
> > Whatever you like more.
>
> Except you don't have to split pid and user namespaces at the same
> time.

Argh, you mean CLONE_NEWUSER? I fotgot about it. And probably
there is something else which I simply do not know?

I got lost. This means send_signal() can't rely on from_parent_ns.
I have no idea how can we fix sys_kill() without a lot of ugly changes
then.

Oleg.

