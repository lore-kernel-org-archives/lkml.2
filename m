Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0IPSGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:06:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:26449 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0IPSGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:06:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,377,1280732400"; 
   d="scan'208";a="325418964"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/3] Fix the TIOCGICOUNT problem for good
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
        drosenberg@vsecurity.com
Date: Thu, 16 Sep 2010 18:21:06 +0100
Message-ID: <20100916171747.25987.33573.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remembering to clear fields is something driver authors are simply never
going to remember to get right every new driver. Instead take the problem
away from them and give them a simple interface to do the job.

---

Alan Cox (3):
      tty: icount changeover for other main devices
      tty: Convert the USB drivers to the new icount interface
      tty: Make tiocgicount a handler


 arch/ia64/hp/sim/simserial.c          |   12 -----
 drivers/char/amiserial.c              |   56 ++++++++++++++-----------
 drivers/char/cyclades.c               |   49 ++++++++++++----------
 drivers/char/ip2/ip2main.c            |   71 +++++++++++++++++++-------------
 drivers/char/mxser.c                  |   62 ++++++++++++++++------------
 drivers/char/nozomi.c                 |   37 ++++++++---------
 drivers/char/pcmcia/synclink_cs.c     |   60 ++++++++++++---------------
 drivers/char/synclink.c               |   73 +++++++++++++++------------------
 drivers/char/synclink_gt.c            |   55 +++++++++++++------------
 drivers/char/synclinkmp.c             |   61 +++++++++++++---------------
 drivers/char/tty_io.c                 |   21 +++++++++
 drivers/net/usb/hso.c                 |   35 +++++++---------
 drivers/serial/68360serial.c          |   51 +++++++++++------------
 drivers/serial/serial_core.c          |   35 +++++++---------
 drivers/usb/serial/ark3116.c          |   40 +++++++++---------
 drivers/usb/serial/ftdi_sio.c         |    1 
 drivers/usb/serial/io_edgeport.c      |   49 ++++++++++++----------
 drivers/usb/serial/io_tables.h        |    4 ++
 drivers/usb/serial/io_ti.c            |   29 ++++++++++---
 drivers/usb/serial/mos7720.c          |   50 +++++++++++++----------
 drivers/usb/serial/mos7840.c          |   50 +++++++++++++----------
 drivers/usb/serial/ssu100.c           |   46 +++++++++++----------
 drivers/usb/serial/ti_usb_3410_5052.c |   37 +++++++++++++----
 drivers/usb/serial/usb-serial.c       |   13 ++++++
 include/linux/tty_driver.h            |    9 ++++
 include/linux/usb/serial.h            |    2 +
 net/bluetooth/rfcomm/tty.c            |    4 --
 27 files changed, 561 insertions(+), 451 deletions(-)

-- 
Rust greets time a grave to steam, in mire gloom to no more gleam
Does care die quiet and scarred, Berry red in Barry yard ?

Rusted steel at rest dust all, old sump oil lead is my pall
long rather to linger there, cold my fire once called me fair

Who knows now when I was new, speed in flow and on I flew
I turned eyes to run and see, in steam a dream adore me


