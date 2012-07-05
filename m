Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2GESNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:13:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37008 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2GESMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:12:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 00/10] /dev/random fixups
Date: Thu,  5 Jul 2012 14:12:03 -0400
Message-Id: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series addresses some shortcomings in the /dev/random driver
discovered by Zakir Durumeric, Nadia Halderman, J. Alex Heninger, and
Eric Wustrow.   For more information please see https://factorable.net/

One notable change from previous versions of this patch is that I'm now
fixing in the EIP from the interrupt handler into entropy pool as well
as the timestamp, in order to add more variability.  In addition, if the
CPU has a hardware random number generator, we use it in
xfer_secondary_pool so that some input from the CPU's HWRNG is mixed in
whenever we generate random bytes.

Thanks to Dan Carbenter, Thomas Gleixner, Greg K-H, David Miller, Willy
Tarreau, Linus Torvalds, and Eric Wustrow who all provided very valuable
input, testing, and code.

Please review and comment; the plan is for Linus to pull them during the
next merge window.

						- Ted

Linus Torvalds (1):
  random: create add_device_randomness() interface

Theodore Ts'o (9):
  random: make 'add_interrupt_randomness()' do something sane
  random: use lockless techniques when mixing entropy pools
  usb: feed USB device information to the /dev/random driver
  net: feed /dev/random with the MAC address when registering a device
  random: use the arch-specific rng in xfer_secondary_pool
  random: add new get_random_bytes_arch() function
  random: unify mix_pool_bytes() and mix_pool_bytes_entropy()
  random: add tracepoints for easier debugging and verification
  MAINTAINERS: Theodore Ts'o is taking over the random driver

 MAINTAINERS                   |   4 +-
 drivers/char/random.c         | 223 ++++++++++++++++++++++++++++++++----------
 drivers/mfd/ab3100-core.c     |   2 -
 drivers/usb/core/hub.c        |   9 ++
 include/linux/random.h        |   2 +
 include/trace/events/random.h | 132 +++++++++++++++++++++++++
 kernel/irq/handle.c           |   3 +-
 net/core/dev.c                |   3 +
 8 files changed, 319 insertions(+), 59 deletions(-)
 create mode 100644 include/trace/events/random.h

-- 
1.7.11.1.108.gb129051

