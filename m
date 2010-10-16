Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab0JPHyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:54:39 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1530 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128Ab0JPHyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:54:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:54:34 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] fs: icache protect inode state
Message-ID: <20101016075434.GC19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-9-git-send-email-david@fromorbit.com>
 <20101001060227.GF32349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001060227.GF32349@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 02:02:27AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:40PM +1000, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Before removing the inode_lock, we need to protect the inode list
> > operations with the inode->i_lock. This ensures that all inode state
> > changes are serialised regardless of the fact that the lists they
> > are moving around might be protected by different locks. Hence we
> > can safely protect an inode in transit from one list to another
> > without needing to hold all the list locks at the same time.
> 
> The subject does not seem to match the patch description and content.

It is adding i_lock around remaining places where an inode can be moved
on or off icache data structures. As I've described, this is quite
central to my locking design, isn't the changelog understandable?


