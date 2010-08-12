Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab0HLTAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:00:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34068 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066Ab0HLTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jHHqbcI3C+yVzeMZpAj6BSv7TZ9D6OPDIoutFwtxgKbqO5gUHAyoRNBw1tzbCLvkSv
         hQVAGk10A+tjRypj7chGRGheLEBcbYMn1baR+iyneK5mq5reEh4mQPBf1Z0eXVYw2+Ad
         7HChesdm7SIywFUATW1KtC0qSUZUWlRA1Eogk=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=9v0o5pQ6s=sjjnk0udmrBAiy4wD+h2vrn_h8=@mail.gmail.com>
References: <20100809181638.GI3026@linux.vnet.ibm.com>
	<AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
	<20100811222854.GJ2516@linux.vnet.ibm.com>
	<AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812140903.GB11362@sirena.org.uk>
	<AANLkTik=K2znpgiHVgA1oD5Znrmm0Gx45ajfoQ7AwG3F@mail.gmail.com>
	<AANLkTi=9v0o5pQ6s=sjjnk0udmrBAiy4wD+h2vrn_h8=@mail.gmail.com>
Date: Thu, 12 Aug 2010 22:00:27 +0300
Message-ID: <AANLkTiniku7rqkio-T6f9tL_adJSrDKfU33wFEEkeMVH@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Theodore Tso <tytso@mit.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Thu, Aug 12, 2010 at 8:33 PM, Brian Swetland <swetland@google.com> wrote:
> On Thu, Aug 12, 2010 at 9:57 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>
>> Correct, but still a considerable amount of changes would need to be
>> done, which _nobody_ has expressed any intention to do.
>>
>> Besides, IMO a good mobile platform would share as much as possible
>> with desktop software. Say, the improvements Nokia has endorsed on the
>> Telepathy IM framework can only help the people already using it on
>> the desktop.
>>
>> However, personally, if I ever have to do './configure
>> --enable-suspend-blockers', I would think that something that just
>> doesn't belong has creped by to user-space. I don't see why there
>> should something particularly different between mobile phones and
>> laptops, and I think this has been already expressed over, and over.
>
> So, because you feel that phones should be little laptops you oppose
> providing (optional!) support for environments that take a different
> view to that?

Look. I'll share with you a little experience.

For years I've been working on a piece of software to access
Microsoft's WLM IM service on linux. I have high quality standards for
my software, so I optimized algorithms and bandwith, I used valgrind
to find memory leaks, OProfile for performance bottlenecks, and so on.
All this on a laptop.

When I ported this code to the N900 it just worked, not more-or-less;
perfectly. I could stay online the whole day without the battery
running out, and I didn't have to make *any* change.

Then at some point people started complaining about battery usage, but
lo and behold, on the desktop people started reporting too much
bandwith/cpu usage as well. I tried on my laptop, and was able to
reproduce, and fix (bug related to daylight savings time).

For years people have been trying to unify certain KDE/GNOME code, and
freedesktop.org was born. Now the same technologies are used by Nokia
on Maemo, and now MeeGo (DBus, Telepathy, GStreamer, tracker, etc.),
so the optimizations done for mobile benefit everyone; desktop power
usage also improves.

So, yeah, I think the fact that my laptop and phone share the same
software is great, and that improvements in one benefit the other.

> I think that we're still a ways away from a world where we can treat
> mobile devices the same as laptops and get reasonable user
> experiences.

Why do you keep ignoring the N900? It has a lot of components that
come directly from the linux ecosystem and people are having more than
reasonable experiences (some are ecstatic).

> I think it's unfortunate if the attitude here is "wait
> and someday it won't matter", especially because I'm skeptical that
> we're likely to hit that "someday" any time soon.

Nobody is waiting for anything. There's hard work all over the place
to improve power usage.

If you think suspend blockers are useful for you, great, use them. I
just don't see why they should be merged if nobody is going to use
them but you. But maybe you are right, and maybe dynamic PM alone
never reaches the same levers of performance, then people would ask
for it to be merged, and it will. No biggie.

In the meantime, it would be wise to remember that this is not
Nokia/Intel vs Google. Nokia has invested a great deal in dynamic PM,
and those changes have benefited Android products directly (I even
remember somebody from Google directly thanking Nokia for that), and
that will continue. So we are on the same team.

And finally, if they don't get merged, I hope you don't see that as a
loss. At the very least I think you got a lot of review comments from
the most qualified experts in the world _free of charge_, and as a
result the code should be more robust.

Cheers.

-- 
Felipe Contreras
