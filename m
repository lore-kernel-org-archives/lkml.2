Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0FJG0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:26:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44686 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0FJG0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:26:34 -0400
Date: Thu, 10 Jun 2010 08:26:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] perf events finer grained context instrumentation /
 context exclusion
Message-ID: <20100610062618.GA20062@elte.hu>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Here is the new version of per context exclusion, based on hooks on 
> irq_enter/irq_exit. I haven't observed slowdowns but I haven't actually 
> measured the impact.

One thing that would be nice to see in this discussion is a comparison of 
before/after perf stat --repeat runs.

Something like:

  perf stat --repeat ./hackbench 5

Done with full stat, and then also done with hardirqs/softirqs excluded. (i.e. 
task context stats only)

I.e. does the feature really give us the expected statistical stability in 
results? Does it really exclude hardirq/softirq workloads, etc.?

Thanks,

	Ingo
