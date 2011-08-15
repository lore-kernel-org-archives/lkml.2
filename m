Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1HOPMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:12:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46703 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1HOPMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:12:19 -0400
Date: Mon, 15 Aug 2011 11:10:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Joe Jin <joe.jin@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>
Subject: Re: [Xen-devel] Re: [patch] xen-blkback: sync I/O after backend
 disconnected
Message-ID: <20110815151042.GA22541@dumpdata.com>
References: <4E48A6A6.4040706@oracle.com>
 <20110815144610.GA3707@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815144610.GA3707@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E493700.014C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 10:46:10AM -0400, Christoph Hellwig wrote:
> On Mon, Aug 15, 2011 at 12:55:02PM +0800, Joe Jin wrote:
> > When backend disconnect, sync IO requests to the disk.
> 
> Care to explain why?

I was thinking it might be a good idea to do that when a disk
(file, LVM, real block device) is released from a guest just in case
there is some outstanding I/Os. But then I realized that we
bypasses the page cache anyhow - so there should be no outstanding I/O
requests - unless they are in the disk queue.

And the guest would normally issues a FLUSH when unmounting the
disk. Hm, I wonder what the conditions are when we forcibly kill the
guest - there might be outstanding I/Os in the disk's cache -
at which point we should probably sync the write cache, no?

> 
> Also you'll just need a sync_blockdev, fsync_bdev does far to many
> things that don't make any sense when you don't have a file system
> mounted on a device.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
