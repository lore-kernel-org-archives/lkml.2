Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2GQCAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:00:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62031 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2GQCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:00:38 -0400
Date: Mon, 16 Jul 2012 19:00:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/30] staging: comedi: add pci_dev pointer to
 comedi_device
Message-ID: <20120717020034.GA28771@kroah.com>
References: <201207111449.15203.hartleys@visionengravers.com>
 <20120717015201.GA10048@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AA915E16@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AA915E16@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 08:55:47PM -0500, H Hartley Sweeten wrote:
> On Monday, July 16, 2012 6:52 PM, Greg KH wrote:
> > On Wed, Jul 11, 2012 at 02:49:14PM -0700, H Hartley Sweeten wrote:
> >> The pci_dev pointer in the private driver data is used by every
> >> comedi pci driver. Some of them only have the need for the
> >> private data because of this pointer.
> >> 
> >> Introduce the pci_dev pointer in the comedi_device struct so it
> >> can be used instead of needing it in the private data.
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Ian Abbott <abbotti@mev.co.uk>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> ---
> >>  drivers/staging/comedi/comedidev.h | 2 ++
> >>  1 file changed, 2 insertions(+)
> >> 
> >> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> >> index de8c99c..55f2373 100644
> >> --- a/drivers/staging/comedi/comedidev.h
> >> +++ b/drivers/staging/comedi/comedidev.h
> >> @@ -212,6 +212,8 @@ struct comedi_device {
> >>  	 * DMA_NONE */
> >>  	struct device *hw_dev;
> >>  
> >> +	struct pci_dev *pcidev;
> >
> > No, the field above this, hw_dev, should be used instead here, as that's
> > what it is there for, right?
> 
> The hw_dev pointer is currently only used for something dealing with dma.
> I have not dug into it yet to see what exactly it's used for.  The comment
> says:
> 
> 	/* hw_dev is passed to dma_alloc_coherent when allocating async buffers
> 	 * for subdevices that have async_dma_dir set to something other than
> 	 * DMA_NONE */

Which is exactly what the pci device should be used for, it knows this
information :)

> > Care to rework this series with that change instead?
> 
> It could probably be used with some sort of container_of but I'm not sure.

Yes it can.

To set the field:

	hw_dev = &pci_dev->dev;

to get it back:
	pci_dev = container_of(hw_dev, struct pci_device, struct device);

I think.  That's off the top of my head, please try it out first.

And use a macro for the container_of stuff, that makes it easier to
understand.

thanks,

greg k-h
