Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab1GLHU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab1GLHU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:20:26 -0400
Message-ID: <4E1BF5A1.5070301@redhat.com>
Date: Tue, 12 Jul 2011 10:20:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <1309362157-6596-1-git-send-email-avi@redhat.com> <1309362157-6596-2-git-send-email-avi@redhat.com> <20110629160841.GA2032@somewhere> <20110629162725.GH15521@e102144-lin.cambridge.arm.com> <20110704135820.GD5551@somewhere> <4E11C9CC.2070909@redhat.com> <20110704143655.GE5551@somewhere> <20110711210753.GA3582@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110711210753.GA3582@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 12:07 AM, Will Deacon wrote:
> On Mon, Jul 04, 2011 at 03:36:57PM +0100, Frederic Weisbecker wrote:
> >  On Mon, Jul 04, 2011 at 05:10:20PM +0300, Avi Kivity wrote:
> >  >  On 07/04/2011 04:58 PM, Frederic Weisbecker wrote:
> >  >  >Another thing I would like to do in the even longer term is to not use perf anymore
> >  >  >for ptrace breakpoints, because that involves a heavy dependency and few people are
> >  >  >happy with that. Instead we should just have a generic hook into the sched_switch()
> >  >  >and handle pure ptrace breakpoints there. The central breakpoint API would still be
> >  >  >there to reserve/schedule breakpoint resources between ptrace and perf.
> >  >  >
> >  >
> >  >  'struct preempt_notifier' may be the hook you're looking for.
> >
> >  Yeah looks like a perfect fit as it's per task.
>
> I had a quick look at this and I think the preempt_notifier stuff needs
> slightly extending so that we can register a notifier for a task other than
> current [e.g. the child of current on which we are installing breakpoints].
>
> If the task in question is running, it looks like this will introduce a race
> condition between notifier registration and rescheduling. For the purposes
> of ptrace this shouldn't be a problem as the child will be stopped, but
> others might also want to make use of the new functionality.
>
> Any ideas on how this could be achieved, or am I better off just restricting
> this to children that are being traced?

Maybe we need a generic "run this function in this task's context" 
mechanism instead.  Like an IPI, but targeting tasks instead of cpus.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

