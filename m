Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1CCIwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:52:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab1CCIwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:52:10 -0500
Date: Thu, 3 Mar 2011 09:51:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <daahern@cisco.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, acme@ghostprotocols.net,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, John Stultz <johnstul@us.ibm.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
Message-ID: <20110303085148.GA16832@elte.hu>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
 <1298865151-23656-4-git-send-email-daahern@cisco.com>
 <alpine.LFD.2.00.1103012359460.2701@localhost6.localdomain6>
 <4D6E5413.6060500@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E5413.6060500@cisco.com>
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


* David Ahern <daahern@cisco.com> wrote:

> > How does all that deal with CLOCK_REALTIME being affected by NTP and
> > settimeofday? Not really, as far as I can tell. It somehow works, but
> > that depends on the frequency of your event injection.
> 
> It is sampled at some periodic rate to get NTP changes. Right now it is
> hardcoded at once an hour. The frequency option can be added to the
> --tod parameter.

As Thomas mentioned, we probably need something more complete than that.

Still your approach is obviously useful and i'd like to stress that explicitly. Have 
you considered another related feature, feeding printk lines as special 'string 
events' into the perf ringbuffer?

It would round up your scheme very nicely: that way you'd have a single, global, 
GTOD-correlated event store/flow for basically every system event you might be 
interested in. You could switch events (and tracepoints) on/off based on need, 
controlling the type and rate of information in a very finegrained way.

If the printk approach works out i'd even suggest that such a facility would need a 
separate tool within perf: 'perf syslog' or 'perf log'. It would heavily reuse 
perf-script and other perf internal facilities, obviously - but you would not be 
tied to any particular sub-tool implementation.

EDAC type events could feed into this as well, giving the tool a broader 'system 
health' aspect as well, beyond the 'system performance analysis' aspect.

Thanks,

	Ingo
