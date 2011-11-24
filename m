Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1KXGZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:25:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab1KXGZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:25:27 -0500
Date: Thu, 24 Nov 2011 08:24:41 +0200
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
Message-ID: <20111124062440.GG29994@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
 <20111123084640.GE22734@redhat.com>
 <87ty5uxso3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty5uxso3.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:06:44AM +1030, Rusty Russell wrote:
> > > +/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> > > +struct virtio_pci_common_cfg {
> > > +	/* About the whole device. */
> > > +	__u64 device_features;	/* read-only */
> > > +	__u64 guest_features;	/* read-write */
> > > +	__u64 queue_address;	/* read-write */
> > > +	__u16 msix_config;	/* read-write */
> > > +	__u8 device_status;	/* read-write */
> > > +	__u8 unused;
> > > +
> > > +	/* About a specific virtqueue. */
> > > +	__u16 queue_select;	/* read-write */
> > > +	__u16 queue_align;	/* read-write, power of 2. */
> > > +	__u16 queue_size;	/* read-write, power of 2. */
> > > +	__u16 queue_msix_vector;/* read-write */
> > > +};
> > 
> > Slightly confusing as the registers are in fact little endian ...
> 
> Good point, should mark them appropriately with __le16.  That makes it
> even clearer.
> 
> Thanks,
> Rusty.

Do we still require atomic access to fields in common cfg?
If yes it's a problem as some systems don't have 64 bit
addresses. If no, implementations might get harder.

-- 
MST
