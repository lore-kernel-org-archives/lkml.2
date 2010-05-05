Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0EEXPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:15:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab0EEXPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:15:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 6 May 2010 01:16:36 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Garrett <mjg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
References: <Pine.LNX.4.44L0.1005051554490.1885-100000@iolanthe.rowland.org> <87fx26ymrf.fsf@deeprootsystems.com>
In-Reply-To: <87fx26ymrf.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005060116.37035.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010, Kevin Hilman wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Wed, 5 May 2010, Matthew Garrett wrote:
> >
> >> On Wed, May 05, 2010 at 03:20:40PM -0400, Alan Stern wrote:
> >> 
> >> > One the face of it, a runtime-PM solution would dictate that the
> >> > codec's driver ought to turn off the codec whenever the driver thinks
> >> > it isn't being used.  Ergo, if the driver didn't know when a call was
> >> > in progress, it would use runtime PM to turn off the codec during a
> >> > call.
> >> 
> >> Well, part of the problem is that right now most of our beliefs about 
> >> imposed constraints tend to be based on what userspace is doing - "Don't 
> >> power down the audio codec when userspace has it open", for instance. 
> >> But that goes away with opportunistic suspend. In most cases you don't 
> >> want the audio codec to stay awake just because userspace was using it 
> >> to make bouncing cow noises, especially if you've just frozen userspace. 
> >> So the problem becomes more complicated than it would otherwise be.
> >
> > It sounds like the problem can be stated simply enough: At the moment, 
> > nobody knows when the codec should be powered down!  Userspace might 
> > have some idea, but even if its ideas are right it has no way of 
> > communicating them to the kernel.
> >
> > The power/control sysfs attribute was intended for just that purpose,
> > although it was aimed at runtime PM rather than system PM.  
> > Nevertheless, it or something like it could be used.  Of course, there 
> > would still remain the issue of userspace telling the kernel not to 
> > power down the codec while making bouncing cow noises -- but at this 
> > point it's not really a kernel problem any more.
> 
> I guess what we're talking about here is a set of per-device
> constraints that could be used by both [opportunistic|system] suspend
> and runtime PM.  For lack of a better term, per-device PM QoS (as
> compared to the current system-wide PM QoS.)
> 
> For example, if userspace (or some other device) has communicated that
> it has a constraint on the audio HW, then both the suspend path and the
> runtime PM path could check those constraints before making a decision
> on how to act.  Hopefully the phone app would set a constraint and the
> cow-noise app would not.  :)
> 
> On OMAP, we keep track of per-device constraints (currently latency
> and throughput) in order to make proper run-time PM decicions in the
> kernel, but we are realizing that we need a way for userspace to
> communicate these constraints as well, so that userspace can make
> power vs. performance policy decisions instead of the kernel.
> 
> Probably generalizing these into the LDM is the direction to go so
> userspace can set constraints on a per-device (or per-class?) basis:
> 
> /sys/devices/.../power/constraint/throughput
> /sys/devices/.../power/constraint/wakeup_latency
> /sys/devices/.../power/constraint/... ?

That sounds reasonable although it may be a challenge to find a set of
universal constraints common to all devices.

Rafael
