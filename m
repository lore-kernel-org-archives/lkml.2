Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1LSNsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:48:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62689 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1LSNsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:48:36 -0500
Date: Mon, 19 Dec 2011 11:49:12 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2011-12-19
Message-ID: <20111219134912.GC2610@joana>
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

Another set of patches for 3.3. The biggest change here is a long-waited move
from tasklets to workqueue. All our bluetooth core processing is now done in
process context. Besides that there is some update from Johan to management
interface and some other fix/improvements over the three.

Please pull, thanks!

	Gustavo

The following changes since commit 5bd5e9a6ae5137a61d0b5c277eac61892d89fc4f:

  ath9k: Support RSN Mesh (2011-12-16 09:30:43 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next master

Andrei Emeltchenko (2):
      Bluetooth: Add HCI Read Data Block Size function
      Bluetooth: Simplify num_comp_pkts_evt function

Gustavo F. Padovan (30):
      Bluetooth: remove struct hci_chan_hash
      Bluetooth: remove lock from struct conn_hash
      Bluetooth: Initialize LE connection count
      Bluetooth: Use chan instead of l2cap_pi macro
      Bluetooth: Use list_for_each_entry in hci_conn_hash_flush()
      Bluetooth: make hci_conn_enter_sniff_mode static
      Bluetooth: Replace spin_lock by mutex in hci_dev
      Bluetooth: Use delayed_work for connection timeout
      Bluetooth: Use delayed work for advertisiment cache timeout
      Bluetooth: hci_conn_auto_accept() doesn't need locking
      Bluetooth: Move L2CAP timers to workqueue
      Bluetooth: Don't use spin_lock socket lock anymore
      Bluetooth: Remove sk_backlog usage from L2CAP
      Bluetooth: move hci_task_lock to mutex
      Bluetooth: convert chan_lock to mutex
      Bluetooth: Use RCU to manipulate chan_list
      Bluetooth: convert conn hash to RCU
      Bluetooth: Don't disable tasklets to call hdev->notify()
      Bluetooth: Move command task to workqueue
      Bluetooth: convert tx_task to workqueue
      Bluetooth: convert info timer to delayed_work
      Bluetooth: invert locking order in connect path
      Bluetooth: Change l2cap chan_list to use RCU
      Bluetooth: move power_off to system workqueue
      Bluetooth: Use new alloc_workqueue()
      Bluetooth: Remove work_add and work_del from hci_sysfs
      Bluetooth: Use system workqueue to schedule power_on
      Bluetooth: Add ProFUSION's copyright
      Revert "Bluetooth: Revert: Fix L2CAP connection establishment"
      Merge git://git.kernel.org/.../padovan/bluetooth

Johan Hedberg (10):
      Bluetooth: Update mgmt_read_info and related mgmt messages
      Bluetooth: Move mgmt_set_fast_connectable to the right location
      Bluetooth: Remove mgmt_set_service_cache
      Bluetooth: Move EIR and CoD update functions to a better position
      Bluetooth: Add timer for automatically disabling the service cache
      Bluetooth: Update ordering and opcodes of mgmt messages
      Bluetooth: Use correct struct for user_confirm_neg_reply
      Bluetooth: Add missing confirm_name field to mgmt_ev_device_found
      Bluetooth: Fix mgmt_(block,unblock)_device opcodes
      Bluetooth: Add missing mgmt_confirm_name command definition

Marcel Holtmann (1):
      Bluetooth: Process recv path in a workqueue instead of a tasklet

Mat Martineau (3):
      Bluetooth: Incoming ACL packets do not force active mode
      Bluetooth: Prevent uninitialized data access in L2CAP configuration
      Bluetooth: Clear RFCOMM session timer when disconnecting last channel

 include/net/bluetooth/hci.h      |    9 +
 include/net/bluetooth/hci_core.h |  118 +++----
 include/net/bluetooth/l2cap.h    |   24 +-
 include/net/bluetooth/mgmt.h     |  191 ++++++-----
 net/bluetooth/hci_conn.c         |  137 ++++-----
 net/bluetooth/hci_core.c         |  173 ++++++-----
 net/bluetooth/hci_event.c        |   99 ++++--
 net/bluetooth/hci_sock.c         |   21 +-
 net/bluetooth/hci_sysfs.c        |   91 ++---
 net/bluetooth/hidp/core.c        |    4 +-
 net/bluetooth/l2cap_core.c       |  360 +++++++++++----------
 net/bluetooth/l2cap_sock.c       |   62 +----
 net/bluetooth/mgmt.c             |  696 ++++++++++++++++++++------------------
 net/bluetooth/rfcomm/core.c      |    1 +
 net/bluetooth/sco.c              |    4 +-
 15 files changed, 1015 insertions(+), 975 deletions(-)
