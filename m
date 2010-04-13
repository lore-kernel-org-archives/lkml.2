Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0DMSKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:10:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0DMSKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:10:24 -0400
Date: Tue, 13 Apr 2010 14:10:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org
Subject: Re: [PATCH 1/4] blkdev: pass gfp_mask and flags to
	blkdev_issue_flush
Message-ID: <20100413181023.GB1483@infradead.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org> <1271077437-7921-2-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271077437-7921-2-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +enum{
> +	__BLKDEV_IFL_WAIT,	/* wait for completion */
> +	__BLKDEV_IFL_BARRIER,	/*issue request with barrier */
> +};
> +#define BLKDEV_IFL_WAIT		(1 << __BLKDEV_IFL_WAIT)
> +#define BLKDEV_IFL_BARRIER	(1 << __BLKDEV_IFL_BARRIER)

This is a very awkward stayle to define flags.  There really should
be no need for the __-prefixed version.  While you're using them for
test/set_bit and co there's no reason to use these atomic bitops here.

