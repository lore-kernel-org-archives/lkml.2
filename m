Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1E3TuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:50:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37710 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1E3TuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GMTu7ULyVhARP+PutGxsMFVHm47SxvoQTIziJfrVSMKcEa1pC4wyPHtk5/BQ2/6A5K
         /GnsvAZvcwmkeyPc9yWLSK7vlbFxBHpyRDyWEXdSfUnyJ4vJqLz8vvd8IX9ZfU3DVxqb
         FQoY42HD5sjmusxj7Sm339fD9KaRxDS9YqKPs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
 <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
 <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Mon, 30 May 2011 21:49:22 +0200
Message-ID: <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
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

On Mon, May 30, 2011 at 8:45 PM,  <david@lang.hm> wrote:
> On Mon, 30 May 2011, D. Jansen wrote:
>
>> On Mon, May 30, 2011 at 8:02 PM,  <david@lang.hm> wrote:
>>>
>>> no, you cannot just change a fsync to a barrier, in some cases the data
>>> absolutly needs to be saved, not just ordered (remember the example of a
>>> mail server telling the other system that the data can be deleted after a
>>> fsync returns)
>>
>> I'm not really sure I why shouldn't have that choice as a user. Just
>> because someone else could be running a mailserver on his system and
>> configure it in a way that it doesn't behave as it should?
>> If he really wants to do that there's really nothing we can do to stop
>> him. I'm sure there are other ways existing kernel options can be used
>> to make software behave different than it should. Are we going to
>> remove them all now?
>>
>> The big problem is that so far only fsync existed and lots of software
>> seemingly abuses it as an expensive write barrier. And it would really
>> be lovely to have the choice to stop that on an opt-in basis in laptop
>> mode.
>
> is the benifit of not spinning up the disk really worth the risk of loosing
> data?

Is that a choice I can make myself? Is that a choice I make with
laptop mode? Or is that a choice I may only make if I'm willing to
modify and compile my own kernel?
>
> and should this really be a global across-the-board option?

The point is option imo.
>
> the problem is that most users don't know what their system is running, or
> what effect disaling fsync would have. those that do can probably use
> LD_PRELOAD to override fsync calls.

As we found out, they can't. But if we export barrier, I hope a
library could wrap fsyncs into barriers. Is that the case?
>
> it doesn't take running a mail server, even a mail client will have the same
> risk. If you use POP for mail (a very common option) then you download
> messages and tell the server to delete them. if you do not really save them
> (one fsync after they are all saved), then you can loose everything that you
> downloaded.

Yes, I know. It's the same argument again and again. I understand not
everybody wants this. But some do. Some prefer working 10-20% longer
on battery (certainty) instead of possibly losing 5 % data
(possibility) or losing all your data (possibility if you use laptop
mode and the hard disk wakes up again and again and eventually wears
out). That's why there's laptop mode. And this would play into laptop
mode and prevent the hard disk from breaking down prematurely and
saving battery.

Please try it out before you say that it's not necessary in your use
case. It's useful and necessary in mine and other mobile use cases.
Please don't assume that all distributions activate this by default
and mailservers world wide use all their emails because they all crash
with laptop mode active.

I really don't care if it's in the kernel or elsewhere. But I care
that old data is not corrupted. And it seems this is not (yet)
possible with user space, e.g. a library in ld_preload. So I'm happy
for any hints how to accomplish this.
