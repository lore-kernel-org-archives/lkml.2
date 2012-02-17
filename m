Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2BQKND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:13:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52242 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab2BQKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:13:00 -0500
X-Sasl-enc: 9IdMbg4vt9by5anjo7LNUK8+3OzTEPzK1aw1iWX1x2S1 1329473579
Message-ID: <4F3E28D1.1030509@ladisch.de>
Date: Fri, 17 Feb 2012 11:15:45 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Alex,Shi" <alex.shi@intel.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, stern@rowland.harvard.edu,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Takashi Iwai <tiwai@suse.de>,
        trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>  <4F311233.9070404@intel.com> <20120207144204.GA7214@kroah.com>  <20120207172743.GA4780@xanatos> <20120207221317.GA6103@xanatos>  <1328664392.12669.233.camel@debian> <1328682430.12669.443.camel@debian>  <1328692300.12669.593.camel@debian>  <20120214002030.GA10364@xanatos>  <1329359801.12669.2872.camel@debian> <1329461087.12669.2911.camel@debian>  <4F3E0C3D.4030307@ladisch.de> <1329468418.12669.2988.camel@debian>
In-Reply-To: <1329468418.12669.2988.camel@debian>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,Shi wrote:
>> The controller driver will need to know which of the multiple MSI-X
>> interrupts has been raised:
>>
>> irqreturn_t (*msix_irq)(struct usb_hcd *hcd, unsigned int nr_or_index);
>
> Actually, hcd has 2 object for msix, msix_count and msix_entries.
>
> Do you mean msix_count maybe smaller than we decide in hcd_setup_msix()?

No.  But when msic_count > 1, we have multiple interrupts.

> Which situation will make this?

Assume that an XHCI controller has two rings, and that each one gets its
own MSI-X interrupt.  How should the driver decide which of the rings
needs to be handled?

irqreturn_t xhci_msix_irq(struct usb_hcd *hcd)
{
	struct xhci_hcd *xhci = hcd_to_xhci(hcd);

	if (...)
		handle(xhci->ring[0]);
	else
		handle(xhci->ring[1]);
}

I.e., what should go into the if()?


Regards,
Clemens
