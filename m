Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1DDWgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:36:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57384 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab1DDWgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:36:38 -0400
Date: Mon, 4 Apr 2011 15:29:14 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110404222914.GB27628@count0.beaverton.ibm.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
 <4D9A00B1.2080002@cs.columbia.edu>
 <1301953409.31531.130.camel@tp-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301953409.31531.130.camel@tp-t61>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 04:43:29PM -0500, Nathan Lynch wrote:
> On Mon, 2011-04-04 at 13:32 -0400, Oren Laadan wrote:
> > From the technical point of view it *is* a big problem:  there are
> > very good reasons why we chose a certain design. 
> > 
> > If Natahan is suggesting in-kernel tree creation as a temporary thing
> > to simplify the code for review - then, given that this patch handles
> > a single process, doing so add lots of unnecessary code, all of which
> > in the kernel.
> > 
> > If this is the beginning of a permanent approach, then it is totally
> > incompatible with what we have done so far, and severely restricts 
> > the kind of use--cases of the project, potentially making it too
> > unattractive for many natural adaptors, like HPC users. Sorry, nack.
> 
> It's not a stopgap measure to "ease review" or whatever; recreating the
> task tree in-kernel is a fundamental - and simplifying - part of the
> design.  I have earned through painful experience the opinion that
> recreating the task tree in userspace is pretty much insane, as is
> exposing the pid allocator to userspace via eclone(2), as is attempting
> to support c/r of any resource that isn't isolated/virtualized, as is
> having every recreated task "rendezvous" in the kernel by having them
> all call restart(2), even though little significant work can be done in
> parallel.

So far we've been proceeding under the assumption that some userspace
code ugliness was acceptable if it simplified the kernel code. With
ghost issues and the stuff you've mentioned above I think it's become
questionable whether that choice has simplified the kernel code enough
and trying something different is valuable.

At this point the only advantage I still see in userspace task creation for
restart is the reviewability of it. eclone is a small piece of code that
can be reviewed independently of restart and thus will prove alot easier to
review for correctness and security than in-kernel task creation for restart.

Cheers,
	-Matt Helsley
