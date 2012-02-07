Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2BGO4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:56:30 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33704 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab2BGO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:56:29 -0500
X-Sasl-enc: p9ZOAQ5VYnCAdGLzLQ815JiqtA1KhuMqDo8A3kywaKkT 1328626588
Date: Tue, 7 Feb 2012 06:42:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: sarah.a.sharp@linux.intel.com, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
Message-ID: <20120207144204.GA7214@kroah.com>
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
 <4F311233.9070404@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F311233.9070404@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 07:59:47PM +0800, Alex Shi wrote:
> On 02/06/2012 08:29 PM, Alex Shi wrote:
> 
> > MSI/MSIX is the favorite interrupt for PCIe device. PCIe usb HCD should
> > be used more and more in future, but current USB core still just wants
> > line IRQ, only XHCI usb driver enabled MSI/MSIX.
> > 
> > This patch enabled pci MSI/MSIX in usb core for HCD, and removed MSI/MSIX
> > setup code from XHCI since it becomes redundant now.
> > There 2 places need prepare to enable MSI/MSIX in usb driver.
> > 1, set HCD_MSI_FIRST in driver->flags to enable MSI/MSIX.
> > 2, prepare a get_msix_num() for specific drivers.
> > XHCI is a good example for this.
> > 
> > This patch bases on my "USB-try-MSI-before-legacy-irq-on-pci-xhci-HCD"
> > patch.
> 
> 
> Gregkh&Alan:
> 
> Do you need a full patch that include my recent MSI setup/bug fix
> patches? or just this one is ok?

I was thinking that Sarah would forward this on.  We need whatever
should be applied to the tree, as I do not have any pending patches from
you in my queue.

greg k-h
