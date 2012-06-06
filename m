Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2FFUUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:20:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab2FFUTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:19:48 -0400
Date: Wed, 6 Jun 2012 23:19:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
Message-ID: <20120606201942.GA23405@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
 <1338972341.2760.3944.camel@edumazet-glaptop>
 <20120606111357.GA15070@redhat.com>
 <1338988210.2760.4485.camel@edumazet-glaptop>
 <20120606144941.GA17092@redhat.com>
 <1338995944.26966.6.camel@edumazet-glaptop>
 <20120606161715.GA17575@redhat.com>
 <1339002782.26966.22.camel@edumazet-glaptop>
 <20120606184351.GA20380@redhat.com>
 <1339013171.26966.60.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339013171.26966.60.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:06:11PM +0200, Eric Dumazet wrote:
> On Wed, 2012-06-06 at 21:43 +0300, Michael S. Tsirkin wrote:
> 
> > 1. We are trying to look at counters for purposes of tuning the device.
> > E.g. if ethtool reports packets and bytes, we'd like to calculate
> > average packet size by bytes/packets.
> > 
> > If both counters are read atomically the metric becomes more exact.
> > Not a must but nice to have.
> > 
> 
> metrics are exact right now.

Yes, but they are not synchronised between themselves.
E.g. you can in theory have a report where #of packets > #of bytes.

I know there's no guarantee they are synchronised
on an arbitrary device but if they are, without
slowing fast path, it's nice.
