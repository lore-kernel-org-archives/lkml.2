Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1EQOgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:36:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51994 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab1EQOgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sRhRy1Afs7r+7zlJVbWmqVoI9HlUAqa4a1Xn9R1O+oYSnRCzzMJYYGn8eXjOKKd9zs
         c7B3vtdJKIk1KjuQLwppmbqKLWupsGtyxjeziPHZsPPxjr5o5hoq4wgpQqEIK7xFfYsw
         xfgNaEiySnzC6bmD+rwZqgfI5cG+pOkYqU8qk=
MIME-Version: 1.0
In-Reply-To: <20110517092331.GB22019@alberich.amd.com>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
	<1305016329.2914.22.camel@laptop>
	<BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
	<1305122055.2914.220.camel@laptop>
	<BANLkTikCF8uTH05gGG_H2bEYvZe0wmtS9A@mail.gmail.com>
	<20110517092331.GB22019@alberich.amd.com>
Date: Tue, 17 May 2011 22:36:21 +0800
Message-ID: <BANLkTimrHFMg9-D-Wx2z4xd+Pcjm_Wta9Q@mail.gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
From: Hillf Danton <dhillf@gmail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 5:23 PM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> On Sun, May 15, 2011 at 01:50:42AM -0400, Hillf Danton wrote:
>> On Wed, May 11, 2011 at 9:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2011-05-11 at 21:26 +0800, Hillf Danton wrote:
>> >> Your work for rewriting NUMA support, published at
>> >>          http://marc.info/?l=linux-kernel&m=130218515520540
>> >> is patched by changing how level is computed and by changing how it is
>> >> used to build the mask.
>> >>
>> >> When computing, some valid levels are lost in your work.
>> >>
>> >> When building mask, nodes are selected only if they have same distance,
>> >> thus nodes of less distance are also masked out since the computation of
>> >> level now is tough.
>> >>
>> >> Without MUNA hardware, I did not test the patch:(
>> >
>> > I do have a (tiny) NUMA box (2 nodes) but that actually booted with the
>> > old code too, Andreas Hermann from AMD (CC'ed) is usually willing to
>> > test such patches on somewhat larger systems. Please send a full patch
>> > against tip/master for him to apply.
>> >
>>
>> Hi Peter
>>
>> With the guiding from Ingo on git fetch the tip/master, the work is
>> now finished:)
>>
>> Hopely it is not too late for Andreas.
>>
>> In the following, the concern is also added for distances not covered by level,
>> please review again.
>
> Sorry, can't test your stuff. What git-tree and branch did you use to
> build this patch?
>
> Your patch seems to be corrupted/broken:
>
>  # scripts/checkpatch.pl your_patch.diff
>  ERROR: patch seems to be corrupt (line wrapped?)
>  #175: FILE: kernel/sched.c:6822:
>  *(*sched_domain_mask_f)(int cpu);
>
>  WARNING: line over 80 characters
>  #222: FILE: kernel/sched.c:7088:
>  +     return per_cpu_ptr(sched_domains_numa_masks[sched_domains_curr_level], cpu);
>
>  WARNING: printk() should include KERN_ facility level
>  #239: FILE: kernel/sched.c:7105:
>  +                 printk("distance(0,%d): %d\n", j, distance);
>
>  ERROR: need consistent spacing around '-' (ctx:WxV)
>  #253: FILE: kernel/sched.c:7119:
>  +                 for (k = level -1; k >= i; k--)
>                               ^
>  ...
>
> (I assume that it wasn't corrupted on my end.)
>
>
Hi Andreas

First I say sorry to you for the not well prepared patch.

Since I am not good at playing git, I am not sure the patch was
against the latest tip/master,
and I have no idea about the ERROR above.

Then it looks better that Peter will prepare the patch again.

thanks
            Hillf
