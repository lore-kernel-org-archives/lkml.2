Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2LZQpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 11:45:10 -0500
Received: from netrider.rowland.org ([192.131.102.5]:42620 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753340Ab2LZQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 11:45:09 -0500
Date: Wed, 26 Dec 2012 11:45:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now
 get many "unable to enumerate USB device" messages
In-Reply-To: <50D9EB2E.9000105@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.1212261139060.15906-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Dec 2012, Larry Finger wrote:

> On 12/25/2012 10:26 AM, Alan Stern wrote:
> > On Mon, 24 Dec 2012, Larry Finger wrote:
> >
> >> The problem has been bisected to commit adfa79d entitled "USB: EHCI: make
> >> ehci-pci a separate driver". The symptom is that my NVIDIA controller again
> >> reverts to unended logging of messages of the form "hub 2-0:1.0: unable to
> >> enumerate USB device on port 5".
> >
> > A few more details would be helpful, such as the dmesg log (with
> > CONFIG_USB_DEBUG enabled).  As it is, I don't see how that commit could
> > cause this problem.  It should not have resulted in any changes in
> > behavior -- all it did was split up a driver that was one module into
> > two modules.
> >
> >> This behavior was previously fixed with commit c618759.
> >
> > That commit affected the ohci-hcd driver, whereas this one affects
> > ehci-hcd.  They can't possibly be related.
> 
> Alan,
> 
> You are the expert, but I am confident of my bisection. A kernel built from 
> commit 3e02320 does not have the problem, but commit adfa79d does.
> 
> The dmesg output with CONFIG_USB_DEBUG enabled is posted at
> http://susepaste.org/790689.

I see.  Do you happen to have CONFIG_USB_EHCI_HCD=y and
CONFIG_USB_EHCI_PCI=m in your .config?  If you do, try changing
EHCI_PCI to y.

Alan Stern

