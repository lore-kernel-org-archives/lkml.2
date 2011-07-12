Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab1GLJle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:41:34 -0400
Received: from 8bytes.org ([88.198.83.132]:59530 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1GLJld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:41:33 -0400
Date: Tue, 12 Jul 2011 11:41:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110712094131.GA29812@8bytes.org>
References: <20110704143655.GE5551@somewhere> <20110711210753.GA3582@e102144-lin.cambridge.arm.com> <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins> <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins> <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins> <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310463060.14978.17.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 11:31:00AM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 12:27 +0300, Avi Kivity wrote:

> > But it means that 'current' is not set to the right value.  If the 
> > function depends on it, then it will misbehave.  And in fact 
> > preempt_notifier_register(), which is the function we want to call here, 
> > does depend on current.
> > 
> > Of course we need to find more users for this, but I have a feeling this 
> > will be generally useful.  The alternative is to keep adding bits to 
> > thread_info::flags.
> 
> Using TIF_bits sounds like a much better solution for this, wakeups are
> really rather expensive and its best to avoid extra if at all possible.

I would rather vote for Avi's solution too. Such a functionality is very
helpful for LWP-perf integration as well (because we need a way to call
do_mmap for a task != current).

Regards,

	Joerg

