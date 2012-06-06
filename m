Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2FFSvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab2FFSvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:51:12 -0400
Date: Wed, 6 Jun 2012 21:51:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
Message-ID: <20120606185107.GA20503@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
 <1338972341.2760.3944.camel@edumazet-glaptop>
 <20120606111357.GA15070@redhat.com>
 <1338988210.2760.4485.camel@edumazet-glaptop>
 <20120606144941.GA17092@redhat.com>
 <20120606081432.6b602065@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606081432.6b602065@nehalam.linuxnetplumber.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 08:14:32AM -0700, Stephen Hemminger wrote:
> On Wed, 6 Jun 2012 17:49:42 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Sounds good, but I have a question: this realies on counters
> > being atomic on 64 bit.
> > Would not it be better to always use a seqlock even on 64 bit?
> > This way counters would actually be correct and in sync.
> > As it is if we want e.g. average packet size,
> > we can not rely e.g. on it being bytes/packets.
> 
> This has not been a requirement on real physical devices; therefore
> the added overhead is not really justified.
> 
> Many network cards use counters in hardware to count packets/bytes
> and there is no expectation of atomic access there.

BTW for cards that do implement the counters in software,
under xmit lock, is anything wrong with simply taking the xmit lock
when we get the stats instead of the per-cpu trick + seqlock?

