Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2EJOpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:45:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57376 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756518Ab2EJOpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:45:51 -0400
Date: Thu, 10 May 2012 10:45:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: Peter Chen <peter.chen@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
In-Reply-To: <20120510123754.6a6d95b9@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1205101041350.1831-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012, NeilBrown wrote:

>  Maybe we need to not suspend the USB OTG interface when the device as a
>  whole enters suspend-to-RAM.  Maybe we need to register a dummy gadget to
>  the bus active while in suspend?
>  Does the gadget have to be responsive while-ever the bus is not suspended?

Yes.

>  Maybe we can arrange for any USB activity to trigger a resume?

Probably not, at least, not fast enough.  The gadget is required to 
respond to USB packets within a few microseconds.  At a minimum, the 
USB device controller would have to remain fully powered.

>  Entering suspend while still charging really should be possible - at least
>  with a dump charger and hopefully from a host port as well.  I'll like to
>  find the best way to achieve that, and any help you can provide would be
>  greatly appreciated.

If the gadget is attached to a dumb charger rather than a host then 
there's no problem.  But otherwise it's not so simple.

Have you read the USB charger class specification?  (I haven't...)

Alan Stern

