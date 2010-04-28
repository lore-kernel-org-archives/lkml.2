Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab0D1Thh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:37:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57499
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab0D1Thf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:37:35 -0400
Date: Wed, 28 Apr 2010 12:37:41 -0700 (PDT)
Message-Id: <20100428.123741.189712262.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3SJf4mE021942


Mainly I'm pushing this to revert the TCP bind() bug fix, it's
causing too much fallout to try and sort out this late in the
-rc series.

Bunch of OOPS'ers for SCTP, Intel chip fixes (lack of PHY powerdown in
ixgbe lets crap into chip FIFO wedging the chip completely, etc.), a
regression fix for tg3 on systems that do run out of MSI vectors, bnx2
driver fixes (lost MSI-X vectors, 'scheduling while atomic' fix) and
hopefully r8169 MAC address programming is solid now.

Please pull, thanks a lot!

The following changes since commit b91ce4d14a21fc04d165be30319541e0f9204f15:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Andre Detsch (2):
      tg3: Fix INTx fallback when MSI fails
      cxgb3: Wait longer for control packets on initialization

Andreas Hartmann (1):
      drivers/usb/net/kaweth.c: add device "Allied Telesyn AT-USB10 USB Ethernet Adapter"

Andy Fleming (1):
      gianfar: Wait for both RX and TX to stop

Ben Hutchings (3):
      sfc: Wait at most 10ms for the MC to finish reading out MAC statistics
      sfc: Always close net device at the end of a disabling reset
      sfc: Change falcon_probe_board() to fail for unsupported boards

Bruce Allan (1):
      e1000e: enable/disable ASPM L0s and L1 and ERT according to hardware errata

Dan Carpenter (2):
      ipheth: potential null dereferences on error path
      bluetooth: handle l2cap_create_connless_pdu() errors

David S. Miller (1):
      Revert "tcp: bind() fix when many ports are bound"

Elina Pasheva (1):
      net/usb: add sierra_net.c driver

Ken Kawasaki (1):
      smc91c92_cs: spin_unlock_irqrestore before calling smc_interrupt()

Michael Chan (3):
      bnx2: Fix lost MSI-X problem on 5709 NICs.
      bnx2: Prevent "scheduling while atomic" warning with cnic, bonding and vlan.
      bnx2: Update version to 2.0.9.

Peter Waskiewicz (1):
      ixgbe: Power down PHY during driver resets

Stefan Schmidt (1):
      ieee802154: Fix oops during ieee802154_sock_ioctl

Torgny Johansson (1):
      cdc_ether: fix autosuspend for mbm devices

Vlad Yasevich (3):
      sctp: fix potential reference of a freed pointer
      sctp: per_cpu variables should be in bh_disabled section
      sctp: Fix oops when sending queued ASCONF chunks

Wei Yongjun (2):
      sctp: avoid irq lock inversion while call sk->sk_data_ready()
      sctp: fix to calc the INIT/INIT-ACK chunk length correctly is set

YOSHIFUJI Hideaki / å‰è—¤è‹±æ˜ (1):
      bridge br_multicast: Ensure to initialize BR_INPUT_SKB_CB(skb)->mrouters_only.

franÃ§ois romieu (2):
      r8169: failure to enable mwi should not be fatal
      r8169: more broken register writes workaround

 drivers/net/bnx2.c               |   48 +-
 drivers/net/cxgb3/cxgb3_main.c   |    2 +-
 drivers/net/e1000e/82571.c       |   20 +-
 drivers/net/e1000e/e1000.h       |    5 +-
 drivers/net/e1000e/netdev.c      |   70 ++-
 drivers/net/gianfar.c            |    6 +-
 drivers/net/ixgbe/ixgbe_82599.c  |   62 ++-
 drivers/net/ixgbe/ixgbe_main.c   |   22 +-
 drivers/net/ixgbe/ixgbe_type.h   |    2 +
 drivers/net/pcmcia/smc91c92_cs.c |   31 +-
 drivers/net/r8169.c              |   32 +-
 drivers/net/sfc/efx.c            |    4 +-
 drivers/net/sfc/falcon.c         |    4 +-
 drivers/net/sfc/falcon_boards.c  |   13 +-
 drivers/net/sfc/nic.h            |    2 +-
 drivers/net/sfc/siena.c          |   13 +-
 drivers/net/tg3.c                |    1 +
 drivers/net/usb/Kconfig          |   10 +
 drivers/net/usb/Makefile         |    1 +
 drivers/net/usb/cdc_ether.c      |    1 +
 drivers/net/usb/ipheth.c         |   15 +-
 drivers/net/usb/kaweth.c         |    1 +
 drivers/net/usb/sierra_net.c     | 1001 ++++++++++++++++++++++++++++++++++++++
 include/net/sctp/command.h       |    1 +
 include/net/sctp/sctp.h          |    1 +
 net/bluetooth/l2cap.c            |    5 +-
 net/bridge/br_multicast.c        |    6 +-
 net/ieee802154/af_ieee802154.c   |    3 +
 net/ipv4/inet_connection_sock.c  |   16 +-
 net/ipv6/inet6_connection_sock.c |   15 +-
 net/sctp/associola.c             |    6 +-
 net/sctp/endpointola.c           |    1 +
 net/sctp/sm_make_chunk.c         |   32 +-
 net/sctp/sm_sideeffect.c         |   26 +
 net/sctp/sm_statefuns.c          |    8 +-
 net/sctp/socket.c                |   14 +-
 36 files changed, 1312 insertions(+), 188 deletions(-)
 create mode 100644 drivers/net/usb/sierra_net.c
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
