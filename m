Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1JJFLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:11:48 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:34061 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab1JJFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:11:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAK97kk55LHti/2dsb2JhbABDqBqBBoFTAQEFJxMcIxAIAxguFCUDIRO+Gg6HNQScWokD
Date: Mon, 10 Oct 2011 16:11:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, ceph-devel@vger.kernel.org,
        rwheeler@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: add d_prune dentry operation
Message-ID: <20111010051141.GV3159@dastard>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
 <1317875170-9349-2-git-send-email-sage@newdream.net>
 <20111006212118.GA24109@infradead.org>
 <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 03:20:37PM -0700, Sage Weil wrote:
> On Thu, 6 Oct 2011, Christoph Hellwig wrote:
> > On Wed, Oct 05, 2011 at 09:26:10PM -0700, Sage Weil wrote:
> > > This adds a d_prune dentry operation that is called by the VFS prior to
> > > pruning (i.e. unhashing and killing) a hashed dentry from the dcache.  This
> > > will be used by Ceph to maintain a flag indicating whether the complete
> > > contents of a directory are contained in the dcache, allowing it to satisfy
> > > lookups and readdir without addition server communication.
> > 
> > What tree is the patch against?  I seems to fail to apply against Linus'
> > latests.  
> 
> Whoops, I rebased against v3.0 instead of latest master.
> 
> > It also seem like it basically should not be be opencoded but in a
> > wrapper around dentry_lru_del for all cases but the lazy removal from
> > LRU in case that is referenced, with some comments explaining the whole
> > thing.
> 
> Yeah, that's a bit better.  There are four dentry_lru_del() callers, two 
> where we there is a reference, and two where we want to ->d_prune too.

The code in the patch doesn't explain to me why you'd need to call
dentry_lru_prune() rather than dentry_lru_del()? It's something to
do with the difference between active and inactive LRU removal, but
I can't really tell. My patchset removes the LRU abuse from
select_parent, so I'm kind of wondering what the correct thing is to
do there. 

Hence, can you add a bit of documentation to those functions
explaining why and when you should use one or the other?  i.e
document the situations where the FS needs to be notified of
pruning, rather than leaving anyone who is reading the code
guessing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
