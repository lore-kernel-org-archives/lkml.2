Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0ITNMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:12:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37929 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab0ITNMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:12:41 -0400
Message-ID: <4C975DCC.9050902@fusionio.com>
Date: Mon, 20 Sep 2010 15:12:44 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel OOPs when usb
 key  is inserted"
References: <20100920130318.GA29565@lst.de>
In-Reply-To: <20100920130318.GA29565@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-20 15:03, Christoph Hellwig wrote:
> Hi Vivek, hi Jens,
> 
> where was http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=44c74d6292e97f8bd9adfa6b0df3cb4f3c42a6dc posted  on the mailinglist?
> 
> I can't find it in my lkml or fsdevel inboxes.  Either way I don't think
> just papering over the underlying issue like this is a good idea.  
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

I did this one 15 months ago (according to git), but I never got it
tested:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=7a0ebc7ea1db42a71841df6a15be9fd420fae980

IIRC, the mtd stuff also uses a shared queue. But I think that is it.
Would indeed be VERY nice to finally get rid of that crap, it has
technically been outlawed since 2.5.1.

-- 
Jens Axboe

