Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1IFTnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:43:24 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:17018 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1IFTnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:43:19 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPVD:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 6 Sep 2011 15:43:09 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Hommey <mh@glandium.org>, <linux-kernel@vger.kernel.org>,
        <dzickus@redhat.com>
Subject: Re: Problem with perf hardware counters grouping
In-Reply-To: <1314878012.11566.7.camel@twins>
Message-ID: <alpine.DEB.2.00.1109061538270.24588@cl320.eecs.utk.edu>
References: <20110831085718.GB13884@glandium.org> <1314878012.11566.7.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Peter Zijlstra wrote:
> 
> Both those have 4 generic hardware counters, but x86 defaults to
> enabling the NMI watchdog which takes one, leaving you with 3 (try: echo
> 0 > /proc/sys/kernel/nmi_watchdog). If you had looked at your dmesg
> output you'd have found lines like:
> 
>   NMI watchdog enabled, takes one hw-pmu counter.
> 
> The code can only check if the group as a whole could possibly fit on a
> PMU, which is where your failure on >4 comes from.
> 
> What happens with your >3 case is that while the group is valid and
> could fit on the PMU, it won't fit at runtime because the NMI watchdog
> is taking one and won't budge (cpu-pinned counter have precedence over
> any other kind), effectively starving your group of pmu runtime.
> 
> Also, we should fix that return to say -EINVAL or so.

So any hope of a fix on this?  

As mentioned this is a serious problem for PAPI and I am trying to find a 
good way to enable a workaround in a way that doesn't punish people who 
have the watchdog disabled.

Is there a "stable" API method of determining if the nmi_watchdog is 
present and stealing a perf-counter?  

If I find a "1" in /proc/sys/kernel/nmi_watchdog can I assume a counter is 
being stolen?

Vince

