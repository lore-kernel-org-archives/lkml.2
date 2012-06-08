Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403Ab2FHRLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:11:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933890Ab2FHRLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:11:31 -0400
Message-ID: <1339175476.26976.102.camel@ul30vt>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Alex Williamson <alex.williamson@redhat.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 11:11:16 -0600
In-Reply-To: <20120608164426.GE9705@local>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com> <4FD1FB49.3020905@siemens.com>
	 <1339165009.26976.60.camel@ul30vt> <1339166867.3870.29.camel@blech>
	 <4FD22552.6090609@01019freenet.de> <20120608164426.GE9705@local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 18:44 +0200, Hans J. Koch wrote:
> On Fri, Jun 08, 2012 at 06:16:18PM +0200, Andreas Hartmann wrote:
> > Hi Dominic,
> > 
> > Dominic Eschweiler wrote:
> > > Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> > >> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> > >> secure config space access, resource access, DMA mapping services, and
> > >> full interrupt support to userspace.  
> 
> VFIO is not a "better UIO". It *requires* an IOMMU. Dominic didn't say on
> what CPU he's working, so it's not clear if he can use VFIO at all.
> 
> UIO is intended for general use with devices that have mappable registers
> and don't fit into any other subsystem. No more, no less.

VFIO is a secure UIO.  An IOMMU is required for any model that allows a
user to program DMA of a device, whether VFIO or something else.  As
Michael noted, if we allow UIO PCI to enable bus master, we open
ourselves up to a whole world of problems with a user suddenly having
access to and DMA'able memory in the system.  So really, add that the
device must only use PIO to your list of requirements for UIO, which
rules out any kind of high speed device.  Thanks,

Alex

