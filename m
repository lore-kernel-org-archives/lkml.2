Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab2IUTtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:49:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52461 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab2IUTs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:48:56 -0400
Date: Fri, 21 Sep 2012 15:48:53 -0400 (EDT)
Message-Id: <20120921.154853.2298914541794501981.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8LJn7bR011917


More bug fixes, nothing gets past these guys:

1) More kernel info leaks found by Mathias Krause, this time in the
   IPSEC configuration layers.

2) When IPSEC policies change, we do not properly make sure that
   cached routes (which could now be stale) throughout the system will
   be revalidated.  Fix this by generalizing the generation count
   invalidation scheme used by ipv4.  From Nicolas Dichtel.

3) When repairing TCP sockets, we need to allow to restore not just
   the send window scale, but the receive one too.  Extend the
   existing interface to achieve this in a backwards compatible way.
   From Andrey Vagin.

4) A fix for FCOE scatter gather feature validation erroneously
   caused scatter gather to be disabled for things like AOE too.
   From Ed L. Cashin.

5) Several cases of mishandling of error pointers, from Mathias Krause,
   Wei Yongjun, and Devendra Naga.

6) Fix gianfar build, from Richard Cochran.

7) CAP_NET_* failures should return -EPERM not -EACCES, from Zhao
   Hongjiang.

8) Hardware reset fix in janz-ican3 CAN driver, from Ira W. Snyder.

9) Fix oops during rmmod in ti_hecc CAN driver, from Marc Kleine-Budde.

10) The removal of the conditional compilation of the clk support code
    in the stmmac driver broke things.  This is because the interfaces
    used are the ones that don't also perform the enable/disable of
    the clk.  Fix from Stefan Roese.

11) The QFQ packet scheduler can record out of range virtual start
    times, resulting later in misbehavior and even crashes.  Fix
    from Paolo Valente.

12) If MSG_WAITALL is used with IOAT DMA under TCP, we can wedge the
    receiver when the advertised receive window goes to zero.  Detect
    this case and force the processing of the IOAT DMA queue when it
    happens to avoid getting stuck.  Fix from Michal Kubecek.

13) batman-adv assumes that test_bit() returns only 0 or 1, but this
    is not true for x86 (which returns -1 or 0, via the 'sbb'
    instruction).  Fix from Linus Lussing.

14) Fix small packet corruption in e1000, from Tushar Dave.

15) make_blackhole() in the IPSEC policy code can do one read unlock
    too many, fix from Li RongQing.

16) The new tcp_try_coalesce() code introduced a bug in TCP URG handling,
    fix from Eric Dumazet.

17) Fix memory leak in __netif_receive_skb() when doing zerocopy and
    when hit an OOM condition.  From Michael S. Tsirkin.

18) netxen blindly deferences pdev->bus->self, which is not guarenteed
    to be non-NULL.  Fix from Nikolay Aleksandrov.

19) Fix a performance regression caused by mistakes in ipv6 checksum
    validation in the bnx2x driver, fix from Michal Schmidt.

Please pull, thanks a lot!

