Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187Ab0EDUnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:43:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab0EDUnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:43:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Tue, 4 May 2010 22:44:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87r5lrh780.fsf@deeprootsystems.com> <201005042223.41370.rjw@sisk.pl>
In-Reply-To: <201005042223.41370.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005042244.16208.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 May 2010, Rafael J. Wysocki wrote:
> On Tuesday 04 May 2010, Kevin Hilman wrote:
> > Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
> > 
> > > On Mon, May 03, 2010 at 05:43:34PM -0700, Brian Swetland wrote:
> > >> On Mon, May 3, 2010 at 5:09 PM, Arve Hjønnevåg <arve@android.com> wrote:
> > >> > On Mon, May 3, 2010 at 4:37 PM, Kevin Hilman
> > >
> > >> >> This last point is especially troubling.  I don't find it a comforting
> > >> >> path to go down if the drivers have to start caring about which PM
> > >> >> policy is currently in use.
> > >
> > >> I'll echo Arve here -- all drivers should seek to be in the lowest
> > >> power state possible at all times.  We've never suggested that
> > >> suspend_block is a substitute for that.
> > >
> > > Looking at this from a subsystem/driver author point of view the problem
> > > I'm faced with is that as a result of using system suspend much more
> > > aggressively the subsystem and driver layers are getting conflicting
> > > instructions about what the lowest power state possible is.
> > 
> > Exactly.
> > 
> > With runtime PM, there is flexibility in choosing the lowest power
> > state at the device/subsystem level, based on activity, timeouts,
> > bitrate, dependencies, latency/throughput constraints, etc.
> > 
> > With opportunistic suspend, all of this flexibility is gone, and the
> > device/subsystem is told to go into the lowest power, highest latency
> > state, period.
> 
> Guys, please.
> 
> The opportunistic suspend feature is _not_ to replace runtime PM by any means!
> 
> However, there are situations in which runtime PM is clearly insufficient.
> The idea behind runtime PM is that subsystems and device drivers will know
> when to put devices into low power states and save energy this way.  Still,
> even if all subsystems do that 100% efficiently, there may be more savings
> possible by putting the entire system into a sleep state (like on ACPI-based
> PCs) and we can reach there by runtime PM alone.

s/can/can't/; s/reach/go/

Rafael
