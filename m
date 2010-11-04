Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0KDOlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:41:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50059 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751991Ab0KDOlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:41:13 -0400
Date: Thu, 4 Nov 2010 10:41:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: pali.rohar@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] OHCI: Fix for regression in 2.6.37-rc1 since commit
 3df7169e7
In-Reply-To: <4CD20820.1070406@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.1011041039450.2522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010, Larry Finger wrote:

> On 11/03/2010 04:04 PM, Alan Stern wrote:
> > 
> > This patch is definitely wrong -- it defeats the entire purpose of 
> > rewriting the control register!  That write was added _specifically_ to 
> > put the controller into reset, i.e., to change the functional state.
> > 
> > Furthermore, the write does the same thing as ohci_hcd.c does in its
> > ohci_usb_reset() routine.  Regardless, ohci_run() does a complete host
> > controller reset, which should override anything done in pci-quirks.c.  
> > Perhaps _that_ routine needs some attention.
> 
> It is looking as if your patch is exposing a different bug. When I disable the
> write in pci_quirks leaving the controllers in OPER or RESUME mode, then
> ohci_run() is not called. I'm still trying to find out why.

Is your OHCI controller attached via PCI?  If it is, I don't see how 
ohci_pci_start() can avoid calling ohci_run().

Alan Stern

