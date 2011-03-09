Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1CIKic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:38:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab1CIKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:38:31 -0500
Date: Wed, 9 Mar 2011 05:38:28 -0500
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "hch@infradead.org" <hch@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
Message-ID: <20110309103828.GA26181@infradead.org>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
 <20110304040907.GB32404@redhat.com>
 <4D70E78D.9000402@fusionio.com>
 <20110304132551.GA2407@infradead.org>
 <4D762330.8000003@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D762330.8000003@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 01:38:08PM +0100, Jens Axboe wrote:
> -#define DP_UNPLUG             8 /* equals REQ_UNPLUG  */
> +#define DP_UNPLUG             8 /* not used anymore   */

The way this is used might need some more review.  It seems like DRBD is
trying to propagate unplug requests over the wire, which is
functionality we lose now.

> + * The various wait functions, such as wait_on_writeback_range() will
> + * ultimately call sync_page() which will ultimately call
> + * blk_run_backing_dev(), which will end up unplugging the device queue.

This comment describes code that doesn't exist anymore on your branch.

