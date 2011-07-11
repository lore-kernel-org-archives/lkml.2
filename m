Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1GKVIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:08:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37588 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab1GKVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:08:20 -0400
Date: Mon, 11 Jul 2011 22:07:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110711210753.GA3582@e102144-lin.cambridge.arm.com>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
 <1309362157-6596-2-git-send-email-avi@redhat.com>
 <20110629160841.GA2032@somewhere>
 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>
 <20110704135820.GD5551@somewhere>
 <4E11C9CC.2070909@redhat.com>
 <20110704143655.GE5551@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704143655.GE5551@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 03:36:57PM +0100, Frederic Weisbecker wrote:
> On Mon, Jul 04, 2011 at 05:10:20PM +0300, Avi Kivity wrote:
> > On 07/04/2011 04:58 PM, Frederic Weisbecker wrote:
> > >Another thing I would like to do in the even longer term is to not use perf anymore
> > >for ptrace breakpoints, because that involves a heavy dependency and few people are
> > >happy with that. Instead we should just have a generic hook into the sched_switch()
> > >and handle pure ptrace breakpoints there. The central breakpoint API would still be
> > >there to reserve/schedule breakpoint resources between ptrace and perf.
> > >
> > 
> > 'struct preempt_notifier' may be the hook you're looking for.
> 
> Yeah looks like a perfect fit as it's per task.

I had a quick look at this and I think the preempt_notifier stuff needs
slightly extending so that we can register a notifier for a task other than
current [e.g. the child of current on which we are installing breakpoints].

If the task in question is running, it looks like this will introduce a race
condition between notifier registration and rescheduling. For the purposes
of ptrace this shouldn't be a problem as the child will be stopped, but
others might also want to make use of the new functionality.

Any ideas on how this could be achieved, or am I better off just restricting
this to children that are being traced?

Cheers,

Will
