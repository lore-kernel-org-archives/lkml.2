Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0I3Cnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:43:37 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:34595 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752452Ab0I3Cng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:43:36 -0400
Date: Thu, 30 Sep 2010 12:43:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] fs: Introduce per-bucket inode hash locks
Message-ID: <20100930024331.GW5665@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-13-git-send-email-david@fromorbit.com>
 <20100930015213.GA1535@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930015213.GA1535@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:14PM -0400, Christoph Hellwig wrote:
> 
> Instead of doing the lock overkill on a still fundamentally global data
> structure what about replacing this with something better.  I know
> you've already done this with the XFS icache, and while the per-AG
> concept obviously can't be generic at least some of the lessons could be
> applied.

The XFS inode cache design is tied tightly to the inode layout in
XFS, so the tree-per-ag-per-mount parallelism design really does not
work in a generic manner.  Sure, we could probably make it a
hashed-tree rather than hashed-link-list design, but that's a much
more fundamental change than just splitting the locks up.

> then again how much testing did this get anyway given that you
> benchmark ran mostly XFS which doesn't hit this at all?

I've been running comparitive benchmarks on ext4 as well so that I
also test all the generic paths.

> If it was up to me I'd dtop this (and the bl_list addition) from the
> series for now and wait for people who care about the scalability of
> the generic icache code to come up with a better data structure.

I think that it's going to take a lot of work to come up with
something more generically optimal, so in the mean time I think this
is a net win for filesystems that use the generic icache.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
