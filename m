Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1EDP4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:56:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1EDP4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:56:46 -0400
Date: Wed, 4 May 2011 18:56:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 4/8]vhost: vhost TX zero-copy support
Message-ID: <20110504155624.GB15648@redhat.com>
References: <1304496684.20660.84.camel@localhost.localdomain>
 <20110504095650.GA11592@redhat.com>
 <1304522284.7076.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304522284.7076.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 08:18:04AM -0700, Shirley Ma wrote:
> > > +void vhost_zerocopy_callback(struct sk_buff *skb)
> > > +{
> > > +     int idx = skb_shinfo(skb)->ubuf.desc;
> > > +     struct vhost_virtqueue *vq = skb_shinfo(skb)->ubuf.arg;
> > > +
> > > +     /* set len = 1 to mark this desc buffers done DMA */
> > > +     vq->heads[idx].len = 1;
> > > +}
> > 
> > So any kind of callback like that, that goes into the skb,
> > will be racy wrt module unloading because module can go away
> > after you mark dma done and before this function returns.
> > Solution is to have a core function that does the
> > final signalling (e.g. sock_wfree is in core).
> > Would be nice to fix, even though this race is
> > completely theoretical, I don't believe it will
> > trigger in practice.
> 
> I run lots of stress tests, and never hit this. 
> 
> But I can try to fix it.

Yes, it's a theoretical thing. Nice to have but not a must.

