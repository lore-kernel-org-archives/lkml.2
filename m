Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1KWJkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:40:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54128 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1KWJkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:40:53 -0500
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
In-Reply-To: <20111123084932.GF22734@redhat.com>
References: <20111122183621.GA5235@redhat.com>
	 <87hb1v1scp.fsf@rustcorp.com.au>  <20111123084932.GF22734@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 23 Nov 2011 11:38:40 +0200
Message-ID: <1322041120.3581.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 10:49 +0200, Michael S. Tsirkin wrote:
> On Wed, Nov 23, 2011 at 01:02:22PM +1030, Rusty Russell wrote:
> > +/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> > +struct virtio_pci_common_cfg {
> > +	/* About the whole device. */
> > +	__u64 device_features;	/* read-only */
> > +	__u64 guest_features;	/* read-write */
> 
> We currently require atomic accesses to common fields.
> Some architectures might not have such for 64 bit,
> so these need to be split I think ...

We can consider stealing the feature implementation from virtio-mmio:
Use the first 32 bits as a selector and the last as the features
themselves.

It's more complex to work with, but it provides 2**32 32 feature bits
(which should be enough for a while) and it solves the atomic access
issue.

> > +	__u64 queue_address;	/* read-write */
> > +	__u16 msix_config;	/* read-write */
> > +	__u8 device_status;	/* read-write */
> > +	__u8 unused;
> > +
> > +	/* About a specific virtqueue. */
> > +	__u16 queue_select;	/* read-write */
> > +	__u16 queue_align;	/* read-write, power of 2. */
> > +	__u16 queue_size;	/* read-write, power of 2. */
> > +	__u16 queue_msix_vector;/* read-write */
> > +};
> >  #endif
> > 
> > 

-- 

Sasha.

