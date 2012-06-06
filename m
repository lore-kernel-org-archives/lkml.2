Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2FFRNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:13:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46819 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2FFRNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:13:07 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20120606161715.GA17575@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
	 <1338988210.2760.4485.camel@edumazet-glaptop>
	 <20120606144941.GA17092@redhat.com>
	 <1338995944.26966.6.camel@edumazet-glaptop>
	 <20120606161715.GA17575@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 19:13:02 +0200
Message-ID: <1339002782.26966.22.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 19:17 +0300, Michael S. Tsirkin wrote:

> But why do you say at most 1 packet?
> 
> Consider get_stats doing:
>                u64_stats_update_begin(&stats->syncp);
>                stats->tx_bytes += skb->len;
> 
> on 64 bit at this point
> tx_packets might get incremented any number of times, no?
> 
>                 stats->tx_packets++;
>                 u64_stats_update_end(&stats->syncp);
> 
> now tx_bytes and tx_packets are out of sync by more than 1.

You lost me there.

No idea of what you are thinking about.

There is no atomicity guarantee in SNMP counters. (Ie fetching tx_bytes
and tx_packets in a transaction is not mandatory in any RFC)

As long as there is no cumulative error, its OK.



