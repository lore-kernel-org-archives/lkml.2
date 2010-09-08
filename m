Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0IHVGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:06:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0IHVF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:05:58 -0400
Date: Wed, 8 Sep 2010 17:05:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Cross <david.cross@cypress.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cachefiles, mpage_cleardirty addtition, west bridge
 related
Message-ID: <20100908210553.GA22411@infradead.org>
References: <1283888011.7250.17.camel@odc-laptop>
 <4313.1283956531@redhat.com>
 <9465F8A421744836B35704023ECA8253@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9465F8A421744836B35704023ECA8253@stanford.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 09:51:22AM -0700, David Cross wrote:
> This is used by the current west bridge driver in the linux-next tree,
> marked as BROKEN at the moment. It is used in order to clear dirty pages
> from the page cache for a specific file after it has been allocated. This
> allows west bridge to transfer data from USB to storage directly without
> requiring that the file data path go through the CPU. The easiest way to
> think of this is that it allows for direct file based DMA. Please let me
> know if you have any additional questions or concerns on this.

It's sad enough that it was taken into any tree at all, but we're not
going to add incorrect crap into the kernel kernel for it.

mpage_* are pagecache manpipulation routines, and are only for use by
filesystems for inodes they manage.  A driver may never access this
directly.  Is this the same piece of junk you wanted fat_get_block
exported for?

