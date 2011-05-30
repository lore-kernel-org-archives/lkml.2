Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1E3VYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 17:24:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33760 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1E3VYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 17:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SUP6JnLmlJsF3vDYe3oo+knlChYuMP3yGFOuCFS8tKxKWpKVV+u2KiXg1gj4gvCmI7
         teffqZn5y1Q7a52hfpz+HPgJKUWH84mu/T9yy8ae9fH3AzB8MK89PApGxweIp8TzdZxa
         K0Clyf+UDU8MAKRS6+/oQJqC4W2B3zlcqbWm0=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
 <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
 <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
 <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Mon, 30 May 2011 23:24:03 +0200
Message-ID: <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:53 PM,  <david@lang.hm> wrote:
> On Mon, 30 May 2011, D. Jansen wrote:
>
>> On Mon, May 30, 2011 at 8:45 PM,  <david@lang.hm> wrote:
>>>
>>>
>>> the problem is that most users don't know what their system is running,
>>> or
>>> what effect disaling fsync would have. those that do can probably use
>>> LD_PRELOAD to override fsync calls.
>>
>> As we found out, they can't. But if we export barrier, I hope a
>> library could wrap fsyncs into barriers. Is that the case?
>
> a library can wrap fsync into anything.
>
>>>
>>> it doesn't take running a mail server, even a mail client will have the
>>> same
>>> risk. If you use POP for mail (a very common option) then you download
>>> messages and tell the server to delete them. if you do not really save
>>> them
>>> (one fsync after they are all saved), then you can loose everything that
>>> you
>>> downloaded.
>>
>> Yes, I know. It's the same argument again and again. I understand not
>> everybody wants this. But some do. Some prefer working 10-20% longer
>> on battery (certainty) instead of possibly losing 5 % data
>> (possibility) or losing all your data (possibility if you use laptop
>> mode and the hard disk wakes up again and again and eventually wears
>> out).
>
> those are some powerful numbers you are throwing around, can you back them
> up?

Yes. My netbook uses 4.8 W with hard disk off. 0.5 W more with hard
disk on. A lot of the time, the display is off and the power
consumption drops to about 3.5 W. I don't know how I got to 20 % atm.
I can only do this if fsync is disabled. I tried before, but it would
go on for every write. It died, very prematurely.
>
> do you really have so many fsync's going on that the disk spins up so much
> that you would gain 10-20% battery life?

Yes. Every autosave in LibreOffice triggers one. And I want autosave,
but I want them in memory, not on disk.
>
> and what makes you think the extra spin-ups from fsyncs will cause your hard
> drive to fail significantly earlier? (if you have a hard drive with a
> limited number of spin-up cycles, you probably don't want to use laptop mode
> at all)

Experience, see above. Also, this is well described behavior. All hard
disks are only designed to last a certain number of head loads and
unloads. Spinning up and down even less.
>
> why do you think it's a possibility of loosing only 5% of data?

Well, it really depends on the way your configure laptop mode. But in
my case the laptop mode window is 20 minutes, the run time then is
about 10-12 hrs. I can actually lose less than 5 % of the data created
during the battery run time. It's a certain 1-1.5 hours (10-15 %) more
work or a possible 20 mins (3.3 % actually) loss of work. I think it's
a good deal.
