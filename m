Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2IGAFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:05:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab2IGAFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:05:04 -0400
Date: Fri, 7 Sep 2012 03:06:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120907000623.GA3000@redhat.com>
References: <503CC904.3050207@gmail.com>
 <20120829110748.GB5970@redhat.com>
 <503E2F27.5060904@gmail.com>
 <20120829153833.GE7407@redhat.com>
 <503E4873.6060607@gmail.com>
 <871uigj747.fsf@rustcorp.com.au>
 <20120906050257.GA17656@redhat.com>
 <877gs7inx8.fsf@rustcorp.com.au>
 <20120906084526.GE17656@redhat.com>
 <87txvahfv3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txvahfv3.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 09:19:04AM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > On Thu, Sep 06, 2012 at 05:27:23PM +0930, Rusty Russell wrote:
> >> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> > Yes without checksum net core always linearizes packets, so yes it is
> >> > screwed.
> >> > For -net, skb always allocates space for 17 frags + linear part so
> >> > it seems sane to do same in virtio core, and allocate, for -net,
> >> > up to max_frags + 1 from cache.
> >> > We can adjust it: no _SG -> 2 otherwise 18.
> >> 
> >> But I thought it used individual buffers these days?
> >
> > Yes for receive, no for transmit. That's probably why
> > we should have the threshold per vq, not per device, BTW.
> 
> Can someone actually run with my histogram patch and see what the real
> numbers are?
> 
> I'm not convinced that the ideal 17-buffer case actually happens as much
> as we think.  And if it's not happening with this netperf test, we're
> testing the wrong thing.
> 
> Thanks,
> Rusty.

hope to play with it next week
