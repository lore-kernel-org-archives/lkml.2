Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1HXGQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:16:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57141
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab1HXGQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:16:07 -0400
Date: Wed, 24 Aug 2011 02:16:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        khlebnikov@openvz.org
Subject: Re: [PATCH 01/13] fs: Use a common define for inode slab caches
Message-ID: <20110824061602.GA24077@infradead.org>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-2-git-send-email-david@fromorbit.com>
 <20110823091307.GA21492@infradead.org>
 <20110823092041.GX3162@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823092041.GX3162@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 07:20:41PM +1000, Dave Chinner wrote:
> > Why do we keep the SLAB_HWCACHE_ALIGN flag for some filesystems?
> 
> I didn't touch that one, mainly because I think that there are
> different reasons for wanting cacheline alignment. e.g. a filesystem
> aimed primarily at embedded systms with slow CPUs and little memory
> doesn't want to waste memory on cacheline alignment....

A little grepping shows jffs2 is a counter example, because it exactly
wants SLAB_HWCACHE_ALIGN to avoid issues with mtd dma.

I'm fine with defering this for now, but the state of using
SLAB_HWCACHE_ALIGN or not is just as much as mess as the rest of the
inode slab flags was.  I'd go as far as calling the whole existance of
most slab flags an utter mess, but that is another fight.