The following changes since commit 3f0c3c8fe30c725c1264fb6db8cc4b69db3a658a:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes (2012-09-14 18:05:14 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to a630844d898ae8a0b4a3db84af061150682e0d3c:

  net/stmmac: Use clk_prepare_enable and clk_disable_unprepare (2012-09-21 14:59:52 -0400)

----------------------------------------------------------------
Andrey Vagin (1):
      tcp: restore rcv_wscale in a repair mode (v2)

Arend van Spriel (1):
      brcmsmac: fix mismatch in number of custom regulatory rules

Ariel Elior (1):
      bnx2x: remove false warning regarding interrupt number

BjÃ¸rn Mork (1):
      net: qmi_wwan: adding Huawei E367, ZTE MF683 and Pantech P4200

Colin Ian King (1):
      brcm80211: fix missing allocation failure check

David S. Miller (2):
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless
      Merge branch 'fixes-for-3.6' of git://gitorious.org/linux-can/linux-can

Devendra Naga (1):
      at91ether: return PTR_ERR if call to clk_get fails

Ed L. Cashin (2):
      aoe: assert AoE packets marked as requiring no checksum
      net: do not disable sg for packets requiring no checksum

Eric Dumazet (2):
      net: rt_cache_flush() cleanup
      tcp: fix regression in urgent data handling

Felix Fietkau (1):
      ath9k: make PA linearization optional, disabled by default and fix checks

Hante Meuleman (2):
      brcmfmac: fix big endian bug in i-scan.
      brcmfmac: Fix big endian host configuration data.

Ira W. Snyder (1):
      can: janz-ican3: fix support for older hardware revisions

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Larry Finger (1):
      rtlwifi: rtl8192ce: Log message that B_CUT device may not work

Li RongQing (2):
      xfrm: fix a read lock imbalance in make_blackhole
      net/core: fix comment in skb_try_coalesce

Linus LÃ¼ssing (1):
      batman-adv: make batadv_test_bit() return 0 or 1 only

Marc Kleine-Budde (1):
      can: ti_hecc: fix oops during rmmod

Mathias Krause (8):
      xfrm_user: return error pointer instead of NULL
      xfrm_user: return error pointer instead of NULL #2
      xfrm_user: fix info leak in copy_to_user_auth()
      xfrm_user: fix info leak in copy_to_user_state()
      xfrm_user: fix info leak in copy_to_user_policy()
      xfrm_user: fix info leak in copy_to_user_tmpl()
      xfrm_user: ensure user supplied esn replay window is valid
      xfrm_user: don't copy esn replay window twice for new states

Michael S. Tsirkin (1):
      net: fix memory leak on oom with zerocopy

Michal KubeÄek (1):
      tcp: flush DMA queue before sk_wait_data if rcv_wnd is zero

Michal Schmidt (1):
      bnx2x: fix rx checksum validation for IPv6

Nicolas Dichtel (5):
      ipv4/route: arg delay is useless in rt_cache_flush()
      netns: move net->ipv4.rt_genid to net->rt_genid
      xfrm: invalidate dst on policy insertion/deletion
      ipv6: use net->rt_genid to check dst validity
      ipv6: use DST_* macro to set obselete field

Nikolay Aleksandrov (1):
      netxen: check for root bus in netxen_mask_aer_correctable

Paolo Valente (1):
      pkt_sched: fix virtual-start-time update in QFQ

Richard Cochran (1):
      gianfar: fix phc index build failure

Stefan Roese (1):
      net/stmmac: Use clk_prepare_enable and clk_disable_unprepare

SÃ¸ren holm (1):
      asix: Support DLink DUB-E100 H/W Ver C1

Tushar Dave (1):
      e1000: Small packets may get corrupted during padding by HW

Wei Yongjun (3):
      ipv6: fix return value check in fib6_add()
      stmmac: fix return value check in stmmac_open_ext_timer()
      net/irda: sh_sir: fix return value check in sh_sir_set_baudrate()

Zhao Hongjiang (1):
      net: change return values from -EACCES to -EPERM

 drivers/block/aoe/aoecmd.c                             |  1 +
 drivers/net/can/janz-ican3.c                           |  4 +---
 drivers/net/can/ti_hecc.c                              |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c        | 12 +++++++-----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c       | 11 ++++++-----
 drivers/net/ethernet/cadence/at91_ether.c              |  2 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c       |  1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c           |  4 ++--
 drivers/net/ethernet/intel/e1000/e1000_main.c          | 11 +++++++++++
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c   |  4 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c      | 10 +++++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac_timer.c     |  8 ++++----
 drivers/net/irda/sh_sir.c                              |  2 +-
 drivers/net/usb/asix_devices.c                         |  4 ++++
 drivers/net/usb/qmi_wwan.c                             | 11 ++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c         |  4 ++++
 drivers/net/wireless/ath/ath9k/debug.c                 |  2 ++
 drivers/net/wireless/ath/ath9k/hw.c                    |  4 ----
 drivers/net/wireless/ath/ath9k/hw.h                    |  3 +--
 drivers/net/wireless/ath/ath9k/link.c                  |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c   | 26 ++++++++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  6 ++++--
 drivers/net/wireless/brcm80211/brcmsmac/channel.c      |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h           |  1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c            | 12 ++++++++++--
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c            |  6 ++++--
 include/linux/xfrm.h                                   |  2 ++
 include/net/ip6_fib.h                                  |  5 ++---
 include/net/net_namespace.h                            | 10 ++++++++++
 include/net/netns/ipv4.h                               |  1 -
 include/net/route.h                                    |  2 +-
 net/batman-adv/bitarray.h                              |  6 +++---
 net/bluetooth/bnep/sock.c                              |  4 ++--
 net/bluetooth/cmtp/sock.c                              |  4 ++--
 net/bluetooth/hci_sock.c                               | 16 ++++++++--------
 net/bluetooth/hidp/sock.c                              |  4 ++--
 net/core/dev.c                                         |  5 +++--
 net/core/skbuff.c                                      |  4 +++-
 net/ipv4/arp.c                                         |  2 +-
 net/ipv4/devinet.c                                     | 10 +++++-----
 net/ipv4/fib_frontend.c                                | 20 ++++++++++----------
 net/ipv4/fib_rules.c                                   |  2 +-
 net/ipv4/fib_trie.c                                    |  6 +++---
 net/ipv4/route.c                                       | 43 +++++--------------------------------------
 net/ipv4/tcp.c                                         | 23 ++++++++++++++++++-----
 net/ipv4/tcp_input.c                                   |  5 ++---
 net/ipv6/inet6_connection_sock.c                       | 23 +----------------------
 net/ipv6/ip6_fib.c                                     |  4 ++++
 net/ipv6/route.c                                       | 19 ++++++++++++-------
 net/netrom/af_netrom.c                                 |  2 +-
 net/sched/sch_qfq.c                                    |  5 ++++-
 net/xfrm/xfrm_policy.c                                 |  3 ++-
 net/xfrm/xfrm_user.c                                   | 57 ++++++++++++++++++++++++++++++++++++++++++---------------
 security/selinux/include/xfrm.h                        |  1 +
 55 files changed, 253 insertions(+), 192 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
