Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2FFUYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:24:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39290 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab2FFUYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:24:22 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <20120606201620.GA23358@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
	 <1338988210.2760.4485.camel@edumazet-glaptop>
	 <20120606144941.GA17092@redhat.com>
	 <20120606081432.6b602065@nehalam.linuxnetplumber.net>
	 <20120606185107.GA20503@redhat.com>
	 <1339012441.26966.48.camel@edumazet-glaptop>
	 <20120606195814.GA20677@redhat.com>
	 <1339013289.26966.62.camel@edumazet-glaptop>
	 <20120606201620.GA23358@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 22:24:19 +0200
Message-ID: <1339014259.26966.70.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 23:16 +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 06, 2012 at 10:08:09PM +0200, Eric Dumazet wrote:
> > On Wed, 2012-06-06 at 22:58 +0300, Michael S. Tsirkin wrote:
> > 
> > > Absolutely, I am talking about virtio here.  I'm not kicking
> > > u64_stats_sync idea I am just saying that simple locking
> > > would work for virtio and might be better as it
> > > gives us a way to get counters atomically.
> > 
> > Which lock do you own in the RX path ?
> 
> We can just disable napi, everything is updated from napi callback.

This is very disruptive, and illegal from ndo_get_stats64()

(ndo_get_stats64() is not allowed to sleep, and I cant see how you are
going to disable napi without sleeping)



