Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1FKW6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 18:58:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49604 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1FKW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 18:58:17 -0400
Date: Sat, 11 Jun 2011 15:58:02 -0700 (PDT)
Message-Id: <20110611.155802.495936379311916892.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        kvm@vger.kernel.org, herbert@gondor.hengli.com.au
Subject: Re: [PATCH] virtio_net: introduce VIRTIO_NET_HDR_F_DATA_VALID
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110610112828.GA21037@redhat.com>
References: <1307703377-3798-1-git-send-email-jasowang@redhat.com>
	<20110610112828.GA21037@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 15:58:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 10 Jun 2011 14:28:28 +0300

> On Fri, Jun 10, 2011 at 06:56:17PM +0800, Jason Wang wrote:
>> There's no need for the guest to validate the checksum if it have been
>> validated by host nics. So this patch introduces a new flag -
>> VIRTIO_NET_HDR_F_DATA_VALID which is used to bypass the checksum
>> examing in guest. The backend (tap/macvtap) may set this flag when
>> met skbs with CHECKSUM_UNNECESSARY to save cpu utilization.
>> 
>> No feature negotiation is needed as old driver just ignore this flag.
> 
> This wasn't required by the spec, but maybe it should be.
> 
>> Iperf shows 12%-30% performance improvement for UDP traffic. For TCP,
>> when gro is on no difference as it produces skb with partial
>> checksum. But when gro is disabled, 20% or even higher improvement
>> could be measured by netperf.
>> 
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied to net-next-2.6
