Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0IWVkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab0IWVkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:40:24 -0400
Date: Thu, 23 Sep 2010 17:40:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] floppy: switch to one queue per drive instead of sharing
 a queue (Was: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel OOPs when
 usb key  is inserted")
Message-ID: <20100923214015.GK20338@redhat.com>
References: <20100920130318.GA29565@lst.de>
 <4C975DCC.9050902@fusionio.com>
 <20100920223001.GJ6138@redhat.com>
 <20100921182529.GA31132@redhat.com>
 <4C992F12.5090000@fusionio.com>
 <20100922204216.GA7487@redhat.com>
 <4C9B08CF.6000504@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9B08CF.6000504@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 09:59:11AM +0200, Jens Axboe wrote:
> On 2010-09-22 22:42, Vivek Goyal wrote:
> > On Wed, Sep 22, 2010 at 12:17:54AM +0200, Jens Axboe wrote:
> > 
> > [..]
> >> Super, thanks a lot! I will queue this up. If you want to continue
> >> this (very noble) crusade, the next target is
> >> drivers/mtd/mtd_blkdevs.c. I never got that one started, but it was
> >> next on my list.
> > 
> > Hi Jens,
> > 
> > IIUC, for MTD this conversion is already done and we seem to be using separate
> > request queue for each gendisk instead of some disks sharing a single
> > request queue. I think by following is relevant commit. Maxim should be
> > able to confirm though.
> 
> Great! So the question is if other drivers with shared queues remain.
> 

I was browsing through drivers/blcok/ dir and apart from amiga and atari
floppy drivers, following also seems to be sharing the request queue across
gendisks.

drivers/block/cpqarray.c
drivers/block/hd.c
drivers/block/swim3.c
drivers/block/swim.c
drivers/block/xd.c

I will look into fixing those, the biggest challenge in front of me is
testing the changes. Especially arch specific drivers.

Thanks
Vivek
