Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1ITRRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:17:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1ITRRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:17:35 -0400
Date: Tue, 20 Sep 2011 19:13:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] creds: __task_cred(current) doesn't need
	rcu_read_lock_held()
Message-ID: <20110920171341.GA22317@redhat.com>
References: <20110920163805.GA20804@redhat.com> <20110920143959.GC15859@redhat.com> <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com> <5088.1316535551@redhat.com> <5820.1316537404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5820.1316537404@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > > -	rcu_dereference_protected(current->cred, 1)
> > >
> > > and:
> > >
> > > > -		rcu_dereference_check(__t->real_cred, 0);		\
> > >
> > > you'll notice they aren't quite the same in one very fundamental way.
> >
> > Do you mean that this patch adds the unnecessary ACCESS_ONCE +
> > smp_read_barrier_depends() to current_cred() or I missed something
> > else?
>
> Something else.  The current_cred() uses ->cred:

Argh!!! I am soooo stupid.

Thanks a lot for the quick NACK!


So. This patch shouldn't touch current_cred().

But this also means, in theory it is not good to assume that
send_signal() can use __task_cred(current) instead of current_cred(),
although I doubt very much that someone can do override_creds() +
kill(SEND_SIG_NOINFO). So the change in __task_cred() is probably not
really good too.

Thanks.

Oleg.

