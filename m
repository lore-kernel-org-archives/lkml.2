Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab2FFUfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:35:10 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:38596 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756849Ab2FFUfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:35:08 -0400
Message-ID: <1339014904.2836.56.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, <netdev@vger.kernel.org>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
Date: Wed, 6 Jun 2012 21:35:04 +0100
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
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18950.005
X-TM-AS-Result: No--15.588800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
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

Seriously, though: don't do that; this is going to hurt performance for
minimal benefit.

Ben.

> > You'll have to add a lock in fast path. This sounds really a bad choice
> > to me.
> 
> .ndo_get_stats64 is not data path though, is it?
> 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

