Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433Ab2CAJp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:45:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750Ab2CAJpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:45:53 -0500
Date: Thu, 1 Mar 2012 10:45:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mc@linux.vnet.ibm.com
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-ID: <20120301094529.GA366@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228084359.GJ21106@elte.hu>
 <20120228132719.f375071a.akpm@linux-foundation.org>
 <4F4DBB26.2060907@linux.vnet.ibm.com>
 <20120229091732.GA11505@elte.hu>
 <4F4E083A.2080304@linux.vnet.ibm.com>
 <20120301073845.GA5350@elte.hu>
 <4F4F3E16.5080703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4F3E16.5080703@linux.vnet.ibm.com>
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


* Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> We wanted to avoid doing for_each_possible_cpu() to avoid the 
> unnecessary performance hit. [...]

That was done at the cost of making the code rather complex.

The thing is, *ANY* cpu-mask loop is an utter slowpath, so the 
"performance hit" is an overstatement. There's already dozens of 
of for_each_possible_cpu() loops in the kernel, and it's a 
perfectly acceptable solution in such cases.

I suspect it does not matter much now as the code appears to be 
correct, but in general we want to opt for simpler designs for 
rare and fragile codepaths.

Thanks,

	Ingo
