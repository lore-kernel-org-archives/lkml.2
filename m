Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2FZGBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:01:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab2FZGA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:00:59 -0400
Message-ID: <4FE95086.2020207@redhat.com>
Date: Tue, 26 Jun 2012 14:02:46 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Sridhar Samudrala <sri@us.ibm.com>
CC: krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        mst@redhat.com, netdev@vger.kernel.org, mashirle@us.ibm.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, akong@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org
Subject: Re: [net-next RFC V4 PATCH 0/4] Multiqueue virtio-net
References: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com> <4FE8A4B6.1080200@us.ibm.com>
In-Reply-To: <4FE8A4B6.1080200@us.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 01:49 AM, Sridhar Samudrala wrote:
> On 6/25/2012 2:16 AM, Jason Wang wrote:
>> Hello All:
>>
>> This series is an update version of multiqueue virtio-net driver 
>> based on
>> Krishna Kumar's work to let virtio-net use multiple rx/tx queues to 
>> do the
>> packets reception and transmission. Please review and comments.
>>
>> Test Environment:
>> - Intel(R) Xeon(R) CPU E5620 @ 2.40GHz, 8 cores 2 numa nodes
>> - Two directed connected 82599
>>
>> Test Summary:
>>
>> - Highlights: huge improvements on TCP_RR test
>> - Lowlights: regression on small packet transmission, higher cpu 
>> utilization
>>               than single queue, need further optimization
> Does this also scale with increased number of VMs?
>

Hi Sridhar:

Good suggestions, I didn't measure them. I would run test and post them.

Thanks

> Thanks
> Sridhar
>>
>> Analysis of the performance result:
>>
>> - I count the number of packets sending/receiving during the test, and
>>    multiqueue show much more ability in terms of packets per second.
>>
>> - For the tx regression, multiqueue send about 1-2 times of more packets
>>    compared to single queue, and the packets size were much smaller 
>> than single
>>    queue does. I suspect tcp does less batching in multiqueue, so I 
>> hack the
>>    tcp_write_xmit() to forece more batching, multiqueue works as well as
>>    singlequeue for both small transmission and throughput
>>
>> - I didn't pack the accelerate RFS with virtio-net in this sereis as 
>> it still
>>    need further shaping, for the one that interested in this please see:
>>    http://www.mail-archive.com/kvm@vger.kernel.org/msg64111.html
>>
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

