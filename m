Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab1JQUiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:38:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1JQUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:38:44 -0400
Date: Mon, 17 Oct 2011 18:39:01 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2011-10-17
Message-ID: <20111017203900.GE2631@joana>
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

As the 3.1 release is taking too long to happen I decided to send you another
pull request. If you think it's too late just ignore it, or queue it up for
3.3 merge window. Do what is better to you. ;)

The bigger changes here are from Andrei, he did many changes in L2CAP looking
forward for the Bluetooth 3.0 High Speed implementation. It is the biggest
change on High Speed until now.

There are some fixes on the hidp module by David Hermann, Peter Hurley and me.
The rest are just clean ups and small fixes.

Thanks.

	Gustavo


The following changes since commit fd38f734cb8200529e281338514945fcbff2364b:

  igbvf: convert to ndo_fix_features (2011-10-16 13:18:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next.git master

Andrei Emeltchenko (27):
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

David Herrmann (4):
      Bluetooth: hidp: Stop I/O on shutdown
      Bluetooth: Fix hci core device initialization
      Bluetooth: Rename sysfs un/register to add/del
      Bluetooth: Forward errors from hci_register_dev

Gustavo F. Padovan (14):
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

Paul Bolle (2):
      Bluetooth: btusb: also be quiet when suspending
      Bluetooth: btusb: hide more usb_submit_urb errors

Peter Hurley (1):
      Bluetooth: hidp: safely acquire hci connection

 drivers/bluetooth/btusb.c         |   13 +-
 include/net/bluetooth/bluetooth.h |    2 +-
 include/net/bluetooth/hci.h       |   15 +
 include/net/bluetooth/hci_core.h  |   16 +-
 include/net/bluetooth/l2cap.h     |  342 ++++++++++++++++++----
 include/net/bluetooth/mgmt.h      |    2 -
 net/bluetooth/hci_core.c          |   21 +-
 net/bluetooth/hci_event.c         |   30 ++-
 net/bluetooth/hci_sysfs.c         |   22 +-
 net/bluetooth/hidp/core.c         |  150 +++++-----
 net/bluetooth/l2cap_core.c        |  594 ++++++++++++++++++++++++-------------
 net/bluetooth/l2cap_sock.c        |   51 ++--
 net/bluetooth/mgmt.c              |   26 +-
 13 files changed, 905 insertions(+), 379 deletions(-)
