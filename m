Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1ETWVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:21:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:40500 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1ETWUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:20:53 -0400
Subject: Re: [bg-linux] [PATCH 6/7] [RFC] enable early TLBs for BG/P
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Kazutomo Yoshii <kazutomo@mcs.anl.gov>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
In-Reply-To: <BANLkTikG9mfzXM0WmWxPLhjGD-M6AVznkw@mail.gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-6-git-send-email-ericvh@gmail.com>
	 <1305851941.7481.92.camel@pasglop>
	 <BANLkTinAqeu7C+U_HFrOAOctFTuSUwG-iA@mail.gmail.com>
	 <1305856442.7481.120.camel@pasglop> <4DD5E218.5030508@mcs.anl.gov>
	 <1305863541.7481.132.camel@pasglop>
	 <BANLkTikG9mfzXM0WmWxPLhjGD-M6AVznkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 08:20:39 +1000
Message-ID: <1305930039.7481.189.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 08:01 -0500, Eric Van Hensbergen wrote:
> On Thu, May 19, 2011 at 10:52 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >> Unfortunately, the firmware is also required:
> >> - to configure Blue Gene Interrupt Controller(BIC)
> >> - to configure Torus DMA unit. e.g. fifo
> >> - to configure global interrupt (even we don't use, we need to disable
> >> some channel correctly)
> >
> > Can't we just write bare metal code for that ?
> >
> 
> The kittyhawk code has the bare-metal equivalents for all of these.
> When I get to the drivers, I'll favor the kittyhawk versions for
> submission and then we'll see if it would be possible to adapt the HPC
> extensions to use the bare-metal versions of the drivers versus the
> firmware interface.

Ok. We can also start with using the FW and then migrate to bare metal.

> >> - to access node personality information (node id, DDR size, HZ, etc) or
> >> maybe we can directly access SRAM?
> >
> > That should be turned into device-tree at boot, possibly from a
> > bootloader or from the zImage wrapper.
> >
> 
> This is the approach is used by the kittyhawk u-boot approach.
> However, it would also be just as easy to construct an in-memory
> device-tree within Linux by mapping the personality page and copying
> the relevant bits out.  This has the advantage of being able to boot
> Linux directly on the nodes without an intermediary boot loader (which
> kittyhawk uses just to allow us customize which kernel boots on a
> node-to-node basis whereas the stock system boots the same kernel on
> all the nodes within a partition allocation (64-40,000 nodes)).

We can do that from the zImage wrapper... that would be nicer than doing
it from the kernel itself unless there's good reasons to do so like
iSeries.

Cheers,
Ben.

