Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2KAUjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:39:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49314 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750825Ab2KAUjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:39:11 -0400
Date: Thu, 1 Nov 2012 16:39:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jan Beulich <jbeulich@suse.com>
cc: rdunlap@infradead.org, <sfr@canb.auug.org.au>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 31 (ehci, dbgp)
In-Reply-To: <5092D1AC020000780008EB60@nat28.tlf.novell.com>
Message-ID: <Pine.LNX.4.44L0.1211011636410.1762-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Jan Beulich wrote:

> >>> Alan Stern <stern@rowland.harvard.edu> 11/01/12 4:28 PM >>>
> >On Wed, 31 Oct 2012, Randy Dunlap wrote:
> >> on x86_64:
> >> 
> >> drivers/built-in.o: In function `ehci_reset':
> >> host.c:(.text+0x542a7e): undefined reference to `dbgp_reset_prep'
> >> host.c:(.text+0x542b75): undefined reference to `dbgp_external_startup'
> >> drivers/built-in.o: In function `ehci_bus_resume':
> >> host.c:(.text+0x544705): undefined reference to `dbgp_reset_prep'
> >> host.c:(.text+0x544731): undefined reference to `dbgp_external_startup'
> >
> >We all forgot about the chipidea driver.  It includes code from 
> 
> I didn't even know of this.
> 
> >ehci-hcd in a rather unorthodox manner (see 
> >drivers/usb/chipidea/host.c).
> >
> >Evidently we need to change your new test in
> >drivers/usb/early/ehci-dbgp.c to:
> >
> >#if IS_ENABLED(CONFIG_USB_HCD_EHCI) || defined(CONFIG_USB_CHIPIDEA_HOST)
> >
> >Upcoming changes to ehci-hcd will make this unnecessary in 3.8, but for 
> >now we need it.
> 
> Which tells me that the CONFIG_USB_SUPPORT version would have been
> the better one  (and I would favor that over the ugly variant you suggest
> above).

I also suggested IS_ENABLED(CONFIG_USB), which is no uglier than what 
you submitted and would also fix this build error.  How about using it 
instead?

Alan Stern

