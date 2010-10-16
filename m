Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0JPH5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:47 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41909 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab0JPH5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:57:43 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] fs: icache lock inode hash
Message-ID: <20101016075743.GU19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-4-git-send-email-david@fromorbit.com>
 <20101001060650.GH32349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001060650.GH32349@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 02:06:50AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:35PM +1000, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Currently the inode hash lists are protected by the inode_lock. To
> > allow removal of the inode_lock, we need to protect the inode hash
> > table lists with a new lock. Nest the new inode_hash_lock inside the
> > inode_lock to protect the hash lists.
> 
> There is no reason to make inode_hash_lock global, it's only used inside
> inode.c

It was like that while hugetlbfs still used it. Fixed, thanks.
