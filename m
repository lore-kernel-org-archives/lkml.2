Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1GALZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:25:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41839 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab1GALZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:25:50 -0400
Date: Fri, 1 Jul 2011 13:25:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-ID: <20110701112534.GG20990@elte.hu>
References: <20110622152514.GA9521@albatros>
 <20110629151436.9be479fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629151436.9be479fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *ns)
> >  	ns->shm_ctlmax = SHMMAX;
> >  	ns->shm_ctlall = SHMALL;
> >  	ns->shm_ctlmni = SHMMNI;
> > +	ns->shm_rmid_forced = 0;
> >  	ns->shm_tot = 0;
> >  	ipc_init_ids(&shm_ids(ns));
> >  }
> 
> The problem is that nobody will test your feature.  So for testing
> purposes, let's enable the feature by default.  I assume this:

I'd also strongly argue to keep this as a default. OOM-kills are not 
part of POSIX and violate POSIX in a number of ways already.

Furthermore, if testing shows that this is not actually breaking 
anything in a serious way we could also in theory simplify the patch 
and just make this the default behavior with no runtime ability to 
switch it off.

Thanks,

	Ingo
