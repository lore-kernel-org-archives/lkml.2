Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0KYQGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:06:06 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40637 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752742Ab0KYQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:06:04 -0500
Date: Thu, 25 Nov 2010 11:06:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Nobody cared about IRQs at shutdown
In-Reply-To: <4CEE8604.4040506@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1011251056530.22247-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:

> Hello.
> 
> After switching my Gentoo desktop from sysvinit + openrc to systemd, I 
> started getting "nobody cared" messages about IRQs 16 and 19 (common 
> thing: they are assigned to the USB controllers, that's why CC: 

According to your listing, they are used by uhci-hcd.  Do the messages 
go away if you unload uhci-hcd before shutting down?

> linux-usb) at shutdown. Also, instead of shutting down immediately, the 
> kernel started waiting for something to time out (and after the timeout, 
> it does power off the computer). Adding the "irqpoll" parameter does 
> work around the issue. A screen photo illustrating the problem and the 
> kernel config are attached.
> 
> I didn't try to bisect because there is no known good kernel. I.e., the 
> issue doesn't exist without systemd, and I didn't run systemd with 
> earlier kernels.
> 
> Please help diagnosing and, if possible, fixing this problem.
> 
> The broken image at the top of the screen is from extlinux (I use it to 
> boot the kernel because I don't like grub).

You may need to debug the uhci-hcd driver.  Look into
drivers/usb/host/uhci-hcd.c; the uhci_shutdown() routine ought to be
called and it ought to call uhci_hc_died(), which in turn calls
uhci_reset_hc() in pci-quirks.c, which is supposed to prevent the
controller from generating any IRQs.

Do you have any USB devices attached to bus 3 or bus 6?

Alan Stern

