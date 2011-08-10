Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1HJSf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:35:26 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:44090 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1HJSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:35:25 -0400
Date: Wed, 10 Aug 2011 14:35:11 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110810183511.GA2443@flamenco.cs.columbia.edu>
References: <20110808091432.GA19570@flamenco.cs.columbia.edu>
 <4E3FABDA.8080204@ge.com>
 <20110808101140.GA21300@flamenco.cs.columbia.edu>
 <4E3FC33D.2080202@ge.com>
 <20110808172216.GA2311@flamenco.cs.columbia.edu>
 <4E40F719.1020100@ge.com>
 <20110809191915.GB28746@flamenco.cs.columbia.edu>
 <4E42359B.2050105@ge.com>
 <20110810091550.GA383@flamenco.cs.columbia.edu>
 <4E425483.2050400@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E425483.2050400@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:50:59 +0100, Martyn Welch wrote:
> Again, in pci-driver.c:
> 
> static int pci_device_probe(struct device * dev)
> {
>         int error = 0;
>         struct pci_driver *drv;
>         struct pci_dev *pci_dev;
> 
>         drv = to_pci_driver(dev->driver);
>         pci_dev = to_pci_dev(dev);
>         pci_dev_get(pci_dev);
>         error = __pci_device_probe(drv, pci_dev);
>         if (error)
>                 pci_dev_put(pci_dev);
> 
>         return error;
> }
> 
> Again, doing as Manohar suggested.

Well in fact I just realised our discussion has been completely
misdirected.

I read the original patch again, and it does something different
to what these _get_dev functions are doing. The patch increments
the refcount of the _bridge_; the get_dev() calls increment the
functions of the _device_ itself, not the bridge, which wouldn't
protect the device against the bridge being removed.

The closest thing I saw in the kernel was usb_get_intf(),
which is what I had in mind when I wrote the original patchset
back in the day:

http://lxr.free-electrons.com/ident?i=usb_get_intf

Sorry for overlooking this (and the subsequent noise), it's
been a while since then.

		Emilio
