Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab0JSDyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:54:21 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28011 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757828Ab0JSDyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:54:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoEAJyxvEx5LcB2gWdsb2JhbAChZxYBARYiIsMWhUkEj0o
Date: Tue, 19 Oct 2010 14:54:15 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Sage Weil <sage@newdream.net>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101019035415.GA3256@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-18-git-send-email-david@fromorbit.com>
 <20101017013047.GA4394@infradead.org>
 <20101017024923.GA6453@amd>
 <20101017041313.GJ32255@dastard>
 <20101017043514.GA21802@amd>
 <20101017051310.GA22060@amd>
 <20101017065245.GE29677@dastard>
 <Pine.LNX.4.64.1010181419200.15249@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1010181419200.15249@cobra.newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 02:27:02PM -0700, Sage Weil wrote:
> I took a look at this code and was able to remove the i_lock -> 
> dcache_lock nesting.  To be honest, I'm not sure why I did it that way in 
> the first place.  The only point (now) where i_lock is used/needed is 
> while checking the ceph inode flags, and that's done without holding 
> dcache_lock (presumably soon to be d_lock).

Great, it was a bit nasty of ceph to add that in without documenting
it, but I guess it got past reviewers so it was up to them to ack it
or point it out.

I think we should probably enforce a rule that dcache_lock not nest
inside i_lock :) Anybody wanting to do that in future had better have
a really good reason.

 
> The patch is 622386be in the for-next branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
> 
> Anyway, hope this helps!  

It does, thanks.

