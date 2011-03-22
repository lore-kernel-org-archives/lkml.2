Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1CVOFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:05:39 -0400
Received: from linux-sh.org ([111.68.239.195]:41560 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1CVOFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:05:37 -0400
Date: Tue, 22 Mar 2011 23:04:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Message-ID: <20110322140420.GA24004@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl> <201103131403.49561.rwys@fuw.edu.pl> <20110317082016.GB13315@linux-sh.org> <201103190147.28001.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103190147.28001.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 01:47:27AM +0100, Rafael J. Wysocki wrote:
> On Thursday, March 17, 2011, Paul Mundt wrote:
> > On Sun, Mar 13, 2011 at 02:03:49PM +0100, R. J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Convert the SuperH clocks framework and shared interrupt handling
> > > code to using struct syscore_ops instead of a sysdev classes and
> > > sysdevs for power managment.
> > > 
> > > This reduces the code size significantly and simplifies it.  The
> > > optimizations causing things not to be restored after creating a
> > > hibernation image are removed, but they might lead to undesirable
> > > effects during resume from hibernation (e.g. the clocks would be left
> > > as the boot kernel set them, which might be not the same way as the
> > > hibernated kernel had seen them before the hibernation).
> > > 
> > > This also is necessary for removing sysdevs from the kernel entirely
> > > in the future.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > This misses the use of the sysdev class by the userimask code, though I'm
> > open to suggestions for alternatives.
> 
> For now, I'd simply move the sysdev class definition to userimask.c, like
> in the patch below.  The current goal is to eliminate the suspend/resume and
> shutdown operations from sysdevs (and sysdev drivers), the next step will
> be to replace the remaining sysdevs with alternative mechanisms.
> 
It's not quite that straightforward, you've also killed off the name
attribute for each of the intc sysdevs, so we no longer have a visible
way to map a given intc controller number to the controller name in a
user visible way.

I'm not opposed to the syscore thing for suspend/resume ops, but I'm not
willing to trash the userimask and name mapping interface in the process
with no alternatives.

userimask was the first global configuration item I added, but there are
other per-controller and global configuration knobs that I plan to export
through the interface, so there really needs to be a compelling reason
for moving off of sysdevs.
