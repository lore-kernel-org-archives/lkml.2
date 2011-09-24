Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1IXQlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 12:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab1IXQlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 12:41:13 -0400
Date: Sat, 24 Sep 2011 18:37:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110924163709.GA6776@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920174849.GB22317@redhat.com> <20110920185354.GA19629@sergelap> <20110921175357.GA25590@redhat.com> <20110923163113.GA3820@sergelap> <20110923173656.GA5233@redhat.com> <20110923212025.GA21330@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110923212025.GA21330@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > On 09/23, Serge E. Hallyn wrote:
> > >
> > > It looks like I can fix all the
> > > cases
> >
> > except ptrace_signal(). Although we can simply ignore this case, imho.
>
> ptrace_signal() calls send_signal() though.

Confused... I meant the "if (signr != info->si_signo)" case. This is
simple, and I only meant that this case is not that important.

> > > by checking whether si_fromuser(info)
> >
> > I am not sure... sys_rt_queueinfo() is nasty. Plus we have to handle
> > the "fromkernel" case too. May be we can ignore this too.
>
> sys_rt_tgsigqueueinfo() still seems to go through send_signal().

Yes. But how can you fix si_uid? We do not even know if it exists.
Please look at siginfo/_uid, there is a union. We can't know what
the caller of sys_rt_sigqueueinfo() puts in this location.

Oleg.

