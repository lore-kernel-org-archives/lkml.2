Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab0EMUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:16:56 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64275 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab0EMUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XoQHht9HBRbtR27dUrcqK5qrqNQhoVNf5kx852JCbbNlZXLrovAEyKxYPmCZZBi+W7
         0fOJBLsNt8TRYxI+uot08X4Pyc1NGXRqBn13giSOCpEhUPH3tZCdaI+hA5gdcCs8kfNi
         emeoVOLqQdKWOBYleBkIydZLPdLDQgxjpPjIw=
MIME-Version: 1.0
In-Reply-To: <o2j6599ad831005131312jfef915b5g9cc7c96761742977@mail.gmail.com>
References: <1273669541.3086.24.camel@localhost>
	 <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
	 <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
	 <h2z6599ad831005121220h7956eb62yeea13626093b4a6e@mail.gmail.com>
	 <AANLkTikyXpXKhyy2oZxAF5ums2go2qie0ShOGt2dtHBH@mail.gmail.com>
	 <m2x6599ad831005121236ufa1bff7fz78423b1fb6b513e7@mail.gmail.com>
	 <AANLkTimxO3xWmr8jgyiwsLNyqTJ-4OWJ4zNROC9SE7XH@mail.gmail.com>
	 <o2j6599ad831005131312jfef915b5g9cc7c96761742977@mail.gmail.com>
Date: Thu, 13 May 2010 22:16:51 +0200
Message-ID: <AANLkTikWgHQBbLP7n6l7f5I676GsElDnO8VmlaEdtc6G@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, peterz@infradead.org, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:12 PM, Paul Menage <menage@google.com> wrote:
> On Wed, May 12, 2010 at 12:59 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>> On Wed, May 12, 2010 at 9:36 PM, Paul Menage <menage@google.com> wrote:
>>> On Wed, May 12, 2010 at 12:29 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>>>>> I think the idea is reasonable - the only way that I could see it
>>>>> breaking someone would be code that currently does something like:
>>>>>
>>>>> mkdir A
>>>>> mkdir B
>>>>> echo 1 > A/mem_exclusive
>>>>> echo 1 > B/mem_exclusive
>>>>> echo $mems_for_a > A/mems
>>>>> echo $mems_for_b > B/mems
>>>>>
>>>>> The attempts to set the mem_exclusive flags would fail, since A and B
>>>>> would both have all of the parent's mems.
>>>>>
>>>>
>>>> But would this not fail otherwise?
>>>>
>>>
>>> Assuming that mems_for_a and mems_for_b were disjoint, it would be
>>> fine currently.
>>>
>>
>> Ah my bad. I misread mems_for_a as taking the value from the parent.
>> You are right, that was a case I missed.
>>
>> Hmm, so how do we fix this? Any solutions? Not fixing the kernel
>> pushes the problem to the userspace, making it hard for tons of more
>> applications to use cgroups without jumping through a lot of hoops.
>>
>
> Well, it's not clear to me whether the case I outlined is actually one
> that would bite people - it's likely a rare case.
>
> Balbir's point that some apps might get upset by finding non-empty
> mems/cpus in a newly-created cgroup is more reasonable.
>
> How about a per-cgroup cpuset.inherit_defaults file that defaults to
> false and is inherited from the parent. If the parent's file is set to
> true, then the mems/cpus are also inherited?
>
> Then the sysadmin who's giving out user-controllable cpuset-based
> cgroups can just set it to true and the users don't need to worry
> about setting up the defaults.
>

Default for root being "true" should work. Anything else, and you
still require the programmer to know about cpuset and setting that
flag to true.

Dhaval
