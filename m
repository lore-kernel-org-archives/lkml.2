Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1ARXyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:54:09 -0500
Received: from verein.lst.de ([213.95.11.210]:53919 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab1ARXyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:54:08 -0500
Date: Wed, 19 Jan 2011 00:54:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: allow re-reading config space at runtime
Message-ID: <20110118235401.GA16219@lst.de>
References: <20110114160137.GA18721@lst.de> <201101181138.50421.rusty@rustcorp.com.au> <20110118122751.GA27997@lst.de> <201101190956.10137.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101190956.10137.rusty@rustcorp.com.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:56:09AM +1030, Rusty Russell wrote:
> > I don't think we have much choice.  We're getting called from irq
> > context, so we'll need to allocate memory to offload things.  That's
> > unless we keep a thread around that we just need to wake up, which
> > would be a huge waste of ressources.
> 
> Yes, but can we keep a workqueue struct around?

We can keep one around, but we can't prevent the virtio core code from
calling us again while it's still in use.

