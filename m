Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1LCBjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:39:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48336 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1LCBhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:37:53 -0500
Date: Sat, 3 Dec 2011 10:38:37 +0900
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2011-12-03
Message-ID: <20111203013837.GA2816@joana>
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

Another big pull for -next. Some work on LE scanning from Andre Guedes, more
AMP work from Andrei Emeltchenko. HCI Management Interface improvements from
Johan Hedberg and Management and SMP work from Brian Gix. The rest are just
fixes and clean ups.

Please pull, or let me know any problems. Thanks.

	Gustavo

The following changes since commit ba5736a5e9ac20c378ae4179e8a0ed3cc4b44351:

  ath9k_hw: add default chainmask for AR9462 (2011-11-30 15:09:02 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next master

Andre Guedes (4):
      Bluetooth: Rename mgmt_inquiry_failed()
      Bluetooth: mgmt_stop_discovery_failed()
      Bluetooth: Add dev_flags to struct hci_dev
      Bluetooth: LE Set Scan Parameter Command

Andrei Emeltchenko (10):
      Bluetooth: Move scope of kernel parameter enable_hs
      Bluetooth: Do not set HCI_RAW when HS enabled
      Bluetooth: Allow to set AMP type for virtual HCI
      Bluetooth: making enable_hs independent from L2CAP
      Bluetooth: Use queue in the device list
      Bluetooth: Add HCI Read Flow Control Mode function
      Bluetooth: remove old code
      Bluetooth: Correct version check in hci_setup
      Bluetooth: Remove magic bluetooth version numbers
      Bluetooth: trivial: correct check for LMP version

Bing Zhao (1):
      Bluetooth: btmrvl: support Marvell Bluetooth device SD8797

Brian Gix (9):
      Bluetooth: Add HCI defines for User Passkey entry
      Bluetooth: Add MGMT opcodes for Passkey Entry
      Bluetooth: Add MGMT event for Passkey Entry
      Bluetooth: User Pairing Response restructuring
      Bluetooth: Differentiate LE User Pairing Responses
      Bluetooth: Add User Passkey Response handling
      Bluetooth: Add HCI User Passkey Req Evt handling
      Bluetooth: Cleanup blkcipher on SMP termination
      Bluetooth: Centralize SMP pairing failure handling

Cong Wang (1):
      btusb: fix a memory leak in btusb_send_frame()

David Herrmann (2):
      Bluetooth: cmtp: Fix module reference
      Bluetooth: bnep: Fix module reference

Gustavo F. Padovan (5):
      Bluetooth: Rename l2cap_check_security()
      Bluetooth: Allow L2CAP to increase the security level
      Bluetooth: Only set ack_timer if we didn't send and ack
      Bluetooth: Add user readable debug for state changes
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth

Johan Hedberg (10):
      Bluetooth: Add public/random LE address information to mgmt messages
      Bluetooth: Fix deadlock with mgmt_pair_device
      Bluetooth: Add proper response to mgmt_remove_keys command
      Bluetooth: Add status parameter to mgmt_disconnect response
      Bluetooth: Add address type to mgmt_pair_device
      Bluetooth: Fix mgmt_pair_device imediate error responses
      Bluetooth: Return success instead of EALREADY for mgmt commands
      Bluetooth: Create a unique mgmt error code hierarchy
      Bluetooth: Add missing cmd_complete for mgmt_load_link_keys
      Bluetooth: Pass all message parameters to mgmt_start_discovery

Szymon Janc (5):
      Bluetooth: Fix possible NULL pointer derefence in l2cap code
      Bluetooth: Simplify l2cap_add_to_srej_queue
      Bluetooth: Refactor loop in l2cap_retransmit_one_frame
      Bluetooth: Simplify __l2cap_global_chan_by_addr
      Bluetooth: Fix some checkpatch.pl errors and warnings

 drivers/bluetooth/Kconfig         |    6 +-
 drivers/bluetooth/btmrvl_sdio.c   |   15 +-
 drivers/bluetooth/btusb.c         |    3 +-
 drivers/bluetooth/hci_vhci.c      |    8 +
 include/net/bluetooth/bluetooth.h |    5 +
 include/net/bluetooth/hci.h       |   38 +++
 include/net/bluetooth/hci_core.h  |   28 ++-
 include/net/bluetooth/l2cap.h     |    2 +-
 include/net/bluetooth/mgmt.h      |   49 +++-
 net/bluetooth/bnep/core.c         |    8 +-
 net/bluetooth/cmtp/core.c         |    5 +-
 net/bluetooth/hci_conn.c          |    2 +-
 net/bluetooth/hci_core.c          |   31 +-
 net/bluetooth/hci_event.c         |  152 +++++++--
 net/bluetooth/l2cap_core.c        |  101 ++++--
 net/bluetooth/l2cap_sock.c        |   16 +-
 net/bluetooth/mgmt.c              |  660 ++++++++++++++++++++++++++++---------
 net/bluetooth/smp.c               |   32 ++-
 18 files changed, 880 insertions(+), 281 deletions(-)

