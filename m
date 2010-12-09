Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab0LIFQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 00:16:25 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58238 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab0LIFQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 00:16:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMPy/0x5LdBk/2dsb2JhbACjaHnAG4VJBJAL
Date: Thu, 9 Dec 2010 16:16:17 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/46] Revert "fs: use RCU read side protection in
   d_validate"
Message-ID: <20101209051617.GA3436@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <2d1d8ffc4acea8b6c4e5b58bb1653b3f0e7071e2.1290852958.git.npiggin@kernel.dk>
 <20101208011656.GD29333@dastard>
 <20101208093824.GA3151@amd>
 <20101209004413.GB32766@dastard>
 <20101209043842.GB3139@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209043842.GB3139@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 03:38:42PM +1100, Nick Piggin wrote:
> > Code changes. It may not be doing what it was originally
> > needed/intended to be doing - I don't need to waste time on code
> > archeology and second guessing when there are others around that can
> > tell me this off the top oftheir head. ;)
> 
> Well the d_validate API is meant to provide that, so it's broken
> whether or not its callers use it correctly. It's also exported
> to external modules...
> 
> Yes we should remove smbfs and rip the cache out of ncpfs and
> remove d_validate entirely when possible (or, provide a more

The reason why I don't remove the caching crap entirely is because
it is not a trivial change to properly remove it, and I don't have
the time or inclination to do it properly and have it tested when
it's easy to provide a correct, simple, and back compatible API.

The patch Christoph posted for smbfs and ncpfs just hacks out where the
dentry is used from the cache, but leaves a lot of cache infrastructure
there to rot.


> reasonable API and caching library entirely in the dcache code
> that a filesystem might use). But this is the right first step.

For the record, if anyone cares, the sanest and simplest way to do this
would be to store the dentry's hash along with its pointer, and have
interfaces to allocate, destroy, insert, and delete from cache, and
lookup based on a supplied compare function. (but obviously we shouldn't
bother unless some good numbers turn up)

