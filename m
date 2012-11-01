Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936027Ab2KAP2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:28:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49030 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935998Ab2KAP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:28:37 -0400
Date: Thu, 1 Nov 2012 11:28:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jan Beulich <JBeulich@suse.com>, Randy Dunlap <rdunlap@infradead.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 31 (ehci, dbgp)
In-Reply-To: <509199A5.1090109@infradead.org>
Message-ID: <Pine.LNX.4.44L0.1211011120230.1762-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Randy Dunlap wrote:

> On 10/30/2012 11:26 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20121030:
> > 
> 
> 
> on x86_64:
> 
> drivers/built-in.o: In function `ehci_reset':
> host.c:(.text+0x542a7e): undefined reference to `dbgp_reset_prep'
> host.c:(.text+0x542b75): undefined reference to `dbgp_external_startup'
> drivers/built-in.o: In function `ehci_bus_resume':
> host.c:(.text+0x544705): undefined reference to `dbgp_reset_prep'
> host.c:(.text+0x544731): undefined reference to `dbgp_external_startup'

Jan:

We all forgot about the chipidea driver.  It includes code from 
ehci-hcd in a rather unorthodox manner (see 
drivers/usb/chipidea/host.c).

Evidently we need to change your new test in
drivers/usb/early/ehci-dbgp.c to:

#if IS_ENABLED(CONFIG_USB_HCD_EHCI) || defined(CONFIG_USB_CHIPIDEA_HOST)

Upcoming changes to ehci-hcd will make this unnecessary in 3.8, but for 
now we need it.

Alan Stern

