Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0K3AIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:08:37 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32514 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab0K3AIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:08:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAP7O80x5LcIv/2dsb2JhbACjCnLCT4VHBA
Date: Tue, 30 Nov 2010 11:08:33 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/7] fs: preserve inode dirty bits on failed metadata
  writeback
Message-ID: <20101130000833.GD3255@amd>
References: <20101123140610.292941494@kernel.dk>
 <20101123140707.922192750@kernel.dk>
 <20101129145936.GC26076@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129145936.GC26076@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 09:59:37AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 24, 2010 at 01:06:14AM +1100, npiggin@kernel.dk wrote:
> > Otherwise we think the inode is clean even if syncing failed.
> 
> The patch itself looks fine, but I'm not sure it's enough.  If we do
> an synchronous writeout it could fail long after ->write_inode
> has returned.

Oh there are lots of holes in this buggy POS. Still more that I
haven't fixed, even before you think about error cases.

But, after a *successful* ->write_inode (whether sync or async),
then the filesystem is not going to get any more, unless they
mark the inode dirty again.

I think that's fine, so long as the dirty buffers or whatever are
properly synced at sync(2) / fsync(2) time.

