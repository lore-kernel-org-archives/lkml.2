Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0KFGs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 02:48:26 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60941 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0KFGsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 02:48:23 -0400
Date: Fri, 5 Nov 2010 23:48:13 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kapil@ccs.neu.edu, gene@ccs.neu.edu
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101106064813.GC11535@count0.beaverton.ibm.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <20101102214706.GA28593@lst.de>
 <1288835258.6132.56.camel@tp-t61>
 <4CD26270.5050906@kernel.org>
 <1288903537.2897.28.camel@tp-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288903537.2897.28.camel@tp-t61>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 03:45:37PM -0500, Nathan Lynch wrote:
> On Thu, 2010-11-04 at 08:36 +0100, Tejun Heo wrote:
> > Hello,
> > 
> > On 11/04/2010 02:47 AM, Nathan Lynch wrote:
> > >>   In this case whitelisting the allowed
> > >> state by requiring special APIs for all I/O (or even just standard
> > >> APIs as long as they are supposed by the C/R lib you're linked against)
> > >> is the more pragmatic, and I think faithful aproach.
> > > 
> > > I don't think users will go for it.  They'll continue to use dodgy
> > > out-of-tree kernel modules and/or LD_PRELOAD hacks instead of porting
> > > their applications to a new library.  I think a C/R library is an
> > > "ideal" solution, but it's one that nobody would use - especially in
> > > HPC, unless the library somehow provides better performance.
> > 
> > I hear that there are plans to integrate one of the userland
> > snapshotting implementations with HPC workload manager.  ISTR the
> > combination to be condor + dmtcp but not sure.  I think things like
> > that make a lot of sense.
> 
> If you look at the C/R implementations of those two projects you'll see
> that they don't implement what I take to be hch's suggestion - a library
> or platform with special-purpose APIs to which applications are ported
> in order to gain C/R ability.  For all their good points, the projects

And even if they did, I don't think asking application developers to use
such a broad API -- one that requires special APIs for all I/O -- is
practical for many of the purposes outlined at kernel summit.
I think DMTCP is better off for not attempting to mandate such APIs.

How rare is it for an application or library to change the underlying
APIs it uses? How many applications have been ported say from Gnome to
KDE (or vice-versa) over the lifetime of the project? Relative to all
the other applications? I would hazard a guess that most were rewritten
rather than ported and that those that were ported are an utterly
insignificant fraction of what's out there.

It's much better to offer tools that, as much as possible, don't care
which APIs the applications use.

Cheers,
	-Matt Helsley
