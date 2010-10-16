Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab0JPHyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:54:45 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1530 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170Ab0JPHyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:54:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:54:42 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/17] fs: Make last_ino, iunique independent of
 inode_lock
Message-ID: <20101016075442.GD19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-10-git-send-email-david@fromorbit.com>
 <20101001060827.GI32349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001060827.GI32349@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 02:08:27AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:41PM +1000, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Before removing the inode_lock, we need to make the last_ino  and iunique
> > counters independent of the inode_lock. last_ino can be trivially converted to
> > an atomic variable, while the iunique counter needs a new lock nested inside
> > the inode_lock to provide the same protection that the inode_lock previously
> > provided.
> 
> Given that last_ino becomes a per-cpu construct only a few patches later
> I think there's no point to make it an atomic_t here - just reorder the
> per-cpu patch before the inode_lock removal.

I wanted to avoid doing any of that until inode_lock is gone, but
perhaps for this one it makes sense. At the very least, I'll merge
the latter two patches into one, and perhaps this one too.


