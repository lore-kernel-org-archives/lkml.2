Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab2FFUGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:06:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64367 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab2FFUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:06:14 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20120606184351.GA20380@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
	 <1338988210.2760.4485.camel@edumazet-glaptop>
	 <20120606144941.GA17092@redhat.com>
	 <1338995944.26966.6.camel@edumazet-glaptop>
	 <20120606161715.GA17575@redhat.com>
	 <1339002782.26966.22.camel@edumazet-glaptop>
	 <20120606184351.GA20380@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 22:06:11 +0200
Message-ID: <1339013171.26966.60.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 21:43 +0300, Michael S. Tsirkin wrote:

> 1. We are trying to look at counters for purposes of tuning the device.
> E.g. if ethtool reports packets and bytes, we'd like to calculate
> average packet size by bytes/packets.
> 
> If both counters are read atomically the metric becomes more exact.
> Not a must but nice to have.
> 

metrics are exact right now.

As soon as you read a value, it might already have changed.

Maybe you want to stop_machine() to make sure all the metrics you want
are 'exact' ;)

> 2. 32 bit systems have some overhead because of the seqlock.
> virtio could instead simply keep tx counters in the queue structure, and
> get the tx lock when they are read.
> 

But then you need atomic64 stuff, have you an idea of the cost of such
primitives on 32bit ?

3. use 32bit counters on 32bit arches, as many drivers still do ?



