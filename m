Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352Ab0HGJOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 05:14:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48419 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762325Ab0HGJOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 05:14:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Date: Sat, 7 Aug 2010 11:12:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: david@lang.hm, Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100807061558.GA28087@thunk.org> <201008071111.05585.rjw@sisk.pl>
In-Reply-To: <201008071111.05585.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008071112.35790.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 07, 2010, Rafael J. Wysocki wrote:
> On Saturday, August 07, 2010, Ted Ts'o wrote:
> > On Fri, Aug 06, 2010 at 08:14:09PM -0700, david@lang.hm wrote:
> > > 
> > > that description sounds far more like normal sleep power management
> > > that suspending. especially since they want to set timers to wake
> > > the system up and the defining characteristic of suspend (according
> > > to this thread) is that timers don't fire while suspended.
> > > 
> > > as I am seeing it, there are two reasons why this don't "just work"
> > > 
> > > 1. sleeping can't currently save as much power as suspending
> > 
> > No, I don't think that's the case at all.  The key thing here is that
> > *most* applications don't need to be modified to use suspend locks,
> > because even though they might be in an event loop, when the user user
> > turns off the display, the user generally doesn't want it doing things
> > on their behalf.
> > 
> > Again, take for example the Mac Book, since Apple has gotten this
> > right for most users' use cases.  When you close the lid, you even if
> > the application is under the misguided belief that it should be
> > checking every five seconds to see whether or not the web page has
> > reloaded --- actually, that's not what you want.  You probably want
> > the application to be forcibly put to sleep.  So the whole point of
> > the suspend blocker design is that you don't have to modify most
> > applications; they just simply get put to sleep when you close the
> > MacBook lid, or, in the case of the Android device, you push the
> > button that turns off the screen.
> 
> But in principle that need not mean suspending the entire system.
> To get applications out of the way, you need to freeze user space.
> However, that's not sufficient, because in addition to that you need to
> prevent deactivate the majority of interrupt sources to avoid waking up the
> CPU (from C-states) too often.

s/prevent deactivate/deactivate/

Rafael
