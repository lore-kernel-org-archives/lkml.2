Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2BVUx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:53:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab2BVUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:53:57 -0500
Date: Wed, 22 Feb 2012 12:53:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.3-rc4
Message-ID: <20120222205337.GA4085@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fe250923bbbbcbccc9aa7b84d05ee7a060450534:

  Merge tag 'usb-3.3-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2012-02-09 13:50:54 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ usb-3.3-rc4

for you to fetch changes up to c6c1e4491dc8d1ed2509fa6aacffa7f34614fc38:

  USB: Added Kamstrup VID/PIDs to cp210x serial driver. (2012-02-21 16:29:15 -0800)

----------------------------------------------------------------
USB bugfixes for 3.3-rc4

A number of new device ids, and a cleanup/fix for some of the option
device ids that shouldn't have been added in the first place.

There's also a few USB 3 fixes for problems that people have reported,
and a usb-storage bugfix to round it out.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      usb-storage: fix freezing of the scanning thread

Andrew Lunn (1):
      USB: Serial: ti_usb_3410_5052: Add Abbot Diabetes Care cable id

Bruno Thomsen (1):
      USB: Added Kamstrup VID/PIDs to cp210x serial driver.

Elric Fu (1):
      USB: Set hub depth after USB3 hub reset

Greg Kroah-Hartman (3):
      Merge tag 'for-usb-linus-2012-02-10' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'for-usb-linus-2012-02-14' of git://git.kernel.org/.../sarah/xhci into usb-linus
      Merge tag 'for-usb-linus-2012-02-21' of git://git.kernel.org/.../sarah/xhci into usb-linus

Sarah Sharp (5):
      USB: Remove duplicate USB 3.0 hub feature #defines.
      xhci: Fix oops caused by more USB2 ports than USB3 ports.
      USB: Don't fail USB3 probe on missing legacy PCI IRQ.
      USB: Fix handoff when BIOS disables host PCI device.
      xhci: Fix encoding for HS bulk/control NAK rate.

li.rui27@zte.com.cn (1):
      USB: option: cleanup zte 3g-dongle's pid in option.c

 drivers/usb/core/hcd-pci.c            |    5 +-
 drivers/usb/core/hcd.c                |    6 +-
 drivers/usb/core/hub.c                |   30 ++++---
 drivers/usb/host/pci-quirks.c         |   11 +++
 drivers/usb/host/xhci-hub.c           |    2 +-
 drivers/usb/host/xhci-mem.c           |   32 ++++++--
 drivers/usb/host/xhci.c               |    5 +
 drivers/usb/serial/cp210x.c           |    2 +
 drivers/usb/serial/option.c           |  143 +++------------------------------
 drivers/usb/serial/ti_usb_3410_5052.c |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.h |    4 +
 drivers/usb/storage/usb.c             |   90 +++++++--------------
 drivers/usb/storage/usb.h             |    7 +-
 include/linux/usb/ch11.h              |   10 +--
 14 files changed, 126 insertions(+), 227 deletions(-)
