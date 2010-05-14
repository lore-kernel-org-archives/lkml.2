Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0ENAD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:03:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57337 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0ENADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:03:54 -0400
Date: Fri, 14 May 2010 01:03:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@suse.de>
Cc: Daniel Walker <dwalker@fifo99.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, Beno?t Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100514000327.GB1582@sirena.org.uk>
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005132311.26293.rjw@sisk.pl> <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com> <201005132327.16163.rjw@sisk.pl> <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com> <20100513214653.GA21120@suse.de> <20100513222748.GA3240@opensource.wolfsonmicro.com> <20100513224503.GA23014@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513224503.GA23014@suse.de>
X-Cookie: Microwaves frizz your heir.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 03:45:03PM -0700, Greg KH wrote:
> On Thu, May 13, 2010 at 11:27:49PM +0100, Mark Brown wrote:
> > On Thu, May 13, 2010 at 02:46:53PM -0700, Greg KH wrote:

> > Is that really the issue?  The ones I've looked at have mostly suffered
> > from being built on 2.6.29 and needing refreshes for current kernel APIs
> > or from general code quality issues - I don't recall ever looking at one
> > and thinking that the wakelocks were the one issue.

> Yes, it is an issue.  See the mess that we have had in trying to get
> some of the original G1 drivers merged in the staging tree for proof of
> this.

Ah, that's surprising - I had thought most of the issues there were due
to the substantial MSM architecture core code which most of the G1 stuff
depended on (things like the DSP interface and so on) and the general
need for staging-style updates which churned against the non-mainline
versions rather than the wakelocks.  It's true that the wakelocks
weren't helping, though.
 
Most of the cases I've seen have been off-CPU drivers that were either
working to outdated APIs or having to jump through hoops because they
really wanted to use new kernel features rather than CPU things.

> > Chances are that if the driver is useful people will start using it in
> > non-Android systems anyway.

> No, not usually.  Do you really think that someone else is going to use
> the G1 camera driver for anything else?  :)

Not if it's genuinely G1 specific, although presumably most of that
driver is actually chip drivers for the various components of a camera
subsystem which may well appear in other systems (not that I have the
slightest bit of familiarity with how camera hardware is organised).

> > If this really is a big concern with getting drivers into mainline then
> > surely we could just add some noop wakelock functions for the drivers to
> > call?  It's not particularly pretty but it'd deal with the driver merge
> > side of things.

> I fail to see why getting the real functionality of the wakelocks into
> the kernel is a problem.  Especially as they fit a real need, and work
> well for that.

Well, like I've said I personally don't object to merging them now that
the audio use case has been sorted.  I suggested this because it would
allow something to be put in place to facilitate driver merging which
would avoid the core and userspace issues that people are still raising
with the implementation and let people get on with at least the driver
side.

If wakelocks don't make the next merge window and there is a problem
with drivers then it'd be nice to get the stubs in so that the APIs are
present in subsystem trees for drivers to merge.
