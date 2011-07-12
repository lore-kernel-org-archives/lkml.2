Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1GLJmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:42:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48747 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750Ab1GLJmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:42:19 -0400
Date: Tue, 12 Jul 2011 10:42:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110712094205.GB26125@e102144-lin.cambridge.arm.com>
References: <20110711210753.GA3582@e102144-lin.cambridge.arm.com>
 <4E1BF5A1.5070301@redhat.com>
 <1310459898.18678.108.camel@twins>
 <4E1C0F02.9040906@redhat.com>
 <1310462046.14978.11.camel@twins>
 <4E1C10F8.6010300@redhat.com>
 <1310462335.14978.12.camel@twins>
 <4E1C1373.5080500@redhat.com>
 <1310463060.14978.17.camel@twins>
 <4E1C1585.4000207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1C1585.4000207@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:36:05AM +0100, Avi Kivity wrote:
> On 07/12/2011 12:31 PM, Peter Zijlstra wrote:
> > >
> > >  But it means that 'current' is not set to the right value.  If the
> > >  function depends on it, then it will misbehave.  And in fact
> > >  preempt_notifier_register(), which is the function we want to call here,
> > >  does depend on current.
> > >
> > >  Of course we need to find more users for this, but I have a feeling this
> > >  will be generally useful.  The alternative is to keep adding bits to
> > >  thread_info::flags.
> >
> > Using TIF_bits sounds like a much better solution for this, wakeups are
> > really rather expensive and its best to avoid extra if at all possible.
> >
> 
> We do need a way to make the task look at them.

... especially without pushing this down into the arch code where I don't
think it belongs.
