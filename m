Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2HNU4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:56:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42285 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab2HNUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:55:45 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 173.246.103.110
Date: Tue, 14 Aug 2012 13:55:38 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Thai Bui <blquythai@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
Message-ID: <20120814205537.GA2879@jtriplet-mobl1>
References: <1344891431-30869-1-git-send-email-blquythai@gmail.com>
 <20120813212151.GA15429@phenom.dumpdata.com>
 <CAKkTMC5SP6LgWbhtkU_HCBUAfArGuHXtp4mcwi2tFTjZOwVQbA@mail.gmail.com>
 <5029823A.9020207@xenotime.net>
 <20120814011826.GA2255@leaf>
 <502AB14C.6090406@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502AB14C.6090406@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:13:00PM -0700, Randy Dunlap wrote:
> On 08/13/2012 06:18 PM, Josh Triplett wrote:
> > On Mon, Aug 13, 2012 at 03:39:54PM -0700, Randy Dunlap wrote:
> > In any case, do you object to the introduction of a Kconfig option at
> > all, or to that option defaulting to off?  In particular, would you
> > object if the option only showed up if EMBEDDED, and defaulted to y?  At
> > that point, you could reasonably expect that most users and distros will
> > have it enabled, so you'll be able to count on asking people to enable
> > it and send you the output.  Would that suffice?
> 
> It's not one patch that I object to.  It's a "pile" of them.
> and when does it stop?  or does it go on ad infinitum?

Sounds like you're describing Linux development in general, and I think
the same argument of "as long as people keep wanting to work on it"
applies.

> One could make options to make many lines of code configurable,
> but that would hardly be the right thing to do IMHO.

That seems like an argument better made about specific patches, rather
than as a blanket statement ignoring the details of any particular
patch.  It seems reasonable to me to evaluate the tradeoff of complexity
versus space savings for each patch.  A complex patch that saves very
little space certainly doesn't seem reasonable, and a simple patch that
saves a pile of space seems very reasonable.  In this case, the space
savings seems reasonable enough to justify a patch that seems incredibly
non-invasive.  If the patch had a diffstat in the hundreds of lines, I'd
understand the complaint.

> > The patch itself seems incredibly straightforward and non-invasive to
> > me; it just stubs out the global variable and lets GCC fold away all the
> > code.
> > 
> > At this point, the kernel is running out of major things to cut out to
> > save space; getting from ~200k (the current smallest kernel possible) to
> > much less than that will require a pile of patches that save anywhere
> 
> a pile being how many patches (roughly)?

At the moment, the team has a half-dozen patches in flight.  How many
more will happen in the future depends on how well the remaining parts
of a minimal kernel partition into large, self-contained, removable
chunks.

In any case, could we perhaps pull this conversation back down out of
the abstract and go back to discussing the specific patch in question?

- Josh Triplett
