Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0ITNcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab0ITNcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:32:17 -0400
Date: Mon, 20 Sep 2010 09:32:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel OOPs when usb
 key is inserted"
Message-ID: <20100920133211.GB6138@redhat.com>
References: <20100920130318.GA29565@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920130318.GA29565@lst.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 03:03:18PM +0200, Christoph Hellwig wrote:
> Hi Vivek, hi Jens,
> 
> where was http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=44c74d6292e97f8bd9adfa6b0df3cb4f3c42a6dc posted  on the mailinglist?
> 
> I can't find it in my lkml or fsdevel inboxes.  Either way I don't think
> just papering over the underlying issue like this is a good idea.  

Hi Christoph,

https://patchwork.kernel.org/patch/163661/

> 
> The big issue is that cfq tries to scanf the textual representation of
> the dev_t from the request_queue by abusing the bdi.  But the reason why
> we don't have a dev_t in the request_queue is that it's still not
> unique.  If it was we could easily add a dev_t into the request_queue
> and be done with it.
> 
> So the fix is either to get rid of the last remaining users of shared
> request_queues (IIRC the various floppy drivers) and just add a dev_t
> in the request_queue for the bdi, tracing and cfq, or add a dev_t into
> the request_queue and add a flag for shared request queues that the
> floppy driver and whoever needs it set and let the bdi sysfs code, cfq
> and blocktrace ignore theis request_queue.  This will also allow to
> get rid of the crap about ignoring failures due to already register
> or prematurely unregistered bdis and actually add real error handling
> to that code.

Agreed that multiple disks backed by single reuqest queue does not fit
CFQ's + cgroup model. I am also using same model for throttling block
devices. So it is important to fix it. 

I will test the patch Jens wrote long back and mentioned in other mail for
fixing floppy drivers. Will also try to scan for other drivers doing this.
If you have some hints for me regarding what drivers to look at, that will
help.

Thanks
Vivek 
