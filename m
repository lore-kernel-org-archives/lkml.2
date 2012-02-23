Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2BWL07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:26:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab2BWL05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:26:57 -0500
Date: Thu, 23 Feb 2012 12:26:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120223112650.GA23844@elte.hu>
References: <1321495153.5100.7.camel@marge.simson.net>
 <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <20120223104959.GA8454@linux.vnet.ibm.com>
 <20120223112005.GA7645@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223112005.GA7645@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> "perf bench sched pipe" was run 10 times and average ops/sec 
> score alongwith std. dev is noted as below.
> 
> 
> 		SD_BALANCE_WAKE		SD_BALANCE_WAKE
> 		 disabled		enabled
> 
> Avg. score	108984.900 		111844.300 (+2.6%)
> std dev		20383.457		21668.604

pro perf tip of the day: did you know that it's possible to run:

  perf stat --repeat 10 --null perf bench sched pipe

and get meaningful, normalized stddev calculations for free:

       5.486491487 seconds time elapsed                                          ( +-  5.50% )

the percentage at the end shows the level of standard deviation.

You can add "--sync" as well, which will cause perf stat to call 
sync() - this gives extra stability of individual iterations and 
makes sure all IO cost is accounted to the right run.

Thanks,

	Ingo
