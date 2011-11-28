Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1K1IlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:41:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1K1IlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:41:03 -0500
Date: Mon, 28 Nov 2011 10:41:51 +0200
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
Message-ID: <20111128084009.GB20084@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
 <20111123084640.GE22734@redhat.com>
 <87ty5uxso3.fsf@rustcorp.com.au>
 <20111124070728.GH29994@redhat.com>
 <87vcq5t69c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcq5t69c.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 11:25:43AM +1030, Rusty Russell wrote:
> > > But I'm *terrified* of making the spec more complex;
> > 
> > All you do is move stuff around. Why do you think it simplifies the spec
> > so much?
> 
> No, but it reduces the yuk factor.  Which has been important to adoption.

Sorry if I'm dense. Could you please clarify: do you think we can live
with the slightly higher yuk factor assuming the spec moves the
legacy mode into an appendix as you explain below and driver has a
single 'legacy' switch?

> And that's *not* all I do: reducing the number of options definitely
> simplifies the spec.  For example, the spec should currently say
> (looking at your implementation):
> 
>   Notifying the device
>   ====================
>   If you find a valid VIRTIO_PCI_CAP_NOTIFY_CFG capability, and you can
>   map 2 bytes within it, those two bytes should be used to notify the
>   device of new descriptors in its virtqueues, by writing the index of the
>   virtqueue to that mapping.
> 
>   If the capability is missing or malformed or you cannot map it, the
>   virtqueue index should be written to the VIRTIO_PCI_QUEUE_NOTIFY offset
>   of the legacy bar.
> 
> Vs:
> 
>   Notifying the device
>   ====================
>   The index of the virtqueue containing new descriptors should be written
>   to the location specified by the VIRTIO_PCI_CAP_NOTIFY_CFG capability.
>   (Unless the device is in legacy mode, see Appendix Y: Legacy Mode).

Yes, I agree, this is better.

...

> Look, I try to be more inclusive and polite than Linus, but at some
> point more verbiage is wasted.
> We will have single Legacy Mode switch.

Sorry, I'm adding more verbiage :( 
When you say a single Legacy Mode switch, you mean that the driver will
assume either legacy layout or the new one, correct?

> Accept it, or fork the standard.
>
> If you want to reuse the same structure, we're going to need to figure
> out how to specify the virtqueue address without a fixed alignment, and
> how to specify the alignment itself.

I think I see a way to do that in a relatively painless way.
Do you prefer seeing driver patches or spec? Or are you not interested
in reusing the same structure at all?

-- 
MST
