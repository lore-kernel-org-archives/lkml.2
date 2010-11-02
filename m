Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0KBQzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:55:11 -0400
Received: from verein.lst.de ([213.95.11.210]:43563 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab0KBQzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:55:06 -0400
Date: Tue, 2 Nov 2010 17:54:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 4/4] xen/blkfront: cope with backend that fail empty BLKIF_OP_WRITE_BARRIER requests
Message-ID: <20101102165434.GA19703@lst.de>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com> <a90cc3e15a94274bb22b990be16cd1f62747a0dd.1288714384.git.jeremy.fitzhardinge@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a90cc3e15a94274bb22b990be16cd1f62747a0dd.1288714384.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  				       info->gd->disk_name);
>  				error = -EOPNOTSUPP;
> +			}
> +			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
> +				     info->shadow[id].req.nr_segments == 0)) {
> +				printk(KERN_WARNING "blkfront: %s: empty write barrier op failed\n",
> +				       info->gd->disk_name);
> +				error = -EOPNOTSUPP;
> +			}

We don't use -EOPNOTSUPP anymore in the new world order, anything
barrier related is just a normal I/O error now.

