Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2G3D2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 23:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2G3D2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 23:28:13 -0400
Message-ID: <5015FFDE.5030007@redhat.com>
Date: Mon, 30 Jul 2012 11:30:38 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, mashirle@us.ibm.com, kvm@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        sri@us.ibm.com
Subject: Re: [net-next RFC V5 2/5] virtio_ring: move queue_index to vring_virtqueue
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-3-git-send-email-jasowang@redhat.com> <1341488454.18786.15.camel@lappy> <5010FDB2.5040505@redhat.com>
In-Reply-To: <5010FDB2.5040505@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 04:20 PM, Paolo Bonzini wrote:
> Il 05/07/2012 13:40, Sasha Levin ha scritto:
>> @@ -275,7 +274,7 @@ static void vm_del_vq(struct virtqueue *vq)
>>          vring_del_virtqueue(vq);
>>
>>          /* Select and deactivate the queue */
>> -       writel(info->queue_index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
>> +       writel(virtqueue_get_queue_index(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
>>          writel(0, vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
>>
> This accesses vq after vring_del_virtqueue has freed it.
>
> Paolo
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Yes, so need a temporary variable before vring_del_virtqueue().

Thanks.
