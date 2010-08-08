Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0HHRkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 13:40:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42184 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0HHRkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 13:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=gWm9J3C2kBlSANQf87ESjPqm1eRhVjFS6Y7JP9RStwjme5w/STupcuWFOi+a0sqfcR
         85Pq1YaYOnImzTJS2weecA9aJJtidr+CjP5ugCbDtEtrvJTNvP18czmsU4RAqo6euWxo
         xcpuz3LS6jXnLHYqUnTBv1fk0EpQTxm3NdN4s=
MIME-Version: 1.0
In-Reply-To: <20100808155719.GB3635@thunk.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
Date: Sun, 8 Aug 2010 20:40:28 +0300
Message-ID: <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
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

On Sun, Aug 8, 2010 at 6:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Aug 08, 2010 at 03:53:52PM +0300, Felipe Contreras wrote:
>>
>> You are overgeneralizing; there are many applications that run in the
>> background, and you want to keep them running even when the display is
>> off.
>
> Really?  How many do you really expect will be running at the same
> time on a mobile platform with a 800-1000 mWh battery?  And what
> percentage of the applications that might be in a Android or Moblin or
> Maemo app store will have things running in the background?  10%?
> 20%?  50%?  80%?

At any given time most of the applications are running on the
background, how much exactly depends on the platform. In my N900 I can
see that at least 90% of the process are running on the background
right now.

>> You seen to be concentrating on UI-only applications, for those it's
>> worth noting that Android provides separate mechanisms for power
>> saving. Since Android doesn't have true multi-tasking, the
>> applications must serialize their states so that the next time they
>> are opened they seem to have not been closed. So, the current active
>> UI application can be closed while turning off the display, and
>> re-opened later.
>
> Actually in practice, the process or processes which comprise current
> active UI application generally won't actually be killed when you turn
> off the display.  It *might* happen, if one of the rare backround
> applications needs more memory than is available without closing some
> of the more recently open applications.  In practice, the last 2-3
> most recently used applications are still loaded in memory so you can
> switch back and forth between them simply and easily.  It is true they
> have to be ready to be killed at any time in case their memory is
> needed for the currently active application, but that generally does't
> happen right away.  The design is to keep this transparent to the user
> so the user does't have to keep track of how many apps currently
> running on the system.

My last experience using an Android system was that switching
applications wasn't done "simply and easily".

But supposing it is, Android's UI is completely different to anything
else; you cannot take a GNOME/KDE app and expect it to run on Android.
Since UI applications are written for Android anyway, then they should
be written with PM in mind, and should not rely on suspend blockers.

> In any case, the key thing to keep in mind is that when you deal with
> extreme power savings, very often you end up making compromises that
> probably make sense for other reasons anyway (such as the small screen
> size).  It's not at all clear that supporting generalized
> multi-tasking applications makes sense just from a screen real-estate
> issue and user experience POV, never mind battery lifetime.

My guess is you haven't used a truly multi-tasking device like the
N900; now that I've got used to it, I consider that functionality
*essential*.

Multi-tasking and good PM is possible, and the N900 is a good example.
Rather than giving up multi-tasking to see how much longer the battery
can last, I would rather like to see how to improve batter life for
the multi-tasking case.

>> User-space suspend blockers are relevant for background services, and
>> as it has been discussed before; suspend blockers (not activating
>> them) might actually degrade power usage.
>
> Yes, absolutely.  Note though that with the iPhone, Apple has decided
> that the only background services that will be allowed is audio, VOIP,
> location/navigation, and push notifications.  iOS developers don't get
> access to anything else, and the argument is that nothing else is
> really *needed*.  Android is more flexible in that it allows for
> non-Apple developers to create new background services, but it's not
> clear how many you really *need*.
>
> This goes back to your first assertion that there are *many*
> applications that need to run in the background.  I just don't think
> that's true.  There will be a few, and probably more than just the
> restricted set allowed (and programmed) by Apple.  But not *many*.

The argument in favor of suspend blockers is that you could take
applications that are not designed for embedded, and make them run on
an embedded device without draining excessive battery life; those
applications would have to be background services not conflicting with
Android's design.

I agree there probably would not be that many background apps, and
probably even less ported background apps, but that is actually an
argument against suspend blockers.

The rest of the apps (UI apps), cannot be ported, but have to be
written specifically for Android, and therefore should have PM in
mind, and not require suspend blockers to have good power usage.

-- 
Felipe Contreras
