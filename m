Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0JPHyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:54:52 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1530 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170Ab0JPHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:54:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:54:47 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/17] fs: Factor inode hash operations into functions
Message-ID: <20101016075447.GE19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-12-git-send-email-david@fromorbit.com>
 <20101001060607.GG32349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001060607.GG32349@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 02:06:07AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:43PM +1000, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Before we can replace the inode hash locking with a more scalable
> > mechanism, we need to remove external users of the inode_hash_lock.
> > Make it private by adding a function __remove_inode_hash that can be
> > called by filesystems instead of open-coding their own inode hash
> > removal operations.
> 
> I like the factoring, but this changelog is misleading.  At least in
> this series no new user of __remove_inode_hash appears, and I'm not sure
> where it would appear anyway.  Just making the function global without
> actually exporting it is not helping external filesystems anyway.  For
> now it can simply be made static.

Yeah, hugetlbfs was using this a while back as I said, and I've missed
refactoring it. Will do.

