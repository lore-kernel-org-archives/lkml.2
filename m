Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407Ab0HLRnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:43:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:32940 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758755Ab0HLRnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:43:18 -0400
Date: Thu, 12 Aug 2010 10:43:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812174303.GD2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 02:11:22PM +0300, Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 1:47 PM, Theodore Tso <tytso@mit.edu> wrote:
> > One thing I'm not clear on --- what's your goal?   Is your goal to keep suspend-blockers out of the kernel?   Is it to try to convince the android team suspend-blockers are a bad idea and to change Android to not use them?  Is it to push some other agenda?  Is it to discourage the Android team from trying to waste more time trying to get suspend-blockers (or equivalent functionality) from being added into the kernel?
> 
> My goal is to shine light. I've heard many invalid arguments in favor
> of suspend blockers, I want to shut them down.
> 
> In my mind it's crystal clear that independently of what opportunistic
> suspend is supposed to be fixing, the fact of the matter is that it's
> not a silver bullet as it's claimed to be.

The question is not whether suspend blockers are a silver bullet (in my
opinion there are no silver bullets), but rather whether or not suspend
blockers are useful.

> So far, nobody has refuted these:
>  1) opportunistic suspend needs a good behaved user-space to work properly

As does dynamic power management.

>  2) if suspend blockers are enabled in a system, *all* user-space must
> implement them to work correctly

Really?  From what I can see, only PM-driving applications need to use
suspend blockers.

>  3) implementing suspend blockers in user-space is not a straight-forward task

Fortunately, experience thus far has shown that only a small fraction of
applications need to use suspend blockers.  (Or perhaps you are instead
saying that the implementation of the suspend-blocker infrastructure
itself is not straightforward?  It is not clear from your words.)

>  4) there's a point where sleeping (not doing work) has diminished returns

This one I agree with.

> So, as the length of this thread has shown, the benefits of
> opportunistic suspend are *dubious* at best, and more likely not worth
> the changes needed in user-space which eventually will get pretty
> close to what suspend blockers can achieve even in ideal circumstances
> by just doing dynamic PM.

The length of this thread (and the ones preceding it) is mostly due to
people talking past each other.  For example, the Android folks seem to
believe that it is important that relatively unskilled people be able
to write simple apps, and that the system nevertheless be able to run
these apps in a relatively energy efficient manner.  Your proposals do
not address this issue.  This might be because you are not aware of
this desire, because you are not aware of the computing history that
argues in favor of this requirement, or because you simply don't like
this requirement.  Whatever the reason, until you face this requirement
head on, either addressing it or proving that it need not be addressed,
you will continue to be talking past the Android folks.

							Thanx, Paul
