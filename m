Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0FTUus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:50:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51896 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab0FTUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:50:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:49:54 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/8] firewire: cdev ABI updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following as replies:  Proposed updates to the <linux/firewire-cdev.h>
ABI and to its backing implementation.  These updates are required for
target-type userspace drivers and in order to be able to use more than
one audio device with FFADO.

Some of the patches have already been seen on linux1394-devel but not
yet on linux-kernel.

Corresponding patches to libraw1394 will be posted to linux1394-devel
right after the kernel patch postings.

Clemens Ladisch (1):
      firewire: cdev: fix race in iso context creation

Jay Fenlason (2):
      firewire: cdev: fix responses to nodes at different card
      firewire: expose extended tcode of incoming lock requests to (userspace) drivers

Stefan Richter (5):
      firewire: remove an unused function argument
      firewire: cdev: count references of cards during inbound transactions
      firewire: cdev: freeze FW_CDEV_VERSION due to libraw1394 bug
      firewire: cdev: fix ABI for FCP and address range mapping, add fw_cdev_event_request2
      firewire: cdev: extend fw_cdev_event_iso_interrupt documentation

 drivers/firewire/core-cdev.c            |   81 ++++++++++++++++-----
 drivers/firewire/core-transaction.c     |   18 +++--
 drivers/firewire/net.c                  |    4 +-
 drivers/firewire/sbp2.c                 |    3 +-
 drivers/media/dvb/firewire/firedtv-fw.c |    4 +-
 include/linux/firewire-cdev.h           |  117 +++++++++++++++++++++++++++---
 include/linux/firewire.h                |    2 +-
 7 files changed, 183 insertions(+), 46 deletions(-)
-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

