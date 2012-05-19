Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab2ESOaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:30:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37959 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754624Ab2ESOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:30:01 -0400
Date: Sat, 19 May 2012 10:30:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        <devel@driverdev.osuosl.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH -next] usb: add usb.h stubs for CONFIG_USB not enabled
In-Reply-To: <4FB6FFBF.6000509@xenotime.net>
Message-ID: <Pine.LNX.4.44L0.1205191026400.1348-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Add stubs for some usb core functions when CONFIG_USB
> is not enabled.  This fixes these comedi build errors:
> 
> ERROR: "usb_deregister" [drivers/staging/comedi/comedi.ko] undefined!
> ERROR: "usb_register_driver" [drivers/staging/comedi/comedi.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
> I am only adding the stubs that are needed for comedi to build.
> I expect that more stubs will be needed as more build errors are
> found.  It seems to me that linux/usb.h might need more (major)
> moving of lines to support more stubs in the future.

This doesn't seem like the right thing to do.  If a driver needs to 
register with the USB core then that driver should depend on 
CONFIG_USB.

On the other hand, if the driver is capable of being built without USB 
support then it should use the necessary preprocessor tests to protect 
calls to any USB routines.

Alan Stern

