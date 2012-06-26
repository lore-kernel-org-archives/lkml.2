Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab2FZF7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2FZF7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:59:05 -0400
Message-ID: <4FE95015.7000707@redhat.com>
Date: Tue, 26 Jun 2012 14:00:53 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: mst@redhat.com, akong@redhat.com, habanero@linux.vnet.ibm.com,
        tahm@linux.vnet.ibm.com, haixiao@juniper.net, jwhan@filewood.snu.ac.kr,
        ernesto.martin@viasat.com, mashirle@us.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krkumar2@in.ibm.com, shemminger@vyatta.com, edumazet@google.com
Subject: Re: [PATCH 5/6] tuntap: per queue 64 bit stats
References: <20120625060830.6765.27584.stgit@amd-6168-8-1.englab.nay.redhat.com>  <1340625563-9300-6-git-send-email-jasowang@redhat.com> <1340628765.10893.46.camel@edumazet-glaptop>
In-Reply-To: <1340628765.10893.46.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 08:52 PM, Eric Dumazet wrote:
> On Mon, 2012-06-25 at 19:59 +0800, Jason Wang wrote:
>> As we've added multiqueue support for tun/tap, this patch convert the statistics
>> to use per-queue 64 bit statistics.
> LLTX means you can have several cpus calling TX path in parallel.
>
> So tx stats are wrong (even before this patch), and racy after this
> patch (if several cpu access same queue, it seems to be possible)
>
>         u64_stats_update_begin(&tfile->stats.tx_syncp);
>         tfile->stats.tx_packets++;
>         tfile->stats.tx_bytes += total;
>         u64_stats_update_end(&tfile->stats.tx_syncp);
>
> This can break horribly if several cpus run this code using same 'tfile'
> pointer.

Yes, looks like it's hard to use NETIF_F_LLTX without breaking the u64 
statistics, may worth to use tx lock and alloc_netdev_mq().

> I suggest this patch comes before 'tuntap: multiqueue support' in the
> serie.

Sure, thanks.
>
>
>

