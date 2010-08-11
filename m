Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0HKQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:57:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62748 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab0HKQ5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=tncxLTJy2UJavSP4gJCIkRaUor61kxqVJt1eqnRlboNaJy96Uc6ruQsc9aDT/VvC8v
         gP5ch/2OcXKnVcYEa/LSrkCldwXgnncWELXYB5F+X4yYVmg3utwQPOqm6kSUtzXMnOdl
         sQ/8aswRO27wmd/Xa56hok7QpCWc/EuVfOaIw=
MIME-Version: 1.0
In-Reply-To: <20100808213821.GD3635@thunk.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
Date: Wed, 11 Aug 2010 19:57:32 +0300
Message-ID: <AANLkTinNc1SWmz8pE_4k6vThxQCJfCR_UqV6OM=OsJOf@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 12:38 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Aug 08, 2010 at 08:40:28PM +0300, Felipe Contreras wrote:
>>
>> My guess is you haven't used a truly multi-tasking device like the
>> N900; now that I've got used to it, I consider that functionality
>> *essential*.
>
> I've used an N800, and I wasn't impressed; if anything, the fact that
> I have to worry about manually killing off applications when memory
> gets low, I actually thought it was incredibly sucky.  It was a
> miniature, badly done laptop.
>
> Maybe the N900 is different, but the bigger question is what do you
> mean by "multi-tasking"?  Definitions are critical here, which is why
> Paul was so careful in his definitions section of his document.

Yes, the N900 is drastically different, for starters, it has an actual
window manager.

By multi-tasking I mean me (the user) being able to perform multiple
tasks at the same time.

For example: writing an email, while browsing the web, while having IM
conversations. Obviously not exactly at the same time; start writing
an email, go browse for some url, copy, answer a pending IM message,
go back to the mail, paste.

>> The argument in favor of suspend blockers is that you could take
>> applications that are not designed for embedded, and make them run on
>> an embedded device without draining excessive battery life; those
>> applications would have to be background services not conflicting with
>> Android's design.
>>
>> I agree there probably would not be that many background apps, and
>> probably even less ported background apps, but that is actually an
>> argument against suspend blockers.
>>
>> The rest of the apps (UI apps), cannot be ported, but have to be
>> written specifically for Android, and therefore should have PM in
>> mind, and not require suspend blockers to have good power usage.
>
> If you are using a GUI framework which is optimized for a single-
> application-focus-at-a-time UI that isn't GNOME or KDE, then that will
> require the applications to be written.  However, that's not because
> of suspend-blockers.

Let's concentrate; Android is the only mobile platform that has
expressed interested in suspend blockers. UI applications in Android
are written specifically for Android. Period.

Other platforms, such as MeeGo, rely on Qt API, not suspend blockers.

> If you assume a GUI framework which is flexible enough --- maybe Qt
> falls into this category, maybe not --- for the rest of the
> applications, they don't need to *know* about suspend blockers, and
> they certainly do't have to be rewritten or modified specifically for
> suspend blockers.  So if your argument is that applications that don't
> need bacground services (which you've admitted comprises majority of
> applicatios) need to be modified or written specifically to support
> suspend blockers, that's simply not true.  They don't need to be
> modified at all.

That's not my argument at all. I was talking about a counter-argument
to "suspend blockers make porting desktop apps easer".

Android's UI applications are unimportant here because they have not
been ported from the desktop realm; they were designed specifically
for Android, including all its PM capabilities.

The only relevant applications are the ones designed for the desktop
that are ported to Android, and thus might make assumptions that hurt
battery life. These are background services.

If you are saying that there are few background apps, then that's an
argument against suspend blockers:
 1) few applications can be ported
 2) the few applications that can be ported, being background
services, might miss timers and behave worst than _without_ suspend
blockers

> As far as whether they *should* require suspend blockers to be in the
> kernel to get power usage that is suitable for cell phone batteries, I
> would agree that in the ideal world, it would be nice if you could
> have applications that make the correct performance/battery
> utilization tradeoff for devices running on 800 mWh batteries, 94,000
> mWh batteries, and while running on the AC mains.  But I don't believe
> that it's likely to be true, and if you want to try to beat up on
> application writers one at a time to be power optimized --- as far as
> I'm concerned, that's an argument *for* suspend blockers, since I'm
> not big believer in plans that begin, "First, you command the tides of
> the sea to go back", King Canute style.  :-)

Power is just like any other resource, why are desktop applications
not using 100% CPU, or 100% of memory? Because if they did nobody
would be using them. There's a social pressure to use less resources,
or at least less resources than the competence. If an application uses
too much battery time nobody would use it, unless perhaps if the
functionality is too good and there are no alternatives.

I believe social forces already deal with this problem, all we need to
do is provide better tools, not patronize user-space applications.

-- 
Felipe Contreras
