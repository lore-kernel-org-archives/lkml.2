Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1KQRDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:03:49 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:64102 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757857Ab1KQRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:03:48 -0500
X-IronPort-AV: E=Sophos;i="4.69,528,1315173600"; 
   d="scan'208";a="131205993"
Message-ID: <4EC53E72.5040408@inria.fr>
Date: Thu, 17 Nov 2011 18:03:46 +0100
From: Tomasz Buchert <tomasz.buchert@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz> <4EC4DE9D.3040703@inria.fr> <20111117161318.GA1233@tiehlicka.suse.cz>
In-Reply-To: <20111117161318.GA1233@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/11/2011 17:13, Michal Hocko a écrit :
> On Thu 17-11-11 11:14:53, Tomasz Buchert wrote:
>> Hi,
>> I'm trying to understand now why I did that change in
>>
>> 2d3cbf8bc (the bug itself was in the if-the-else clause in
>> update_if_frozen , anyway).
>> Well, when I look at this now I think that there is nothing wrong
>> with your patch.
>> You can try my testcases from 2d3cbf8bc and 0bdba580, but it should be ok.
> Yes, I have tried it before sending the patch.
>
>> One thing I am not sure completely of is the following situation. So
>> the group is frozen
>> with the STOPPED task inside. There are few questions:
>> * if you send SIGCONT to the task now, will it wake up?
> No, it will enter refrigerator and wake up on thawing the group. Check
> out `goto relock' after do_signal_stop returns.
>
I've checked your patch empirically few hours before :).
Also I've read get_signal_to_deliver() and you are right - it's gonna be 
fine.
The decision is not mine, of course, but I suggest to merge it.
Good work!

Tomek
