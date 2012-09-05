Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab2IEOnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:43:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45908 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2IEOnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:43:53 -0400
Date: Wed, 5 Sep 2012 10:33:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Panella <stefano.panella@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/1] XEN: Use correct masking in
 xen_swiotlb_alloc_coherent.
Message-ID: <20120905143318.GA6908@phenom.dumpdata.com>
References: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com>
 <5040B249.4000306@citrix.com>
 <20120831164010.GA18929@localhost.localdomain>
 <50460B2E.3020200@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50460B2E.3020200@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:07:42PM +0100, Stefano Panella wrote:
> On 08/31/2012 05:40 PM, Konrad Rzeszutek Wilk wrote:
> >On Fri, Aug 31, 2012 at 01:47:05PM +0100, David Vrabel wrote:
> >>On 31/08/12 10:57, Stefano Panella wrote:
> >>>When running 32-bit pvops-dom0 and a driver tries to allocate a coherent
> >>>DMA-memory the xen swiotlb-implementation returned memory beyond 4GB.
> >>>
> >>>This caused for example not working sound on a system with 4 GB and a 64-bit
> >>>compatible sound-card with sets the DMA-mask to 64bit.
> >>>
> >>>On bare-metal and the forward-ported xen-dom0 patches from OpenSuse a coherent
> >>>DMA-memory is always allocated inside the 32-bit address-range by calling
> >>>dma_alloc_coherent_mask.
> >>We should have the same behaviour under Xen as bare metal so:
> >>
> >>Acked-By: David Vrabel <david.vrabel@citrix.com>
> >>
> >>This does limit the DMA mask to 32-bits by passing it through an
> >>unsigned long, which seems a bit sneaky...
> >so is the issue that we are not casting it from 'u64' to 'u32'
> >(unsigned long) on 32-bit?
> 
> Yes. I do not completely understand why but I think on 32-bit kernel we need to cast dma_mask to u32. This is done automatically using dma_alloc_coherent_mask()

OK, patch applied. I altered the git commit description a bit and
changed the author to  Ronny Hegewald <ronny.hegewald@online.de>.

Also added it on stable@vger.kernel.org

Thanks for tracking this down.
