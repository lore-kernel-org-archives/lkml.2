Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1A0P3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:29:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1A0P3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:29:48 -0500
Date: Thu, 27 Jan 2011 17:29:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: allow re-reading config space at runtime
Message-ID: <20110127152926.GA4898@redhat.com>
References: <20110114160137.GA18721@lst.de>
 <201101181138.50421.rusty@rustcorp.com.au>
 <20110118122751.GA27997@lst.de>
 <201101190956.10137.rusty@rustcorp.com.au>
 <20110118235401.GA16219@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118235401.GA16219@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 12:54:01AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 19, 2011 at 09:56:09AM +1030, Rusty Russell wrote:
> > > I don't think we have much choice.  We're getting called from irq
> > > context, so we'll need to allocate memory to offload things.  That's
> > > unless we keep a thread around that we just need to wake up, which
> > > would be a huge waste of ressources.
> > 
> > Yes, but can we keep a workqueue struct around?
> 
> We can keep one around, but we can't prevent the virtio core code from
> calling us again while it's still in use.

Yes but in that specific situation (double schedule before
it runs once) discarding one change notification
would not hurt at all.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
