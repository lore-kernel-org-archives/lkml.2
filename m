Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1KPRPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:15:05 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:3520 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab1KPRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:15:00 -0500
Subject: Re: [PATCH net-next v5 07/10] forcedeth: implement
 ndo_get_stats64() API
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: David Decotigny <david.decotigny@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
In-Reply-To: <20111116085533.0982001e@s6510.linuxnetplumber.net>
References: <cover.1321420513.git.david.decotigny@google.com>
	 <dcc1ec263220b7bb1f7271933c30a8f89c19d991.1321420513.git.david.decotigny@google.com>
	 <20111116085533.0982001e@s6510.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 16 Nov 2011 17:14:54 +0000
Message-ID: <1321463694.2709.1.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18522.005
X-TM-AS-Result: No--14.068900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 16 Nov 2011 17:14:59.0718 (UTC) FILETIME=[454BFA60:01CCA483]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 08:55 -0800, Stephen Hemminger wrote:
> On Tue, 15 Nov 2011 21:15:55 -0800
> David Decotigny <david.decotigny@google.com> wrote:
> 
> > This commit implements the ndo_get_stats64() API for forcedeth. Since
> > these stats are being updated from different contexts (process and
> > timer), this commit adds protection (locking + atomic variables).
> > 
> > Tested:
> >   - 16-way SMP x86_64 ->
> >     RX bytes:7244556582 (7.2 GB)  TX bytes:181904254 (181.9 MB)
> >   - pktgen + loopback: identical rx_bytes/tx_bytes and rx_packets/tx_packets
> 
> Rather than adding additional locking why not use a percpu structure
> to hold statistics. See loopback, macvlan, veth, xen-netfront.

percpu is stupid for a single-queue driver.

> Or realize that the Tx side is single threaded by dev->xmit_lock already
> and the Rx side is single threaded by NAPI.

Right.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

