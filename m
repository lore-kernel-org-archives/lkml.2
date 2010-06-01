Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0FAVGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:06:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0FAVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:04:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 0/6] USB: BKL removal
Date: Tue,  1 Jun 2010 23:04:39 +0200
Message-Id: <1275426285-9088-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V01U2FsdGVkX1/V1tcL13YchVibEMAOvnp2sLanxNLejhtMZrd
 jrwsGMHuGuqJRr0vstlXkGu3ckZsbn5cDM5NRF8ipfAetY49Uz
 B2ui2EvYMLJtIRkFh+jSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here goes another series of BKL removal patches, mostly
from Andi. There are some minor drivers left in the
USB subsystem that someone should take care of, but
this series at least gets to the point where USB
works with the BKL disabled.

Please apply to your USB next tree.

	Arnd

Andi Kleen (4):
  USB-BKL: Remove lock_kernel in usbfs update_sb()
  USB-BKL: Convert usb_driver ioctl to unlocked_ioctl
  USB-BKL: Remove BKL use for usb serial driver probing
  USB-BKL: Remove BKL use in uhci-debug

Arnd Bergmann (2):
  usb/gadget: Do not take BKL for gadget->ops->ioctl
  usb/mon: kill BKL usage

 drivers/usb/core/devio.c        |    7 ++-----
 drivers/usb/core/hub.c          |    3 ++-
 drivers/usb/core/inode.c        |    4 ----
 drivers/usb/gadget/f_fs.c       |    2 --
 drivers/usb/gadget/inode.c      |    6 ++----
 drivers/usb/host/uhci-debug.c   |   17 ++++++-----------
 drivers/usb/misc/usbtest.c      |    3 ++-
 drivers/usb/mon/mon_bin.c       |   22 ++--------------------
 drivers/usb/serial/usb-serial.c |   30 ++++++++++++++----------------
 include/linux/usb.h             |    2 +-
 10 files changed, 31 insertions(+), 65 deletions(-)

