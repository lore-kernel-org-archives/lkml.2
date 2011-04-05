Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1DEF1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 01:27:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59034
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1DEF1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:27:50 -0400
Date: Mon, 04 Apr 2011 22:27:13 -0700 (PDT)
Message-Id: <20110404.222713.84392579.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p355S0hP023774


1) TCP ipv6 mis-interprets error pointer, from Boris Ostrovsky.

2) Ease a BUG() into a warning in TCP, from Ilpo J√§rvinen.

3) SCTP under-allocates asconf-ack chunks, from Wei Yongjun.

4) fix dev_ethtool_get_rx_csum() NETIF_F_RXCSUM handling, from
   Micha≈Ç Miros≈Çaw.

5) Add some device IDs to rt2x00, from Xose Vazquez Perez.

6) starfire dma_addr_t size test no longer needs to be a mess, from
   FUJITA Tomonori.

Please pull, thanks a lot!

The following changes since commit d7c764c4c7b782c660b4600b0bff2e3509892a4d:

  Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-04-04 08:37:45 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Andrei Emeltchenko (1):
      Bluetooth: delete hanging L2CAP channel

Arnd Bergmann (1):
      usbnet: use eth%d name for known ethernet devices

Boris Ostrovsky (1):
      ipv6: Don't pass invalid dst_entry pointer to dst_release().

Christian Lamparter (1):
      carl9170: Fix tx aggregation problems with some clients

Daniel Halperin (1):
      mac80211: fix aggregation frame release during timeout

David S. Miller (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

FUJITA Tomonori (1):
      starfire: clean up dma_addr_t size test

Felix Fietkau (2):
      mac80211: fix a crash in minstrel_ht in HT mode with no supported MCS rates
      ath9k: fix a chip wakeup related crash in ath9k_start

Gustavo F. Padovan (1):
      Bluetooth: Fix HCI_RESET command synchronization

Ilpo J√§rvinen (1):
      tcp: len check is unnecessarily devastating, change to WARN_ON

Johan Hedberg (1):
      Bluetooth: Fix missing hci_dev_lock_bh in user_confirm_reply

Johannes Berg (1):
      iwlegacy: fix bugs in change_interface

Juuso Oikarinen (1):
      cfg80211: fix BSS double-unlinking (continued)

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Mariusz Kozlowski (3):
      mac80211: fix possible NULL pointer dereference
      cfg80211:: fix possible NULL pointer dereference
      mlx4: fix kfree on error path in new_steering_entry()

Micha≈Ç Miros≈Çaw (1):
      net: Fix dev dev_ethtool_get_rx_csum() for forced NETIF_F_RXCSUM

Petr ≈†tetiar (1):
      mac80211: fix NULL pointer dereference in ieee80211_key_alloc()

Stanislaw Gruszka (2):
      iwl3945: do not deprecate software scan
      iwl3945: disable hw scan by default

Suraj Sumangala (1):
      Bluetooth: Increment unacked_frames count only the first transmit

Thomas Gleixner (1):
      Bluetooth: Fix warning with hci_cmd_timer

Vinicius Costa Gomes (1):
      Bluetooth: Fix sending LE data over USB

Wei Yongjun (2):
      sctp: fix auth_hmacs field's length of struct sctp_cookie
      sctp: malloc enough room for asconf-ack chunk

Xose Vazquez Perez (1):
      wireless: rt2x00: rt2800usb.c add and identify ids

 drivers/bluetooth/btusb.c                    |    6 ++++-
 drivers/net/mlx4/mcg.c                       |    4 +-
 drivers/net/starfire.c                       |    6 +----
 drivers/net/usb/cdc_eem.c                    |    2 +-
 drivers/net/usb/cdc_ether.c                  |    2 +-
 drivers/net/usb/cdc_ncm.c                    |    2 +-
 drivers/net/usb/cdc_subset.c                 |    8 ++++++
 drivers/net/usb/gl620a.c                     |    2 +-
 drivers/net/usb/net1080.c                    |    2 +-
 drivers/net/usb/plusb.c                      |    2 +-
 drivers/net/usb/rndis_host.c                 |    2 +-
 drivers/net/usb/usbnet.c                     |    3 +-
 drivers/net/usb/zaurus.c                     |    8 +++---
 drivers/net/wireless/ath/ath9k/main.c        |    4 +++
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/main.c     |    1 +
 drivers/net/wireless/ath/carl9170/tx.c       |    7 ++++++
 drivers/net/wireless/iwlegacy/iwl-core.c     |   10 ++++++++
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    7 ++---
 drivers/net/wireless/rt2x00/rt2800usb.c      |   10 ++++++--
 include/linux/netdevice.h                    |    4 +-
 include/linux/usb/usbnet.h                   |    2 +
 include/net/bluetooth/hci.h                  |    2 +
 include/net/sctp/structs.h                   |    2 +-
 net/bluetooth/hci_core.c                     |   10 ++++++-
 net/bluetooth/hci_event.c                    |    4 ++-
 net/bluetooth/l2cap_core.c                   |    4 ++-
 net/bluetooth/l2cap_sock.c                   |    5 ++-
 net/bluetooth/mgmt.c                         |    2 +
 net/ipv4/tcp_output.c                        |    3 +-
 net/ipv6/tcp_ipv6.c                          |    1 +
 net/mac80211/key.c                           |    7 +++--
 net/mac80211/rc80211_minstrel_ht.c           |   25 +++++++++++++++------
 net/mac80211/rx.c                            |    3 +-
 net/sctp/sm_make_chunk.c                     |    4 +-
 net/wireless/scan.c                          |   31 +++++++++++++++++--------
 36 files changed, 138 insertions(+), 60 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
