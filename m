Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab2BOP27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:28:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56811 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2BOP24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:28:56 -0500
Date: Wed, 15 Feb 2012 07:28:51 -0800
From: mark gross <markgross@thegnar.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, markgross@thegnar.org,
        NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        Greg KH <greg@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
Message-ID: <20120215152851.GB25163@gs62>
Reply-To: markgross@thegnar.org
References: <201202070200.55505.rjw@sisk.pl>
 <201202100144.11123.rjw@sisk.pl>
 <20120212020507.GD18742@gs62>
 <201202122232.12541.rjw@sisk.pl>
 <CAMP5Xgd3ODhA6rR_=nTw3EfUeeACfrzN4ycPLypryi8hfcBW8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5Xgd3ODhA6rR_=nTw3EfUeeACfrzN4ycPLypryi8hfcBW8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 04:11:24PM -0800, Arve Hjønnevåg wrote:
> On Sun, Feb 12, 2012 at 1:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, February 12, 2012, mark gross wrote:
> >> On Fri, Feb 10, 2012 at 01:44:10AM +0100, Rafael J. Wysocki wrote:
> > [...]
> >> > I'd like us and Android to use the same low-level data structures for power
> >> > management and the same API eventually, at least for drivers.  This is not
> >> > the case at the moment and it's actively hurting us as a project quite a bit.
> >> > If Android needs to add patches on top of whatever we have to get the desired
> >> > functionality, I'm fine with that, as long as they don't require drivers to use
> >> > APIs that are incompatible with the mainline.  Insisting that Android should
> >> > use a user-space-based autosleep implementation wouldn't help at all, because
> >> > realistically this isn't going to happen.
> >>
> >> why not?  I don't think having the PMS explicitly acknowledge a wake
> >> event is a big ask at all.
> >
> > I'd like to hear what the Android people think about that, but somehow it seems
> > to me they won't like it. :-)
> >
> 
> Correct.
> 
> The android power manager service does not handle wake events and
> therefore does not know when it is safe to acknowledge a wake event
> (assuming this acknowledgement re-triggers suspend). Other components
> handle the event and only notify the power manager if the event should
> change a state (e.g. turn the screen on). Some wake events, like the
> alarm used for battery monitoring, don't signal user space at all if
> the user visible state did not change. Other wake events are processed
> by lower level user-space services than the system-server where the
> power manager runs.

So you are all good with the wake event suspend race condition never ever
getting corrected or the fact that we have to sprinkle overlapping
kernel wake locks up and down the stack if we want to attempt to
implement correct code or that there is *no* way to deal with the hand
off of a wake lock critical section between kernel and user mode on wake
events without having a somewhat arbitrary time out wake lock dropping in
kernel mode?

Fine, if you don't like having the PMS ack wake events how about having
the services that handle them do it?  

The basic problem with wake locks is that there is no explicit wake
event acknowledgment required before re-suspending.  How about helping
us come up with a solution to that.

--mark

> -- 
> Arve Hjønnevåg
