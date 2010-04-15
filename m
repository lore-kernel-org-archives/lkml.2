Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0DOBuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:50:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53356 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755844Ab0DOBux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:50:53 -0400
Date: Wed, 14 Apr 2010 21:50:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pedro Ribeiro <pedrib@gmail.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Chris Wright <chrisw@sous-sol.org>,
       USB list <linux-usb@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <iommu@lists.linux-foundation.org>, Andi Kleen <andi@firstfloor.org>,
       Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <y2z74fd948d1004141412z1bb8424ekae627356bd8cc408@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004142147050.8765-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Pedro Ribeiro wrote:

> On 14 April 2010 22:01, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Wed, Apr 14, 2010 at 04:29:22PM -0400, Alan Stern wrote:
> >> On Wed, 14 Apr 2010, Chris Wright wrote:
> >>
> >> > So dma_map_single is the case that's failing, but you think the mask is
> >> > correct?  What about the direction?
> >>
> >> The mask and direction are unquestionably correct.  The mask is set up
> >> by pci_setup_device() and not changed thereafter.  Furthermore, the
> >> audio works okay until another device (a DVB tuner) is plugged in.
> >
> > Could the driver for the DVB tuner change the PCI mask? That is, change
> > the pci mask way after it has been initialized (don't laugh, this did
> > happend - as I remember 4 months fix was posted on the DRM mailing list
> > for this).
> >
> 
> I can also trigger the bug on mount and unmount of a USB stick, albeit
> its not as intensive.

In addition, it's worth pointing out that the DVB tuner is another USB 
device, not a PCI device.  Hence it doesn't have a PCI driver, and it 
seems most unlikely that its driver would modify the DMA mask of a 
different device.

Alan Stern

