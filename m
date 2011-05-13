Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab1EMUlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:41:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45221 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab1EMUlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:41:19 -0400
Date: Fri, 13 May 2011 16:40:39 -0400 (EDT)
Message-Id: <20110513.164039.1294478950559992021.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 May 2011 13:40:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some stragglers, the bridging one is pretty important as it hits
virtualization users:

1) Do not run ipv4 options parser on ipv6 packets in bridging,
   from Stephen Hemminger.

2) Regression fix, changes to TOS/tclass handling made ECN stop
   being done on ipv6 connections.  Fix from Steinar H. Gunderson.

3) On-wire packets for bridging modes were defined in a way (lacking
   necessary __packed directives), such that they didn't work properly
   on some architectures (namely, ARM).  Fix from Vitalii Demianets.

4) Long ago net_device_ops conversion broke several m68k drivers
   based upon the 8390 infrastructure.  Fix from Geert Uytterhoeven.

5) SFC needs to map certain chip memory as uncacheable, from Ben
   Hutchings.

6) Memory hotplug oops fix in ehea driver from Anton Blanchard.

7) IBSS oops fix in intel wireless drivers, from Stanislaw Gruszka.

8) Command pending queue locking fix in libertas.

Please pull, thanks a lot!

The following changes since commit 3568bd9720b4a775f28a718fcbb462ce2f386988:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-05-11 19:13:34 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Anton Blanchard (1):
      ehea: Fix memory hotplug oops

Ben Hutchings (1):
      sfc: Always map MCDI shared memory as uncacheable

David S. Miller (2):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'sfc-2.6.39' of git://git.kernel.org/.../bwh/sfc-2.6

Geert Uytterhoeven (3):
      zorro8390: Fix regression caused during net_device_ops conversion
      hydra: Fix regression caused during net_device_ops conversion
      ne-h8300: Fix regression caused during net_device_ops conversion

Luciano Coelho (1):
      mac80211: don't start the dynamic ps timer if not associated

Mohammed Shafi Shajakhan (1):
      ath9k: Fix a warning due to a queued work during S3 state

Paul Fox (1):
      libertas: fix cmdpendingq locking

Stanislaw Gruszka (1):
      iwlegacy: fix IBSS mode crashes

Steinar H. Gunderson (1):
      ipv6: restore correct ECN handling on TCP xmit

Stephen Hemminger (1):
      bridge: fix forwarding of IPv6

Vitalii Demianets (1):
      bonding,llc: Fix structure sizeof incompatibility for some PDUs

 drivers/net/Makefile                     |    6 ++--
 drivers/net/bonding/bond_3ad.h           |   10 +++---
 drivers/net/ehea/ehea_main.c             |    6 ++--
 drivers/net/hydra.c                      |   14 ++++----
 drivers/net/ne-h8300.c                   |   16 +++++-----
 drivers/net/sfc/mcdi.c                   |   49 ++++++++++++++++++-----------
 drivers/net/sfc/nic.h                    |    2 +
 drivers/net/sfc/siena.c                  |   25 +++++++++++++--
 drivers/net/wireless/ath/ath9k/main.c    |    8 +++++
 drivers/net/wireless/iwlegacy/iwl-core.c |    7 ++++
 drivers/net/wireless/iwlegacy/iwl-dev.h  |    6 ++++
 drivers/net/wireless/libertas/cmd.c      |    6 ++-
 drivers/net/zorro8390.c                  |   12 ++++----
 include/net/inet_ecn.h                   |   16 ++++++++--
 include/net/llc_pdu.h                    |    8 ++--
 net/bridge/br_netfilter.c                |    2 +-
 net/mac80211/tx.c                        |    4 ++
 17 files changed, 132 insertions(+), 65 deletions(-)
