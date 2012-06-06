Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab2FFT6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab2FFT6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:58:19 -0400
Date: Wed, 6 Jun 2012 22:58:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
Message-ID: <20120606195814.GA20677@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
 <1338972341.2760.3944.camel@edumazet-glaptop>
 <20120606111357.GA15070@redhat.com>
 <1338988210.2760.4485.camel@edumazet-glaptop>
 <20120606144941.GA17092@redhat.com>
 <20120606081432.6b602065@nehalam.linuxnetplumber.net>
 <20120606185107.GA20503@redhat.com>
 <1339012441.26966.48.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339012441.26966.48.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 09:54:01PM +0200, Eric Dumazet wrote:
> On Wed, 2012-06-06 at 21:51 +0300, Michael S. Tsirkin wrote:
> 
> > BTW for cards that do implement the counters in software,
> > under xmit lock, is anything wrong with simply taking the xmit lock
> > when we get the stats instead of the per-cpu trick + seqlock?
> > 
> 
> I still dont understand why you would do that.
> 
> Most modern machines are 64bits, so there is no seqlock overhead,
> nothing at all.
> 
> If you focus on 32bit hardware, just stick on 32bit counters ?

These wrap around.

> Note that most u64_stats_sync users are virtual drivers, without xmit
> lock (LLTX drivers)
> 
> 

Absolutely, I am talking about virtio here.  I'm not kicking
u64_stats_sync idea I am just saying that simple locking
would work for virtio and might be better as it
gives us a way to get counters atomically.


-- 
MST
