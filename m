Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805Ab0FRJsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 05:48:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47052 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab0FRJsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 05:48:52 -0400
Date: Fri, 18 Jun 2010 11:48:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100618094838.GD23977@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <20100612102558.GA4000@elte.hu>
 <4C15A5D1.1040104@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C15A5D1.1040104@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> (2010/06/12 19:25), Ingo Molnar wrote:
> > 
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> >> NMI can be triggered even when IRQ is masked. So it is not safe for NMI 
> >> handler to call some functions. One solution is to delay the call via self 
> >> interrupt, so that the delayed call can be done once the interrupt is 
> >> enabled again. This has been implemented in MCE and perf event. This patch 
> >> provides a unified version and make it easier for other NMI semantic handler 
> >> to take use of the delayed call.
> > 
> > Instead of introducing this extra intermediate facility please use the same 
> > approach the unified NMI watchdog is using (see latest -tip): a perf event 
> > callback gives all the extra functionality needed.
> > 
> > The MCE code needs to be updated to use that - and then it will be integrated 
> > into the events framework.
> 
> Hi Ingo,
> 
> I think this "NMI delayed call mechanism" could be a part of "the events 
> framework" that we are planning to get in kernel soon. [...]

My request was to make it part of perf events - which is a generic event 
logging framework. We dont really need/want a second 'events framework'
as we have one already ;-)

> [...]  At least APEI will use NMI to report some hardware events (likely 
> error) to kernel.  So I suppose we will go to have a delayed call as an 
> event handler for APEI.

Yep, that makes sense. I wasnt arguing against the functionality itself, i was 
arguing against the illogical layering that limits its utility. By making it 
part of perf events it becomes a generic part of that framework and can be 
used by anything that deals with events and uses that framework.

Thanks,

	Ingo
