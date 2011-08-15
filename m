Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1HOOqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:46:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54588
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753583Ab1HOOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:46:19 -0400
Date: Mon, 15 Aug 2011 10:46:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] xen-blkback: sync I/O after backend disconnected
Message-ID: <20110815144610.GA3707@infradead.org>
References: <4E48A6A6.4040706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E48A6A6.4040706@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:55:02PM +0800, Joe Jin wrote:
> When backend disconnect, sync IO requests to the disk.

Care to explain why?

Also you'll just need a sync_blockdev, fsync_bdev does far to many
things that don't make any sense when you don't have a file system
mounted on a device.

