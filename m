Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1I0KbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:31:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49150 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1I0KbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:31:18 -0400
Date: Tue, 27 Sep 2011 16:01:06 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110927103106.GD4357@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <20110927063222.GB18519@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110927063222.GB18519@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2011-09-27 08:32:24]:

> What are the tasks doing which are running - are they plain burning 
> CPU time? If the tasks do something more complex, do you also have a 
> measure of how much work gets done by the workload, per second?

They are simple cpu hogs at this time.

> Percentual changes in that metric would be nice to include in an 
> additional column - that way we can see that it's not only idle
> that has gone down, but workload performance has gone up too.

Ok, good point.

> In fact even if there was only a CPU burning loop in the workload it 
> would be nice to make that somewhat more sophisticated by letting it 
> process some larger array that has a cache footprint. This mimics 
> real workloads that don't just spin burning CPU time but do real data 
> processing.
> 
> For any non-trivial workload it's possible to reduce idle time 
> without much increase in work done and in fact it's possible to 
> decrease idle time *and* work done - so we need to see more clearly 
> here and make sure it's all an improvement.

Ok - I will run a cpu intensive benchmark and get some numbers on
how benchmark score varies with the patch applied. I can pick a simple
matrix multiplication type benchmark, unless you have other suggestions!

- vatsa
