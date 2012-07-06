Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab2GFWvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:51:02 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37462 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab2GFWu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:50:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 00/12] /dev/random fixups
Date: Fri,  6 Jul 2012 18:44:52 -0400
Message-Id: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version fixes some sparse complaints; reduces stack usage in
xfer_secondary_pool; fixes a lockdep complaint caused by
get_random_bytes() getting called from interrupt context; and other
minor updates as requested by patch reviewers.

					- Ted

Linus Torvalds (1):
  random: create add_device_randomness() interface

Mark Brown (2):
  rtc: wm831x: Feed the write counter into device_add_randomness()
  mfd: wm831x: Feed the device UUID into device_add_randomness()

Theodore Ts'o (9):
  random: fix up sparse warnings
  random: make 'add_interrupt_randomness()' do something sane
  random: use lockless techniques in the interrupt path
  usb: feed USB device information to the /dev/random driver
  net: feed /dev/random with the MAC address when registering a device
  random: use the arch-specific rng in xfer_secondary_pool
  random: add new get_random_bytes_arch() function
  random: add tracepoints for easier debugging and verification
  MAINTAINERS: Theodore Ts'o is taking over the random driver

 MAINTAINERS                   |   4 +-
 drivers/char/random.c         | 274 +++++++++++++++++++++++++++++++-----------
 drivers/mfd/ab3100-core.c     |   2 -
 drivers/mfd/wm831x-otp.c      |   8 ++
 drivers/rtc/rtc-wm831x.c      |  24 +++-
 drivers/usb/core/hub.c        |   9 ++
 include/linux/random.h        |   4 +-
 include/trace/events/random.h | 134 +++++++++++++++++++++
 kernel/irq/handle.c           |   7 +-
 net/core/dev.c                |   3 +
 net/core/rtnetlink.c          |   1 +
 11 files changed, 393 insertions(+), 77 deletions(-)
 create mode 100644 include/trace/events/random.h

-- 
1.7.11.1.108.gb129051

