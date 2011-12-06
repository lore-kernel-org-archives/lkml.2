Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1LFT7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:59:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab1LFT7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:59:46 -0500
Date: Tue, 06 Dec 2011 14:59:43 -0500 (EST)
Message-Id: <20111206.145943.888247369587722446.davem@redhat.com>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB6K04Bh017255


1) RTO_ONLINK state bit can be lost in routing cache entries, fix from
   Julian Anastasov.

2) INET peer validation fix could result in an OOPS if the call fails,
   but allowing this operation to fail in the first place is the real
   issue.  If we can't lookup the neighbour for the new gateway, simply
   revert back to the old one.  We'll end up with another ICMP redirect
   but that's fine and better than failing and having to add ugly recovery
   code all over the place.

3) FIFO overflow and packet processing race fixes in r8169 from
   FranÃ§ois Reomieu.

4) pasemi_mac build was broken accidently, fix from Ben Hutchings.

5) cfg80211 wireless race fixes from Luis R. Rodriguez.

6) Reconfiguring HT40 after assosciation in iwlwifi results in a firmware
   abort, so don't do it.  From Wey-Yi Guy.

Please pull, thanks a lot.

The following changes since commit 45e713efe2fa574b6662e7fb63fae9497c5e03d4:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2011-12-05 16:54:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

Ben Hutchings (1):
      pasemi_mac: Fix building as module

David S. Miller (2):
      ipv4: Fix peer validation on cached lookup.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless

Johannes Berg (1):
      iwlagn: fix HW crypto for TX-only keys

John W. Linville (2):
      Revert "mac80211: clear sta.drv_priv on reconfiguration"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Julian Anastasov (1):
      ipv4: make sure RTO_ONLINK is saved in routing cache

Luis R. Rodriguez (2):
      cfg80211: fix race on init and driver registration
      cfg80211: amend regulatory NULL dereference fix

Peter Pan(æ½˜å«å¹³) (1):
      ipv4:correct description for tcp_max_syn_backlog

Simon Wunderlich (1):
      mac80211: fill rate filter for internal scan requests

Stephen Boyd (1):
      net: Silence seq_scale() unused warning

Wei Liu (1):
      netback: Fix alert message.

Wey-Yi Guy (2):
      iwlwifi: do not re-configure HT40 after associated
      iwlwifi: change the default behavior of watchdog timer

franÃ§ois romieu (2):
      r8169: Rx FIFO overflow fixes.
      r8169: fix Rx index race between FIFO overflow recovery and NAPI handler.

 Documentation/networking/ip-sysctl.txt      |   10 +++---
 drivers/net/ethernet/pasemi/Makefile        |    3 +-
 drivers/net/ethernet/realtek/r8169.c        |   53 ++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   36 ++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    5 ---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   34 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   22 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    4 +-
 drivers/net/xen-netback/netback.c           |    2 +-
 net/core/request_sock.c                     |    7 ++--
 net/core/secure_seq.c                       |    2 +
 net/ipv4/route.c                            |   47 ++++++++++--------------
 net/mac80211/main.c                         |    6 +++
 net/mac80211/util.c                         |    1 -
 net/wireless/reg.c                          |   49 ++++++++++++++++---------
 19 files changed, 155 insertions(+), 132 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
