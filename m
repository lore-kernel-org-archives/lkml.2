Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab0HLLkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:40:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56341 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753689Ab0HLLkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:40:04 -0400
Date: Thu, 12 Aug 2010 07:40:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, <paulmck@linux.vnet.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, <david@lang.hm>,
        Brian Swetland <swetland@google.com>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <arve@android.com>, <mjg59@srcf.ucam.org>, <pavel@ucw.cz>,
        <florian@mickler.org>, <rjw@sisk.pl>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <menage@google.com>, <david-b@pacbell.net>,
        <James.Bottomley@suse.de>, <arjan@infradead.org>, <swmike@swm.pp.se>,
        <galibert@pobox.com>, <dipankar@in.ibm.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010, Felipe Contreras wrote:

> My goal is to shine light. I've heard many invalid arguments in favor
> of suspend blockers, I want to shut them down.
> 
> In my mind it's crystal clear that independently of what opportunistic
> suspend is supposed to be fixing, the fact of the matter is that it's
> not a silver bullet as it's claimed to be.
> 
> So far, nobody has refuted these:
>  1) opportunistic suspend needs a good behaved user-space to work properly

That seems entirely reasonable, since opportunistic suspend is 
essentially a userspace facility.  Its in-kernel component is extremely 
small (and is already in mainline).

>  2) if suspend blockers are enabled in a system, *all* user-space must
> implement them to work correctly

That isn't clear at all.  Certainly they must be implemented correctly 
in some parts of userspace.  But other parts can simply be denied 
permission to use them.

>  3) implementing suspend blockers in user-space is not a straight-forward task

Perhaps so.  Lots of things in userspace aren't straight-forward --
GUIs, for example.  So what?  That's not a proof they shouldn't be
used.

>  4) there's a point where sleeping (not doing work) has diminished returns

Agreed.  It is platform dependent.  The Google people seem to believe 
strongly they have not yet reached that point on their platforms.

> So, as the length of this thread has shown, the benefits of
> opportunistic suspend are *dubious* at best, and more likely not worth
> the changes needed in user-space which eventually will get pretty
> close to what suspend blockers can achieve even in ideal circumstances
> by just doing dynamic PM.

You're ignoring the fact that Android has _already_ made the necessary
userspace changes.  Now you're going to ask them to change back,
offering as motivation the loss of a real (albeit "dubious")  
power-saving advantage?  Why should they accept your offer?

Alan Stern

