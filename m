Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1FDOI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 10:08:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49627
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891Ab1FDOIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 10:08:55 -0400
Date: Sat, 4 Jun 2011 10:08:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 08/12] superblock: introduce per-sb cache shrinker
 infrastructure
Message-ID: <20110604140848.GA20404@infradead.org>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
 <1306998067-27659-9-git-send-email-david@fromorbit.com>
 <20110604004231.GV11521@ZenIV.linux.org.uk>
 <20110604015212.GD561@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110604015212.GD561@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 11:52:12AM +1000, Dave Chinner wrote:
> I wanted to put it early on in the unmount path so that the shrinker
> was guaranteed to be gone before evict_inodes() was called. That
> would mean that it is obviously safe to remove the iprune_sem
> serialisation in that function.

The iprune_sem removal is fine as soon as you have a per-sb shrinker
for the inodes which keeps an active reference on the superblock until
all the inodes are evicted.

