Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab1DMWel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:34:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933311Ab1DMWej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:34:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [uclinux-dist-devel] freezer: should barriers be smp?
Date: Thu, 14 Apr 2011 00:34:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1104131805090.2005-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104131805090.2005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104140034.41727.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 14, 2011, Alan Stern wrote:
> On Wed, 13 Apr 2011, Rafael J. Wysocki wrote:
> 
> > The above means that smp_*mb() are defined as *mb() if CONFIG_SMP is set,
> > which basically means that *mb() are more restrictive than the corresponding
> > smp_*mb().  More precisely, they also cover the cases in which the CPU
> > reorders instructions on uniprocessor, which we definitely want to cover.
> > 
> > IOW, your patch would break things on uniprocessor where the CPU reorders
> > instructions.
> 
> How could anything break on a UP system?  CPUs don't reorder 
> instructions that drastically.  For example, no CPU will ever violate
> this assertion:
> 
> 	x = 0;
> 	y = x;
> 	x = 1;
> 	assert(y == 0);
> 
> even if it does reorder the second and third statements internally.  
> This is guaranteed by the C language specification.

Well, you conveniently removed the patch from your reply. :-)

For example, there's no reason why the CPU cannot reorder things so that
the "if (frozen(p))" is (speculatively) done before the "if (!freezing(p))"
if there's only a compiler barrier between them.

> > > Documentation/memory-barriers.txt:
> > > SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
> > > systems because it is assumed that a CPU will appear to be self-consistent,
> > > and will order overlapping accesses correctly with respect to itself.
> > 
> > Exactly, which is not guaranteed in general (e.g. on Alpha).  That is, some
> > CPUs can reorder instructions in such a way that a compiler barrier is not
> > sufficient to prevent breakage.
> 
> I don't think this is right.  You _can_ assume that Alphas appear to be
> self-consistent.  If they didn't, you wouldn't be able to use them at
> all.

I'm quite convinced that the statement "some CPUs can reorder instructions in
such a way that a compiler barrier is not sufficient to prevent breakage" is
correct.

Thanks,
Rafael
