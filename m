Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0IOLqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:46:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35796 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab0IOLqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:46:21 -0400
Date: Wed, 15 Sep 2010 13:45:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        greenrd@greenrd.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] hw breakpoints: Fix pid namespace bug
Message-ID: <20100915114556.GA18760@elte.hu>
References: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
 <tip-d958077d007d98125766d11e82da2fd6497b91d6@git.kernel.org>
 <20100915114150.GA5621@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915114150.GA5621@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.4
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.4 required=5.9 tests=BAYES_00,URG_BIZ autolearn=no SpamAssassin version=3.2.5
	1.6 URG_BIZ                BODY: Contains urgent matter
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Sep 15, 2010 at 10:03:06AM +0000, tip-bot for Matt Helsley wrote:
> > Commit-ID:  d958077d007d98125766d11e82da2fd6497b91d6
> > Gitweb:     http://git.kernel.org/tip/d958077d007d98125766d11e82da2fd6497b91d6
> > Author:     Matt Helsley <matthltc@us.ibm.com>
> > AuthorDate: Mon, 13 Sep 2010 13:01:18 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 15 Sep 2010 10:43:59 +0200
> > 
> > hw breakpoints: Fix pid namespace bug
> > 
> > Hardware breakpoints can't be registered within pid namespaces
> > because tsk->pid is passed rather than the pid in the current
> > namespace.
> > 
> > (See https://bugzilla.kernel.org/show_bug.cgi?id=17281 )
> > 
> > This is a quick fix demonstrating the problem but is not the
> > best method of solving the problem since passing pids internally
> > is not the best way to avoid pid namespace bugs. Subsequent patches
> > will show a better solution.
> > 
> > Much thanks to Frederic Weisbecker <fweisbec@gmail.com> for doing the
> > bulk of the work finding this bug.
> > 
> > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Robin Green <greenrd@greenrd.org>
> > Cc: Prasad <prasad@linux.vnet.ibm.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> > LKML-Reference: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> 
> 
> Aiie, you have been too fast too apply that on -tip, [...]

Came from Peter.

> [...] especially it should go to perf/urgent with some stable backport 
> tags. And I need to test them as he said that was only compile tested.

No problem, mind cherry-picking it into an urgent pull request? The 
overlap is not an issue.

> Lemme just check it really fixes the issue and I'll package his three 
> patches in according pull requests.

Ok!

Thanks,

	Ingo
