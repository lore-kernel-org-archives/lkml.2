Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1CNKYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:24:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1CNKY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:24:29 -0400
Date: Mon, 14 Mar 2011 06:24:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        cluster-devel@redhat.com, xfs@oss.sgi.com,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Check for immutable flag in fallocate path
Message-ID: <20110314102426.GA29888@infradead.org>
References: <4D6221B8.9040303@gmail.com>
 <4D6F5473.2070709@gmail.com>
 <20110303213903.GL15097@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303213903.GL15097@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:39:03AM +1100, Dave Chinner wrote:
> WTF?  Why does append mode have any effect on whether we can punch
> holes in a file or not? There's no justification for adding this in
> the commit message. Why is it even in a patch that is for checking
> immutable inodes? What is the point of adding it, when all that will
> happen is people will switch to XFS_IOC_UNRESVSP which has never had
> this limitation?

xfs_ioc_space unconditionally rejects inodes with S_APPEND set for
all preallocation / hole punching ioctls.  This might be overzealous for
preallocations not changing the size, or just extending i_size, but it's
IMHO entirely correct for hole punching.  
