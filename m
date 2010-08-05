Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab0HEARX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:17:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35352 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230Ab0HEARV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:17:21 -0400
Date: Wed, 4 Aug 2010 17:17:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: david@lang.hm
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805001716.GO24163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100804185520.GA2417@srcf.ucam.org>
 <201008042251.08266.rjw@sisk.pl>
 <20100804205654.GA4986@srcf.ucam.org>
 <alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm>
 <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com>
 <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm>
 <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com>
 <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
 <20100804233013.GN24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:49:22PM -0700, david@lang.hm wrote:
> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
> 
> >On Wed, Aug 04, 2010 at 04:23:43PM -0700, david@lang.hm wrote:
> >>On Wed, 4 Aug 2010, Arve Hj?nnev?g wrote:
> >>
> >>>
> >>>We suspend as soon as no wakelocks are held. There is no delay.
> >>
> >>So, if I have a bookreader app that is not allowed to get the
> >>wakelock, and nothing else is running, the system will suspend
> >>immediatly after I click a button to go to the next page? it will
> >>not stay awake to give me a chance to read the page at all?
> >>
> >>how can any application run without wakelock privilages?
> >
> >Isn't a wakelock held as long as the display is lit, so that the
> >system would continue running as long as the page was visible?
> 
> what holds this wakelock, and what sort of timeout does it have?
> (and why could that same timeout be used in other ways instead)

I defer to the Android guys on what exactly holds the display's
wakelock.  The timeout is the display-blank timeout.

> how many apps really need to keep running after the screen blanks?
> there are a few (audio output apps, including music player and
> Navigation directions), but I don't have see a problem with them
> being marked as the 'trusted' apps to pay attention instead.

Downloading is another.

The music player is an interesting example.  It would be idle most
of the time, given that audio output doesn't consume very much CPU.
So you would not want to suspend the system just because there were
no runnable processes.  In contrast, allowing the music player to
hold a wake lock lets the system know that it would not be appropriate
to suspend.

Or am I misunderstanding what you are proposing?

> if the backlight being on holds the wakelock, it would seem that
> almost every other use of the wakelock could (and probably should)
> be replaced by something that tickles the display to stay on longer.

The problem with this approach is that the display consumes quite a
bit of power, so you don't want to leave it on unnecessarily.  So if
the system is doing something (for example, playing music) that does
not require the display, you really want the display to be off.

							Thanx, Paul
