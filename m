Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0CTNBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0CTNBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:01:47 -0400
Message-ID: <4BA4C734.3060907@redhat.com>
Date: Sat, 20 Mar 2010 15:01:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
       Alok Kataria <akataria@vmware.com>,
       Saileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/4] virtio-balloon: allow hypervisor refuse locking some
 pages
References: <20100319204628.4418.84674.stgit@localhost.localdomain> <20100319204647.4418.23072.stgit@localhost.localdomain>
In-Reply-To: <20100319204647.4418.23072.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 10:46 PM, Dmitry Torokhov wrote:
> Some hypervisors may refuse our request to lock pages in certain
> circumstances. For example, VMware may decide that the target balloon
> size decreased since it was last communicated to the guest and thus
> current page should not be locked.
>
>
>   static struct virtio_driver virtio_balloon_driver = {
> diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
> index a50ecd1..4baad1c 100644
> --- a/include/linux/virtio_balloon.h
> +++ b/include/linux/virtio_balloon.h
> @@ -6,12 +6,16 @@
>   #include<linux/virtio_config.h>
>
>   /* The feature bitmap for virtio balloon */
> -#define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
> -#define VIRTIO_BALLOON_F_STATS_VQ	1 /* Memory Stats virtqueue */
> +#define VIRTIO_BALLOON_F_MUST_TELL_HOST		0 /* Tell before reclaiming pages */
> +#define VIRTIO_BALLOON_F_STATS_VQ		1 /* Memory Stats virtqueue */
> +#define VIRTIO_BALLOON_F_HOST_MAY_REFUSE	2 /* Host may refuse some pages */
>
>   /* Size of a PFN in the balloon interface. */
>   #define VIRTIO_BALLOON_PFN_SHIFT 12
>
> +#define VIRTIO_BALLOON_PFN_OK		0
> +#define VIRTIO_BALLOON_PFN_FAIL		1
> +
>   struct virtio_balloon_config
>   {
>   	/* Number of pages host wants Guest to give up. */
>    

Please update the virtio pci spec (can't find the URL - Rusty?) to 
reflect the protocol change.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

