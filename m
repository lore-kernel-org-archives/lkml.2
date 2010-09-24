Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0IXSLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:11:54 -0400
Received: from kroah.org ([198.145.64.141]:39109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0IXSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:11:53 -0400
Date: Fri, 24 Sep 2010 11:11:43 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for .36-rc
Message-ID: <20100924181143.GA14923@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some usb driver fixes for .36-rc

Most of these are pending musb driver patches that the developers have
been haggling out for a while, but are needed to solve some issues with
the .36 kernel and that driver.

The most important one is a fix for a much-reported oops in the HID
driver.  Turns out it was a very old bug in the USB core causing this
issue, which no one had ever hit as they had never called the USB core
in this manner.  It was caused by the BKL rework in the HID driver and
really is a USB core issue, not a HID one.  It has been tested by a lot
of people to resolve their issue.

And there's a documentation update, catching up on a change from the .35
kernel in the way autosuspend works.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees, with the
exception of the documentation update, which came into me today.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/Kconfig           |    6 +-
 drivers/usb/core/file.c            |   35 ++++++++---------
 drivers/usb/core/message.c         |    1 +
 drivers/usb/musb/cppi_dma.c        |    1 +
 drivers/usb/musb/musb_gadget.c     |   75 ++++++++++++++++++-----------------
 drivers/usb/musb/musb_gadget.h     |    2 +
 drivers/usb/musb/musb_gadget_ep0.c |    9 ++++
 drivers/usb/musb/musb_host.c       |    6 +++
 8 files changed, 77 insertions(+), 58 deletions(-)

---------------

Alan Stern (2):
      USB: fix bug in initialization of interface minor numbers
      USB: update Kconfig help text for CONFIG_USB_SUSPEND

Ming Lei (6):
      usb: musb: gadget: fix kernel panic if using out ep with FIFO_TXRX style
      usb: musb: gadget: fix bulk IN infinit hangs in double buffer case
      usb: musb: gadget: enable autoclear for OUT transfer in both DMA 0 and DMA 1
      usb: musb: gadget: fix DMA length for OUT transfer
      usb: musb: gadget: complete request only if data is transfered over
      usb: musb: gadget: fix dma length in txstate

Santosh Shilimkar (1):
      usb: musb: host: Issue a memory barrier before starting DMA

Sergei Shtylyov (1):
      usb: musb: gadget: restart request on clearing endpoint halt

