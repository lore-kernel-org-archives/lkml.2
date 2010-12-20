Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0LTLzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 06:55:13 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:56924 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0LTLzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 06:55:07 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCHv7 00/16] changed some patches
Date: Mon, 20 Dec 2010 14:54:50 +0300
Message-Id: <cover.1292844387.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending only the patches that were changed.

Changelog
v6 -> v7:
 * fixed issues pointaed out by Andrew Morton:
   * convert pps_idr_lock to mutex and protect idr_pre_get
   * comment usage of local_irq_save()/local_irq_restore()
     in pps_parport and pps_gen_parport
   * don't allow NTP_PPS and NO_HZ at the same time
 * allow to select generators if PPS is not selected
 * disable as much code related to kernel consumer as possible
   if NTP_PPS is not selected
   * extract kernel consumer code to drivers/pps/kc.{c,h}

Alexander Gordeev (16):
  pps: trivial fixes
  pps: declare variables where they are used in switch
  pps: fix race in PPS_FETCH handler
  pps: unify timestamp gathering
  pps: access pps device by direct pointer
  pps: convert printk/pr_* to dev_*
  pps: move idr stuff to pps.c
  pps: make idr lock a mutex and protect idr_pre_get
  pps: use BUG_ON for kernel API safety checks
  pps: simplify conditions a bit
  pps: timestamp is always passed to dcd_change()
  ntp: add hardpps implementation
  pps: capture MONOTONIC_RAW timestamps as well
  pps: add kernel consumer support
  pps: add parallel port PPS client
  pps: add parallel port PPS signal generator

 Documentation/ioctl/ioctl-number.txt     |    2 +-
 Documentation/pps/pps.txt                |   46 ++++
 Documentation/serial/tty.txt             |    2 +-
 drivers/pps/Kconfig                      |   11 +
 drivers/pps/Makefile                     |    3 +-
 drivers/pps/clients/Kconfig              |    7 +
 drivers/pps/clients/Makefile             |    1 +
 drivers/pps/clients/pps-ktimer.c         |   44 ++--
 drivers/pps/clients/pps-ldisc.c          |   59 ++--
 drivers/pps/clients/pps_parport.c        |  258 ++++++++++++++++++
 drivers/pps/generators/Kconfig           |   13 +
 drivers/pps/generators/Makefile          |    9 +
 drivers/pps/generators/pps_gen_parport.c |  282 ++++++++++++++++++++
 drivers/pps/kapi.c                       |  210 ++++-----------
 drivers/pps/kc.c                         |  123 +++++++++
 drivers/pps/kc.h                         |   47 ++++
 drivers/pps/pps.c                        |  156 +++++++++---
 include/linux/pps.h                      |    7 +
 include/linux/pps_kernel.h               |   61 ++++-
 include/linux/serial_core.h              |    5 +-
 include/linux/time.h                     |    2 +
 include/linux/timex.h                    |    1 +
 include/linux/tty_ldisc.h                |    7 +-
 kernel/time/ntp.c                        |  425 ++++++++++++++++++++++++++++-
 kernel/time/timekeeping.c                |   43 +++
 25 files changed, 1534 insertions(+), 290 deletions(-)
 create mode 100644 drivers/pps/clients/pps_parport.c
 create mode 100644 drivers/pps/generators/Kconfig
 create mode 100644 drivers/pps/generators/Makefile
 create mode 100644 drivers/pps/generators/pps_gen_parport.c
 create mode 100644 drivers/pps/kc.c
 create mode 100644 drivers/pps/kc.h

-- 
1.7.2.3

