Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935588Ab2KBTFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:05:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58125 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932260Ab2KBTFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:05:50 -0400
X-Sasl-enc: b89CxRrONKAg79nNiPPggi8/bOV9TbWFl3SwjeCSKz18 1351883149
Date: Fri, 2 Nov 2012 12:05:48 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: build failures after merge of the final tree (usb
 tree related)
Message-ID: <20121102190548.GA1607@kroah.com>
References: <20121102170459.5e152727a2a38797ee493da0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102170459.5e152727a2a38797ee493da0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 05:04:59PM +1100, Stephen Rothwell wrote:
> Hi ,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> In file included from drivers/usb/host/ehci-platform.c:28:0:
> drivers/usb/host/ehci.h: In function 'ehci_readl':
> drivers/usb/host/ehci.h:662:3: error: implicit declaration of function 'readl_be' [-Werror=implicit-function-declaration]
> drivers/usb/host/ehci.h:663:3: error: implicit declaration of function 'readl' [-Werror=implicit-function-declaration]
> drivers/usb/host/ehci.h: In function 'ehci_writel':
> drivers/usb/host/ehci.h:674:3: error: implicit declaration of function 'writel_be' [-Werror=implicit-function-declaration]
> drivers/usb/host/ehci.h:675:3: error: implicit declaration of function 'writel' [-Werror=implicit-function-declaration]
> 
> Caused by commit 99f91934a907 ("USB: EHCI: make ehci-platform a separate
> driver") from the usb tree.
> 
> I have reverted that commit for today.
> 
> I then got:
> 
> drivers/usb/chipidea/built-in.o: In function `ehci_init_driver':
> (.opd+0x5a0): multiple definition of `ehci_init_driver'
> drivers/usb/host/built-in.o:(.opd+0xb58): first defined here
> drivers/usb/chipidea/built-in.o: In function `.ehci_init_driver':
> (.text+0x6528): multiple definition of `.ehci_init_driver'
> drivers/usb/host/built-in.o:(.text+0x9eb4): first defined here
> drivers/usb/chipidea/built-in.o: In function `ehci_suspend':
> (.opd+0xc18): multiple definition of `ehci_suspend'
> drivers/usb/host/built-in.o:(.opd+0x11d0): first defined here
> drivers/usb/chipidea/built-in.o: In function `ehci_resume':
> (.opd+0x1020): multiple definition of `ehci_resume'
> drivers/usb/host/built-in.o:(.opd+0x1680): first defined here
> drivers/usb/chipidea/built-in.o: In function `.ehci_suspend':
> (.text+0x100e4): multiple definition of `.ehci_suspend'
> drivers/usb/host/built-in.o:(.text+0x13b00): first defined here
> drivers/usb/chipidea/built-in.o: In function `.ehci_resume':
> (.text+0x17760): multiple definition of `.ehci_resume'
> drivers/usb/host/built-in.o:(.text+0x1b498): first defined here
> drivers/usb/chipidea/built-in.o: In function `ehci_setup':
> (.opd+0x1128): multiple definition of `ehci_setup'
> drivers/usb/host/built-in.o:(.opd+0x17a0): first defined here
> drivers/usb/chipidea/built-in.o: In function `.ehci_setup':
> (.text+0x228f0): multiple definition of `.ehci_setup'
> drivers/usb/host/built-in.o:(.text+0x266fc): first defined here
> 
> Which is caused by commit 3e0232039967 ("USB: EHCI: prepare to make
> ehci-hcd a library module").
> 
> I have added the following patch to disable the chipidea driver for now:


Both of these should now be fixed in my tree.

thanks,

greg k-h
