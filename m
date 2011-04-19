Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1DSWax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1DSWav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:30:51 -0400
Subject: Re: [PATCH] vfio: Add an ioctl to reset the device
From: Alex Williamson <alex.williamson@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: pugs@ieee.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        qemu-devel@nongnu.org, aafabbri@cisco.com, dwang2@cisco.com,
        benve@cisco.com
In-Reply-To: <20110419222626.GP12133@x200.localdomain>
References: <20110419203234.4254.94914.stgit@s20.home>
	 <20110419220743.GO12133@x200.localdomain> <1303251751.3110.129.camel@x201>
	 <20110419222626.GP12133@x200.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 16:30:37 -0600
Message-ID: <1303252237.3110.131.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 15:26 -0700, Chris Wright wrote:
> * Alex Williamson (alex.williamson@redhat.com) wrote:
> > On Tue, 2011-04-19 at 15:07 -0700, Chris Wright wrote:
> > > * Alex Williamson (alex.williamson@redhat.com) wrote:
> > > > When using VFIO to assign a device to a guest, we want to make sure
> > > > the device is quiesced on VM reset to stop all DMA within the guest
> > > > mapped memory.  Add an ioctl which just calls pci_reset_function()
> > > > and returns whether it succeeds.
> > > 
> > > Shouldn't there be a reset when binding/unbinding vfio to/from a pci
> > > device?
> > 
> > There's already one when the /dev/vfioX file is opened, we should add
> > another on release, and probably add the same PCI save state store/load
> > that I'm proposing for KVM across those.  Thanks,
> 
> Hmm, I looked and didn't see it, hence the question.

vfio_open() -> pci_reset_function()
https://github.com/pugs/vfio-linux-2.6/blob/vfio/drivers/vfio/vfio_main.c

