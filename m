Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620Ab2DLAgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:36:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab2DLAgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:36:50 -0400
Date: Wed, 11 Apr 2012 17:36:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
Message-ID: <20120412003646.GA23447@kroah.com>
References: <20120411183457.GA19379@kroah.com>
 <4F85E217.8060406@kernel.dk>
 <4F85EAA3.7010807@micron.com>
 <20120411204041.GA14375@kroah.com>
 <4F860440.60808@micron.com>
 <20120411223718.GA24665@kroah.com>
 <4F86228F.50705@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F86228F.50705@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 05:32:15PM -0700, Asai Thambi S P wrote:
> On 4/11/2012 3:37 PM, Greg KH wrote:
> 
> > On Wed, Apr 11, 2012 at 03:22:56PM -0700, Asai Thambi S P wrote:
> >> On 4/11/2012 1:40 PM, Greg KH wrote:
> >>
> >>> On Wed, Apr 11, 2012 at 01:33:39PM -0700, Asai Thambi S P wrote:
> >>>> On 4/11/2012 12:57 PM, Jens Axboe wrote:
> >>>>
> >>>>> On 2012-04-11 20:34, Greg KH wrote:
> >>>>>> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
> >>>>>> depend on PCI.
> >>>>>
> >>>>> I think it's an old dependency. I've built and run it here without as
> >>>>> well, and no functional issues either.
> >>>>>
> >>>>> Sam/Asai?
> >>>>>
> >>>>
> >>>>
> >>>> Both driver and device will work fine without PCIe hotplug dependency. This
> >>>> dependency is required for supporting surprise removal and surprise insertion
> >>>> of the device on systems with PCIe hotplug controller.
> >>>
> >>> But that's not a driver-specific thing at all.  All PCI drivers need to
> >>> be able to handle this (I like how you constantly check the pci id,
> >>> that's cute.)
> >>>
> >>> So I think a basic dependancy on PCI should be fine here.
> >>
> >> The P320 is different from existing PCIe devices supporting surprise removal
> >> and surprise insertion (SRSI) capability (aka hotplug). We equate the hotplug
> >> functionality enabled by PCIe hotplug controllers to that of any other storage
> >> endpoint (SAS, SATA, FC, etc). For those devices, hotplug functionality is
> >> enabled by the transport layer and propagated up to host storage stack for
> >> handling.
> > 
> > Huh?  No, hotplug on Linux happens on the PCI level, and has done so for
> > over 10 years.
> 
> Just to clarify, I was referring to hotplug of SAS/SATA/FC storage devices,
> not HBA.

Ah, ok, yes, you are right, but as you aren't using the SCSI layer here
(odd, but ok), you can only handle hotplug at the PCI layer.

thanks,

greg k-h
