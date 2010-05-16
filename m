Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0EPNi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 09:38:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0EPNi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 09:38:26 -0400
Date: Sun, 16 May 2010 09:38:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jiaying Zhang <jiayingz@google.com>
Cc: hch@infradead.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       mrubin@google.com
Subject: Re: [PATCH, RFC] addjust discard request to be aligned with hwsect
	size to support SSDs with larger sector size
Message-ID: <20100516133820.GA25820@infradead.org>
References: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:19:53PM -0700, Jiaying Zhang wrote:
> The currect blkdev_issue_discard() function assumes 512 sector size.
> We have seen some problem when using discard on a SSD that has larger
> sector size. The following patch adjusts the starting address and size of
> a discard request to be aligned with hwsect size.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

> -	if (!blk_queue_discard(q))
> +	if (!blk_queue_discard(q) || q->limits.max_discard_sectors == 0)
>  		return -EOPNOTSUPP;

But this change is unrelated.  It's fine with me, but needs a patch of
it's own with a proper description.

