Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2BWLLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:11:50 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60711 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab2BWLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:11:48 -0500
Date: Thu, 23 Feb 2012 16:19:59 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120223104959.GA8454@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329761661.6276.146.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022310-4790-0000-0000-000001747ADA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-02-20 19:14:21]:

> > I was looking at this code due to vatsa wanting to do SD_BALANCE_WAKE.
> 
> I really really need to find time to do systematic mainline testing.
> 
> Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> Maybe that has changed, but I doubt it.  (general aside: testing with a
> bloated distro config is a big mistake)

I am seeing 2.6% _improvement_ in volanomark score by enabling SD_BALANCE_WAKE 
at SMT/MC domains.

Machine : 2 Quad-core Intel X5570 CPU (H/T enabled)
Kernel  : tip (HEAD at 6241cc8)
Java	: OpenJDK 1.6.0_20
Volano  : 2_9_0

Volano benchmark was run 4 times with and w/o SD_BALANCE_WAKE enabled in
SMT/MC domains.

				Average score	std. dev

SD_BALANCE_WAKE disabled	369459.750	4825.046
SD_BALANCE_WAKE enabled		379070.500	379070.5

I am going to try pipe benchmark next. Do you have suggestions for any other 
benchmarks I should try to see the effect of SD_BALANCE_WAKE turned on in 
SMT/MC domains?

- vatsa

