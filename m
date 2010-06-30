Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0F3Od3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:33:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:36008 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab0F3OdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:33:17 -0400
Date: Wed, 30 Jun 2010 22:14:52 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 52/52] fs: icache less I_FREEING time
Message-ID: <20100630121452.GG21358@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030734.042332166@suse.de>
 <20100630101354.GK24712@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630101354.GK24712@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 08:13:54PM +1000, Dave Chinner wrote:
> On Thu, Jun 24, 2010 at 01:03:04PM +1000, npiggin@suse.de wrote:
> > Problem with inode reclaim is that it puts inodes into I_FREEING state
> > and then continues to gather more, during which it may iput,
> > invalidate_mapping_pages, be preempted, etc. Holding these inodes in
> > I_FREEING can cause pauses.
> 
> What sort of pauses? I can't see how holding a few inodes in
> I_FREEING state would cause any serious sort of holdoff...

Well if the inode is accessed again, it has to wait for potentially
hundreds of inodes to be found from the LRU, pagecache invalidated,
and destroyed.

