Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab1KWIts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:49:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1KWItq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:49:46 -0500
Date: Wed, 23 Nov 2011 10:49:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111123084932.GF22734@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hb1v1scp.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 01:02:22PM +1030, Rusty Russell wrote:
> +/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> +struct virtio_pci_common_cfg {
> +	/* About the whole device. */
> +	__u64 device_features;	/* read-only */
> +	__u64 guest_features;	/* read-write */

We currently require atomic accesses to common fields.
Some architectures might not have such for 64 bit,
so these need to be split I think ...

> +	__u64 queue_address;	/* read-write */
> +	__u16 msix_config;	/* read-write */
> +	__u8 device_status;	/* read-write */
> +	__u8 unused;
> +
> +	/* About a specific virtqueue. */
> +	__u16 queue_select;	/* read-write */
> +	__u16 queue_align;	/* read-write, power of 2. */
> +	__u16 queue_size;	/* read-write, power of 2. */
> +	__u16 queue_msix_vector;/* read-write */
> +};
>  #endif
> 
> 
