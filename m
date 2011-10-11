Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1JKV4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:56:55 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:29224 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab1JKV4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:56:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAN24lE55LabZ/2dsb2JhbABDqC2BBoFTAQEFJxMcIxAIAxguFCUDIROIBbggAw6GXWEEnFeJBA
Date: Wed, 12 Oct 2011 08:56:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, ceph-devel@vger.kernel.org,
        rwheeler@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: add d_prune dentry operation
Message-ID: <20111011215649.GB3159@dastard>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
 <1317875170-9349-2-git-send-email-sage@newdream.net>
 <20111006212118.GA24109@infradead.org>
 <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net>
 <20111010051141.GV3159@dastard>
 <Pine.LNX.4.64.1110100850020.26361@cobra.newdream.net>
 <20111010162115.GB751@infradead.org>
 <Pine.LNX.4.64.1110110838500.32350@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110110838500.32350@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 08:39:24AM -0700, Sage Weil wrote:
> On Mon, 10 Oct 2011, Christoph Hellwig wrote:
> > On Mon, Oct 10, 2011 at 09:19:43AM -0700, Sage Weil wrote:
> > > Let me know if the below is clearer.  The requirement is that ->d_prune be 
> > > called prior to unhashing (and then destroying) a victim dentry.  I'm a 
> > > little worried about mixing that in with the lru helpers because it is 
> > > only indirectly related to whether the dentry is on the LRU, and that may 
> > > confuse people.  A cleaned up opencoded patch is here:
> > > 
> > > 	https://github.com/NewDreamNetwork/ceph-client/commit/784a6aa6dc7baf2069c40988d79130dba17c7068
> > > 
> > > and the updated dentry_lru_prune() wrapper version is below.
> > 
> > Long term what I really want is a helper for doing more of the real
> > removal in single place.  This is one step towards it, and the series
> > from Dave is another.
> 
> Ah, makes sense.
> 
> Dave, is the revised patch more clear?  

Yeah, I kind of understand what it is doing now, and the comments
will remind me when I start digging in this code again. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
