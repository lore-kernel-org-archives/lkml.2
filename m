Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2BIHvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:51:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab2BIHvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:51:38 -0500
Date: Thu, 9 Feb 2012 08:51:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
        Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arjan Van De Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
Message-ID: <20120209075106.GB18387@elte.hu>
References: <20120208013959.GA24535@panacea>
 <1328670355.2482.68.camel@laptop>
 <20120208202314.GA28290@redhat.com>
 <1328736834.2903.33.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328736834.2903.33.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2012-02-08 at 15:23 -0500, Dave Jones wrote:
> > I think the biggest mistake we ever made with cpufreq was making it
> > so configurable. If we redesign it, just say no to plugin governors,
> > and
> > yes to a lot fewer sysfs knobs.
> > 
> > So, provide mechanism to kill off all the governors, and there's a
> > migration path from what we have now to something that just works
> > in a lot more cases, while remaining configurable enough for the
> > corner-cases.
> 
> On the other hand, the need for schedulable contxts may not 
> necessarily go away.

We will support it, but the *sane* hw solution is where 
frequency transitions can be done atomically. Most workloads 
change their characteristics very quickly, and so does their 
power management profile change.

The user-space driven policy model failed for that reason: it 
was *way* too slow in reacting) - and slow hardware transitions 
suck for a similar reason as well.

We accomodate all hardware as well as we can, but we *design* 
for proper hardware. So Peter is right, this should be done 
properly.

Thanks,

	Ingo
