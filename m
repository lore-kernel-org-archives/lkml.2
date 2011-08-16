Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HPQ6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:58:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63338 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1HPQ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:58:32 -0400
Date: Tue, 16 Aug 2011 13:59:05 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2011-08-16
Message-ID: <20110816165905.GA27448@joana>
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

Some fixes for 3.1! It looks a lot of fixes but some of them are the same fix
applied to different files. Here we have a fix for a wrong timer value from
Chen Ganir, a lock balance fix from Dan Carpenter, regression fix with the HCI
Reset command from Szymon Janc, a fix to not show error messages on btusb
device disconnect from Paul Bolle. Support for Toshiba AR30XX from Ricardo
Mendoza. And finally a bunch of fixes from Peter Hurley, there are some lost
wake up, deadlocks and memort leaks fixes. Most of them fixes regressions
introduced by the move to the kthread API.

Please pull! Or let me know if disagree with something here. Thanks.

	Gustavo


The following changes since commit 674db1344443204b6ce3293f2df8fd1b7665deea:

  rt2x00: fix crash in rt2800usb_get_txwi (2011-08-11 14:34:37 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth.git master

Chen Ganir (1):
      Bluetooth: Fixed wrong L2CAP Sock timer value

Dan Carpenter (1):
      Bluetooth: unlock if allocation fails in hci_blacklist_add()

Paul Bolle (1):
      Bluetooth: btusb: be quiet on device disconnect

Peter Hurley (15):
      Bluetooth: rfcomm: Remove unnecessary krfcommd event
      Bluetooth: rfcomm: Fix lost wakeups waiting to accept socket
      Bluetooth: Fix lost wakeups waiting for sock state change
      Bluetooth: l2cap: Fix lost wakeups waiting to accept socket
      Bluetooth: sco: Fix lost wakeups waiting to accept socket
      Bluetooth: bnep: Fix lost wakeup of session thread
      Bluetooth: cmtp: Fix lost wakeup of session thread
      Bluetooth: l2cap: Fix lost wakeup waiting for ERTM acks
      Bluetooth: bnep: Fix deadlock in session deletion
      Bluetooth: cmtp: Fix deadlock in session deletion
      Bluetooth: hidp: Fix session cleanup on failed conn add
      Bluetooth: hidp: Fix memory leak of cached report descriptor
      Bluetooth: hidp: Only free input device if failed register
      Bluetooth: hidp: Don't release device ref if never held
      Bluetooth: cmtp: Fix session cleanup on failed conn add

Ricardo Mendoza (1):
      Bluetooth: Add Toshiba laptops AR30XX device ID

Szymon Janc (1):
      Bluetooth: Don't use cmd_timer to timeout HCI reset command

 drivers/bluetooth/ath3k.c    |    1 +
 drivers/bluetooth/btusb.c    |   13 ++++++++++---
 net/bluetooth/af_bluetooth.c |    6 +++---
 net/bluetooth/bnep/bnep.h    |    1 +
 net/bluetooth/bnep/core.c    |   13 ++++++++-----
 net/bluetooth/cmtp/capi.c    |    3 ++-
 net/bluetooth/cmtp/cmtp.h    |    1 +
 net/bluetooth/cmtp/core.c    |   20 ++++++++++++--------
 net/bluetooth/hci_core.c     |    8 +++++---
 net/bluetooth/hidp/core.c    |   19 +++++++++----------
 net/bluetooth/l2cap_core.c   |    6 +++---
 net/bluetooth/l2cap_sock.c   |   30 +++++++++++++++---------------
 net/bluetooth/rfcomm/core.c  |   17 +++++++----------
 net/bluetooth/rfcomm/sock.c  |   28 ++++++++++++++--------------
 net/bluetooth/sco.c          |   28 ++++++++++++++--------------
 15 files changed, 105 insertions(+), 89 deletions(-)
