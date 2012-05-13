Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2EMVsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 17:48:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52049 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2EMVsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 17:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqf5YbkOJgQJWOgck0NpqGzGtxtHHJASZKHvwVuBzkKK6A@mail.gmail.com>
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
 <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com>
 <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com>
 <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com>
 <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com> <CA+1xoqf5YbkOJgQJWOgck0NpqGzGtxtHHJASZKHvwVuBzkKK6A@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 13 May 2012 23:48:18 +0200
Message-ID: <CAPXgP139D4u2qrUEVTRbbddC_RbX5mR9QdmB5N+vqPMLekrknw@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 9:43 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Fri, May 11, 2012 at 5:47 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Btw, I'd also *love* to see some model (eventually - not necessarily
>> now) where we could have the option of the time printouts being a bit
>> different (rather than just on/off). It would be very nice if we had
>> "relative" time printouts for events close together, so the rule could
>> be something like:
>>
>>  - if time is same as last line, pad with empty
>>
>>  - if time is more than a minute from last one, show an absolute value
>> of dd hh:mm:ss
>>
>>  - otherwise, show a relative value of +ss.mmmmmm
>>
>> So the on/off choice could be on/off/relative.
>>
>> Hmm?
>
> So I got something like this:
>
> # sleep 61 ; echo foo > /dev/kmsg ; sleep 61 ; echo bar > /dev/kmsg ;
> sleep 5 ; echo zoot > /dev/kmsg ; sleep 10 ; echo foo > /dev/kmsg ;
> echo bar > /dev/kmsg ; sleep 61 ; echo zoot > /dev/kmsg ; echo foo >
> /dev/kmsg
>
> [  673.222632] foo
> [  734.315249] bar
> [   +5.077527] zoot
> [  +10.235225] foo
> [   +0.002971] bar
> [  810.883085] zoot
> [   +0.003081] foo
>
> If that looks right,
> I can send a patch once this printf overhaul is
> stable

I just sent out the fix to restore the original multi-line behaviour,
I have nothing else queued in that area at the moment.

> unless Kay already plans on doing it as part of his work.

I'm busy making the prink() output look the same as it was before but
without the wrong continuation merges. New features need to wait a
little bit, so go ahead. :)

But I want to express, that I'm very interested in finding out if we
could switch to a 'better' clock source as we have today, which can
safely be translated to wall clock time not leaving the suspend time
out, and not jumping forth and back in time between logs from
different CPUs. I think that would be very useful for your patch too.

Kay
