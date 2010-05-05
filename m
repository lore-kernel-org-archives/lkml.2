Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0EET4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:56:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:60793 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084Ab0EET4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:56:03 -0400
Date: Wed, 5 May 2010 15:55:34 -0400
From: tytso@mit.edu
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matthew Garrett <mjg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505195534.GD18762@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Matthew Garrett <mjg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Brian Swetland <swetland@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Arve Hj?nnev?g <arve@android.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
	mark gross <mgross@linux.intel.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
References: <20100505185225.GA4411@srcf.ucam.org>
 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
 <20100505192208.GB5085@srcf.ucam.org>
 <20100505195249.GC11441@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505195249.GC11441@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I confess I've completely lost track of (a) what problem you are
trying to solve, and (b) how this might relate to some change that
you'd like to see in the suspend block API.  Could you do a quick
summary and recap?  I've gone over the entire thread, and it's still
not clear what change you're advocating for in suspend blockers.

Thanks, regards,

						- Ted

On Wed, May 05, 2010 at 08:52:50PM +0100, Mark Brown wrote:
> On Wed, May 05, 2010 at 08:22:08PM +0100, Matthew Garrett wrote:
> > On Wed, May 05, 2010 at 03:13:52PM -0400, Alan Stern wrote:
> 
> > > Does it know when a call is in progress?
> 
> > Perhaps you could infer that from the audio routing setup? I don't know 
> > enough about embedded codecs.
> 
> Yes, you can providing we extract a bit more information from the
> machine drivers and/or userspace - we already do our power management
> based on paths.  The implementation I'd do here is to provide a facility
> for marking some of the path endpoints as suspend insensitive then on
> suspend leave those endpoints in their current state, force the other
> endpoints off temporarily and re-run the standard power checks.
> 
> One thing I'll need to have a bit of a think about is if we need to
> provide the ability to offer control to userspace for the suspend state
> of path endpoints separately to their runtime state; I suspect the
> answer is yes.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
