Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2KSGP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:15:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab2KSGP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:15:27 -0500
Message-ID: <50A9CF30.9090503@redhat.com>
Date: Mon, 19 Nov 2012 14:18:24 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        krkumar2@in.ibm.com, kvm@vger.kernel.org
Subject: Re: [rfc net-next v6 2/3] virtio_net: multiqueue support
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com> <1351591403-23065-3-git-send-email-jasowang@redhat.com> <874nl5yn4k.fsf@rustcorp.com.au>
In-Reply-To: <874nl5yn4k.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 07:16 AM, Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
>> This addes multiqueue support to virtio_net driver. There's two mode supported:
>> single queue pair mode and multiple queue pairs mode. An obvious
>> difference compared with a physical mq card is that virtio-net reserve
>> first two virtqueues when it is working in multiqueue mode, this is
>> used for implementing adaptive mode switching in the future. The
>> virtqueues that were in both mq and sq mode were initialized and only
>> one queue pair (single queue mode) were used at default. User could
>> use ethtool -L to switch to multiqueue mode withe the next patch.
> Hi Jason,
>
>          This first patch looks good, but conflates three things
> together:
> (1) Separate per-queue structures from struct virtnet_info to allow
>      multiple queues.  This is the mechanical part of the patch.
> (2) An annotation bugfix, see below.
> (3) Enabling mq using a new feature and negotiation.

Hi Rusty:

Sorry for the late response, just back from vacation.

For 1 and 3, I will split the patch as you suggested.
For 2, will fix it.

Thanks
>
>> @@ -700,7 +767,8 @@ static struct rtnl_link_stats64 *virtnet_stats(struct net_device *dev,
>>   	unsigned int start;
>>   
>>   	for_each_possible_cpu(cpu) {
>> -		struct virtnet_stats *stats = per_cpu_ptr(vi->stats, cpu);
>> +		struct virtnet_stats __percpu *stats
>> +			= per_cpu_ptr(vi->stats, cpu);
>>   		u64 tpackets, tbytes, rpackets, rbytes;
>>   
>>   		do {
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

