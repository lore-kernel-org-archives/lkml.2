Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1AaEKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:10:45 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57258 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1AaEKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:10:44 -0500
Message-ID: <4D463647.7000106@linux.vnet.ibm.com>
Date: Mon, 31 Jan 2011 09:40:47 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2 v2.0]sched: Removing unused fields from /proc/schedstat
References: <4D3F3595.4020607@linux.vnet.ibm.com> <4D3F3676.1030601@linux.vnet.ibm.com> <4D3FBAD5.1070307@jp.fujitsu.com>
In-Reply-To: <4D3FBAD5.1070307@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satoru,

> 
> This patch is logically correct, succeeded to compile and works
> fine. But I came to be worried about whether it is good to kill
> all fields you said after reading old and upstream scheduler
> code again.
> 
> I think we can remove rq->sched_switch and rq->sched_switch
> without no problem because they are meaningless. The former
> is for old O(1) scheduler and means the number of runqueue
> switching among active/expired queue. The latter is for
> SD_WAKE_BALANCE flag and its logic is already gone.
> 
> However sbe_* are for SD_BALANCE_EXEC flag and sbf_* are for
> SD_BALANCE_FORK flag. Since both logic for them are still alive,
> the absence of these accounting is regression in my perspective.
> In addition, these fields would be useful for analyzing load
> balance behavior.
> 

sbe_* & sbf_* flags are added by the commit
68767a0ae428801649d510d9a65bb71feed44dd1  Git describe shows that it was
gone in to v2.6.12-1422-g68767a0  which is quite old. So in my opinion
this might not be a regression.

> # although I haven't been able to notice they are always zero ;-(
> 
> I prefer not to remove these fields({sbe,sbf}_*) but to add
> accounting code for these flags again. What do you think?

I will go through the code and verify once again.

-Ciju

