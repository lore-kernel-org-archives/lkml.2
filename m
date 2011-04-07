Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1DGIxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 04:53:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36969 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab1DGIxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 04:53:12 -0400
Date: Thu, 7 Apr 2011 10:52:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
Message-ID: <20110407085258.GC16840@elte.hu>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
 <1302077064.2225.1357.camel@twins>
 <1302145733.15889.7472.camel@debian>
 <4D9D55EF.3090606@redhat.com>
 <1302158596.15889.7499.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302158596.15889.7499.camel@debian>
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


* Alex,Shi <alex.shi@intel.com> wrote:

> On Thu, 2011-04-07 at 14:13 +0800, Rik van Riel wrote:
> > On 04/06/2011 11:08 PM, Alex,Shi wrote:
> > > On Wed, 2011-04-06 at 16:04 +0800, Peter Zijlstra wrote:
> > >> On Wed, 2011-04-06 at 06:33 +0800, Alex Shi wrote:
> > 
> > >> You do know that any app that relies on sched_yield behaviour is more
> > >> than broken? Using sched_yield() for anything other than SCHED_FIFO
> > >> tasks is well outside spec.
> > >>
> > >> Furthermore, apparently you used sysctl_sched_compat_yield, which was
> > >> bound to disappear some time, since with the default settings the yield
> > >> semantics didn't actually change.
> > >
> > > Yes, I used sched_compat_yield, otherwise volano will become extremely
> > > slow in my single machine testing. We may reconsider our testing
> > > setting.
> > 
> > With what JVM is this happening?
> 
> I used openjdk from fedora 10~13 and jrockit-R27.3.1-jre1.5.0_11, both
> of them use sched_yield much. And I just did a quick try with
> jrockit-R27.4.0-jre1.6.0_02.x86_64, it had same problem.

Well, switching openjdk to futexes would be a nice performance optimization for 
sure - especially if you can show the speedups with VolanoMark.

It would also put all the performance claims to rest. If indeed yield() is 
faster then this would give us an opportunity to improve futex performance to 
the point (or beyond) yield() based locks.

Thanks,

	Ingo
