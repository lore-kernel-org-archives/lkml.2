Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab1ITM7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:59:36 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59935 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1ITM7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:59:35 -0400
Message-ID: <4E788E08.2020707@parallels.com>
Date: Tue, 20 Sep 2011 09:58:48 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 6/9] Include idle and iowait fields in cpuacct
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>   <1316030695-19826-7-git-send-email-glommer@parallels.com>  <1316510490.11841.15.camel@twins> <4E7888B8.3080809@parallels.com> <1316523502.13664.5.camel@twins>
In-Reply-To: <1316523502.13664.5.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.134.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 09:58 AM, Peter Zijlstra wrote:
> On Tue, 2011-09-20 at 09:36 -0300, Glauber Costa wrote:
>> On 09/20/2011 06:21 AM, Peter Zijlstra wrote:
>>> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
>>>> These are slightly different from the others though:
>>>> (note to reviewers: might be better to put those in a separate
>>>> array?)
>>>>
>>>> Since idle/iowait are a property of the system - by definition,
>>>> no process from any cgroup is running when the system is idle,
>>>> they are system wide. So what these fields really mean, are baselines
>>>> for when the cgroup was created. It allows the cgroup to start
>>>> counting idle/iowait from 0.
>>>
>>> Alternatively you can make iowait based on nr_uninterruptible per cgroup
>>> and count all ticks _this_ cgroup was idle.
>> You think?
>>
>> Humm,humm... maybe...
>> iowait can indeed be seen as a process group characteristic. I was
>> mainly concerned about overhead here, specially for the idle case:
>
> The overhead of accounting per cgroup nr_uninterruptible is the worst I
> think, that's in the sleep/wakeup paths.
>
>> If we are idle, there is no task context we can draw from, since the
>> task in the cpu is the idle task. So we end up having to touch all
>> cgroups... Or am I missing something?
>>
>> Sounds expensive.
>
> Count the total number of ticks on the cpu (I think we already have
> that) and subtract the number of ticks in this cgroup (I think we also
> already have that), which should yield: number of ticks not in this
> cgroup, aka number of ticks this cgroup was idle.
No , no... remember steal time.

