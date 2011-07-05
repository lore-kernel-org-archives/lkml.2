Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1GENKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:10:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32839 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1GENKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:10:18 -0400
Date: Tue, 5 Jul 2011 15:10:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705131005.GA5843@elte.hu>
References: <20110705100320.GK17941@sun>
 <20110705102017.GA12458@elte.hu>
 <20110705103403.GN17941@sun>
 <20110705105959.GA14435@elte.hu>
 <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705121421.GU17941@sun>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> perf, x86: P4 PMU - Add hw_watchdog_set_attr helper to simulate cpu-cycles counting in nmi-watchdog
> 
> Because of constraints existed in Netburst PMU counting
> cpu cycles is allowed for one consumer only.
> 
> If the kernel is booted up with nmi-watchdog enabled
> the watchdog become a consumer of such event and there
> is no more room left for "perf top" and friends (ie any
> attempts to count cpu cycles simultaneously with nmi-watchdog
> doomed to fail).

Hm, what is the symptom - 'perf top' reports nothing?

If multiple users request cycles then perf will time-share them - 
this is what happens if you run many 'perf top' or 'perf stat' 
sessions in parallel for example. For example i just tried to run six 
separate 'perf top' in parallel - and all six worked fine.

So the question is, why does the NMI watchdog prevent 'perf top' from 
working on a P4?

Thanks,

	Ingo
