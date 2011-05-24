Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab1EXEYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:24:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41630 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab1EXEYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:24:36 -0400
Date: Tue, 24 May 2011 06:24:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: huang ying <huang.ying.caritas@gmail.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
Message-ID: <20110524042414.GB8554@elte.hu>
References: <20110520115614.GH14745@elte.hu>
 <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com>
 <20110522100021.GA28177@elte.hu>
 <BANLkTi=VDQMOfWe5tP7nXSv2AEsiUUEteg@mail.gmail.com>
 <20110522132515.GA13078@elte.hu>
 <4DD9C8B9.5070004@intel.com>
 <20110523110151.GD24674@elte.hu>
 <4DDB1396.7050205@intel.com>
 <20110524024848.GA25230@elte.hu>
 <4DDB210D.6060202@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDB210D.6060202@intel.com>
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


* Huang Ying <ying.huang@intel.com> wrote:

> On 05/24/2011 10:48 AM, Ingo Molnar wrote:
> > 
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> >>>> - How to deal with ring-buffer overflow?  For example, there is full of 
> >>>>   corrected memory error in ring-buffer, and now a recoverable memory error 
> >>>>   occurs but it can not be put into perf ring buffer because of ring-buffer 
> >>>>   overflow, how to deal with the recoverable memory error?
> >>>
> >>> The solution is to make it large enough. With *every* queueing solution there 
> >>> will be some sort of queue size limit.
> >>
> >> Another solution could be:
> >>
> >> Create two ring-buffer. One is for logging and will be read by RAS
> >> daemon; the other is for recovering, the event record will be removed
> >> from the ring-buffer after all 'active filters' have been run on it.
> >> Even RAS daemon being restarted or hang, recoverable error can be taken
> >> cared of.
> > 
> > Well, filters will always be executed since they execute when the event is 
> > inserted - not when it's extracted.
> 
> For filters executed in NMI context, they can be executed when the event
> is inserted, no need for buffering.  But for filters executed in
> deferred IRQ context, they need to be executed when event's extracted.

Correct.

Thanks,

	Ingo
