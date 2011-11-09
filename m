Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1KIPNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:13:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55519 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1KIPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:13:06 -0500
Date: Wed, 9 Nov 2011 13:13:39 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2011-11-09
Message-ID: <20111109151339.GK25584@joana>
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

105 patches for the -next release! Yeah, I know that it is too much, but I got
all these patches in the last 3 or 4 weeks. Seems we are going to have one of
the busiest release for Bluetooth that I can remember.

So here we have the took off of the Bluetooth High Speed implementation,
patches from both Mat Martineau and Andrei Emeltchenko. Prioritization support
for L2CAP channels by Luiz Augusto von Dentz. Many management fixes from Johan
Hedberg. The rest are mostly fixes and clean ups.

Unfortunately there a conflict between my bluetoot-next tree and wireless (and
the bluetooth tree as weel) and I can fix it because bluetooth-next is far
behind wireless at this moment, but once you merge this, I'll merge back
wireless-next and solve this and send a new pull resquest. It's a trivial
conflict actually. 

Please pull, or let me know any problems or concerns.

Ah, do you want pgp signed pull requests from me? I think the kernel.org git
url is enough to prove that you are pulling from me.

	Gustavo


The following changes since commit ae2772b313b98a14f69b5bc67135c9fee48771be:

  mac80211: allow frame aggregation for mesh (2011-11-08 15:55:27 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next master

Andre Guedes (3):
      Bluetooth: Create hci_do_inquiry()
      Bluetooth: Create hci_cancel_inquiry()
      Bluetooth: Periodic Inquiry and Discovery

Andrei Emeltchenko (33):
      Bluetooth: EFS: l2cap extended feature mask update
      Bluetooth: EFS: add enable_hs kernel param
      Bluetooth: convert flushable variable to flag in l2cap chan
      Bluetooth: convert force_reliable variable to flag in l2cap chan
      Bluetooth: convert force_active variable to flag in l2cap chan
      Bluetooth: convert role_switch variable to flag in l2cap chan
      Bluetooth: clean up spaces in L2CAP header
      Bluetooth: EWS: extended window size option support
      Bluetooth: EWS: adds ext control field bit mask
      Bluetooth: EWS: rewrite handling Supervisory (S) bits
      Bluetooth: EWS: rewrite handling SAR bits
      Bluetooth: EWS: rewrite reqseq calculation
      Bluetooth: EWS: rewrite L2CAP ERTM txseq calculation
      Bluetooth: EWS: rewrite check frame type function
      Bluetooth: EWS: rewrite handling FINAL (F) bit
      Bluetooth: EWS: rewrite handling POLL (P) bit
      Bluetooth: EWS: recalculate L2CAP header size
      Bluetooth: EWS: define L2CAP header sizes
      Bluetooth: EFS: definitions and headers
      Bluetooth: EFS: assign default values in chan add
      Bluetooth: EFS: add efs option in L2CAP conf req
      Bluetooth: AMP: read local amp info HCI command
      Bluetooth: EWS: handling different Control fields
      Bluetooth: EWS: support extended seq numbers
      Bluetooth: EWS: remove magic numbers in l2cap
      Bluetooth: EWS: fix max_pdu calculation
      Bluetooth: EFS: parse L2CAP config request
      Bluetooth: EFS: implement L2CAP config pending state
      Bluetooth: remove magic offset and size
      Bluetooth: correct debug output
      Bluetooth: Initialize tx_win_max for fixed channel
      Bluetooth: Define HCI reasons instead of magic number
      Bluetooth: EFS: parse L2CAP config response

David Herrmann (13):
      Bluetooth: hidp: Stop I/O on shutdown
      Bluetooth: Fix hci core device initialization
      Bluetooth: Rename sysfs un/register to add/del
      Bluetooth: Forward errors from hci_register_dev
      Bluetooth: Return proper error codes on rfcomm tty init
      Bluetooth: Replace rfcomm tty tasklet by workqueue
      Bluetooth: Ignore hci_unregister_dev return value
      Bluetooth: Make hci_unregister_dev return void
      Bluetooth: ath3k: Use GFP_KERNEL instead of GFP_ATOMIC
      Bluetooth: bcm203x: Fix race condition on disconnect
      Bluetooth: bcm203x: Use GFP_KERNEL in workqueue
      Bluetooth: bfusb: Fix error path on firmware load
      Bluetooth: hidp: Fix module reference cleanup

Gustavo F. Padovan (16):
      Bluetooth: use list_for_each_entry() in hidp
      Bluetooth: prioritize the interrupt channel in hidp
      Bluetooth: Trasmit interrupt channel messages first
      Bluetooth: Fix input device registration
      Bluetooth: Remove wrong error check
      Bluetooth: Uses test_and_clear_bit() when possible
      Bluetooth: Delay session allocation in hidp
      Bluetooth: Rename hidp_find_connection()
      Bluetooth: Fix permission of enable_le param
      Bluetooth: return proper error if sock_queue_rcv_skb() fails
      Bluetooth: Add missing cmd_status() in mgmt
      Bluetooth: Use list_for_each_entry() in mgmt
      Bluetooth: Fix mgmt interaction with userspace
      Bluetooth: Fix missing cmd_status in mgmt
      Bluetooth: small styles clean ups to l2cap_core.c
      Bluetooth: Fix hidp_get_connection()

Johan Hedberg (17):
      Bluetooth: Fix command complete/status for discovery commands
      Bluetooth: Set HCI_MGMT flag only in read_controller_info
      Bluetooth: Fix mgmt response when adapter goes down or is removed
      Bluetooth: Clean up logic in hci_cc_write_scan_enable
      Bluetooth: Add timeout field to mgmt_set_discoverable
      Bluetooth: Fix mgmt response when HCI_Write_Scan_Enable fails
      Bluetooth: Convert power off mechanism to use delayed_work
      Bluetooth: Remove redundant code from mgmt_block & mgmt_unblock
      Bluetooth: Fix response for mgmt_start_discovery when powered off
      Bluetooth: Update link key mgmt APIs to match latest spec.
      Bluetooth: Add address type fields to mgmt messages that need them
      Bluetooth: Pass full hci_dev struct to mgmt callbacks
      Bluetooth: Move pending management command list into struct hci_dev
      Bluetooth: Add missing hci_dev locking when calling mgmt functions
      Bluetooth: Fix cancel_delayed_work_sync usage with locks
      Bluetooth: Fix consistency with u16 integer type in mgmt pending_cmd
      Bluetooth: Remove redundant hci_dev comparisons in mgmt lookups

Luiz Augusto von Dentz (7):
      Bluetooth: replace list_for_each with list_for_each_entry whenever possible
      Bluetooth: set skbuffer priority based on L2CAP socket priority
      Bluetooth: make use sk_priority to priritize RFCOMM packets
      Bluetooth: prioritizing data over HCI
      Bluetooth: handle priority change within quote
      Bluetooth: recalculate priorities when channels are starving
      Bluetooth: use buffer priority to mark URB_ISO_ASAP flag

Mat Martineau (9):
      Bluetooth: Add BT_CHANNEL_POLICY socket option
      Bluetooth: Change scope of the enable_hs module parameter
      Bluetooth: Add channel policy to getsockopt/setsockopt
      Bluetooth: Add AMP-related data and structures for channel signals
      Bluetooth: Add signal handlers for channel creation
      Bluetooth: Add definitions for L2CAP fixed channels
      Bluetooth: Use symbolic values for the fixed channel map
      Bluetooth: Add signal handlers for channel moves
      Bluetooth: Guarantee BR-EDR device will be registered as hci0

Paul Bolle (2):
      Bluetooth: btusb: also be quiet when suspending
      Bluetooth: btusb: hide more usb_submit_urb errors

Paul Fertser (1):
      Bluetooth: ath3k: output firmware filename when request_firmware failed

Peter Hurley (1):
      Bluetooth: hidp: safely acquire hci connection

Szymon Janc (3):
      Bluetooth: rfcomm: Fix sleep in invalid context in rfcomm_security_cfm
      Bluetooth: Increase HCI reset timeout in hci_dev_do_close
      Bluetooth: Add debug print to l2cap_chan_create

 drivers/bluetooth/ath3k.c         |   19 +-
 drivers/bluetooth/bcm203x.c       |   12 +-
 drivers/bluetooth/bfusb.c         |   17 +-
 drivers/bluetooth/bluecard_cs.c   |    4 +-
 drivers/bluetooth/bt3c_cs.c       |    4 +-
 drivers/bluetooth/btuart_cs.c     |    4 +-
 drivers/bluetooth/btusb.c         |   16 +-
 drivers/bluetooth/dtl1_cs.c       |    4 +-
 drivers/bluetooth/hci_vhci.c      |    5 +-
 include/net/bluetooth/bluetooth.h |   29 ++-
 include/net/bluetooth/hci.h       |   22 +
 include/net/bluetooth/hci_core.h  |  136 ++++--
 include/net/bluetooth/l2cap.h     |  409 ++++++++++++++---
 include/net/bluetooth/mgmt.h      |   47 +-
 include/net/bluetooth/rfcomm.h    |    1 +
 net/bluetooth/bnep/core.c         |   13 +-
 net/bluetooth/cmtp/core.c         |   13 +-
 net/bluetooth/hci_conn.c          |   69 +++-
 net/bluetooth/hci_core.c          |  401 ++++++++++++----
 net/bluetooth/hci_event.c         |  221 ++++++----
 net/bluetooth/hci_sysfs.c         |   40 +-
 net/bluetooth/hidp/core.c         |  157 ++++---
 net/bluetooth/l2cap_core.c        |  947 +++++++++++++++++++++++++++----------
 net/bluetooth/l2cap_sock.c        |   90 +++-
 net/bluetooth/mgmt.c              |  502 +++++++++++---------
 net/bluetooth/rfcomm/core.c       |   74 ++-
 net/bluetooth/rfcomm/sock.c       |    2 +
 net/bluetooth/rfcomm/tty.c        |   45 +-
 net/bluetooth/smp.c               |    3 +-
 29 files changed, 2320 insertions(+), 986 deletions(-)

