Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab0HLM2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:28:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45429 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab0HLM2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sXvKOXiCzSr34jZYvsQRPMwvEJsT6SBcn4D7wVIlcEvFZq9noBaz+UHfKEEywAuFe2
         Q/iEhEuu4JyKbXbuEhZVDvXMKjknqEVYY1fL5IE/MiM7mzhf35/GCNY9ejaD68XC19iF
         20a2Lkxvj4ioJ8EO5PYJPsCGBklVQO+Xbp2mE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
Date: Thu, 12 Aug 2010 15:28:01 +0300
Message-ID: <AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Theodore Tso <tytso@mit.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 2:40 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 12 Aug 2010, Felipe Contreras wrote:
>
>> My goal is to shine light. I've heard many invalid arguments in favor
>> of suspend blockers, I want to shut them down.
>>
>> In my mind it's crystal clear that independently of what opportunistic
>> suspend is supposed to be fixing, the fact of the matter is that it's
>> not a silver bullet as it's claimed to be.
>>
>> So far, nobody has refuted these:

[...]

>>  2) if suspend blockers are enabled in a system, *all* user-space must
>> implement them to work correctly
>
> That isn't clear at all.  Certainly they must be implemented correctly
> in some parts of userspace.  But other parts can simply be denied
> permission to use them.

Yes, but all user-space needs to be considered. There certainly will
be cases when people think a certain package doesn't need them, but it
turns out they did. Firefox? Nah... oh, wait a second, I want my
downloads to finish. Do you think there will be any linux desktop
distro willing to attempt that?

>>  3) implementing suspend blockers in user-space is not a straight-forward task
>
> Perhaps so.  Lots of things in userspace aren't straight-forward --
> GUIs, for example.  So what?  That's not a proof they shouldn't be
> used.

Certainly not, but it means when measuring against plain dynamic PM,
opportunistic suspend is less attractive.

>>  4) there's a point where sleeping (not doing work) has diminished returns
>
> Agreed.  It is platform dependent.  The Google people seem to believe
> strongly they have not yet reached that point on their platforms.

Yes, and Nokia/Intel people believe they are close on their platforms.

Surely, at some point Android will reach that point too.

>> So, as the length of this thread has shown, the benefits of
>> opportunistic suspend are *dubious* at best, and more likely not worth
>> the changes needed in user-space which eventually will get pretty
>> close to what suspend blockers can achieve even in ideal circumstances
>> by just doing dynamic PM.
>
> You're ignoring the fact that Android has _already_ made the necessary
> userspace changes.  Now you're going to ask them to change back,
> offering as motivation the loss of a real (albeit "dubious")
> power-saving advantage?  Why should they accept your offer?

Android people have been selling the idea that suspend blockers are
not only for Android, but other platforms can benefit from them too. I
am arguing in that context. Hopefully you agree that that claim is
dubious at best.

Now, switching to Android... I'm sure if Android guys say their
user-space is far from the dynamic PM sweet-spot, then that's the
case. Surely, at some point they will reach it, so that they can
minimize power usage even when the device is actively used (it has
been explained that opportunistic suspend is not activated when screen
is on), maybe it will take one year, maybe two. Will they keep
opportunistic suspend around for those marginal gains? Maybe.

The question is why are we adding a user-space API that:
 1) no user-space beside Android has expresses interest in implementing
 2) is dubious whether the benefits are worth the pain for non-Android
user-space
 3) will become less and less attractive as dynamic PM gets closer to
the sweet-spot, and then surpass it
 4) Android can keep in a separate tree until it's clear in the linux
community that it's useful (if it ever happens)

-- 
Felipe Contreras
