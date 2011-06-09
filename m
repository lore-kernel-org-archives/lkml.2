Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1FITte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:49:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57424 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab1FITtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:49:31 -0400
Date: Thu, 9 Jun 2011 16:49:43 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-06-09
Message-ID: <20110609194943.GF2533@joana>
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

First Bluetooth batch for 3.1 kernel. Here are more L2CAP rewrite/clean up bu
myself.  Low Energy advertising cache support by Andre Guedes and Anderson
Briglia and a new L2CAP socket option, BT_POWER, from Jaikumar Ganesh.
All the rest are basically fixes and cleanup over the whole stack.

Please pull this or let me know any problem. Thanks, John!

	Gustavo


The following changes since commit 931749bf78b969c54de9bbc67cf29b13a40bb73b:

  ath9k: make use of a helper to get paprd scale factor (2011-06-07 14:46:13 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Anderson Briglia (1):
      Bluetooth: Add advertising report meta event structs

Andre Guedes (8):
      Bluetooth: LE advertising cache
      Bluetooth: Add Advertising Report Meta Event handler
      Bluetooth: Clear advertising cache before scanning
      Bluetooth: Advertising entries lifetime
      Bluetooth: Add 'dst_type' field to struct hci_conn
      Bluetooth: Remove useless check in hci_connect()
      Bluetooth: Check advertising cache in hci_connect()
      Bluetooth: Set 'peer_addr_type' in hci_le_connect()

David Miller (3):
      Bluetooth: Kill set but not used variable 'l2cap_sk' in rfcomm_sock_getsockopt_old()
      Bluetooth: Do not ignore errors returned from strict_strtol()
      Bluetooth: Kill set but unused variable 'cmd' in cmtp_recv_capimsg()

Filip Palian (1):
      Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.

Gustavo F. Padovan (8):
      Bluetooth: fix set but not used warning
      Bluetooth: Create __l2cap_chan_close()
      Bluetooth: Create l2cap_chan_send()
      Bluetooth: Add chan->chan_type struct member
      Bluetooth: create channel timer to replace sk_timer
      Bluetooth: Remove export of l2cap_chan_clear_timer()
      Bluetooth: Rename __l2cap_chan_close() to l2cap_chan_close()
      Merge master.kernel.org:/.../padovan/bluetooth-2.6

Jaikumar Ganesh (1):
      Bluetooth: Add BT_POWER L2CAP socket option.

Johan Hedberg (1):
      Bluetooth: Remove unnecessary use of hci_dev_list_lock

Johannes Berg (1):
      Bluetooth: fix sparse & gcc warnings

Luiz Augusto von Dentz (1):
      Bluetooth: fix shutdown on SCO sockets

Mat Martineau (2):
      Bluetooth: Restore accidentally-deleted line
      Bluetooth: Fix check for the ERTM local busy state

Ruiyi Zhang (1):
      Bluetooth: Allow unsegmented SDU retries on sock_queue_rcv_skb failure

Stephen Boyd (1):
      Bluetooth: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning

Ville Tervo (1):
      Bluetooth: Do not send SET_EVENT_MASK for 1.1 and earlier devices

Waldemar Rymarkiewicz (6):
      Bluetooth: Fix auth_complete_evt for legacy units
      Bluetooth: Refactor hci_auth_complete_evt function
      Bluetooth: Remove a magic number
      Bluetooth: Verify a pin code in pin_code_reply
      Bluetooth: Simplify hci_conn_accept_secure check
      Bluetooth: Clean up some code style issues

 drivers/bluetooth/btmrvl_debugfs.c |   12 ++
 include/net/bluetooth/bluetooth.h  |   15 ++-
 include/net/bluetooth/hci.h        |   25 +++
 include/net/bluetooth/hci_core.h   |   55 +++++--
 include/net/bluetooth/l2cap.h      |   24 ++--
 include/net/bluetooth/rfcomm.h     |    9 +-
 net/bluetooth/cmtp/capi.c          |    3 +-
 net/bluetooth/hci_conn.c           |   29 +++-
 net/bluetooth/hci_core.c           |   82 ++++++++++-
 net/bluetooth/hci_event.c          |  155 +++++++++++++-----
 net/bluetooth/l2cap_core.c         |  307 ++++++++++++++++++++++++++++++------
 net/bluetooth/l2cap_sock.c         |  281 ++++++++-------------------------
 net/bluetooth/mgmt.c               |   61 +++++--
 net/bluetooth/rfcomm/sock.c        |    7 +-
 net/bluetooth/sco.c                |   13 ++-
 15 files changed, 697 insertions(+), 381 deletions(-)
