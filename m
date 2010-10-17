Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab0JQXj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 19:39:26 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:56056 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751111Ab0JQXjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 19:39:25 -0400
Date: Mon, 18 Oct 2010 10:39:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101017233921.GF29677@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-18-git-send-email-david@fromorbit.com>
 <20101017013047.GA4394@infradead.org>
 <20101017024923.GA6453@amd>
 <20101017041313.GJ32255@dastard>
 <20101017043514.GA21802@amd>
 <20101017051310.GA22060@amd>
 <20101017065245.GE29677@dastard>
 <20101017070519.GA24641@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017070519.GA24641@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 06:05:19PM +1100, Nick Piggin wrote:
> On Sun, Oct 17, 2010 at 05:52:45PM +1100, Dave Chinner wrote:
> > > A really quick grep reveals cifs is using GlobalSMBSeslock inside i_lock
> > > too.
> > 
> > I'm having a grep-fail day. Where is that one?
> 
> Uh, inside one of the 6 places that i_lock is taken in cifs. The only
> non-trivial one, not surprisingly.

It's two function calls away from the use of i_lock, in a different file.
A quick grep on a warm, sunny Sunday afternoon between walking the
dog and heading down to the pub for a beer and dinner isn't going to
find that. :/

Anyway, this one looks fairly easy to fix as the code that locks
GlobalSMBSeslock is only called from this location. I'll code up a
patch to fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
