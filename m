Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0HDBJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:09:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33072 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842Ab0HDBJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:09:16 -0400
Date: Tue, 3 Aug 2010 18:09:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804010912.GK2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
 <20100803154112.GE2407@linux.vnet.ibm.com>
 <AANLkTim474Yp=MP3EX9pabc9XO8Q-McCns207SLPYuUb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim474Yp=MP3EX9pabc9XO8Q-McCns207SLPYuUb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 03:23:00PM -0700, Arve Hjønnevåg wrote:
> 2010/8/3 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Mon, Aug 02, 2010 at 09:18:27PM -0700, Arve Hjønnevåg wrote:
> >> On Sat, Jul 31, 2010 at 10:58 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> ...
> >> > o       Statistics of the power-control actions taken by power-aware
> >> >        applications must be provided, and must be keyed off of program
> >> >        name.
> >>
> >> We don't key the stats off the program name, but having useful
> >> statistics is critical too us. The current code in linux-next does not
> >> appear to allow this (I'm referring to pm_stay_awake here, etc not
> >> pm-qos.)
> >
> > OK, maybe I was confused earlier.  So you do not track statistics via
> > the device being open throughout the application's lifetime?
> 
> The suspend blocker patchset does track statistics while the device is
> open, but it it not keyed of the program name. The name is passed from
> user-space and a single process can have the device open several
> times. The wakelock interface that we currently use just creates a new
> object every time it sees a new name and never frees it.

Ah, good to know!

							Thanx, Paul

> ...
> >> > o       If no power-aware or power-optimized application are indicating
> >> >        a need for the system to remain operating, the system is permitted
> >> >        (even encouraged!) to suspend all execution, even if power-naive
> >> >        applications are runnable.  (This requirement did appear to be
> >> >        somewhat controversial.)
> >>
> >> I would say it should suspend even if power aware applications are
> >> runnable. Most applications do not exclusively perform critical work.
> >
> > The point being that a power-aware application does not block suspend
> > -unless- it holds a suspend blocker, correct?
> 
> Yes.
> 
> >
> > Or am I missing some other subtlety?
> 
> No.
> 
> ...
> >> > o       Any initialization of the API that controls the system power
> >> >        state must be unconditional, so as to be free from failure.
> >> >        (I don't currently understand how this relates, probably due to
> >> >        my current insufficient understanding of the proposed patch set.)
> >>
> >> Unconditional initialization makes it easier to add suspend blockers
> >> to existing kernel code since you don't have to add new failure exit
> >> paths. It is not a strong requirement.
> >
> > Ah, that makes more sense!  I moved this to a new "NICE-TO-HAVES"
> > section.  I also changed the last parenthesized sentence to read
> > "Such unconditional initialization reduces the intrusiveness of the
> > the Android patchset."  Does that work?
> >
> 
> Sure.
> 
> 
> 
> -- 
> Arve Hjønnevåg
