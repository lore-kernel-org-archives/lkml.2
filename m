Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1IGVbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079Ab1IGVbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:31:46 -0400
Date: Wed, 7 Sep 2011 17:31:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, jbeulich@novell.com,
        linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110907213137.GJ31726@redhat.com>
References: <20110907174832.GN32190@dumpdata.com>
 <20110907181740.GG31726@redhat.com>
 <20110907201620.GB26548@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907201620.GB26548@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:16:20PM -0400, Christoph Hellwig wrote:
> [Hmm, for some reason I never manage to receive Konrads mails directly,
>  but only get the replies, or copies via the list]
> 
> On Wed, Sep 07, 2011 at 02:17:40PM -0400, Vivek Goyal wrote:
> > On Wed, Sep 07, 2011 at 01:48:32PM -0400, Konrad Rzeszutek Wilk wrote:
> > > Hey Christoph,
> > > 
> > > I was wondering what you think is the proper way of implementing a
> > > backend to support the 'barrier' type requests? We have this issue were
> > > there are 2.6.36 type guests that still use barriers and we would like
> > > to support them properly. But in 3.0 there are no barriers - hence
> > > the question whether WRITE_fLUSH_FUA would be equal to WRITE_BARRIER?
> > 
> > I think WRITE_FLUSH_FUA is not same as WRITE_BARRIER. Because it does
> > not ensure request ordering. A request rq2 which is issued after rq1 (with
> > WRITE_flush_FUA), can still finish before rq1. In the past WRITE_BARRIER
> > would not allow that.
> > 
> > So AFAIK, WRITE_flush_fua is not WRITE_BARRIER.
> 
> Indeed.  And while most guests won't care some will.  E.g. reiserfs
> which is the standard filesystem in most SuSE guests, which happen to
> be fairly popular with Xen.
> 
> I'd suggest you look at the pre-2.6.36 barrier implementation and see
> if you can move that into xen-blkfront.
> 
> For the qemu side doing this is a bit easier as you'll just have to wait
> for all pending aio requests to complete.  The current qemu xen disk
> code gets thus horribly wrong, though.

I have a basic question. In old guest why BARRIER handling on request
queue is not sufficient for sequencing and ordering of requests and why
xen-blkfront and qemu have to do something about it.

I am also wondering if virtio-blk have similar issues?

Thanks
Vivek
