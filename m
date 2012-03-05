Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2CEQqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:46:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab2CEQqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:46:06 -0500
Message-ID: <4F54ED6C.4060600@redhat.com>
Date: Mon, 05 Mar 2012 11:44:28 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Tim Hockin <thockin@hockin.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com> <20120201163126.GA19837@google.com> <20120201184959.GH6731@somewhere.redhat.com> <20120201115107.93e11471.akpm@linux-foundation.org>
In-Reply-To: <20120201115107.93e11471.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 02:51 PM, Andrew Morton wrote:
> On Wed, 1 Feb 2012 19:50:01 +0100
> Frederic Weisbecker<fweisbec@gmail.com>  wrote:
>
>> On Wed, Feb 01, 2012 at 08:31:26AM -0800, Tejun Heo wrote:
>>> On Wed, Feb 01, 2012 at 04:37:40AM +0100, Frederic Weisbecker wrote:
>>>> Changes In this version:
>>>>
>>>> - Split 32/64 bits version of res_counter_write_u64() [1/10]
>>>>    Courtesy of Kirill A. Shutemov
>>>>
>>>> - Added Kirill's ack [8/10]
>>>>
>>>> - Added selftests [9/10], [10/10]
>>>>
>>>> Please consider for merging. At least two users want this feature:
>>>
>>> Has there been further discussion about this approach?  IIRC, we
>>> weren't sure whether this should be merged.
>>
>> The doubts I have noticed were:
>>
>> Q: Can't we rather focus on a global solution to fight forkbombs?
>>
>> If we can find a reliable solution that works in any case and that
>> prevent from any forkbomb to impact the rest of the system then it
>> may be an acceptable solution. But I'm not aware of such feature.
>>
>> Besides, another point in having this task counter is that we
>> have a per container limit. Assuming all containers are running under
>> the same user, we can protect against a container starving all others
>> with a massive amount of processes close to the NR_PROC rlimit.

> What I struggle with is "is this feature useful enough to warrant
> merging it"?

I have seen thunderbird create as many child processes
as it could (until I hit my rlimit NR_PROC), and have
seen web servers go wrong under a combination of load
and buggy scripts, forking as many processes as they
could.

Since we know rlimit NR_PROC is useful, having the
equivalent per cgroup will be useful, too.

What we need to lose is the focus on malicious
forkbombs - buggy programs are a real issue, and
protecting against them is useful.
