Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2JESFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:05:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57531 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754753Ab2JESFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:05:33 -0400
Date: Fri, 5 Oct 2012 14:05:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 09/16] USB: EHCI: mark ehci_orion_conf_mbus_windows
 __devinit
In-Reply-To: <1349448930-23976-10-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1210051405170.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012, Arnd Bergmann wrote:

> The __devinit section is going away soon, but while it's
> still there, we get a correct warning about
> ehci_orion_conf_mbus_windows being discarded before
> its caller, so it should be marked __devinit rather than
> __init.
> 
> Without this patch, building dove_defconfig results in:
> 
> WARNING: drivers/usb/host/built-in.o(.devinit.text+0x8a4): Section mismatch in reference from the function ehci_orion_drv_probe() to the function .init.text:ehci_orion_conf_mbus_windows()
> The function __devinit ehci_orion_drv_probe() references
> a function __init ehci_orion_conf_mbus_windows().
> If ehci_orion_conf_mbus_windows is only used by ehci_orion_drv_probe then
> annotate ehci_orion_conf_mbus_windows with a matching annotation.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org

Acked-by: Alan Stern <stern@rowland.harvard.edu>

