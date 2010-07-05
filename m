Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0GEWld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 18:41:33 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:39631 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754328Ab0GEWlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 18:41:32 -0400
Date: Tue, 6 Jul 2010 08:41:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100705224106.GZ24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
 <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
 <20100703034123.GE11732@laptop>
 <20100702213149.f0ca2f72.akpm@linux-foundation.org>
 <20100703050652.GF11732@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703050652.GF11732@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 03:06:52PM +1000, Nick Piggin wrote:
> So it makes a lot of sense to have a lock to rule the inode (as opposed
> to now we have a lock to rule *all* inodes).

I don't disagree with this approach - I object to the fact that you
repurpose an existing lock and change it's locking rules to "rule
the inode". We don't have any one lock that "rules the inode",
anyway, so adding a new "i_list_lock" for the new VFS level locking
strategies makes it a lot more self-contained. Fundamentally I'm
less concerned about the additional memory usage than I am about
having landmines planted around i_lock...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
