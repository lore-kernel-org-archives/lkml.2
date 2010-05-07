Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0EGIon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:44:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:32827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0EGIom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:44:42 -0400
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU
 utilization
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1273220736.1642.318.camel@laptop>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins>  <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop>  <1273220736.1642.318.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 10:44:38 +0200
Message-ID: <1273221878.1642.320.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 10:25 +0200, Peter Zijlstra wrote:
> We are however still fully greedy, which is still O(n), which we don't
> want. However if we stop being greedy and use the same heuristic we do
> now, stop filling the PMU at the first fail, we'll still be fair,
> because the algorithm ensures that.
> 
FWIW the non-greedy algorithm is O(m * log(n)), where m is the number of
counters on the PMU and n the number of competing events, since m is
pretty much a constant, we can say the full algorithm is O(log n).



