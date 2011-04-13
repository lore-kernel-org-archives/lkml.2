Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab1DMWLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:11:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58406 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933068Ab1DMWLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:11:49 -0400
Date: Wed, 13 Apr 2011 18:11:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [uclinux-dist-devel] freezer: should barriers be smp
 ?
In-Reply-To: <201104132353.09282.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1104131805090.2005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, Rafael J. Wysocki wrote:

> The above means that smp_*mb() are defined as *mb() if CONFIG_SMP is set,
> which basically means that *mb() are more restrictive than the corresponding
> smp_*mb().  More precisely, they also cover the cases in which the CPU
> reorders instructions on uniprocessor, which we definitely want to cover.
> 
> IOW, your patch would break things on uniprocessor where the CPU reorders
> instructions.

How could anything break on a UP system?  CPUs don't reorder 
instructions that drastically.  For example, no CPU will ever violate
this assertion:

	x = 0;
	y = x;
	x = 1;
	assert(y == 0);

even if it does reorder the second and third statements internally.  
This is guaranteed by the C language specification.

> > Documentation/memory-barriers.txt:
> > SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
> > systems because it is assumed that a CPU will appear to be self-consistent,
> > and will order overlapping accesses correctly with respect to itself.
> 
> Exactly, which is not guaranteed in general (e.g. on Alpha).  That is, some
> CPUs can reorder instructions in such a way that a compiler barrier is not
> sufficient to prevent breakage.

I don't think this is right.  You _can_ assume that Alphas appear to be
self-consistent.  If they didn't, you wouldn't be able to use them at
all.

Alan Stern

