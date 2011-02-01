Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1BARcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:32:46 -0500
Received: from verein.lst.de ([213.95.11.210]:47331 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab1BARcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:32:45 -0500
Date: Tue, 1 Feb 2011 18:32:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: allow re-reading config space at runtime
Message-ID: <20110201173234.GC16883@lst.de>
References: <20110114160137.GA18721@lst.de> <201101181138.50421.rusty@rustcorp.com.au> <20110118122751.GA27997@lst.de> <201101190956.10137.rusty@rustcorp.com.au> <20110118235401.GA16219@lst.de> <20110127152926.GA4898@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127152926.GA4898@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 05:29:26PM +0200, Michael S. Tsirkin wrote:
> Yes but in that specific situation (double schedule before
> it runs once) discarding one change notification
> would not hurt at all.

Except that you can't easily do it.  We can't simply reuse a work
structure embedded in say struct virtio_blk without first doing a
flush_work_sync/cancel_work_sync to remove it from the internal
workqueue.c queues.  And those calls can sleep and thus can't be called
from interrupt context either.

