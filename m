Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab1JLO0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:26:24 -0400
Received: from 99-108-226-0.lightspeed.iplsin.sbcglobal.net ([99.108.226.0]:58452
	"EHLO peff.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1JLO0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:26:22 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Oct 2011 10:26:22 EDT
Date: Wed, 12 Oct 2011 10:19:39 -0400
From: Jeff King <peff@peff.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Valdis.Kletnieks@vt.edu, git@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/20] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111012141939.GA25085@sigill.intra.peff.net>
References: <20111010133852.829771373@goodmis.org>
 <20111011055017.GA32616@elte.hu>
 <20002.1318367320@turing-police.cc.vt.edu>
 <20111012080711.GM18618@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111012080711.GM18618@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 10:07:14AM +0200, Ingo Molnar wrote:

> > On Tue, 11 Oct 2011 07:50:17 +0200, Ingo Molnar said:
> > 
> > >  $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/perf/core
> > >  fatal: The remote end hung up unexpectedly
> > 
> > Is it possible to get 'git' to say something more informative than 
> > "hung up unexpectedly"? "Tree not found, check URL" or similar 
> > would be nice...

It's not possible for the client to say anything more. The server sees
that the request isn't valid and hangs up without saying anything. So
the server needs to be changed to output better responses.

> Firstly, arguably, typoing something is not 'fatal' really - it's 
> just a resource that was not found on the server.
> 
> Secondly, and more importantly, the reason for the failed pull is 
> indeed important to know, if you want to resolve the problem with a 
> minimum fuss:
> 
>  - Was it the tree that didnt exist?
>  - Or the branch?
>  - Or was there some other problem [such as a truly unexpectedly 
>                                     closed transport socket]?
> 
> It's really useful for a painless UI flow to disambiguate failure 
> messages into clearly actionable variants.

I agree. I think some people are concerned with leaking information
about which repos exist and how they are configured. That is probably
not a big problem for a public site like kernel.org, though.

You might find this thread interesting:

  http://thread.gmane.org/gmane.comp.version-control.git/182529/focus=182642

It seems to have resulted in a patch that will at least say "access
denied" for every error. Which is a step up from "the remote end hung up
unexpectedly", but I do think most users would appreciate it being more
specific.

Perhaps we just need a config option to turn on more verbose messages,
if the site decides that there's no security implications to doing so.

-Peff
