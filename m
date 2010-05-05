Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0EELGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:06:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55191 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752555Ab0EELGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:06:22 -0400
Date: Wed, 5 May 2010 12:06:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505110630.GA5754@opensource.wolfsonmicro.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <201005042223.41370.rjw@sisk.pl>
 <20100504235644.GA5231@opensource.wolfsonmicro.com>
 <201005050222.31038.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005050222.31038.rjw@sisk.pl>
X-Cookie: The early worm gets the late bird.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:22:30AM +0200, Rafael J. Wysocki wrote:
> On Wednesday 05 May 2010, Mark Brown wrote:

> > On a mobile phone when the system is in a voice call the data flow for
> > the call is entirely handled outside the CPU (normally referred to as
> > Applications Processor or AP here) by the baseband and audio CODEC,

> In that case someone (either a driver or, most likely, user space) will need to
> keep a suspend blocker active.

That is not actually what Android systems are doing, and if it is what's
supposed to happen then I'd really expect to see a patch to ASoC as part
of this series which shows how this is supposed to be integrated - it's
the sort of thing I'd expect to see some kernel space management for.

Honestly I don't think that's a very good solution for actual systems,
though.  A part of the reasoning behind designing systems in this way is
allowing the AP to go into the lowest possible power state while on a
voice call so it doesn't seem at all unreasonable for the system
integrator to expect that the AP will be driven into the standard low
power state the system uses for it during a call and in a system using
opportunistic suspend that's suspend mode.

> > In other words, the issue is that we run into situations where we need
> > an element of suspend control to go along with the opportunistic suspend
> > in order to allow some elements to be kept running - since suspend
> > blocking is taken suspend suppression seems like a reasonable term.

> Suspend really is a sledgehammer thing.  Either you suspend the whole system
> or you don't suspend at all.  You can prevent opportunistic suspend from
> happening using suspend blockers (that's what they are for), but that's pretty
> much everything you can do about it.  If you want power savings while some
> parts of the system are active, use runtime PM for that.

On the one hand that's the answer that works well with the existing
Linux design here so great.  On the other hand as discussed above that
doesn't match so well with user expectations.

> What I'd use opportunistic suspend for is not the saving of energy when there's
> a call in progress, because in that case some parts of the system need to be
> active, but to save energy when the device is completely idle, ie. the user
> interface is not used, music is not played "in the background" etc. (my phone
> is in such a state 90% of the time at least).

Remember that even in your full system suspend the system is not
actually fully idle - the baseband is still sitting there looking after
itself, keeping the phone on the network.  The only difference between
on call and off call from the point of view of the Linux system is that
there is an active audio path which happens to have been set up by the
Linux system.
