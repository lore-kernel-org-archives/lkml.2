Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0HHP5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:57:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:49228 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0HHP5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:57:32 -0400
Date: Sun, 8 Aug 2010 11:57:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: david@lang.hm, Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100808155719.GB3635@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
	Brian Swetland <swetland@google.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
	florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
	peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
	menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
	arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
	dipankar@in.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100804195704.GA23681@linux.vnet.ibm.com>
 <20100806225453.GA3947@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
 <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
 <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
 <20100807061558.GA28087@thunk.org>
 <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 03:53:52PM +0300, Felipe Contreras wrote:
> 
> You are overgeneralizing; there are many applications that run in the
> background, and you want to keep them running even when the display is
> off.

Really?  How many do you really expect will be running at the same
time on a mobile platform with a 800-1000 mWh battery?  And what
percentage of the applications that might be in a Android or Moblin or
Maemo app store will have things running in the background?  10%?
20%?  50%?  80%?

> You seen to be concentrating on UI-only applications, for those it's
> worth noting that Android provides separate mechanisms for power
> saving. Since Android doesn't have true multi-tasking, the
> applications must serialize their states so that the next time they
> are opened they seem to have not been closed. So, the current active
> UI application can be closed while turning off the display, and
> re-opened later.

Actually in practice, the process or processes which comprise current
active UI application generally won't actually be killed when you turn
off the display.  It *might* happen, if one of the rare backround
applications needs more memory than is available without closing some
of the more recently open applications.  In practice, the last 2-3
most recently used applications are still loaded in memory so you can
switch back and forth between them simply and easily.  It is true they
have to be ready to be killed at any time in case their memory is
needed for the currently active application, but that generally does't
happen right away.  The design is to keep this transparent to the user
so the user does't have to keep track of how many apps currently
running on the system.

In any case, the key thing to keep in mind is that when you deal with
extreme power savings, very often you end up making compromises that
probably make sense for other reasons anyway (such as the small screen
size).  It's not at all clear that supporting generalized
multi-tasking applications makes sense just from a screen real-estate
issue and user experience POV, never mind battery lifetime.

> User-space suspend blockers are relevant for background services, and
> as it has been discussed before; suspend blockers (not activating
> them) might actually degrade power usage.

Yes, absolutely.  Note though that with the iPhone, Apple has decided
that the only background services that will be allowed is audio, VOIP,
location/navigation, and push notifications.  iOS developers don't get
access to anything else, and the argument is that nothing else is
really *needed*.  Android is more flexible in that it allows for
non-Apple developers to create new background services, but it's not
clear how many you really *need*.

This goes back to your first assertion that there are *many*
applications that need to run in the background.  I just don't think
that's true.  There will be a few, and probably more than just the
restricted set allowed (and programmed) by Apple.  But not *many*.

						- Ted

P.S.  Although you won't see Apple admitting it, their "fast app
switching" is basically what Android has had all along, and most
mobile developers are quite happy to call this multi-tasking.  Yes,
it's not the same as trying to compile the kernel using "make -j 16"
in the background.  But are you really going to do that on a cell
phone battery?  I think not.
