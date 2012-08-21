Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2HUTg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:36:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56545 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2HUTgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:36:54 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 21 Aug 2012 12:36:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: inux-next: Tree for Aug 21 (usb_speed_string)
Message-ID: <20120821193656.GA10864@roeck-us.net>
References: <20120821160403.6deca090a9a435d2b1e3d8ba@canb.auug.org.au>
 <5033CE2F.8000608@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5033CE2F.8000608@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 11:06:39AM -0700, Randy Dunlap wrote:
> On 08/20/2012 11:04 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20120820:
> > 
> 
> 
> on x86_64:
> 
> ERROR: "usb_speed_string" [drivers/usb/core/usbcore.ko] undefined!
> 
> 
> CONFIG_USB_SUPPORT is not enabled
> (but many other USB drivers are enabled).
> 

Caused by

config IR_TTUSBIR

which selects USB but does not have the necessary dependency on USB_ARCH_HAS_HCD.

Introduced by commit 0938069fa08970f1c898970c1331a029efe9a1ce "[media] rc: Add
support for the TechnoTrend USB IR Receiver".

Fixing this exposes

ERROR: "usb_kill_urb" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_set_interface" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_free_coherent" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_submit_urb" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_clear_halt" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_ifnum_to_if" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_alloc_coherent" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_free_urb" [drivers/media/usb/gspca/gspca_main.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/media/usb/gspca/gspca_main.ko] undefined!

which I think is due to CONFIG_USB_GSPCA=m, but I have no idea how that can be
enabled w/o USB support.

Guenter
