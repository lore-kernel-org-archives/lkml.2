Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1BBIy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:54:57 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45301 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1BBIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:54:55 -0500
Message-ID: <4D491BE2.7010802@linux.vnet.ibm.com>
Date: Wed, 02 Feb 2011 14:24:58 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 1/2 v2.0]sched: Removing unused fields from /proc/schedstat
References: <4D3F3595.4020607@linux.vnet.ibm.com> <4D3F3676.1030601@linux.vnet.ibm.com> <4D3FBAD5.1070307@jp.fujitsu.com> <4D463647.7000106@linux.vnet.ibm.com>
In-Reply-To: <4D463647.7000106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satoru,


>> I think we can remove rq->sched_switch and rq->sched_switch
>> without no problem because they are meaningless. The former
>> is for old O(1) scheduler and means the number of runqueue
>> switching among active/expired queue. The latter is for
>> SD_WAKE_BALANCE flag and its logic is already gone.
>>
>> However sbe_* are for SD_BALANCE_EXEC flag and sbf_* are for
>> SD_BALANCE_FORK flag. Since both logic for them are still alive,
>> the absence of these accounting is regression in my perspective.
>> In addition, these fields would be useful for analyzing load
>> balance behavior.
>>

The sbe_* & sbf_* counters were added by the commit 
68767a0ae428801649d510d9a65bb71feed44dd1 But it was subsequently 
removed by the commit 476d139c218e44e045e4bc6d4cc02b010b343939

[ciju@ciju kernel]$ git describe 68767a0ae428801649d510d9a65bb71feed44dd1 --contains
v2.6.13-rc1~68^2~148
[ciju@ciju kernel]$ git describe 476d139c218e44e045e4bc6d4cc02b010b343939 --contains
v2.6.13-rc1~68^2~140

So.. it was introduced and removed in 2.6.13 time frame


When the counters were removed the sbe_* sbf_* variable
declarations were not removed. Hence it caused a little confusion.
So I believe these stats were not available and hence can't be 
considered as regression. 

476d139c218e44e045e4bc6d4cc02b010b343939 consolidated the fork and 
exec balance. Thereafter it became non-trivial to provide separate 
stats for fork and exec events. So if people think a consolidated  
balance-on-event is needed, it can be looked into separately. But 
that shouldn't prevent this documentation cleanup patch from 
getting in.

-Ciju


