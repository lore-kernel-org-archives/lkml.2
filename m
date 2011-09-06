Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1IFNbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:31:03 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:62664 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab1IFNa7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:30:59 -0400
X-AuditID: 1209190d-b7be0ae000000a16-51-4e661fc23280
Subject: Re: [PATCH] percpu_counter: Put a reasonable upper bound on percpu_counter_batch
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110906034851.GC18425@mtj.dyndns.org>
Date: Tue, 6 Sep 2011 09:30:50 -0400
Cc: Anton Blanchard <anton@samba.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
References: <20110826072622.406d3395@kryten> <20110826072927.5b4781f9@kryten> <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110829214609.495ee299@kryten> <20110906034851.GC18425@mtj.dyndns.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1244.3)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsUixG6nrntIPs3PYOdEWYuvXzpYLP7df8Fu
	se/9WTaLmfPusFlc3jWHzeLX8qOMDmweLZvLPXbOusvusWlVJ5vH3F19jB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZXw9bVEwi7Ni2tJpjA2Ma9m7GDk5JARMJK7smc0EYYtJXLi3nq2LkYtDSGAf
	o8TEe50sEM56RomGvQ1sIFVCApeZJH5NdgexhQUiJc5v+cfaxcjBwStgLPH6H9ggZgE9iR3X
	f7GC2GwCShJ3Pu1nAbE5gZb9PPEObDGLgIrEk1VvwZYxC2xilFjVN4UNollbYtnC18wgNq+A
	lcS5D7dYIY64zChxamYr2AYRAVmJK9MeMkKcLS+xuOUz4wRGwVkId8xCcscsJGMXMDKvYpRN
	ya3SzU3MzClOTdYtTk7My0st0jXSy80s0UtNKd3ECIoATkneHYzvDiodYhTgYFTi4dVKSPUT
	Yk0sK67MPcQoycGkJMq7Ghg/QnxJ+SmVGYnFGfFFpTmpxYcYJTiYlUR4tfiBcrwpiZVVqUX5
	MClpDhYlcd7CHQ5+QgLpiSWp2ampBalFMFkZDg4lCd5KkKGCRanpqRVpmTklCGkmDk6Q4TxA
	w81AaniLCxJzizPTIfKnGBWlxHmPgCQEQBIZpXlwvbAE9YpRHOgVYd5ckCoeYHKD634FNJgJ
	aPCh/FSQwSWJCCmpBsbTOXOPFCV1mOxUYH70+uGu25082kIm2mse5PTXT503R8zqVP22sImx
	/qxBBwPslhly9FrEV1+vOLpMquKl+GfZSv581qKJ7txz0y+5dsRNkFNWWHFezFXA/7GP+CoF
	o01397/YqX1dUrOy9W+Omuci06A9R7f8t4uzy3ZMbJlcWv08bPt7WyWW4oxEQy3mouJEAPZ6
	rU8rAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5, 2011, at 11:48 PM, Tejun Heo wrote:

> On Mon, Aug 29, 2011 at 09:46:09PM +1000, Anton Blanchard wrote:
>> 
>> When testing on a 1024 thread ppc64 box I noticed a large amount of
>> CPU time in ext4 code.
>> 
>> ext4_has_free_blocks has a fast path to avoid summing every free and
>> dirty block per cpu counter, but only if the global count shows more
>> free blocks than the maximum amount that could be stored in all the
>> per cpu counters.
>> 
>> Since percpu_counter_batch scales with num_online_cpus() and the maximum
>> amount in all per cpu counters is percpu_counter_batch * num_online_cpus(),
>> this breakpoint grows at O(n^2).
>> 
>> This issue will also hit with users of percpu_counter_compare which
>> does a similar thing for one percpu counter.
>> 
>> I chose to cap percpu_counter_batch at 1024 as a conservative first
>> step, but we may want to reduce it further based on further benchmarking.
>> 
>> Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> Applied to percpu/for-3.2.

Um, this was an ext4 patch and I pointed out it could cause problems.  (Specifically, data loss…)

- Ted

