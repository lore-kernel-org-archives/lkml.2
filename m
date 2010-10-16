Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0JPHyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:54:17 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1494 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884Ab0JPHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:54:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:54:11 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] fs: icache lock s_inodes list
Message-ID: <20101016075411.GA19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-3-git-send-email-david@fromorbit.com>
 <20101001054909.GB32349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001054909.GB32349@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:49:09AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:34PM +1000, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > To allow removal of the inode_lock, we first need to protect the
> > superblock inode list with it's own lock instead of using the
> > inode_lock for this purpose. Nest the new sb_inode_list_lock inside
> > the inode_lock around the list operations it needs to protect.
> 
> Is there any good reason not to make this lock per-superblock?

Because in the first part of the inode lock series, it is breaking
locks in obvious small steps as possible, by adding global locks
protecting bits of what inode_lock used to.

If we did want to make it per-superblock, that would come at the
last part of the series, where inode_lock is removed and steps are
being taken to improve scalability and locking.

But I don't see why we want to make it per-superblock really anyway.
We want to have scalability within a single superblock, so per CPU
locks are needed. Once we have those, per-superblock doesn't really
buy much.

