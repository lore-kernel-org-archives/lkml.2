Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab0EQCWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:22:48 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46840 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752141Ab0EQCWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:22:47 -0400
Date: Sun, 16 May 2010 22:22:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Matt Reimer <mattjreimer@gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <4BF06489.1050200@crca.org.au>
Message-ID: <Pine.LNX.4.44L0.1005162219330.24400-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, Nigel Cunningham wrote:

> >> I object to the patch.
> >>
> >> Tell the patch it ought to exit once thawed, by all means.
> >
> > I'm not sure what you mean.  Care to explain?
> 
> I mean "Set up some sort of flag that it can look at once thawed at 
> resume time, and use that to tell it to exit at that point."

Doesn't the patch do exactly that?  The "flag" is set by virtue of the 
fact that this is part of del_gendisk -- which means the disk is being 
unregistered and hence the writeback thread will exit shortly.

> >> Make the patch unfreezeable to begin with, by all means.
> >
> > That wouldn't work.
> 
> Why not?

It would be nice to know exactly why.  Perhaps the underlying problem 
can be fixed.

> >> If you know a disk is going to be unregistered during resume,
> >
> > How do we check that, exactly?
> 
> Well, if you can figure out that you need to go down this path at this 
> point in the process, you must be able to apply the same logic to come 
> to the same conclusion earlier in the process.

That's not true.  You don't know that a device is going to be unplugged 
until it actually _is_ unplugged.

Alan Stern

