Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab1ITRvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:51:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:46355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1ITRvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:51:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="50390951"
Message-ID: <4E78D2A2.6010106@linux.intel.com>
Date: Tue, 20 Sep 2011 10:51:30 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andi Kleen <andi@firstfloor.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] perf_events: Support a lock_parent event flag
References: <1316127412-1912-1-git-send-email-andi@firstfloor.org>	 <1316127412-1912-3-git-send-email-andi@firstfloor.org> <1316510160.11841.12.camel@twins>
In-Reply-To: <1316510160.11841.12.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This all just sucks horridly. So this name tells us we need inherited
> counters so that whenever we encounter a lock it will be accounted in
> the parent process, or whatever -- which doesn't make any sense.

Thanks for the kind words. So what name do you suggest?

account_in_caller_of_lock ?

i_write_a_novel_in_every_variable_name?

> Furthermore, the sole reason you want this is because you don't want
> callchains, supposedly because they're too expensive, but then you don't
> say that.

perf top doesn't support callchains. And yes it's a lot cheaper too, but 
that wasn't
the main motivation. perf top is just useless to diagnose any lock problems
currently.

I say that in the changelog for the user space.

> How about you provide means of limiting the callchain depth, and then
> frob the in_lock_function() and unwind 1 crap in userspace?

Is that equivalent? The normal call chains don't work without frame 
pointers.
profile_pc does.

-Andi

