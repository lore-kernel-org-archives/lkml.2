Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2GZIUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:20:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65096 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GZIUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:20:10 -0400
Message-ID: <5010FDB2.5040505@redhat.com>
Date: Thu, 26 Jul 2012 10:20:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Jason Wang <jasowang@redhat.com>, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, mashirle@us.ibm.com, kvm@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        sri@us.ibm.com
Subject: Re: [net-next RFC V5 2/5] virtio_ring: move queue_index to vring_virtqueue
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-3-git-send-email-jasowang@redhat.com> <1341488454.18786.15.camel@lappy>
In-Reply-To: <1341488454.18786.15.camel@lappy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/07/2012 13:40, Sasha Levin ha scritto:
> @@ -275,7 +274,7 @@ static void vm_del_vq(struct virtqueue *vq)
>         vring_del_virtqueue(vq);
>  
>         /* Select and deactivate the queue */
> -       writel(info->queue_index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
> +       writel(virtqueue_get_queue_index(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
>         writel(0, vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
>  

This accesses vq after vring_del_virtqueue has freed it.

Paolo

