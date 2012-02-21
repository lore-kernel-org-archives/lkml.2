Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2BUAGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:06:33 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59501 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2BUAGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:06:32 -0500
Date: Tue, 21 Feb 2012 05:36:22 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120221000622.GH2350@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
 <1321495153.5100.7.camel@marge.simson.net>
 <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <20120220150348.GC2350@linux.vnet.ibm.com>
 <1329762343.6276.156.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329762343.6276.156.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022014-1396-0000-0000-000000B3B82B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-02-20 19:25:43]:

> > I can give that a try for my benchmark and see how much it helps. My
> > suspicion is it will not fully solve the problem I have on hand.
> 
> I doubt it will either.  Your problem is when it doesn't succeed, but
> you have an idle core available in another domain.

fwiw the patch I had sent does a wakeup balance within prev_cpu's
cache_domain (and not outside). It handles the case where we don't have
any idle cpu/core within prev_cpu's cache domain, in which case we look
for next best thing (least loaded cpu). I did see good numbers with that
(for both my benchmark and sysbench).

More on this later in the day ..

- vatsa

