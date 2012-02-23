Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2BWLVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:21:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35308 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755779Ab2BWLVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:21:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ISQwU6YyIYeaRjU7abKoFIgmbfsjZ7fuVRS0EGv
	dK8VCYTjSiN1CR
Message-ID: <1329996064.7411.106.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Thu, 23 Feb 2012 12:21:04 +0100
In-Reply-To: <20120223104959.GA8454@linux.vnet.ibm.com>
References: <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1329748861.2293.345.camel@twins>
	 <1329761661.6276.146.camel@marge.simpson.net>
	 <20120223104959.GA8454@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 16:19 +0530, Srivatsa Vaddagiri wrote:

> I am seeing 2.6% _improvement_ in volanomark score by enabling SD_BALANCE_WAKE 
> at SMT/MC domains.

That's an unexpected (but welcome) result.

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
> I am going to try pipe benchmark next. Do you have suggestions for any other 
> benchmarks I should try to see the effect of SD_BALANCE_WAKE turned on in 
> SMT/MC domains?

Unpinned netperf TCP_RR and/or tbench pairs?  Anything that's wakeup
heavy should tell the tail.

-Mike

