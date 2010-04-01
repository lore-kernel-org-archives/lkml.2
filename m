Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0DAQdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:33:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42109 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757954Ab0DAQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:32:59 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [RFC PATCH 00/14] Some BKL killing in the serial drivers
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:04:08 +0100
Message-ID: <20100401155513.8882.54006.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

Alan Cox (14):
      synclink: reworking locking a bit
      specialix; Kill the BKL
      epca: Kill the big kernel lock
      cyclades: Kill off BKL usage
      synclink: kill the big kernel lock
      rocket: kill BKL
      isicom: kill off the BKL
      riscom8: kill use of lock_kernel
      istallion: use bit ops for the board flags
      stallion: prune lock_kernel calls
      vc: Locking clean up
      tty: serial - fix various misuses/mishandlings of port->tty
      tty: serial - fix tty back references in termios
      tty: serial - fix tty referencing in set_ldisc


 drivers/char/cyclades.c      |   20 +++-----
 drivers/char/epca.c          |    4 --
 drivers/char/isicom.c        |   12 ++---
 drivers/char/istallion.c     |   59 ++++++++++++----------
 drivers/char/riscom8.c       |   14 +++--
 drivers/char/rocket.c        |   28 +++++++----
 drivers/char/selection.c     |    4 ++
 drivers/char/specialix.c     |   11 ++--
 drivers/char/stallion.c      |   20 +++++---
 drivers/char/synclink.c      |   19 ++++---
 drivers/char/synclink_gt.c   |   90 +++++++++++++++++-----------------
 drivers/char/synclinkmp.c    |   41 ++++++++--------
 drivers/char/vt.c            |    8 ++-
 drivers/serial/21285.c       |   10 +---
 drivers/serial/bfin_5xx.c    |    7 +--
 drivers/serial/imx.c         |   10 ++--
 drivers/serial/ioc3_serial.c |    9 ++-
 drivers/serial/ioc4_serial.c |    9 ++-
 drivers/serial/max3100.c     |    3 -
 drivers/serial/serial_core.c |  111 +++++++++++++++++++++++-------------------
 include/linux/serial_core.h  |    2 -
 21 files changed, 258 insertions(+), 233 deletions(-)

-- 

