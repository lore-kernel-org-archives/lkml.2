Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2LCUID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:08:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40362 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2LCUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:08:01 -0500
Date: Mon, 03 Dec 2012 15:07:59 -0500 (EST)
Message-Id: <20121203.150759.585217844505239949.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, nhorman@tuxdriver.com, ramirose@gmail.com,
        davej@redhat.com, mtk.manpages@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] tun: only queue packets on device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121203200714.GA2183@redhat.com>
References: <20121203200714.GA2183@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 3 Dec 2012 22:07:14 +0200

> Historically tun supported two modes of operation:
> - in default mode, a small number of packets would get queued
>   at the device, the rest would be queued in qdisc
> - in one queue mode, all packets would get queued at the device
> 
> This might have made sense up to a point where we made the
> queue depth for both modes the same and set it to
> a huge value (500) so unless the consumer
> is stuck the chance of losing packets is small.
> 
> Thus in practice both modes behave the same, but the
> default mode has some problems:
> - if packets are never consumed, fragments are never orphaned
>   which cases a DOS for sender using zero copy transmit
> - overrun errors are hard to diagnose: fifo error is incremented
>   only once so you can not distinguish between
>   userspace that is stuck and a transient failure,
>   tcpdump on the device does not show any traffic
> 
> Userspace solves this simply by enabling IFF_ONE_QUEUE
> but there seems to be little point in not doing the
> right thing for everyone, by default.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks Michael.
