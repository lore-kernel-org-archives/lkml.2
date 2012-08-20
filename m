Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2HTUtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:49:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62909 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2HTUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:49:49 -0400
Date: Mon, 20 Aug 2012 13:49:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Build usb_speed_string unconditionally
Message-ID: <20120820204944.GA19667@kroah.com>
References: <20120820195808.GD4461@tassilo.jf.intel.com>
 <Pine.LNX.4.44L0.1208201639050.1182-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1208201639050.1182-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 04:42:44PM -0400, Alan Stern wrote:
> On Mon, 20 Aug 2012, Andi Kleen wrote:
> 
> > On Mon, Aug 20, 2012 at 03:47:48PM -0400, Alan Stern wrote:
> > > On Mon, 20 Aug 2012, Andi Kleen wrote:
> > > 
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > The usb core uses usb_speed_string(). But it's only selected
> > > > for USB_GADGET. Enable it unconditionally.
> > > 
> > > What are you talking about?  USB_COMMON isn't selected at all, but it
> > > does get built whenever USB or USB_GAGDET is enabled.  From
> > > drivers/usb/Kconfig:
> > 
> > Just trying to fix my LTO randconfigs.
> > 
> > Here's a config that violated it on rc2.
> 
> Okay, I see the problem.  Your config has:
> 
> # CONFIG_USB_SUPPORT is not set
> CONFIG_USB=m
> 
> That combination should not be possible, because in 
> drivers/usb/Kconfig, the definition of USB is inside an "if 
> USB_SUPPORT" block.
> 
> Runing "make oldconfig" shows that this happened because:
> 
> warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && IR_IGUANA && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD)
> 
> The culprit is DRM_USB, and I think Greg has just accepted a patch to 
> fix it.

Yes, it's now in Linus's tree.

Andi, care to try this again with this .config on Linus's tree to see if
it all now works properly?

thanks,

greg k-h
