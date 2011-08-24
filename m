Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1HXEqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:46:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41007 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HXEqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:46:39 -0400
Date: Tue, 23 Aug 2011 21:46:33 -0700 (PDT)
Message-Id: <20110823.214633.35980203609378871.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 23 Aug 2011 21:46:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7O4kr8U030406


As is usually the case at this point, we're fixing driver problems
and small minor regressions elsewhere:

1) Several rt2x00 bug fixes from Stanislaw Gruszka:
   a) Cure oops in rt2800usb_write_tx_desc().
   b) Fix flag check order in rt2800usb_work_txdone otherwise we might
      skip ready entries.
   c) Fix oops in rt2800usb_get_txwi.

2) usbnet cdc_nacm driver DMAs stack variables, fix from Josh Boyer.

3) On gianfar, even when VLAN HW offload is disabled, descriptors
   still set VLAN bit, make sure we ignore it in that situation and
   don't accidently think the card offloaded VLAN header stripping.
   Fix from Jiri Pirko.

4) IPV6 SIT tunnels don't propagate v6 transport class to the ipv4
   type of service when they should, fix from Lionel Elie Mamane.

5) Port mirror/redirect doesn't propagate xmit codes to caller, fix
   from Jamal Hadi Salim.

6) Fix changing bonding mode from backup to round-robin, from Weiping Pan.

7) Fix erroneous non-tagged packet filtering in via-velocity, from Jiri
   Pirko.

8) Like we did for ipv4's IP_PKTOPTIONS, we have to make ipv6's
   IPV6_2292PKTOPTIONS handle compat mode properly too.  From Daniel Baluta.

9) Fix accidental reintroduce of skb->dev==NULL oopser in ATM's br2684.
   From Daniel Schwierzeck.

10) Fix device leak in bridging, from Eric Dumazet.

11) Memory leak fix in wl12xx wireless, from Julia Lawall.

12) FCOE memory leak for DDP packets in ixgbe from Alexander Duyck.

13) Fix half-duplex mode with some chips in e1000e, from Bruce Allan.

14) 82579 e1000e chip can drop packets at 100Mbps, workaround by increasing
    PLL counter to trick the PHY, from Bruce Allan.

15) Fix e1000e conflicts with Management Engine that can corrupt the
    TX and RX tail pointers.  Also from Bruce Allan.

16) Revert one iwlagn change, and part of another, to fix sysfs private
    handling and eliminating a bad pointer oops on unload, from
    Emmanuel Grumbach.

17) In vmxnet3 do not enable vlan filters in promisc mode, from Jesse Gross.

18) Fix double free in sja1000 CAN driver, from Julia Lawall.

19) Fix build due to missing include in sh_eth.c, from Nobuhiro Iwamatsu.

20) gfar_ethflow_to_filter_table() uses more than 2K of stack space, fix
    from Wang Shaoyan.

21) Hopefully fix Ingo's forcedeth vlan regression, from Jiri Pirko.

22) vlan_untag() needs to reset SKB header pointers, from Jiri Pirko.

Please pull, thanks a lot!

The following changes since commit 14c62e78dc1379185515be41903c4a667efc6d54:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-08-23 18:09:08 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net.git master

Alexander Duyck (1):
      ixgbe: Fix FCOE memory leak for DDP packets

Bruce Allan (3):
      e1000e: Spurious interrupts & dropped packets with 82577/8/9 in half-duplex
      e1000e: workaround for packet drop on 82579 at 100Mbps
      e1000e: workaround invalid Tx/Rx tail descriptor register write

Daniel Baluta (1):
      ipv6: Fix ipv6_getsockopt for IPV6_2292PKTOPTIONS

Daniel Schwierzeck (1):
      atm: br2684: Fix oops due to skb->dev being NULL

David S. Miller (2):
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless

Emmanuel Grumbach (2):
      Revert "iwlagn: sysfs couldn't find the priv pointer"
      iwlagn: sysfs couldn't find the priv pointer

Eric Dumazet (1):
      bridge: fix a possible net_device leak

Geoffrey Thomas (1):
      net: Documentation: RFC 2553bis is now RFC 3493

Jamal Hadi Salim (1):
      net_sched: fix port mirror/redirect stats reporting

Jesse Gross (1):
      vmxnet3: Don't enable vlan filters in promiscuous mode.

Jiri Pirko (4):
      gianfar: prevent buggy hw rx vlan tagging
      via-velocity: remove non-tagged packet filtering
      forcedeth: call vlan_mode only if hw supports vlans
      vlan: reset headers on accel emulation path

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Josh Boyer (1):
      usbnet/cdc_ncm: Don't use stack variables for DMA

Julia Lawall (2):
      drivers/net/wireless/wl12xx: add missing kfree
      drivers/net/can/sja1000/plx_pci.c: eliminate double free

Lionel Elie Mamane (1):
      sit tunnels: propagate IPv6 transport class to IPv4 Type of Service

Nobuhiro Iwamatsu (1):
      net: sh_eth: Fix build by forgot including linux/interrupt.h

Peter Pan(æ½˜å«å¹³) (1):
      bonding:reset backup and inactive flag of slave

Stanislaw Gruszka (3):
      rt2x00: fix crash in rt2800usb_write_tx_desc
      rt2x00: fix order of entry flags modification
      rt2x00: fix crash in rt2800usb_get_txwi

Wang Shaoyan (1):
      gianfar: reduce stack usage in gianfar_ethtool.c

Willem de Bruijn (3):
      net: add missing entries to Documentation/networking/00-INDEX
      net: minor update to Documentation/networking/scaling.txt
      net: netdev-features.txt update to Documentation/networking/00-INDEX

 Documentation/networking/00-INDEX       |  116 +++++++++++++++++++++++++++++++
 Documentation/networking/ip-sysctl.txt  |    2 +-
 Documentation/networking/scaling.txt    |   23 ++++--
 drivers/net/bonding/bond_main.c         |   18 +++++
 drivers/net/can/sja1000/plx_pci.c       |    4 +-
 drivers/net/e1000e/e1000.h              |    4 +
 drivers/net/e1000e/ich8lan.c            |   65 ++++++++++++++----
 drivers/net/e1000e/netdev.c             |   80 ++++++++++++++++++++-
 drivers/net/forcedeth.c                 |    3 +-
 drivers/net/gianfar.c                   |    9 ++-
 drivers/net/gianfar_ethtool.c           |   26 ++++++--
 drivers/net/ixgbe/ixgbe_main.c          |    4 +-
 drivers/net/sh_eth.c                    |    1 +
 drivers/net/usb/cdc_ncm.c               |   47 ++++++++++---
 drivers/net/via-velocity.c              |    4 -
 drivers/net/vmxnet3/vmxnet3_drv.c       |   34 +++++----
 drivers/net/wireless/iwlwifi/iwl-pci.c  |   25 +++----
 drivers/net/wireless/rt2x00/rt2800usb.c |   20 ++++--
 drivers/net/wireless/rt2x00/rt2x00usb.c |   17 ++---
 drivers/net/wireless/wl12xx/acx.c       |    6 +--
 drivers/net/wireless/wl12xx/testmode.c  |    5 +-
 net/8021q/vlan_core.c                   |    2 +
 net/atm/br2684.c                        |    7 +-
 net/bridge/br_if.c                      |    6 ++-
 net/ipv6/ipv6_sockglue.c                |    9 ++-
 net/ipv6/sit.c                          |    3 +
 net/sched/act_mirred.c                  |    3 +-
 27 files changed, 433 insertions(+), 110 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
