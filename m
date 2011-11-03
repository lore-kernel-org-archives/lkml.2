Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414Ab1KCS5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:57:16 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45168 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933865Ab1KCS5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:57:14 -0400
Message-ID: <4EB2E3E6.6070401@parallels.com>
Date: Thu, 3 Nov 2011 16:56:38 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag> <4EB2C4A5.6000406@parallels.com> <20111103165903.GA4755@Debian-60-squeeze-64-minimal> <20111103182101.5037c1e5@lxorguk.ukuu.org.uk> <20111103185108.GA5153@Debian-60-squeeze-64-minimal>
In-Reply-To: <20111103185108.GA5153@Debian-60-squeeze-64-minimal>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 04:51 PM, Max Kellermann wrote:
> On 2011/11/03 19:21, Alan Cox<alan@lxorguk.ukuu.org.uk>  wrote:
>>> After little discussion, nobody seemed to be interested in it, and
>>> nobody merged it.  I reposted it today, not knowing somebody else had
>>> come up with a similar idea meanwhile.
>>
>> I don't really see a meaningful use case for this. Why should millions of
>> users have this stuff in their kernel. What's the general purpose use
>> case we should all be excited about ?
>
> Putting a reasonable limit on jobs that are expected to run only for a
> limited amount of time, with a limited amount of total resources.  For
> example: CGI, cron jobs, backup, munin plugins, virus scanners and
> other email filters, procmail, ... - when the job is done, the group
> can be deleted, and new instances will run in a new group.
>
> With just RLIMIT_NPROC or task_counter, you can limit the total number
> of processes, but it will not stop a fork bomb - it will only slow it
> down.  The fork bomb will still bounce between 1 and the limit, and
> consume lots of resources for forking and exiting.
>
> (Glauber: the above should answer your last email, too)

Yet, the damage a fork bomb can pose into the system this way is 
severely limited. Combined with the cpu controller to guarantee that 
this group of process will never take the whole cpu for themselves,
you have almost everything you need, if not everything.

> Similar existing feature: RLIMIT_CPU.  Millions of users have it in
> their kernels, but nobody uses it nowadays.  And it's not even
> optional.
>
> Btw. I have no problem with maintaining this patch (and a whole bunch
> of others) in my proprietary git repository at work forever.  They're
> very useful for my employer.  I'm just trying to be a good citizen by
> sharing them.

Well, one alternative is to try to rebase your work on top of -mm, 
taking Frederic's work into account. What we really don't need, is 
another cgroup for that. So if you manage to convince people that this 
is really a win - haven't convinced me so far - the way to go is 
enhancing the existing fork cgroup.

> Max

