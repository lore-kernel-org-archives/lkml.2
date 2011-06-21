Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab1FUSUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:20:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32802 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1FUSUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:20:07 -0400
Date: Tue, 21 Jun 2011 15:20:24 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-06-21
Message-ID: <20110621182024.GD2628@joana>
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

Another batch for 3.1. More L2CAP rewrite patches by myself, now we have an API
that in the future will allow other pieces like l2cap_sock.c/rfcomm/AMP manager
to use. It still an unfinished work. We also have here the first bit of the 
Low Energy Security Manager Protocol by Vinicius Gomes and Another Briglia. And
support for blacklist devices in the management interface by Antti Julku. The
rest are just fixes and clean ups.

Please pull, thanks!

	Gustavo

The following changes since commit e10542c447abf7c840931ff12f7d0dee976ca2ea:

  rtlwifi: rtl8192{c,ce,cu,se}: Remove comparisons of booleans with true (2011-06-20 15:47:43 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Anderson Briglia (6):
      Bluetooth: Implement the first SMP commands
      Bluetooth: Start SMP procedure
      Bluetooth: Add simple SMP pairing negotiation
      Bluetooth: Add LE SMP Cryptoolbox functions
      Bluetooth: Add SMP confirmation structs
      Bluetooth: Add SMP confirmation checks methods

Anderson Lizardo (1):
      Bluetooth: fix missing parameter for HCI_OP_DISCONNECT

Antti Julku (2):
      Bluetooth: Move blacklisting functions to hci_core
      Bluetooth: Add blacklisting support for mgmt interface

David Miller (1):
      Bluetooth: Do not ignore errors returned from strict_strtol()

Gustavo F. Padovan (13):
      Bluetooth: Merge l2cap_chan_create() in the l2cap_sock_alloc()
      Bluetooth: Add l2cap_chan_ops abstraction
      Bluetooth: add recv() callback to l2cap_chan_ops
      Bluetooth: add close() callback to l2cap_chan_ops
      Bluetooth: Add state tracking to struct l2cap_chan
      Bluetooth: Add refcnt to struct l2cap_chan
      Bluetooth: Make timer functions generic
      Bluetooth: keep reference if any ERTM timer is enabled
      Bluetooth: Don't forget to check for LE_LINK
      Bluetooth: use bit operation on conf_state
      Bluetooth: Use bit operations on conn_state
      Bluetooth: Fix locking in blacklist code
      Merge master.kernel.org:/.../padovan/bluetooth-2.6

Ilia Kolomisnky (1):
      Bluetooth: Fix L2CAP connection establishment

Johan Hedberg (1):
      Bluetooth: Fix accepting connect requests for defer_setup

Luiz Augusto von Dentz (2):
      Bluetooth: fix shutdown on SCO sockets
      Bluetooth: Fix L2CAP security check

Ville Tervo (1):
      Bluetooth: Do not send SET_EVENT_MASK for 1.1 and earlier devices

Vinicius Costa Gomes (13):
      Bluetooth: Add support for using the crypto subsystem
      Bluetooth: Add support for LE Start Encryption
      Bluetooth: Remove debug statements
      Bluetooth: Add support for resuming socket when SMP is finished
      Bluetooth: Fix initial security level of LE links
      Bluetooth: Update the security level when link is encrypted
      Bluetooth: Add support for building pairing commands
      Bluetooth: Add support for Pairing features exchange
      Bluetooth: Add support for SMP timeout
      Bluetooth: Add key size checks for SMP
      Bluetooth: Fix crash when setting a LE socket to ready
      Bluetooth: Remove useless access to the socket
      Bluetooth: Fix not setting the chan state

 include/net/bluetooth/hci.h      |   34 ++
 include/net/bluetooth/hci_core.h |   13 +
 include/net/bluetooth/l2cap.h    |   95 ++++--
 include/net/bluetooth/mgmt.h     |   10 +
 include/net/bluetooth/smp.h      |   46 +++
 net/bluetooth/Kconfig            |    8 +
 net/bluetooth/Makefile           |    2 +-
 net/bluetooth/hci_conn.c         |   56 +++-
 net/bluetooth/hci_core.c         |  113 ++++++
 net/bluetooth/hci_event.c        |   69 ++++
 net/bluetooth/hci_sock.c         |   70 +----
 net/bluetooth/l2cap_core.c       |  700 +++++++++++++++++++-------------------
 net/bluetooth/l2cap_sock.c       |   97 +++++-
 net/bluetooth/mgmt.c             |   72 ++++-
 net/bluetooth/smp.c              |  533 +++++++++++++++++++++++++++++
 15 files changed, 1460 insertions(+), 458 deletions(-)
 create mode 100644 net/bluetooth/smp.c

