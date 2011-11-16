Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1KPQzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:55:38 -0500
Received: from mail.vyatta.com ([76.74.103.46]:41099 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab1KPQzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:55:36 -0500
Date: Wed, 16 Nov 2011 08:55:33 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Decotigny <david.decotigny@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Subject: Re: [PATCH net-next v5 07/10] forcedeth: implement
 ndo_get_stats64() API
Message-ID: <20111116085533.0982001e@s6510.linuxnetplumber.net>
In-Reply-To: <dcc1ec263220b7bb1f7271933c30a8f89c19d991.1321420513.git.david.decotigny@google.com>
References: <cover.1321420513.git.david.decotigny@google.com>
	<dcc1ec263220b7bb1f7271933c30a8f89c19d991.1321420513.git.david.decotigny@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 21:15:55 -0800
David Decotigny <david.decotigny@google.com> wrote:

> This commit implements the ndo_get_stats64() API for forcedeth. Since
> these stats are being updated from different contexts (process and
> timer), this commit adds protection (locking + atomic variables).
> 
> Tested:
>   - 16-way SMP x86_64 ->
>     RX bytes:7244556582 (7.2 GB)  TX bytes:181904254 (181.9 MB)
>   - pktgen + loopback: identical rx_bytes/tx_bytes and rx_packets/tx_packets

Rather than adding additional locking why not use a percpu structure
to hold statistics. See loopback, macvlan, veth, xen-netfront.

Or realize that the Tx side is single threaded by dev->xmit_lock already
and the Rx side is single threaded by NAPI.
