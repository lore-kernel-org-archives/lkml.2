Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2KQAff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:35:35 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:36363 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2KQAfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:35:33 -0500
Message-ID: <1353112529.2743.83.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [rfc net-next v6 2/3] virtio_net: multiqueue support
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jason Wang <jasowang@redhat.com>,
        <davem@davemloft.net>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <krkumar2@in.ibm.com>, <kvm@vger.kernel.org>, <edumazet@google.com>
Date: Sat, 17 Nov 2012 00:35:29 +0000
In-Reply-To: <20121113064026.GA27416@redhat.com>
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com>
	 <1351591403-23065-3-git-send-email-jasowang@redhat.com>
	 <87y5igyhyg.fsf@rustcorp.com.au> <20121113064026.GA27416@redhat.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 08:40 +0200, Michael S. Tsirkin wrote:
> On Mon, Nov 05, 2012 at 11:38:39AM +1030, Rusty Russell wrote:
> > > @@ -924,11 +1032,10 @@ static void virtnet_get_ringparam(struct net_device *dev,
> > >  {
> > >  	struct virtnet_info *vi = netdev_priv(dev);
> > >  
> > > -	ring->rx_max_pending = virtqueue_get_vring_size(vi->rvq);
> > > -	ring->tx_max_pending = virtqueue_get_vring_size(vi->svq);
> > > +	ring->rx_max_pending = virtqueue_get_vring_size(vi->rq[0].vq);
> > > +	ring->tx_max_pending = virtqueue_get_vring_size(vi->sq[0].vq);
> > >  	ring->rx_pending = ring->rx_max_pending;
> > >  	ring->tx_pending = ring->tx_max_pending;
> > > -
> > >  }
> > 
> > This assumes all vqs are the same size.  I think this should probably
> > check: for mq mode, use the first vq, otherewise use the 0th.
> 
> For rx_pending/tx_pending I think what is required here is the
> actual number of outstanding buffers.
> Dave, Eric - right?
> 
> So this should be the total over all rings and to be useful,
> rx_max_pending/tx_max_pending should be the total too.

So far as I know, all current implementations use the number of
descriptors per ring here. virtio_net should be consistent with this.

Ben.

> > For bonus points, check this assertion at probe time.
> 
> Looks like we can easily support different queues too.
> 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

