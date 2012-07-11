Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab2GKN5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:57:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47651 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab2GKN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:56:59 -0400
Date: Wed, 11 Jul 2012 06:56:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.5-rc6
Message-ID: <20120711135655.GA19587@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.5-rc6

for you to fetch changes up to dbf0e4c7257f8d684ec1a3c919853464293de66e:

  PCI: EHCI: fix crash during suspend on ASUS computers (2012-07-10 09:52:05 -0700)

----------------------------------------------------------------
USB fixes for 3.5-rc6

Here are a few fixes and new device ids for the 3.5-rc6 tree.

The PCI changes resolve a long-standing issue with resuming some EHCI
controllers.  It has been acked by the PCI maintainer, and he asked for it to
go through my USB tree instead of his.

The xhci patches also resolve a number of reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      PCI: EHCI: fix crash during suspend on ASUS computers

Bjørn Mork (2):
      USB: option: add ZTE MF60
      USB: cdc-wdm: fix lockup on error in wdm_read

Gaosen Zhang (1):
      USB: option: Add MEDIATEK product ids

Greg Kroah-Hartman (1):
      Merge tag 'for-usb-linus-2012-07-02' of git://git.kernel.org/.../sarah/xhci into usb-linus

Johan Hovold (1):
      USB: metro-usb: fix tty_flip_buffer_push use

Sarah Sharp (1):
      xhci: Fix hang on back-to-back Set TR Deq Ptr commands.

Stanislaw Ledwon (1):
      usb: Add support for root hub port status CAS

 drivers/pci/pci-driver.c       | 12 ++++++++++++
 drivers/pci/pci.c              |  5 -----
 drivers/pci/quirks.c           | 26 -------------------------
 drivers/usb/class/cdc-wdm.c    |  2 ++
 drivers/usb/core/hub.c         | 18 +++++++++--------
 drivers/usb/host/xhci-hub.c    | 44 ++++++++++++++++++++++++++++++++++++------
 drivers/usb/host/xhci-ring.c   | 11 +++++++++++
 drivers/usb/host/xhci.h        |  6 +++++-
 drivers/usb/serial/metro-usb.c |  8 --------
 drivers/usb/serial/option.c    | 26 +++++++++++++++++++++++++
 include/linux/pci.h            |  2 --
 11 files changed, 104 insertions(+), 56 deletions(-)
