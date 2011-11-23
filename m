Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1KWKaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:30:30 -0500
Received: from mx2.parallels.com ([64.131.90.16]:40821 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab1KWKa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:30:28 -0500
Message-ID: <4ECCCB1D.2090501@parallels.com>
Date: Wed, 23 Nov 2011 08:29:49 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>, <pjt@google.com>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH 0/4] Provide cpuacct functionality in cpu cgroup
References: <1321372757-1581-1-git-send-email-glommer@parallels.com> <20111116095706.6304e695.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111116095706.6304e695.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 10:57 PM, KAMEZAWA Hiroyuki wrote:
> On Tue, 15 Nov 2011 13:59:13 -0200
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> Hi,
>>
>> This is an excerpt of the last patches I sent regarding cpu cgroup.
>> It is mostly focused on cleaning up what we have now, so it can
>> be considered largely preparation. As a user of the new organization
>> of things, I am including cpuacct stats functionality in the end of
>> the series. The files related to cpuusage are left to be sent in
>> an upcoming series after this one is included.
>>
>> Let me know if there is anything you'd like me to address.
>>
>
> I'm sorry but let me several questions.
>
> Why cpu cgroup but cpuacct cgroup ?
> If scheduler stat is reported via cpu cgroup, it makes sense.
> If user accounting information is reported via cpu cgroup, I feel it's strange.
> Do you want to make cpuacct cgroup obsolete and merge 2 cgroups ?
>
> What's relationship between this new counters and cpuacct cgroup ?
> Aren't users confused ?
>
> Please provide Documenation.

Hi Kame,

Just so you know, I intend to withdraw this. This idea came from a 
discussion with Peter, where we were thinking about ways to avoid 
collecting statistics more than once, and walking structures more than 
once as well (And cpuusage, for instance, was already collected for the 
task_groups in the scheduler).

Now, Balbir pointed out that the use case for this really needs to keep
the statistics orthogonal to scheduler entities. So with that in mind, 
merging them would complicate things more than it would simplify.

I think I can go back to my original version, where /proc/stat data is 
shown according to data collected in cpuacct.

