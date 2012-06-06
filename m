Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2FFTyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:54:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54582 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2FFTyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:54:05 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <20120606185107.GA20503@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
	 <1338988210.2760.4485.camel@edumazet-glaptop>
	 <20120606144941.GA17092@redhat.com>
	 <20120606081432.6b602065@nehalam.linuxnetplumber.net>
	 <20120606185107.GA20503@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 21:54:01 +0200
Message-ID: <1339012441.26966.48.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 21:51 +0300, Michael S. Tsirkin wrote:

> BTW for cards that do implement the counters in software,
> under xmit lock, is anything wrong with simply taking the xmit lock
> when we get the stats instead of the per-cpu trick + seqlock?
> 

I still dont understand why you would do that.

Most modern machines are 64bits, so there is no seqlock overhead,
nothing at all.

If you focus on 32bit hardware, just stick on 32bit counters ?

Note that most u64_stats_sync users are virtual drivers, without xmit
lock (LLTX drivers)



