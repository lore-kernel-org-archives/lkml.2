Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0HBWmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:42:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57908 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0HBWmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:42:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Tue, 3 Aug 2010 00:40:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <20100731175841.GA9367@linux.vnet.ibm.com> <201008022333.32623.rjw@sisk.pl> <20100802222752.GI2405@linux.vnet.ibm.com>
In-Reply-To: <20100802222752.GI2405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008030040.20704.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 03, 2010, Paul E. McKenney wrote:
> On Mon, Aug 02, 2010 at 11:33:32PM +0200, Rafael J. Wysocki wrote:
> > On Monday, August 02, 2010, Paul E. McKenney wrote:
> > > On Mon, Aug 02, 2010 at 03:52:20PM +0200, Rafael J. Wysocki wrote:
> > > > On Monday, August 02, 2010, Paul E. McKenney wrote:
> > > > > On Sun, Aug 01, 2010 at 03:47:08PM -0700, Arjan van de Ven wrote:
> > > > > > On Sun, 1 Aug 2010 12:12:28 -0700
> > > > > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > > ...
> > > > > > Another one: freezing whole cgroups..... we have that today. it
> > > > > > actually works quite well.... of course the hard part is the decision
> > > > > > what to put in which cgroup, and at what frequency and duration you let
> > > > > > cgroups run.
> > > > > 
> > > > > Indeed, the Android guys seemed to be quite excited by cgroup freezing
> > > > > until they thought about the application-classification problem.
> > > > > Seems like it should be easy for some types of applications, but I do
> > > > > admit that apps can have non-trivial and non-obvious dependencies.
> > > > 
> > > > This isn't more difficult than deciding which applications will be allowed to
> > > > use wakelocks (in the wakelocks world).  It actually seems to be pretty much
> > > > equivalent to me. :-)
> > > 
> > > If I understand correctly, the problem they were concerned about was
> > > instead "given that a certain set of apps are permitted to use wakelocks,
> > > which of the other apps can safely be frozen when the display blanks
> > > itself."
> > 
> > I _think_ the problem should be reformulated as "which of the other apps
> > can be safely frozen without causing the wakelocks-using ones to have
> > problems" instead (the particular scenario is that one of the wakelocks-using
> > apps may need one of the other apps to process something and therefore the
> > other app cannot be frozen; however, that may be resolved by thawing all of
> > the other apps in such situations IMO).
> 
> I agree that your statement is equivalent to mine.  From what I can see,
> the current Android code resolves this by not freezing any app while
> a wakelock is held.
> 
> Just out of curiosity, how are you detecting the situation in order to
> decide when to thaw the apps in the cgroup?

Well, in fact I would only be able to talk about that theoretically, as I'm
currently not involved in any project using cgroups for power management.
I have considered that, but I haven't tried to implement it.

Thanks,
Rafael
