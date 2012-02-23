Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2BWLTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:19:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58336 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab2BWLTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:19:43 -0500
Date: Thu, 23 Feb 2012 12:19:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120223111929.GA23646@elte.hu>
References: <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
 <1321495153.5100.7.camel@marge.simson.net>
 <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <20120223104959.GA8454@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223104959.GA8454@linux.vnet.ibm.com>
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

> * Mike Galbraith <efault@gmx.de> [2012-02-20 19:14:21]:
> 
> > > I was looking at this code due to vatsa wanting to do SD_BALANCE_WAKE.
> > 
> > I really really need to find time to do systematic mainline testing.
> > 
> > Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> > Maybe that has changed, but I doubt it.  (general aside: testing with a
> > bloated distro config is a big mistake)
> 
> I am seeing 2.6% _improvement_ in volanomark score by enabling SD_BALANCE_WAKE 
> at SMT/MC domains.
> 
> Machine : 2 Quad-core Intel X5570 CPU (H/T enabled)
> Kernel  : tip (HEAD at 6241cc8)
> Java	: OpenJDK 1.6.0_20
> Volano  : 2_9_0
> 
> Volano benchmark was run 4 times with and w/o SD_BALANCE_WAKE enabled in
> SMT/MC domains.
> 
> 				Average score	std. dev
> 
> SD_BALANCE_WAKE disabled	369459.750	4825.046
> SD_BALANCE_WAKE enabled		379070.500	379070.5
> 
> I am going to try pipe benchmark next. Do you have suggestions 
> for any other benchmarks I should try to see the effect of 
> SD_BALANCE_WAKE turned on in SMT/MC domains?

sysbench is one of the best ones punishing bad scheduler 
balancing mistakes.

Thanks,

	Ingo
