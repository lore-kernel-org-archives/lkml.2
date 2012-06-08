Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab2FHOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:16:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab2FHOQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:16:57 -0400
Message-ID: <1339165009.26976.60.camel@ul30vt>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Alex Williamson <alex.williamson@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 08:16:49 -0600
In-Reply-To: <4FD1FB49.3020905@siemens.com>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com> <4FD1FB49.3020905@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 15:16 +0200, Jan Kiszka wrote:
> On 2012-06-08 15:03, Michael S. Tsirkin wrote:
> >> +    /* set master */
> >> +	pci_set_master(pdev);
> >> +
> >> +    /* set DMA mask */
> >> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> > 
> > uio currently only supports devices which do not
> > do DMA.
> > 
> > DMA from uio controlled devices is a no no unless
> > it's behind an IOMMU which can protect us from
> > random memory corruptions this could cause.
> > 
> > In the later case it's OK but we need some code
> > to check this and program the IOMMU appropriately.
> 
> AKA: VFIO. :)
> 
> Dominic, maybe you want to have a look at Alex's work:
> https://github.com/awilliam/linux-vfio

Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides secure
config space access, resource access, DMA mapping services, and full
interrupt support to userspace.  I'm currently working to get this
upstream, probably targeting 3.6 at this point, and would love to have
more users to help make that happen.  Please take a look at the vfio-3.4
branch in the tree above.  See this tree for Qemu's usage of VFIO for
device assignment:
https://github.com/awilliam/qemu-vfio (vfio-ng)

Look forward to your feedback.  Thanks,

Alex

