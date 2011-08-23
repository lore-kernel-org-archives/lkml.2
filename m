Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1HWJNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:13:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41735
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094Ab1HWJNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:13:10 -0400
Date: Tue, 23 Aug 2011 05:13:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
Subject: Re: [PATCH 01/13] fs: Use a common define for inode slab caches
Message-ID: <20110823091307.GA21492@infradead.org>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314089786-20535-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 06:56:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All inode slab cache initialisation calls need to use specific flags
> so that certain core functionality works correctly (e.g. reclaimable
> memory accounting). Some of these flags are used inconsistently
> across different filesystems, so inode cache slab behaviour can vary
> according to filesystem type.
> 
> Wrap all the SLAB_* flags relevant to inode caches up into a single
> SLAB_INODES flag and convert all the inode caches to use the new
> flag.

Why do we keep the SLAB_HWCACHE_ALIGN flag for some filesystems?

