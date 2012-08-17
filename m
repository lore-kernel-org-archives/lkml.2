Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2HQVXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:23:32 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:53918 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2HQVXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:23:21 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 17:23:21 EDT
From: Romain Francoise <romain@orebokech.com>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: 3.6-rc2 Panic -- Network interrupt
Organization: orebokech dot com
References: <201208171820.q7HIKB34001961@clem.clem-digital.net>
Date: Fri, 17 Aug 2012 23:13:15 +0200
In-Reply-To: <201208171820.q7HIKB34001961@clem.clem-digital.net> (Pete
	Clements's message of "Fri, 17 Aug 2012 14:20:11 -0400 (EDT)")
Message-ID: <87pq6pb4t0.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Clements <clem@clem.clem-digital.net> writes:

> Fyi: 
>   Get below panic with 3.6-rc2 soon after boot (hand copy of screen).

> [<c11ec9b6>] ? tcp_v4_rcv+0x626/0x740
> [<C11ccecf>] ? ip_local_deliver_finish+0x6f/0x120
> [<c11cce60>] ? ip_rcv+0x2b0/0x2b0
> [<c11cc9c3>] ? ip_rcv_finish+0xe3/0x2d0
> [<c11ae0a8>] ? __netif_receive_skb+03a8/0x4a0
> [<c11ae20b>] ? process_backlog+0x6b/0x100
> [<c11ae4aa>] ? net_rx_action+07a/0x100
> [<c102769f>] ? __do_softirq+0x7f/0x120
> [<c1027620>] ? irq_enter+0x50/0x50
> <IRQ>
> [<c10274b5>] ? irq_exit+0x55/0x60
> [<c1003a23>] ? do_IRQ+0x43/0xa0
> [<c121cc29>] ? common_interrupt+0x29/0x30
> [<c1007f44>] ? default_idle+0x14/0x30
> [<c1006116>] ? cpu_idle+0x26/0x40
> [<c12d490a>] ? start_kernel+0x244/0x249
> [<c12d4545>] ? kernel_init+0x16e/0x16e
> Code: a9 ff ff e9 14 ff ff ff 90 8b 4a 48 83 e1 fe ff 41 40 89 48 78 8b 52 70 89
> 90 84 01 00 00 8b 51 58 85 d2 74 8c 8b 80 58 01 00 00 <8b> 52 14 89 50 68 c3 8d
> b4 26 00 00 00 00 83 ec 84 0f b6 50 0e
> EIP: [<d8886332>] inet6_sk_rx_dst_set+0x22/0x30 [ipv6] SS:ESP 0068:d7000dcc
> CR2:0000000000010016
> ---[ end trace 71149a645a111f5d ]---
> Kernel panic - not syncing: Fatal exception in interrupt

Maybe related to the IPv6 early demux patches? Adding Cc's.
