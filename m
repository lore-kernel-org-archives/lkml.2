Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958Ab2DKUkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:40:46 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43960 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab2DKUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:40:45 -0400
Date: Wed, 11 Apr 2012 13:40:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
Message-ID: <20120411204041.GA14375@kroah.com>
References: <20120411183457.GA19379@kroah.com>
 <4F85E217.8060406@kernel.dk>
 <4F85EAA3.7010807@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F85EAA3.7010807@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 01:33:39PM -0700, Asai Thambi S P wrote:
> On 4/11/2012 12:57 PM, Jens Axboe wrote:
> 
> > On 2012-04-11 20:34, Greg KH wrote:
> >> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
> >> depend on PCI.
> > 
> > I think it's an old dependency. I've built and run it here without as
> > well, and no functional issues either.
> > 
> > Sam/Asai?
> > 
> 
> 
> Both driver and device will work fine without PCIe hotplug dependency. This
> dependency is required for supporting surprise removal and surprise insertion
> of the device on systems with PCIe hotplug controller.

But that's not a driver-specific thing at all.  All PCI drivers need to
be able to handle this (I like how you constantly check the pci id,
that's cute.)

So I think a basic dependancy on PCI should be fine here.

thanks,

greg k-h
