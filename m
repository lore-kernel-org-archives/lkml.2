Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab2CAWyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:54:41 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:44365 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2CAWyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:54:39 -0500
Message-ID: <4F4FFDE4.8050908@free.fr>
Date: Thu, 01 Mar 2012 23:53:24 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Aditya Kali <adityakali@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Max Kellermann <mk@cm4all.com>, Tim Hockin <thockin@hockin.org>,
        Glauber Costa <glommer@gmail.com>, Paul Menage <paul@paulmenage.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        =?ISO-8859-1?Q?Papp_Tam=E1s?= <tompos@martos.bme.hu>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com> <20120201163126.GA19837@google.com> <20120201184959.GH6731@somewhere.redhat.com> <20120201115107.93e11471.akpm@linux-foundation.org> <20120202145000.GC9071@somewhere.redhat.com>
In-Reply-To: <20120202145000.GC9071@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 03:50 PM, Frederic Weisbecker wrote:
> On Wed, Feb 01, 2012 at 11:51:07AM -0800, Andrew Morton wrote:
>> On Wed, 1 Feb 2012 19:50:01 +0100
>> Frederic Weisbecker<fweisbec@gmail.com>  wrote:
>>
>>> On Wed, Feb 01, 2012 at 08:31:26AM -0800, Tejun Heo wrote:
>>>> On Wed, Feb 01, 2012 at 04:37:40AM +0100, Frederic Weisbecker wrote:
>>>>> Changes In this version:
>>>>>
>>>>> - Split 32/64 bits version of res_counter_write_u64() [1/10]
>>>>>    Courtesy of Kirill A. Shutemov
>>>>>
>>>>> - Added Kirill's ack [8/10]
>>>>>
>>>>> - Added selftests [9/10], [10/10]
>>>>>
>>>>> Please consider for merging. At least two users want this feature:
>>>> Has there been further discussion about this approach?  IIRC, we
>>>> weren't sure whether this should be merged.
>>> The doubts I have noticed were:
>>>
>>> Q: Can't we rather focus on a global solution to fight forkbombs?
>>>
>>> If we can find a reliable solution that works in any case and that
>>> prevent from any forkbomb to impact the rest of the system then it
>>> may be an acceptable solution. But I'm not aware of such feature.
>>>
>>> Besides, another point in having this task counter is that we
>>> have a per container limit. Assuming all containers are running under
>>> the same user, we can protect against a container starving all others
>>> with a massive amount of processes close to the NR_PROC rlimit.
>>>
>>> Q: Can/should we implement a limitation on the number of "fork" as well?
>>>     (as in https://lkml.org/lkml/2011/11/3/233 )
>>>
>>> I'm still not sure about why such a thing is needed. Is it really something we
>>> want? Why can't the task counter be used instead?
>>>
>>> I need more details from the author of this patch. But I doubt we can merge
>>> both subsystems, they have pretty different semantics.
>> What I struggle with is "is this feature useful enough to warrant
>> merging it"?
> The reason why I've been working on it is because we need this feature
> (at least) for LXC.

This feature is a recurrent request from the users of LXC. Recently, a 
container administrator complained an user was able to crash the entire 
host from a container.

http://sourceforge.net/mailarchive/message.php?msg_id=28915923

This feature is really useful to make the containers secure.

   -- Daniel

>
> Two people from our teams have jumped onto the discussion to express
> that they want this feature and why:
>
> https://lkml.org/lkml/2011/12/13/309
> https://lkml.org/lkml/2011/12/13/364
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
>

