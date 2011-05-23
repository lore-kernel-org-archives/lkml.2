Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1EWOX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:23:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32957 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755441Ab1EWOXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:23:25 -0400
Date: Mon, 23 May 2011 10:22:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <00e401cc192a$2211bb50$663531f0$@org>
Message-ID: <Pine.LNX.4.44L0.1105231022060.2020-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Tanya Brokhman wrote:

> I ran some more tests with xhci and I think (or hope :) ) I figured this
> out:
> When connecting a gadget driver that is marked as SS device (the flag
> CONFIG_USB_GADGET_IS_SUPER_SPEED = true) to a SS port over SS cable - 
> the enumeration fails if that gadget driver doesn't provide SS descriptors. 
> BUT: if I connect the same device via HS cable to SS port - the enumeration
> is successful. I think that this is the case where xhci-ring handles the
> device over to the HS hcd :) (By the way, I think that in xhci the
> shared_hcd is SS and the main_hcd is HS)
> 
> In conclusion it seems to me that the device speed is determined by 2
> things:
> 1. the cable used
> 2. whether the device HW supports SS protocol. In our scenario it can since
> SS support is enabled in our udc. (We haven't released it yet.)
> So when a HS device is connected to a SS port, the xHCI checks it's speed
> and if necessary handles it over to the SS root hub. But this is done prior
> to the enumeration phase so if the device speed is SS but it has no SS
> descriptors - the enumeration will fail. The enumeration itself occurs not
> in xhci but in hub.c so the xhci isn't aware of the fact that it failed and
> doesn't handle this.
> 
> Since in dummy_hcd all of this is much simpler I think that the device speed
> should be determined by driver->speed and "which type of cable the
> connection was made over - SS or HS". The "cable type" is exactly what the
> module parameter is.
> 
> My familiarity with the Linux host isn't as good as I would like it to be
> (still working on that) so I might be wrong with my conclusions...

Your analysis is basically correct.

Alan Stern

