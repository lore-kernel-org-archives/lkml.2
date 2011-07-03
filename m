Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1GCTia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 15:38:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab1GCTi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 15:38:28 -0400
Date: Sun, 3 Jul 2011 21:38:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Vasiliy Kulikov <segoon@openwall.com>, solar@openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-ID: <20110703193808.GA17797@elte.hu>
References: <20110622152514.GA9521@albatros>
 <20110629151436.9be479fb.akpm@linux-foundation.org>
 <20110701112534.GG20990@elte.hu>
 <20110701113533.GA19945@albatros>
 <20110701120453.GA28008@elte.hu>
 <20110701151827.7061dcda@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701151827.7061dcda@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > As we really prefer working systems over non-working ones (and lots 
> > of unattached shm segments can clearly result in a non-working 
> > system) we can only accept the "this will break stuff" argument if 
> > it's *demonstrated* to break stuff and if the failure scenario is 
> > carefully described in the commit.
> > 
> > It would take a serious breakage to override a "system locks up 
> > swapping itself to death" failure scenario.
> 
> Ths shared memory interface is defined to be persistent for good 
> reason and all sorts of apps rely upon that so no you can't just 
> ignore that. As a configurable alternative it makes sense (indeed 
> many SYS5 admins used to run shared memory segment sweepers to 
> clean up long idle ones)
> 
> However if it's locking the machine up and not being properly 
> handled by resource management then
> 
> a) your resource management is broken so fix that instead
> b) if your resource management is busted or you are not properly
> tracking resource commits then the user is going to be able to achieve the
> same result by other means (eg a unix domain socket bomb)
> 
> If you've got no overcommit set you shouldn't be able to swap to 
> death, it may be the sysv shared memory objects need to be 
> accounted for specifically somewhere but that would be the right 
> thing to fix and the mechanisms to do it exist.

But the majority of systems have overcommit enabled - that is our 
default.

This is a simple extension of the OOM killer being able to ... kill 
things on OOM, ok? 'to kill' implies 'to break'.

Thanks,

	Ingo
