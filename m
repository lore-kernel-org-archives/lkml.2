Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0EETw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:52:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59456 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0EETw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:52:56 -0400
Date: Wed, 5 May 2010 20:52:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505195249.GC11441@sirena.org.uk>
References: <20100505185225.GA4411@srcf.ucam.org> <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org> <20100505192208.GB5085@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505192208.GB5085@srcf.ucam.org>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:22:08PM +0100, Matthew Garrett wrote:
> On Wed, May 05, 2010 at 03:13:52PM -0400, Alan Stern wrote:

> > Does it know when a call is in progress?

> Perhaps you could infer that from the audio routing setup? I don't know 
> enough about embedded codecs.

Yes, you can providing we extract a bit more information from the
machine drivers and/or userspace - we already do our power management
based on paths.  The implementation I'd do here is to provide a facility
for marking some of the path endpoints as suspend insensitive then on
suspend leave those endpoints in their current state, force the other
endpoints off temporarily and re-run the standard power checks.

One thing I'll need to have a bit of a think about is if we need to
provide the ability to offer control to userspace for the suspend state
of path endpoints separately to their runtime state; I suspect the
answer is yes.
