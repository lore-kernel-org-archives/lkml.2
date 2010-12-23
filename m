Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0LWQIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 11:08:39 -0500
Received: from netrider.rowland.org ([192.131.102.5]:35879 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753053Ab0LWQIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 11:08:37 -0500
Date: Thu, 23 Dec 2010 11:08:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Anoop P A <anoop.pa@gmail.com>
cc: Ralf Baechle <ralf@linux-mips.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Anatolij Gustschin <agust@denx.de>, Anand Gadiyar <gadiyar@ti.com>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Oliver Neukum <oneukum@suse.de>, Hans de Goede <hdegoede@redhat.com>,
        Paul Mortier <mortier@btinternet.com>, Andiry Xu <andiry.xu@amd.com>
Subject: Re: [PATCH V2 2/2] MSP onchip root hub over current quirk.
In-Reply-To: <1293096541.27661.46.camel@paanoop1-desktop>
Message-ID: <Pine.LNX.4.44L0.1012231104060.5617-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010, Anoop P A wrote:

> > > +				usb_detect_quirks(hdev);
> > 
> > This line is wrong.  usb_detect_quirks() gets called only once per 
> > device, when the device is initialized.  Besides, you probably want to 
> > use a hub-specific flag for this rather than a device-specific flag.
> 
> Can you point me to an example for the recommended way of doing the
> hack. I don't have much exposure to USB subsystem.

One example, suitable for PCI devices, can be found in 
drivers/usb/host/ehci-pci.c:ehci_pci_setup().

However the best approach would be for you to avoid adding any
special-purpose code at all.  Is it possible to handle
overcurrent-change events in a way that will work just as well for
normal hubs as for your MSP root hub?

Alan Stern

