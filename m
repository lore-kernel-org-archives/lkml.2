Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2KPOUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:20:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:47979 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab2KPOUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:20:36 -0500
Date: Fri, 16 Nov 2012 06:21:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.7-rc5
Message-ID: <20121116142125.GA2242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.7-rc5

for you to fetch changes up to e592c5d0b7db94b485b4a2342db041a1882b7f75:

  Revert "USB/host: Cleanup unneccessary irq disable code" (2012-11-13 10:52:52 -0800)

----------------------------------------------------------------
USB fixes for 3.7-rc5

Here are some USB fixes for the 3.7 tree.

Nothing huge here, just a number of tiny bugfixes resolving issues that
have been found, and two reverts of patches that were found to have
caused problems.

All of these have been in linux-next already.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bjørn Mork (1):
      USB: keyspan: fix typo causing GPF on open

Dan Williams (2):
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
      USB: option: add Alcatel X220/X500D USB IDs

Felipe Balbi (1):
      Revert "usb: musb: use DMA mode 1 whenever possible"

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.7-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus
      Revert "USB/host: Cleanup unneccessary irq disable code"

Jan Beulich (1):
      USB: fix build with XEN and EARLY_PRINTK_DBGP enabled but USB_SUPPORT disabled

Johan Hovold (1):
      USB: usb_wwan: fix bulk-urb allocation

Roger Quadros (1):
      usb: otg: Fix build errors if USB_MUSB_OMAP2PLUS is selected as module

Wei Yongjun (1):
      usb: musb: ux500: fix 'musbid' undeclared error in ux500_remove()

 drivers/usb/core/hcd.c         | 16 ++++++++++++++++
 drivers/usb/early/ehci-dbgp.c  | 15 +++++++++------
 drivers/usb/host/ehci-ls1x.c   |  2 +-
 drivers/usb/host/ohci-xls.c    |  2 +-
 drivers/usb/musb/musb_gadget.c | 30 ++++++++++++++++++++++++++----
 drivers/usb/musb/ux500.c       |  2 +-
 drivers/usb/otg/Kconfig        |  4 ++--
 drivers/usb/serial/keyspan.c   |  3 +--
 drivers/usb/serial/option.c    |  9 +++++++++
 drivers/usb/serial/usb_wwan.c  | 10 +++++-----
 10 files changed, 71 insertions(+), 22 deletions(-)
