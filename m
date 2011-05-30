Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1E3Uxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:53:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:34897 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab1E3Uxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:53:51 -0400
Date: Mon, 30 May 2011 13:53:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "D. Jansen" <d.g.jansen@googlemail.com>
cc: Theodore Tso <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
 <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com> <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
 <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, D. Jansen wrote:

> On Mon, May 30, 2011 at 8:45 PM,  <david@lang.hm> wrote:
>>
>>
>> the problem is that most users don't know what their system is running, or
>> what effect disaling fsync would have. those that do can probably use
>> LD_PRELOAD to override fsync calls.
>
> As we found out, they can't. But if we export barrier, I hope a
> library could wrap fsyncs into barriers. Is that the case?

a library can wrap fsync into anything.

>>
>> it doesn't take running a mail server, even a mail client will have the same
>> risk. If you use POP for mail (a very common option) then you download
>> messages and tell the server to delete them. if you do not really save them
>> (one fsync after they are all saved), then you can loose everything that you
>> downloaded.
>
> Yes, I know. It's the same argument again and again. I understand not
> everybody wants this. But some do. Some prefer working 10-20% longer
> on battery (certainty) instead of possibly losing 5 % data
> (possibility) or losing all your data (possibility if you use laptop
> mode and the hard disk wakes up again and again and eventually wears
> out).

those are some powerful numbers you are throwing around, can you back them 
up?

do you really have so many fsync's going on that the disk spins up so much 
that you would gain 10-20% battery life?

and what makes you think the extra spin-ups from fsyncs will cause your 
hard drive to fail significantly earlier? (if you have a hard drive with a 
limited number of spin-up cycles, you probably don't want to use laptop 
mode at all)

why do you think it's a possibility of loosing only 5% of data?

David Lang

> That's why there's laptop mode. And this would play into laptop
> mode and prevent the hard disk from breaking down prematurely and
> saving battery.
>
> Please try it out before you say that it's not necessary in your use
> case. It's useful and necessary in mine and other mobile use cases.
> Please don't assume that all distributions activate this by default
> and mailservers world wide use all their emails because they all crash
> with laptop mode active.
>
> I really don't care if it's in the kernel or elsewhere. But I care
> that old data is not corrupted. And it seems this is not (yet)
> possible with user space, e.g. a library in ld_preload. So I'm happy
> for any hints how to accomplish this.
>
