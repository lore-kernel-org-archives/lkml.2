Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1F3BS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:18:58 -0400
Received: from mail.perches.com ([173.55.12.10]:3334 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab1F3BSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:18:53 -0400
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] bluetooth: Use current logging styles
Date: Wed, 29 Jun 2011 18:18:28 -0700
Message-Id: <cover.1309396408.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <1309370457.2208.48.camel@aeonflux>
References: <1309370457.2208.48.camel@aeonflux>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 11:00 -0700, Marcel Holtmann wrote:
> I did not know that. Then we might should go ahead and also cleanup the
> Bluetooth subsystem.
> 
> We do use an implied "Bluetooth: " prefix when calling BT_INFO, but that
> can be easily changed to bt_info() as well since I do not care about
> that part. 
> 
> The Bluetooth subsystem has a Linux 2.4 legacy history and a lot of
> things can be done a lot nicer these days.

Here you go Marcel.

It reduces code/text a couple/few percent too.
 
Joe Perches (2):
  bluetooth: Rename function bt_err to bt_to_errno
  bluetooth: Add bt_printk, convert logging macros to lower case

 drivers/bluetooth/ath3k.c          |   48 ++++----
 drivers/bluetooth/bcm203x.c        |   38 +++---
 drivers/bluetooth/bfusb.c          |   94 +++++++-------
 drivers/bluetooth/bluecard_cs.c    |   18 ++--
 drivers/bluetooth/bpa10x.c         |   38 +++---
 drivers/bluetooth/bt3c_cs.c        |   34 +++---
 drivers/bluetooth/btmrvl_debugfs.c |    2 +-
 drivers/bluetooth/btmrvl_main.c    |   74 ++++++------
 drivers/bluetooth/btmrvl_sdio.c    |  112 +++++++++---------
 drivers/bluetooth/btsdio.c         |   26 ++--
 drivers/bluetooth/btuart_cs.c      |   24 ++--
 drivers/bluetooth/btusb.c          |   64 +++++-----
 drivers/bluetooth/btwilink.c       |   34 +++---
 drivers/bluetooth/dtl1_cs.c        |   20 ++--
 drivers/bluetooth/hci_ath.c        |   14 +-
 drivers/bluetooth/hci_bcsp.c       |   58 +++++-----
 drivers/bluetooth/hci_h4.c         |   18 ++--
 drivers/bluetooth/hci_ldisc.c      |   36 +++---
 drivers/bluetooth/hci_ll.c         |   76 ++++++------
 drivers/bluetooth/hci_vhci.c       |    8 +-
 include/net/bluetooth/bluetooth.h  |   11 +-
 net/bluetooth/af_bluetooth.c       |   20 ++--
 net/bluetooth/bnep/core.c          |   26 ++--
 net/bluetooth/bnep/netdev.c        |   14 +-
 net/bluetooth/bnep/sock.c          |   10 +-
 net/bluetooth/cmtp/capi.c          |   46 ++++----
 net/bluetooth/cmtp/core.c          |   30 +++---
 net/bluetooth/cmtp/sock.c          |   10 +-
 net/bluetooth/hci_conn.c           |   52 ++++----
 net/bluetooth/hci_core.c           |  142 +++++++++++-----------
 net/bluetooth/hci_event.c          |  234 ++++++++++++++++++------------------
 net/bluetooth/hci_sock.c           |   26 ++--
 net/bluetooth/hci_sysfs.c          |   12 +-
 net/bluetooth/hidp/core.c          |   50 ++++----
 net/bluetooth/hidp/sock.c          |   10 +-
 net/bluetooth/l2cap_core.c         |  172 +++++++++++++-------------
 net/bluetooth/l2cap_sock.c         |   40 +++---
 net/bluetooth/lib.c                |   23 ++++-
 net/bluetooth/mgmt.c               |   80 ++++++------
 net/bluetooth/rfcomm/core.c        |  152 ++++++++++++------------
 net/bluetooth/rfcomm/sock.c        |   56 +++++-----
 net/bluetooth/rfcomm/tty.c         |  100 ++++++++--------
 net/bluetooth/sco.c                |   84 +++++++-------
 net/bluetooth/smp.c                |   30 +++---
 44 files changed, 1144 insertions(+), 1122 deletions(-)

-- 
1.7.6.rc1

