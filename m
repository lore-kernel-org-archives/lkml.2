Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab1ELOpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:45:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36744 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754158Ab1ELOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:45:43 -0400
Date: Thu, 12 May 2011 10:45:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <balbi@ti.com>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 7/7] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <000b01cc1064$3b7e51d0$b27af570$@org>
Message-ID: <Pine.LNX.4.44L0.1105121040190.1917-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Tanya Brokhman wrote:

> > >+	retval = usb_add_hcd(hs_hcd, 0, IRQF_DISABLED | IRQF_SHARED);
> > Why IRQF_DISABLED | IRQF_SHARED? you don't interrupts at all.
> 
> I used xhci as reference for this patch. This is the way xhci driver adds
> the hcds. You can find it in xhci_pci_probe(). 
> I'm not very familiar with how this two hcds (main and shared shcd) will
> work together so I thought these flags are needed for their co-operation. 
> Was my assumption mistaken? What flags should I use? 

You don't need any flags at all, because dummy-hcd does not handle any 
hardware interrupts.

> Also, Sergei pointed out that IRQF_DISABLED is deprecated so it seems to me
> that xhci needs an update as well....

Plus every other source file that uses IRQF_DISABLED...

Alan Stern

