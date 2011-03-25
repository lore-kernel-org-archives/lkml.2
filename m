Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1CYElr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 00:41:47 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47341 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384Ab1CYEln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 00:41:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAEQajE15LK5JgWdsb2JhbAClTRUBARYmJcRbDYVcBA
Date: Fri, 25 Mar 2011 15:41:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110325044128.GJ26611@dastard>
References: <4D8B4A89.80608@fusionio.com>
 <20110324183019.GA1676@gentoo.trippels.de>
 <4D8B8F34.5000203@fusionio.com>
 <4D8B92AE.8090308@fusionio.com>
 <20110324185445.GB1696@gentoo.trippels.de>
 <4D8B9457.2020608@fusionio.com>
 <20110324193441.GA1723@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324193441.GA1723@gentoo.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:34:41PM +0100, Markus Trippelsdorf wrote:
> On 2011.03.24 at 19:58 +0100, Jens Axboe wrote:
> > On 2011-03-24 19:54, Markus Trippelsdorf wrote:
> > > On 2011.03.24 at 19:51 +0100, Jens Axboe wrote:
> > >> On 2011-03-24 19:36, Jens Axboe wrote:
> > >>> On 2011-03-24 19:30, Markus Trippelsdorf wrote:
> > >>>> On 2011.03.24 at 14:43 +0100, Jens Axboe wrote:
> > >>>>>
> > >>>>> This is the main pull request for the block IO layer and friends for
> > >>>>> 2.6.39.
> > >>>>
> > >>>> This merge results in an early oops on my system (amd64, xfs).
> > >>>> See the attached photo.
> > >>>>
> > >>>
> > >>> Auch. Can you ensure that you have CONFIG_DEBUGINFO=y in your .config
> > >>> and then do:
> > >>>
> > >>> $ gdb vmlinux
> > >>> ...
> > >>> l *cfq_insert_request+0x32
> > >>>
> > >>> and send that output?
> > >>
> > >> I took a closer look at the oops, and it most likely looks like q ==
> > >> NULL (offset 0x18 == q->elevator). You left out the Code part, so I
> > >> can't verify that for certain. Which makes very little sense. I take it
> > >> this is 100% reproducible? When you send the gdb output, please also
> > >> attach your .config.
> > > 
> > > Yes, it's 100% reproducible here. My .config follows:
> > 
> > Can you try this patch and see if it makes a difference?
> 
> There's no patch ;-)
> 
> > If you boot without the patch and add elevator=noop, does it then work?
> 
> It works insofar as the Oops is gone. But my xfs partitions apparently
> still get corrupted (I had to run xfs_repair on several of them, because
> they would not mount otherwise).

So the patchset is causing repeatable filesystem corruption? Sounds
to me like this series is not yet ready for mainline merging. Last
thing I want to spend the .39 cycle helping people recover busted
filesystems as a result of undercooked block layer changes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
