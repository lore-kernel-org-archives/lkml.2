Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1A1BsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:48:06 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6057 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1A1BsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:48:01 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72275229"
Message-ID: <4D422051.4090407@codeaurora.org>
Date: Thu, 27 Jan 2011 17:48:01 -0800
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Bryan Huntsman <bryanh@codeaurora.org>, Colin Cross <ccross@android.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
References: <AANLkTi=6nwDCdzDz7E2EaAw2pf3KUVjmKMRqGfz5zVhP@mail.gmail.com> <1290577024-12347-1-git-send-email-ccross@android.com> <4D42192C.9000701@codeaurora.org> <AANLkTin7B51maXHRH+FNmZ14bmWmEp9P2=2QTNqgq_Fi@mail.gmail.com>
In-Reply-To: <AANLkTin7B51maXHRH+FNmZ14bmWmEp9P2=2QTNqgq_Fi@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/2011 5:30 PM, Paul Menage wrote:
> On Thu, Jan 27, 2011 at 5:17 PM, Bryan Huntsman<bryanh@codeaurora.org>  wrote:
>>
>> Tested-by: Mike Bohan<mbohan@codeaurora.org>
>>
>> I'm responding on Mike's behalf and adding him to this thread.  This
>> patch improves launch time of a test app from ~700ms to ~250ms on MSM,
>> with much lower variance across tests.  We also see UI latency
>> improvements, but have not quantified the gains.
>>
>
> Is this attached to the wrong patch? I'd thought that it was the other
> patch (removing the rcu_synchronize()) that's the performance booster.
> This one is more about preserving the semantics of the notification
> API.

You are correct. "[PATCH 2/2] cgroup: Remove call to synchronize_rcu in 
cgroup_attach_task" improved the performance.

To be more correct, I tested this patch (eg. "cgroup: Set 
CGRP_RELEASABLE when adding to a cgroup") to the degree that it didn't 
appear to cause any stability or functional regressions when performing 
the simple benchmark procedure described above. I did also test "[PATCH 
2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task" 
independently of this patch to verify that it alone improved the 
performance.

Thanks,
Mike

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
