Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1JKNIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:08:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1JKNIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:08:44 -0400
Date: Tue, 11 Oct 2011 08:08:36 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20111011130836.GA5106@sergelap>
References: <20110920185354.GA19629@sergelap>
 <20110921175357.GA25590@redhat.com>
 <20110923163113.GA3820@sergelap>
 <20110923173656.GA5233@redhat.com>
 <20110923212025.GA21330@sergelap>
 <20110924163709.GA6776@redhat.com>
 <20110925201723.GA5288@sergelap>
 <20110926160619.GA13736@redhat.com>
 <20111004174213.GA24179@sergelap>
 <20111009190022.GA13853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111009190022.GA13853@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> Sorry, I missed this email...
> 
> On 10/04, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > --- x/kernel/signal.c
> > > +++ x/kernel/signal.c
> > > @@ -1019,6 +1019,27 @@ static inline int legacy_queue(struct si
> > >  	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
> > >  }
> > >
> > > +static inline fixup_uid(struct siginfo *info, struct task_struct *t)
> > > +{
> > > +#ifdef CONFIG_USER_NS
> > > +	if (current_user_ns() == task_cred_xxx(t, user_ns)))
> > > +#endif
> > > +		return;
> > > +
> > > +	if (SI_FROMKERNEL(info))
> > > +		switch (info->si_code & __SI_MASK) {
> > > +			default:
> > > +				return;
> > > +
> > > +			case __SI_CHLD:
> >
> > If I'm reading this right, this will catch do_notify_parent, which is
> > sending signals not from current.
> 
> Argh, indeed. So we need to modify the callers.
> 
> OTOH, this is only possible if the debugger notifies tracee->real_parent,
> or we reparent to /sbin/init.

Right.  (I thought we decided that was the case anyway, but maybe I was
missing something)

> Anyways, yes, I forgot about this. Thanks.
> 
> Oleg.

I'll try to get the new patch out this week, else early next.  (Shouldn't
take long to write, but testing is another matter)

thanks,
-serge
