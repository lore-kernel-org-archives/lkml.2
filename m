Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0KJKPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:15:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42182 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0KJKP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:15:28 -0500
Date: Wed, 10 Nov 2010 11:14:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110101450.GA18481@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> Taking a cue from the tracing session from the previous day (where the "perf" vs. 
> "ftrace" vs. "lttng" war was ended by proposing a new tracing methodology that 
> would overcome the shortcomings of both of the merged subsystems while also 
> addressing the requirements of the lttng users) [...]

Well, the direction is that we are unifying ftrace and perf events and we are 
actively phasing out individual ftrace plugins as matching events become available 
(we already removed a few).

Most new tools use the perf syscall and tool writers have expressed the very 
understandable desire that all events (and their reporting facility) be enumerated 
and accessible via a unified API/ABI.

While it often seems easier for subsystems to just do their own ad-hoc 
logging/reporting in the short run (every subsystem tends to think it has its own 
very specific requirements for logging - while users/tool-authors can only shake 
their head in disbelief when looking at the myriads of incompatible and inconsistent 
facilities). The tooling requirement for unification is strong here and can not be 
ignored.

> [...] we explored whether the solution would be to define a new "system health" 
> subsystem that could be used by any part of the kernel to report hardware issues 
> in a coherent way so that end users would have a single place to look for all 
> error information.

Note that Boris has been working on extending perf events into this area as well, 
see this recent submission of patches on lkml:

  [PATCH 20/20] ras: Add RAS daemon

One thing is clear: any 'health subsystem' should not do its own flavor of error 
reporting - instead we want to unify various forms of event logging into a common 
facility.

RAS/EDAC could do its own hardware-specific settings via a separate subsystem - 
although even many of those can be expressed via their respective events. (and we 
are open on the perf events side to give callbacks/facilities for such use)

The synergies of unified event reporting are very strong.

Thanks,

	Ingo
