Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1I0Mgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1I0Mgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:36:35 -0400
Date: Tue, 27 Sep 2011 15:37:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] virtio-net: Verify page list size before fitting
 into skb
Message-ID: <20110927123719.GB11276@redhat.com>
References: <1317058869-19276-1-git-send-email-levinsasha928@gmail.com>
 <20110926184445.GA22278@redhat.com>
 <1317065842.20885.3.camel@lappy>
 <20110926195541.GA23086@redhat.com>
 <1317105842.3467.3.camel@lappy>
 <20110927070034.GB4690@redhat.com>
 <1317122429.3467.5.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317122429.3467.5.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 02:20:29PM +0300, Sasha Levin wrote:
> On Tue, 2011-09-27 at 10:00 +0300, Michael S. Tsirkin wrote:
> > >               skb = page_to_skb(vi, page, len);
> > >               ...
> > 
> > Sorry I don't get it yet. Where is mergeable ignored here?
> 
> The NULL deref happens in page_to_skb(), before merge buffers are
> handled.

The len here is a single buffer length, so for mergeable
buffers it is <= the size of the buffer we gave to hardware,
which is PAGE_SIZE.

        err = virtqueue_add_buf_single(vi->rvq, page_address(page),
                                       PAGE_SIZE, false, page, gfp);
 

Unless of course we are trying to work around broken hardware again,
which I don't have a problem with, but should probably
get appropriate comments in code and trigger a warning.

> I'll test it and see if it's really the case.
> 
> -- 
> 
> Sasha.
