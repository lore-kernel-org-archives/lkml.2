Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1HSPzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1HSPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:55:42 -0400
Date: Fri, 19 Aug 2011 11:55:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 10/11] VFS: Cache request_queue in struct block_device
Message-ID: <20110819155534.GA13464@redhat.com>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
 <1312259893-4548-11-git-send-email-andi@firstfloor.org>
 <20110818194245.GJ15413@redhat.com>
 <4E4D7E3C.8060104@linux.intel.com>
 <20110819141409.GD18656@redhat.com>
 <20110819153622.GD25996@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819153622.GD25996@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 05:36:22PM +0200, Andi Kleen wrote:
> On Fri, Aug 19, 2011 at 10:14:09AM -0400, Vivek Goyal wrote:
> > On Thu, Aug 18, 2011 at 02:03:56PM -0700, Andi Kleen wrote:
> > > 
> > > >Is the performance gain because of this one less dereference really
> > > >substantial.
> > > Yes it is measurable on a large macro benchmark.
> > > 
> > > The gain is from doing the prefetch early enough, and that needs the
> > > additional pointer.
> > 
> > So it gives you extra .3% (as mentioned in your first mail). IMHO, for
> > .3% we should not cache extra request queue pointer.
> 
> Note this is on a benchmark which is primarily userland.  Kernel 
> is only a small part, so it's a much higher percentage for the kernel
> time.
> 
> Also on that large benchmark it's hard to any improvement at all,
> and this isn't even a particularly ugly or intrusive change.

> Not sure why you're against it.

Primarily because of code complexity. We are stashing away a pointer and
not taking any reference anywhere. So I am not even sure who is making
sure that request queue is not gone and there are no comments in the code
about why we are stashing a pointer and how are we making sure that
request queue is around for the lifetime of bdev.

Thanks
Vivek
