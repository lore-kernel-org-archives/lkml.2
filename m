Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054Ab0HMSuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:50:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab0HMSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:50:09 -0400
Date: Fri, 13 Aug 2010 14:50:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Cross <david.cross@cypress.com>
Cc: Greg KH <gregkh@suse.de>, hirofumi@mail.parknet.co.jp,
        linux-kernel@vger.kernel.org
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100813185005.GA21112@infradead.org>
References: <1281721539.5839.4.camel@odc-laptop>
 <20100813175402.GA15024@suse.de>
 <1281724992.12189.16.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281724992.12189.16.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 11:43:12AM -0700, David Cross wrote:
> OK, I am trying to answer all questions on this topic that I am getting,
> but honestly I have not gotten a lot so far. 

Seriously, I think there is absolutely no point in even arguing this.
A driver has absolutely no business looking into any filesystem layout.

> 1) receive all data, buffer it, then write the file. This is typically a
> slow process USB->Processor->SDRAM->Processor/DMA engine->Media
> 2) pre-allocate the file as soon as it knows that it is coming and how
> big it is, and then send the block addresses to an external DMA engine
> and let it transfer the data from the MTP host directly
> 
> The West Bridge driver goes for option two for performance reasons. In
> doing this, it needs to get information from the file system on where to
> store the file.

And what if someone else changes the layout undernath you?  Or uses
a different filesystem?

Basically you will have to introduce operations to the VFS to lock down
a file against layout changes and do DMA transfers.  It's fine if you
only implement it for fat in the beginning, and just return an error
for others, although in general the implementation would be easily
extendable to other filesystems using generic code and the get_blocks
callbacks.
