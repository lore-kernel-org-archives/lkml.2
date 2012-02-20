Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2BTA7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:59:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:52044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab2BTA7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:59:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="112172422"
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: Andiry Xu <andiry.xu@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, stern@rowland.harvard.edu,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Takashi Iwai <tiwai@suse.de>, trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
In-Reply-To: <4F3F4509.4070003@amd.com>
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
	 <4F311233.9070404@intel.com> <20120207144204.GA7214@kroah.com>
	 <20120207172743.GA4780@xanatos> <20120207221317.GA6103@xanatos>
	 <1328664392.12669.233.camel@debian> <1328682430.12669.443.camel@debian>
	 <1328692300.12669.593.camel@debian>  <20120214002030.GA10364@xanatos>
	 <1329359801.12669.2872.camel@debian> <1329461087.12669.2911.camel@debian>
	 <4F3E0C3D.4030307@ladisch.de> <1329468418.12669.2988.camel@debian>
	 <4F3E28D1.1030509@ladisch.de>  <4F3F4509.4070003@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 08:57:03 +0800
Message-ID: <1329699423.14084.9.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Assume that an XHCI controller has two rings, and that each one gets its
> > own MSI-X interrupt.  How should the driver decide which of the rings
> > needs to be handled?
> > 
> > irqreturn_t xhci_msix_irq(struct usb_hcd *hcd)
> > {
> > 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> > 
> > 	if (...)
> > 		handle(xhci->ring[0]);
> > 	else
> > 		handle(xhci->ring[1]);
> > }
> > 
> > I.e., what should go into the if()?
> > 
> > 
> 
> Currently xHCI driver only support one ERST event ring. If we need to
> support multiple event rings in the future, it's simple: in
> usb_hcd_request_msi_msix_irqs, change the last parameter of
> request_irq() to xhci->erst[i], and we can get the corresponding erst[i]
> in xhci_msi_irq() like this:
> 
> irqreturn_t xhci_msi_irq(int irq, void *dev_id)
> {
> 	struct xhci_erst *erst = dev_id;
> 	...
> 	/* Handle corresponding event ring pointed by erst */
> }
> 
> See Matthew Wilcox's patchset below for reference:
> 
> www.spinics.net/lists/linux-usb/msg47353.html

Oh. Thanks Andiry and Clemens! The problem really worth to have another
patchset for it. 

