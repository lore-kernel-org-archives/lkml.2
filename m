Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2K0Gpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:45:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981Ab2K0Gpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:30 -0500
Message-ID: <50B46179.4040809@redhat.com>
Date: Tue, 27 Nov 2012 14:45:13 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: rusty@rustcorp.com.au, mst@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [net-next RFC] pktgen: don't wait for the device who doesn't
 free skb immediately after sent
References: <1353916612-6357-1-git-send-email-jasowang@redhat.com> <20121126093728.0a10f97f@nehalam.linuxnetplumber.net>
In-Reply-To: <20121126093728.0a10f97f@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 01:37 AM, Stephen Hemminger wrote:
> On Mon, 26 Nov 2012 15:56:52 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> Some deivces do not free the old tx skbs immediately after it has been sent
>> (usually in tx interrupt). One such example is virtio-net which optimizes for
>> virt and only free the possible old tx skbs during the next packet sending. This
>> would lead the pktgen to wait forever in the refcount of the skb if no other
>> pakcet will be sent afterwards.
>>
>> Solving this issue by introducing a new flag IFF_TX_SKB_FREE_DELAY which could
>> notify the pktgen that the device does not free skb immediately after it has
>> been sent and let it not to wait for the refcount to be one.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Another alternative would be using skb_orphan() and skb->destructor.
> There are other cases where skb's are not freed right away.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Stephen:

Do you mean registering a skb->destructor for pktgen then set and check 
bits in skb->tx_flag?
