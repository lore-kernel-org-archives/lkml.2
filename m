Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2BGR1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:27:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:25428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab2BGR1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:27:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="104978630"
Date: Tue, 7 Feb 2012 09:27:43 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>, stern@rowland.harvard.edu
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Takashi Iwai <tiwai@suse.de>,
        trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
Message-ID: <20120207172743.GA4780@xanatos>
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
 <4F311233.9070404@intel.com>
 <20120207144204.GA7214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207144204.GA7214@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 06:42:04AM -0800, Greg KH wrote:
> On Tue, Feb 07, 2012 at 07:59:47PM +0800, Alex Shi wrote:
> > On 02/06/2012 08:29 PM, Alex Shi wrote:
> > 
> > > MSI/MSIX is the favorite interrupt for PCIe device. PCIe usb HCD should
> > > be used more and more in future, but current USB core still just wants
> > > line IRQ, only XHCI usb driver enabled MSI/MSIX.
> > > 
> > > This patch enabled pci MSI/MSIX in usb core for HCD, and removed MSI/MSIX
> > > setup code from XHCI since it becomes redundant now.
> > > There 2 places need prepare to enable MSI/MSIX in usb driver.
> > > 1, set HCD_MSI_FIRST in driver->flags to enable MSI/MSIX.
> > > 2, prepare a get_msix_num() for specific drivers.
> > > XHCI is a good example for this.
> > > 
> > > This patch bases on my "USB-try-MSI-before-legacy-irq-on-pci-xhci-HCD"
> > > patch.
> > 
> > 
> > Gregkh&Alan:
> > 
> > Do you need a full patch that include my recent MSI setup/bug fix
> > patches? or just this one is ok?
> 
> I was thinking that Sarah would forward this on.  We need whatever
> should be applied to the tree, as I do not have any pending patches from
> you in my queue.

I'm trying to track down an oops on my for-usb-linus queue that could
either be related to Alex's original MSI work around patch, or the patch
Oliver posted for working around PCI MMIO not being enabled fast enough.
I don't want to review this MSI improvement patch until I'm sure the
original MSI work around patch is stable.

Alex, please give me time to debug bug fixes for 3.3 before pushing on
features for 3.4.

Sarah Sharp
