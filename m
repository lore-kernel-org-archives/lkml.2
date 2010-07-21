Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab0GUMUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:20:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:49832 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0GUMUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:20:01 -0400
Date: Wed, 21 Jul 2010 14:19:31 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
Subject: Re: linux-next: OOPS at boot time
Message-ID: <20100721121930.GE3447@quack.suse.cz>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
 <20100720033656.0ce6356f.akpm@linux-foundation.org>
 <20100720224525.GO32635@dastard>
 <20100720174424.12a4bf64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720174424.12a4bf64.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-07-10 17:44:24, Andrew Morton wrote:
> On Wed, 21 Jul 2010 08:45:25 +1000
...
> This isn't necessarily a problem in the quota code (setting aside the
> question: why the heck does dquot_free_space() set I_DIRTY_PAGES??).
  Because sometime in the dark past (2.4 days I believe), I used
mark_inode_dirty in quota functions (not sure whether there even were
different inode dirty flags back then) and it stayed this way upto now.
mark_inode_dirty_sync() is of course more appropriate for quota code these
days. Cleanup is on its way...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
