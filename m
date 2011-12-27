Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1L0QUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 11:20:32 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58392 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1L0QU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 11:20:29 -0500
Date: Tue, 27 Dec 2011 14:21:03 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2011-12-27
Message-ID: <20111227162103.GB8298@joana>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

This is my last pull request to 3.3. A good part of the changes here are still
related to the workqueue changes, they are both by me and Ulisses Furquim.
Besides that there are more AMP work from Andrei and SMP work from Brian Gix
plus some other fix/improvements.

Please pull.

	Gustavo


The following changes since commit 27bf88829f50cf1af2b052ecee2f6f0dbe4a5141:

  mac80211: Fixing sparse warning at sta_info.c (2011-12-19 15:06:09 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next master

Andrei Emeltchenko (5):
      Bluetooth: Split ctrl init to BREDR and AMP parts
      Bluetooth: Initialize default flow control mode
      Bluetooth: Check for flow control mode
      Bluetooth: Clean up magic pointers
      Bluetooth: Remove magic numbers from le scan cmd

Bing Zhao (1):
      Bluetooth: btusb: fix bInterval for high/super speed isochronous endpoints

Brian Gix (2):
      Bluetooth: Add MITM mechanism to LE-SMP
      Bluetooth: Add SMP to User Passkey and Confirm

Gustavo F. Padovan (9):
      Bluetooth: Move l2cap_{set,clear}_timer to l2cap.h
      Bluetooth: convert security timer to delayed_work
      Bluetooth: Rename info_work to info_timer
      Bluetooth: fix bt_accept_dequeue() to work in process context
      Bluetooth: Remove l2cap priority from inside RFCOMM.
      Bluetooth: add debug output to l2cap_ack_timeout()
      Bluetooth: Remove lock from inquiry_cache
      Bluetooth: remove *_bh usage from hci_dev_list and hci_cb_list
      Bluetooth: Don't disable interrupt when locking the queue

Hemant Gupta (1):
      Bluetooth: Incorrect address while storing LTK.

Jesse Sung (1):
      Bluetooth: Add support for BCM20702A0 [0a5c:21e3]

Ulisses Furquim (4):
      Bluetooth: Remove global mutex hci_task_lock
      Bluetooth: Always compile SCO and L2CAP in Bluetooth Core
      Bluetooth: Make HCI call directly into SCO and L2CAP event functions
      Bluetooth: Fix deadlocks with sock lock and L2CAP timers locks

 drivers/bluetooth/btusb.c         |   10 +-
 include/net/bluetooth/bluetooth.h |   22 ----
 include/net/bluetooth/hci.h       |   14 ++-
 include/net/bluetooth/hci_core.h  |  162 +++++++++++---------------
 include/net/bluetooth/l2cap.h     |   40 ++++++-
 include/net/bluetooth/smp.h       |    6 +
 net/bluetooth/Kconfig             |   37 ++-----
 net/bluetooth/Makefile            |    5 +-
 net/bluetooth/af_bluetooth.c      |   11 +-
 net/bluetooth/bnep/Kconfig        |    2 +-
 net/bluetooth/cmtp/Kconfig        |    2 +-
 net/bluetooth/hci_conn.c          |    4 +-
 net/bluetooth/hci_core.c          |  172 +++++++++++-----------------
 net/bluetooth/hci_event.c         |   28 ++++-
 net/bluetooth/hidp/Kconfig        |    2 +-
 net/bluetooth/l2cap_core.c        |  112 ++++--------------
 net/bluetooth/mgmt.c              |   10 ++-
 net/bluetooth/rfcomm/Kconfig      |    2 +-
 net/bluetooth/rfcomm/core.c       |   44 +++-----
 net/bluetooth/sco.c               |   38 +------
 net/bluetooth/smp.c               |  235 +++++++++++++++++++++++++++++++++----
 21 files changed, 499 insertions(+), 459 deletions(-)

