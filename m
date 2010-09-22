Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0IVUmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0IVUmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:42:20 -0400
Date: Wed, 22 Sep 2010 16:42:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] floppy: switch to one queue per drive instead of sharing
 a queue (Was: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel OOPs when
 usb key  is inserted")
Message-ID: <20100922204216.GA7487@redhat.com>
References: <20100920130318.GA29565@lst.de>
 <4C975DCC.9050902@fusionio.com>
 <20100920223001.GJ6138@redhat.com>
 <20100921182529.GA31132@redhat.com>
 <4C992F12.5090000@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C992F12.5090000@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 12:17:54AM +0200, Jens Axboe wrote:

[..]
> Super, thanks a lot! I will queue this up. If you want to continue
> this (very noble) crusade, the next target is
> drivers/mtd/mtd_blkdevs.c. I never got that one started, but it was
> next on my list.

Hi Jens,

IIUC, for MTD this conversion is already done and we seem to be using separate
request queue for each gendisk instead of some disks sharing a single
request queue. I think by following is relevant commit. Maxim should be
able to confirm though.

-----------------------------------------------------------------------
commit a863862257b7dd08d855bafcb0aedd9ad848ed91
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Mon Feb 22 20:39:29 2010 +0200

    mtd: blktrans: remove mtd_blkcore_priv, switch to per device queue and
threa
    
    This is the biggest change. To make hotplug possible, and this layer
    clean, the mtd_blktrans_dev now contains everything for a single mtd
    block translation device. Also removed some very old leftovers.
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
-----------------------------------------------------------------------

I did create two mtd devices (from block devices, block2mtd), then then
created two block devices on top of those mtd devices (using mtdblock)
and these two devices mtdblock0 and mtdblock1 seems to be using their
own separate request queues. (Change in ioscheduler on one does not change
it on other queue).

So to me it looks like MTD is all set, until and unless I am missing
something.

Vivek
