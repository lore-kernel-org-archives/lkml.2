Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2D2QO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:14:57 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:54085 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2D2QOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:14:55 -0400
Date: Sun, 29 Apr 2012 09:14:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.4-rc5
Message-ID: <20120429161451.GA16480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.4-rc5

for you to fetch changes up to 41c8a48aa8de88ff56ed2f657b93d2446dd7882c:

  Merge tag 'fixes-for-v3.4-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus (2012-04-27 07:50:34 -0700)

----------------------------------------------------------------

USB fixes for 3.4-rc5

Here are a number of small USB fixes for 3.4-rc5.

Nothing major, as before, some USB gadget fixes.  There's a crash fix
for a number of ASUS laptops on resume that had been reported by a
number of different people.  We think the fix might also pertain to
other machines, as this was a BIOS bug, and they seem to travel to
different models and manufacturers quite easily.  Other than that, some
other reported problems fixed as well.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (3):
      USB: gadget: storage gadgets send wrong error code for unknown commands
      USB: EHCI: fix crash during suspend on ASUS computers
      usb: gadget: udc-core: fix incompatibility with dummy-hcd

Felipe Balbi (3):
      usb: musb: drop __deprecated flag
      usb: gadget: dummy: do not call pullup() on udc_stop()
      usb: gadget: udc-core: fix wrong call order

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.4-rc5' of git://git.kernel.org/.../balbi/usb into usb-linus

Heiko Stübner (1):
      usb: otg: gpio_vbus: Add otg transceiver events and notifiers

Julia Lawall (1):
      usb: musb: davinci.c: add missing unregister

Laurent Pinchart (1):
      usb gadget: uvc: uvc_request_data::length field must be signed

Oliver Neukum (1):
      USB: cdc-wdm: fix race leading leading to memory corruption

 drivers/usb/class/cdc-wdm.c         |    7 +++++--
 drivers/usb/core/hcd-pci.c          |    9 +++++++++
 drivers/usb/gadget/dummy_hcd.c      |    1 -
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/file_storage.c   |    2 +-
 drivers/usb/gadget/udc-core.c       |    4 ++--
 drivers/usb/gadget/uvc.h            |    2 +-
 drivers/usb/gadget/uvc_v4l2.c       |    2 +-
 drivers/usb/host/ehci-pci.c         |    8 ++++++++
 drivers/usb/musb/davinci.c          |    3 ++-
 drivers/usb/musb/musb_core.h        |    2 +-
 drivers/usb/otg/gpio_vbus.c         |   15 ++++++++++++++-
 include/linux/usb/hcd.h             |    2 ++
 13 files changed, 47 insertions(+), 12 deletions(-)
