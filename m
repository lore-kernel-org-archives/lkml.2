Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2HTUms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:42:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35460 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754172Ab2HTUmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:42:45 -0400
Date: Mon, 20 Aug 2012 16:42:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [PATCH] USB: Build usb_speed_string unconditionally
In-Reply-To: <20120820195808.GD4461@tassilo.jf.intel.com>
Message-ID: <Pine.LNX.4.44L0.1208201639050.1182-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Andi Kleen wrote:

> On Mon, Aug 20, 2012 at 03:47:48PM -0400, Alan Stern wrote:
> > On Mon, 20 Aug 2012, Andi Kleen wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > The usb core uses usb_speed_string(). But it's only selected
> > > for USB_GADGET. Enable it unconditionally.
> > 
> > What are you talking about?  USB_COMMON isn't selected at all, but it
> > does get built whenever USB or USB_GAGDET is enabled.  From
> > drivers/usb/Kconfig:
> 
> Just trying to fix my LTO randconfigs.
> 
> Here's a config that violated it on rc2.

Okay, I see the problem.  Your config has:

# CONFIG_USB_SUPPORT is not set
CONFIG_USB=m

That combination should not be possible, because in 
drivers/usb/Kconfig, the definition of USB is inside an "if 
USB_SUPPORT" block.

Runing "make oldconfig" shows that this happened because:

warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && IR_IGUANA && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD)

The culprit is DRM_USB, and I think Greg has just accepted a patch to 
fix it.

Alan Stern

