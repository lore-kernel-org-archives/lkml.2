Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1JITHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 15:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1JITHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 15:07:43 -0400
Date: Sun, 9 Oct 2011 21:03:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20111009190344.GB13853@redhat.com>
References: <20110920174849.GB22317@redhat.com> <20110920185354.GA19629@sergelap> <20110921175357.GA25590@redhat.com> <20110923163113.GA3820@sergelap> <20110923173656.GA5233@redhat.com> <20110923212025.GA21330@sergelap> <20110924163709.GA6776@redhat.com> <20110925201723.GA5288@sergelap> <20110926160619.GA13736@redhat.com> <20111008200211.GA28115@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111008200211.GA28115@hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> >
> > +static inline fixup_uid(struct siginfo *info, struct task_struct *t)
> > +{
> > +#ifdef CONFIG_USER_NS
> > +	if (current_user_ns() == task_cred_xxx(t, user_ns)))
> > +#endif
> > +		return;
> > +
> > +	if (SI_FROMKERNEL(info))
> > +		switch (info->si_code & __SI_MASK) {
> > +			default:
> > +				return;
> > +
> > +			case __SI_CHLD:
>
> After looking a bit more, I really think the __SI_CHLD case just needs to
> always be converted at the callers (i.e. do_notify_parent).

Yes, unfortunately.

> > +			case __SI_MESGQ:
>
> This can be done like this, but if this is going to be the only case of
> a SI_FROMKERNEL not being converted at the caller, and there is aiui only
> one caller (__do_notivy in ipc/mmqueue.c), it seems better to just have
> fixup_uid() always return for SI_FROMKERNEL(info).

Yes, agreed.

Oleg.

