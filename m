Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab0F3SJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:09:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22716 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0F3SJc convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Jun 2010 14:09:32 -0400
Date: Wed, 30 Jun 2010 14:07:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>
Subject: Re: should struct device.dma_mask still be a pointer?
Message-ID: <20100630180704.GD16488@phenom.dumpdata.com>
References: <20100622105233.GA4755@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100622105233.GA4755@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C2B881C.00F8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 12:52:33PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> IMHO it's strange that struct device.dma_mask is a pointer instead of a
> plain u64.  The reason this was done back then is described in
> 8ab1bc19e974fdebe76c065fe444979c84ba2f74[1]:
> 
> 	Attached is a patch which moves dma_mask into struct device and cleans up the
> 	scsi mid-layer to use it (instead of using struct pci_dev).  The advantage to
> 	doing this is probably most apparent on non-pci bus architectures where
> 	currently you have to construct a fake pci_dev just so you can get the bounce
> 	buffers to work correctly.
> 
> 	The patch tries to perturb the minimum amount of code, so dma_mask in struct
> 	device is simply a pointer to the one in pci_dev.  However, it will make it
> 	easy for me now to add generic device to MCA without having to go the fake pci
> 	route.
> 
> As I work on such a non-pci bus architecture it's still ugly that this
> is a pointer because I have to allocate extra memory for that.
> 
> Is there a reason not to get rid of struct pci_dev.dma_mask and use
> struct pci_dev.dev.dma_mask instead?  (Well apart from the needed
> effort of course.)

Lets CC Fujita. He has been redoing some of the DMA API, and making the
PCI DMA API be used in favour of the old DMA API.

But from the sounds of it for your architecture you need a DMA API, not
a PCI DMA and you want to merge the dma_mask in one? Preferably in the
struct device one?
