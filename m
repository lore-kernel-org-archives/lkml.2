Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2BWJNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:13:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:61873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab2BWJNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:13:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120443748"
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, clemens@ladisch.de, linux-kernel@vger.kernel.org
In-Reply-To: <1329986384.21053.165.camel@debian>
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
	 <1329728733-32419-2-git-send-email-alex.shi@intel.com>
	 <1329728733-32419-3-git-send-email-alex.shi@intel.com>
	 <20120223034147.GD27250@xanatos>  <1329986384.21053.165.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 17:11:47 +0800
Message-ID: <1329988307.21053.167.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> What do you mean: there is a relation between event rings
> msix_entries.vectors.  and we need to presents this relationships in the
> msix interrupt handler? 
> 
> So does the following mode you like?
> 
> request_irq(hcd->msix_entries[i].vector, msix_irq_handler, 0, "",
> hcd->ring_handler[i]);
> 
> Or another way to do it if we know which ring will handle the irq, like:

here, I mean let the driver remember this relationships. 
> 
> irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd)
> 
> 	switch (irq2ring(irq))
> 	case ring0: driver_handle_ring(ring0);
> 	case ring1: driver_handle_ring(ring1);
> 
> In fact, since there is no actual usage of multiple rings now, I have no
> much idea of the relationships. 
> 
> BTW, if it is possible do this change to another patch? 


