Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1GPRne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 13:43:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35940 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GPRnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 13:43:32 -0400
Date: Sat, 16 Jul 2011 10:43:25 -0700 (PDT)
Message-Id: <20110716.104325.1217042780857481057.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 16 Jul 2011 10:43:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6GHhmge031366


A small batch of fixes:

1) Fix two regressions in checksum offload handling.
   a) Do not set SCTP packets to CHECKSUM_UNNECESSARY, we don't
      have software fallbacks in the TX path for SCTP checksumming
      and therefore won't be able to handle a divert of a packet
      from a device that can do SCTP checksums to one that cannot.
   b) We propagate certain hardware offloads transparently through
      "software" devices (like vlan and bonding) but we cannot do
      that when we lack software fallbacks in the TX path and this
      is relevant for SCTP and FCoE checksumming.  Get rid of the
      NETIF_F_ALL_TX_OFFLOADS macro since it's misuse is what
      introduced this regression.

2) L2CAP bluetooth connection procedure regression fix from
   Gustavo F. Padovan.

3) L2CAP incomming connections can crash with defer_setup enabled
   because ->parent isn't setup yet, handle that properly.  Also
   from Gustavo.

4) gianfar driver need to be more selective of when the RX parser
   of the chip is enabled, from Sebastian Poehn.

5) r6040 NAPI logic has a bug that can disabled interrupts forever,
   fix from Michael Thalmeier.

Please pull, thanks a lot!

The following changes since commit 1765a367a3b5d5e9692949b0c5ec933eff2c0701:

  Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-07-15 18:03:30 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Gustavo F. Padovan (1):
      Bluetooth: Fix regression in L2CAP connection procedure

Ilia Kolomisnky (1):
      Bluetooth: Fix crash with incoming L2CAP connections

Michael Thalmeier (1):
      r6040: only disable RX interrupt if napi_schedule_prep is successful

MichaÅ‚ MirosÅ‚aw (2):
      net: sctp: fix checksum marking for outgoing packets
      net: remove NETIF_F_ALL_TX_OFFLOADS

Sebastian PÃ¶hn (1):
      gianfar: rx parser

 drivers/net/bonding/bond_main.c |    6 +++---
 drivers/net/gianfar.c           |   24 +++++++++++++++++++-----
 drivers/net/gianfar.h           |    3 ++-
 drivers/net/r6040.c             |    8 +++++---
 include/linux/netdevice.h       |    6 ------
 net/8021q/vlan_dev.c            |    6 +++++-
 net/bluetooth/l2cap_core.c      |    9 +++++----
 net/sctp/output.c               |   19 ++++++++-----------
 8 files changed, 47 insertions(+), 34 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
