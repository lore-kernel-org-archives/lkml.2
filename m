Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783Ab1ETTk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:40:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39517 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682Ab1ETTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:40:51 -0400
Date: Fri, 20 May 2011 15:40:18 -0400 (EDT)
Message-Id: <20110520.154018.2179070522483842907.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 20 May 2011 12:40:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4KJfNWE018824


There are two small conflicts to resolve when you merge this:

1) arch/sparc/x86/Kconfig

   Your tree has a change that removes a select on ARCH_NO_SYSDEV_OPS,
   we have one that adds a select on HAVE_BPF_JIT.  Kill the former,
   keep the latter.

2) net/mac80211/agg-tx.c

   Keep the ieee80211_assign_tid_tx() function, delete kfree_tid_tx().

   This is due to the kfree_rcu() changes in your tree.

Anyways in this installment:

1) An x86-64 JIT for BPF filters from Eric Dumazet.

2) More work towards making ipv4 route entries generic enough such that
   we can remove the routing cache and lookup routes directly in the
   routing table.  Maybe by 2.6.41 or 2.6.42 we'll be able to pull this
   off.

3) Preferred source address selection support for ipv6, from Daniel Walter.

4) Batched device unregister support in veth and macvlan, and also some
   RCU synchronization removals during device teardown from Eric Dumazet.

5) Support for running ICMP applications like 'ping' unprivileged, from
   Vasiliy Kulikov.

6) SCTP_GET_ASSOC_ID_LIST socket option support from Wei Yongjun.

7) Support for new chipsets in r8169, from hayeswang.

8) Use RCU locking in CAIF protocol stack, from sjur.brandeland

9) Add QFQ (quick fair queue) packet scheduler, from Stephen Hemminger.

10) Add netlink notifications to bridge layer, also from Stephen.

11) Fix device driver handling of ethtool triggered LED blinking,
    via a new ->set_phys_id() ethtool op.  All drivers converted and
    the old ->phys_id() ethtool op is deleted.  From Stephen Hemminger.

12) RCU conversions in Phonet layer, from R√©mi Denis-Courmont.

13) Many conversions of drivers over to netdev->hw_features, from
    Micha≈Ç Miros≈Çaw.

14) Support for placing interfaces into hardware loopback mode, from
    Mahesh Bandewar.

15) TSO and other bug fixes in r8169 from Francois Romieu.

16) Handle ECN bits more correctly in fragments on ipv4, from
    Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 257313b2a87795e07a0bdf58d0fffbdba8b31051:

  selinux: avoid unnecessary avc cache stat hit count (2011-05-19 21:22:53 -0700)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Adrian Chadd (1):
      ath9k: fix AR9160 xpaBiasLvlFreq endianness handling

Ajit Khaparde (11):
      be2net: add rxhash support
      be2net: use common method to check for sriov function type
      be2net: fix to get max VFs supported from adapter
      be2net: dynamically allocate adapter->vf_cfg
      be2net: call FLR after setup wol in be_shutdown
      be2net: allow register dump only for PFs
      be2net: Add code to display nic speeds other than 1Gbps/10Gbps
      be2net: fix be_mcc_compl_process to identify eth_get_stat command
      be2net: pass domain id to be_cmd_link_status_query
      be2net: add code to display default value of tx rate for VFs
      be2net: Support for version 1 of stats for BE3

Alexander Duyck (10):
      ethtool: prevent null pointer dereference with NTUPLE set but no set_rx_ntuple
      v3 ethtool: add ntuple flow specifier data to network flow classifier
      ixgbe: remove ntuple display support
      ixgbe: move flags and state into the same cacheline
      ixgbe: Combine SFP and multi-speed fiber task into single service task
      ixgbe: Merge watchdog functionality into service task
      ixgbe: merge reset task into service task
      ixgbe: Merge ATR reinit into the service task
      ixgbe: Merge over-temp task into service task
      ixgbe: cleanup some minor issues in ixgbe_down()

Alexander Stein (1):
      macb: Add rx overrun counter

Alexey Dobriyan (6):
      kstrtox: convert drivers/isdn/
      Bluetooth: convert net/bluetooth/ to kstrtox
      pktgen: use %pI6c for printing IPv6 addresses
      netconsole: switch to kstrto*() functions
      net: add mac_pton() for parsing MAC address
      olympic: convert to seq_file

Alexey Orishko (1):
      CDC NCM: Add mising short packet in cdc_ncm driver

Allan Stephens (19):
      tipc: Update comments in message header include file
      tipc: Eliminate unused routing message definitions
      tipc: Cosmetic consolidation of internal message type definitions
      tipc: Remove code to emulate loss of broadcast messages
      tipc: Don't initialize link selector field in fragmented messages
      tipc: Avoid pointless masking of fragmented message identifier
      tipc: Fix issues with fragmentation of an existing message buffer
      tipc: Set name lookup scope field properly in all data messages
      tipc: Fix problem with bundled multicast message
      tipc: Update destination node field on incoming multicast messages
      tipc: Fix sk_buff leaks when link congestion is detected
      tipc: Strengthen checks for neighboring node discovery
      tipc: Abort excessive send requests as early as possible
      tipc: Avoid recomputation of outgoing message length
      tipc: Introduce routine to enqueue a chain of messages on link tx queue
      tipc: Enhance handling of discovery object creation failures
      tipc: Enhance sending of discovery object link request messages
      tipc: Add monitoring of number of nodes discovered by bearer
      tipc: Revise timings used when sending link request messages

Allan, Bruce W (2):
      ethtool: time to blink provided in seconds not jiffies
      ethtool: allow custom interval for physical identification

Amit Virdi (1):
      net/irda/ircomm_tty.c: Use flip buffers to deliver data

Amitkumar Karwar (13):
      mwifiex: return success in set_default_key for WPA/WPA2
      mwifiex: cleanup ioctl wait queue and abstraction layer
      mwifiex: remove unused function parameters
      mwifiex: remove some macro definitions
      mwifiex: optimize driver initialization code
      cfg80211: module_param to disable HT40 in 2.4GHz band
      mwifiex: check firmware capabilities while initialising 5GHz band parameters
      mwifiex: HT capability information handling
      mwifiex: fix bug in mwifiex_save_curr_bcn()
      mwifiex: fix simultaneous assoc and scan issue
      mwifiex: remove unnecessary struct mwifiex_opt_sleep_confirm_buffer
      mwifiex: remove redundant local structures
      mwifiex: remove mwifiex_recv_complete function

Andrei Emeltchenko (2):
      Bluetooth: check L2CAP info_rsp ident and state
      Bluetooth: delete hanging L2CAP channel

Andrew Lunn (1):
      batman-adv: Set the txqueuelen to zero when creating soft interface

Andy Ross (1):
      Bluetooth: Device ids for ath3k on Pegatron Lucid tablets

Anirban Chakraborty (9):
      qlcnic: Cleanup patch
      qlcnic: Code optimization patch
      qlcnic: Changes to VLAN code
      qlcnic: Remove unused code
      qlcnic: Update version number to 5.0.16
      ethtool: Added support for FW dump
      qlcnic: FW dump support
      qlcnic: Take FW dump via ethtool
      qlcnic: Bumped up version number to 5.0.18

Anton Blanchard (2):
      net: Add sendmmsg socket system call
      net: recvmmsg: Strip MSG_WAITFORONE when calling recvmsg

Antonio Ospite (1):
      rfkill: Regulator consumer driver for rfkill

Antonio Quartulli (4):
      batman-adv: orig_hash_find() manages rcu_lock/unlock internally
      batman-adv: Move definition of atomic_dec_not_zero() into main.h
      batman-adv: fix gw_node_update() and gw_election()
      batman-adv: rename everything from *hna* into *tt* (translation table)

Arik Nemtsov (18):
      wl12xx: 1281/1283 support - Use different FW file for AP mode wl127x/wl128x chips
      wl12xx: Clamp byte mode transfers for 128x chips
      wl12xx: configure channel/band while FW is off
      mac80211: allow low level drivers to report packet loss
      wl12xx: support FW TX inactivity triggers
      wl12xx: implement the tx_frames_pending mac80211 callback
      wl12xx: discard corrupted packets in RX
      wl12xx: add BT-coexistance for AP
      wl12xx: use wiphy values for setting rts, frag thresholds on init
      wl12xx: AP-mode - disable beacon filtering on start up
      wl12xx: schedule recovery on command timeout
      wl12xx: print firmware program counter during recovery
      wl12xx: AP-mode - overhaul rate policy configuration
      wl12xx: AP-mode - reconfigure templates after basic rates change
      wl12xx: add debugfs entry for starting recovery
      wl12xx: fix race condition during recovery in AP mode
      wl12xx: export driver state to debugfs
      mac80211: set TID of internal mgmt packets to 7

Ben Greear (2):
      wifi: Add hwflags to debugfs.
      ath5k: Fix lockup due to un-init spinlock.

Ben Hutchings (18):
      sfc: Move test of rx_checksum_enabled from nic.c to rx.c
      sfc: Enable all TSO features on VLANs
      sfc: Implement generic features interface
      ethtool: Convert struct ethtool_ops comment to kernel-doc format
      ethtool: Fill out and update comment for struct ethtool_ops
      ethtool: Change ETHTOOL_PHYS_ID implementation to allow dropping RTNL
      sfc: Implement ethtool_ops::set_phys_id instead of ethtool_ops::phys_id
      gianfar: Clean up implementation of RX network flow classification
      niu: Recognise original ethtool class code for AH/ESP flow hashing
      rndis_host: Poll status before control channel where necessary
      rndis_host: Quirky devices are still 'point-to-point'
      ipv6: Send unsolicited neighbour advertismements when notified
      vlan: Propagate NETDEV_NOTIFY_PEERS notifier
      bonding, ipv4, ipv6, vlan: Handle NETDEV_BONDING_FAILOVER like NETDEV_NOTIFY_PEERS
      ipv4, ipv6, bonding: Restore control over number of peer notifications
      sfc: Fix return value from efx_ethtool_set_rx_ntuple()
      sfc: Fix TX queue numbering when separate_tx_channels=1
      sfc: Use netif_device_{detach,attach}() around reset and self-test

Bing Zhao (10):
      wireless: mwifiex: initial commit for Marvell mwifiex driver
      mwifiex: remove macro SHORT_SLOT_TIME_DISABLED
      mwifiex: remove MWIFIEX_BSS_MODE_ macros
      ieee80211: add HT extended capabilities masks
      mwifiex: remove struct mwifiex_802_11_fixed_ies
      mwifiex: remove unused macros in decl.h and main.h
      mwifiex: fix cmd_skb headroom decreasing issue
      mwifiex: rename function mwifiex_is_ba_stream_avail
      mwifiex: fix missing tsf_val TLV
      mwifiex: cleanup ioctl.h

Brian Cavagnolo (5):
      mwl8k: refactor in preparation for APIv2 update
      mwl8k: update to ap firmware API version 2
      mwl8k: differentiate between WMM queues and AMPDU queues
      mwl8k: add internal API for managing AMPDU streams
      mwl8k: use traffic threshold to decide when to start ampdu

Bruce Allan (5):
      e1000e: convert short duration msleep() to usleep_range()
      e1000e: PCIe link speed in GT/s, not GB/s
      e1000e: If ASPM L0s needs to be disabled, do it prior to enabling device
      e1000e: implement ethtool set_phys_id
      e1000e: minor comment cleanups

Carolyn Wyborny (1):
      igb: Add check for invalid size to igb_get_invariants_82575()

Changli Gao (2):
      net: ping: make local functions static
      net: ping: fix the coding style

Chaoming Li (14):
      rtlwifi: rtl8192ce: Fix LED initialization
      rtlwifi: rtl8192se: Merge def.h
      rtlwifi: rtl8192se: Merge dynamic management routines
      rtlwifi: rtl8192se: Merge firmware routines
      rtlwifi: rtl8192se: Merge hardware routines
      rtlwifi: rtl8192se: Merge led routines
      rtlwifi: rtl8192se: Merge phy routines
      rtlwifi: rtl8192se: Merge register definitions
      rtlwifi: rtl8192se: Merge rf routines
      rtlwifi: rtl8192se: Merge main (sw) routines
      rtlwifi: rtl8192se: Merge table routines
      rtlwifi: rtl8192se: Merge TX and RX routines
      rtlwifi: rtl8192se: Modify Kconfig and Makefile routines for new driver
      rtlwifi: rtl8192se: Remove need to disable ASPM

Chaoming_Li (17):
      rtlwifi: Change efuse routines addition of RTL8192SE and RTL8192DE
      rtlwifi: Change wifi.h for rtl8192se and rtl8192de
      rtlwifi: Change base routines for addition of rtl8192se and rtl8192de
      rtlwifi: Change cam routines for addition of rtl8192se and rtl8192de
      rtlwifi: Convert core routines for addition of rtl8192se and rtl8192de
      rtlwifi: Convert pci routines for addition of rtl8192se and rtl8192de
      rtlwifi: Convert ps routines for addition of rtl8192se and rtl8192de
      rtlwifi: Convert rc routines for addition of rtl8192se and rtl8192de
      rtlwifi: Convert regulatory domain routines for addition of rtl8192se and rtl8192de
      rtlwifi: Convert usb routines for addition of rtl8192se and rtl8192de
      rtlwifi: rtl8192c-common: Convert common dynamic management routines for addition of rtl8192se and rtl8192de
      rtlwifi: rtl8192c-common: Change common firmware routines for addition of rtl8192se and rtl8192de
      rtlwifi: rtl8192c-common: Change common PHY routines for addition of rtl8192se and rtl8192de
      rtlwifi: rtl8192ce: Change hw routine for addition of rtl8192se and rtl8192de
      rtlwifi: rtl8192ce: Change sw and LED routines for addition of rtl8192se and rtl8192de
      rtlwifi: rtl8192ce: Change phy and rc routines for addition of rtl8192se and rtl8192de
      rtlwifi: rtl8192ce: Change rtl8192ce routines phy and trx and modify rtl8192cu for addition of rtl8192se and rtl8192de

Christian Lamparter (7):
      ar9170usb: purge obsolete driver
      p54: implement multicast filter
      carl9170: improve unicast PS buffering
      mac80211: fix too early reorder release timer
      mac80211: consolidate MIC failure report handling
      carl9170: fix -Wunused-but-set-variable warnings
      p54pci: fix -Wunused-but-set-variable warnings

Christoph Fritz (1):
      mwifiex: fix null derefs, mem leaks and trivia

Cindy H. Kao (1):
      iwlwifi: support the svtool messages interactions through nl80211 test mode

Dan Carpenter (1):
      iwlwifi: remove duplicate initialization in __iwl_down()

Daniel Drake (1):
      libertas: remove tx_timeout handler

Daniel Halperin (5):
      iwlwifi: limit number of attempts for highest HT rate
      iwlwifi: cleanup and bugfix tx aggregation code
      iwlwifi: add RATE_MCS_RATE_MSK
      iwlwifi: set default aggregation frame limit to 63
      mac80211: fix contention time computation in minstrel, minstrel_ht

Daniel Walter (2):
      ipv6: ignore looped-back NA while dad is running
      ipv6: RTA_PREFSRC support for ipv6 route source address selection

Daniele Furlan (1):
      batman-adv: remove duplicate code from function is_bidirectional_neigh()

David Decotigny (12):
      net-bonding: Fix minor sparse complaints
      net-bonding: Fix minor/cosmetic type inconsistencies
      net-bonding: Adding support for throughputs larger than 65536 Mbps
      bnx2x: cosmetics: Using ethtool_cmd_speed() API
      ethtool: cosmetics: enforce const-ness in ethtool_cmd_speed
      ethtool: Call ethtool's get/set_settings callbacks with cleaned data
      ethtool: Use full 32 bit speed range in ethtool's set_settings
      ethtool: cosmetic: Use ethtool ethtool_cmd_speed API
      acenic: Fix using the specified speed when configuring NIC
      tulip/de2104x: don't report different speeds depending on port type
      net/igb/e1000/e1000e: more robust ethtool duplex/speed configuration
      stmmac: don't go through ethtool to start auto-negotiation

David S. Miller (182):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Add helper flowi4_init_output().
      ipv4: Use flowi4_init_output() in net/route.h
      ipv4: Use flowi4_init_output() in inet_connection_sock.c
      ipv4: Use flowi4_init_output() in ip_send_reply()
      ipv4: Use flowi4_init_output() in raw_sendmsg()
      ipv4: Use flowi4_init_output() in cookie_v4_check()
      ipv4: Use flowi4_init_output() in udp_sendmsg()
      net: Order ports in same order as addresses in flow objects.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      niu: Fix warnings due to -Wunused-but-set-variable
      s2io: Fix warnings due to -Wunused-but-set-variable.
      9p: Kill set but unused variable in 9p_client_{read,write}() and p9_client_readdir()
      atm: iphase: Fix set-but-not-used warnings.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      net: Missing 'inline' in vlan-disabled vlan_untag()
      ipv4: Call fib_select_default() only when actually necessary.
      atm: eni: Kill set-but-unused variables.
      atm: he: Fix undefined sequence points.
      atm: idt77252: Fix set-but-unused variables.
      atm: solos-pci: Fix set-but-unused variable.
      pktgen: Fix set-but-unused variable.
      decnet: Fix set-but-unused variable.
      econet: Fix set-but-unused variable.
      ax25: Fix set-but-unused variable.
      atm: lec: Fix set-but-unused variables.
      bonding: Fix set-but-unused variable.
      atlx: Fix set-but-unused variable.
      atl1e: Fix set-but-unused variable.
      atl1c: Fix set-but-unused variable.
      isdn: gigaset: Fix set-but-unused variable.
      isdn: eicon: Fix set-but-unused variables.
      isdn: hfcpci: Fix set-but-unused variables.
      isdn: hfcsusb: Fix set-but-unused variables.
      isdn: arcofi: Fix set-but-unused variables.
      isdn: elsa_cs: Fix set-but-unused variables.
      isdn: elsa_ser: Fix set-but-unused variables.
      isdn: hfc_usb: Fix set-but-unused variables.
      isdn: ipacx: Fix set-but-unused variables.
      isdn: jade: Fix set-but-unused variables.
      isdn: l3dss1: Fix set-but-unused variables.
      isdn: l3ni1: Fix set-but-unused variables.
      isdn: teles_cs: Fix set-but-unused variables.
      isdn: i4l: isdn_common: Fix set-but-unused variables.
      isdn: i4l: isdn_net: Fix set-but-unused variables.
      isdn: mISDN: socket: Fix set-but-unused variables.
      bna: Fix set-but-unused variables.
      bnx2x: Fix set-but-unused variables.
      caif: Fix set-but-unused variables.
      irda: irlap_event: Fix set-but-unused variables.
      irda: irproc: Fix set-but-unused variables.
      l2tp: Fix set-but-unused variables.
      netlabel: Fix set-but-unused variables.
      netfilter: nfnetlink_log: Fix set-but-unused variables.
      netfilter: nf_conntrack_standalone: Fix set-but-unused variables.
      netfilter: ip6_tables: Fix set-but-unused variables.
      netfilter: ip6table_mangle: Fix set-but-unused variables.
      isdn: i4l: isdn_tty: Fix unused-but-set variables.
      be2net: Fix unused-but-set variables.
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      decnet: Don't leak entries when rebuilding zone.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      mv643xx_eth: Fix build regression.
      net: Remove __KERNEL__ cpp checks from include/net
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      bluetooth: Fix use-before-initiailized var.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipv4: Sanitize and simplify ip_route_{connect,newports}()
      ipv4: Remove erroneous check in igmpv3_newpack() and igmp_send_report().
      ipv4: Kill RTO_CONN.
      l2tp: Fix inet_opt conversion.
      net: Make dst_alloc() take more explicit initializations.
      net: Use non-zero allocations in dst_alloc().
      ipv4: Use caller's on-stack flowi as-is in output route lookups.
      ipv4: Remove now superfluous code in ip_route_connect().
      ipv4: Fetch route saddr from flow key in inet_sk_reselect_saddr().
      ipv4: Fetch route saddr from flow key in ip4_datagram_connect().
      ipv4: Fetch route saddr from flow key in tcp_v4_connect().
      ipv4: Fetch route saddr from flow key in l2tp_ip_connect().
      ipv4: Get route daddr from flow key in dccp_v4_connect().
      ipv4: Get route daddr from flow key in ip4_datagram_connect().
      ipv4: Get route daddr from flow key in inet_csk_route_req().
      ipv4: Get route daddr from flow key in tcp_v4_connect().
      ipv4: Get route daddr from flow key in l2tp_ip_connect().
      ipv4: Make sure flowi4->{saddr,daddr} are always set.
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      ipv4: Rework ipmr_rt_fib_lookup() flow key initialization.
      ipv4: Renamt struct rtable's rt_tos to rt_key_tos.
      dccp: Use flowi4->saddr in dccp_v4_connect()
      ipv4: Make caller provide on-stack flow key to ip_route_output_ports().
      pptp: Use flowi4's daddr/saddr in pptp_xmit().
      libcxgbi: Use flowi4's saddr in cxgbi_check_route().
      ipv4: Use flowi4's {saddr,daddr} in igmpv3_newpack() and igmp_send_report()
      sctp: Use flowi4's {saddr,daddr} in sctp_v4_dst_saddr() and sctp_v4_get_dst()
      ipv4: Use flowi4->{daddr,saddr} in ipip_tunnel_xmit().
      ipv4: In ip_build_and_send_pkt() use 'saddr' and 'daddr' args passed in.
      ipv4: Pass explicit saddr/daddr args to ipmr_get_route().
      ipv4: Kill rt->rt_{src, dst} usage in IP GRE tunnels.
      ipv6: Use flowi4->{daddr,saddr} in ipip6_tunnel_xmit().
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      hamachi: Delete TX checksumming code commented out since 1999
      inet: Decrease overhead of on-stack inet_cork.
      ipv4: Initialize on-stack cork more efficiently.
      ipv4: Initialize cork->opt using NULL not 0.
      hamachi: Put back RX_CHECKSUM
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      dccp: Use cork flow in dccp_v4_connect()
      tcp: Use cork flow in tcp_v4_connect()
      l2tp: Fix locking in l2tp_ip.c
      l2tp: Fix locking in l2tp_core.c
      l2tp: Use cork flow in l2tp_ip_connect() and l2tp_ip_sendmsg()
      ipv4: Lock socket and use cork flow in ip4_datagram_connect().
      ipv4: Use cork flow in inet_sk_{reselect_saddr,rebuild_header}()
      ipv4: Use cork flow in ip_queue_xmit()
      sctp: Store a flowi in transports to provide persistent keying.
      ipv4: Create inet_csk_route_child_sock().
      ipv4: Use inet_csk_route_child_sock() in DCCP and TCP.
      inet: Pass flowi to ->queue_xmit().
      ipv4: Don't use rt->rt_{src,dst} in ip_queue_xmit().
      sctp: Don't use rt->rt_{src,dst} in sctp_v4_xmit()
      tcp: Use cork flow info instead of rt->rt_dst in tcp_v4_get_peer()
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      udp: Use flow key information instead of rt->rt_{src,dst}
      ipv4: Pass flow keys down into datagram packet building engine.
      ipv4: Pass flow key down into ip_append_*().
      sctp: Fix debug message args.
      Merge branch 'davem-next.r8169' of git://git.kernel.org/.../romieu/netdev-2.6
      ipv4: Pass explicit daddr arg to ip_send_reply().
      ipv4: icmp: Eliminate remaining uses of rt->rt_src
      ipv4: udp: Eliminate remaining uses of rt->rt_src
      sctp: Remove rt->rt_src usage in sctp_v4_get_saddr()
      infiniband: Remove rt->rt_src usage in addr4_resolve()
      ipv4: xfrm: Eliminate ->rt_src reference in policy code.
      Merge branch 'tipc-May10-2011' of git://git.kernel.org/.../paulg/net-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-3.6
      ipvs: Use IP_VS_RT_MODE_* instead of magic constants.
      ipvs: Eliminate rt->rt_dst usage in __ip_vs_get_out_rt().
      ipv4: Kill spurious opt->srr check in ip_options_rcv_srr().
      ipv4: Simplify iph->daddr overwrite in ip_options_rcv_srr().
      ipv4: Elide use of rt->rt_dst in ip_forward()
      Merge branch 'master' of master.kernel.org:/.../davem/net-next-2.6
      ipv4: Fix 'iph' use before set.
      ipv4: Kill spurious write to iph->daddr in ip_forward_options().
      ipv4: Always call ip_options_build() after rest of IP header is filled in.
      ipv4: Remove route key identity dependencies in ip_rt_get_source().
      ipv4: Remove rt->rt_dst reference from ip_forward_options().
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      ipv4: Trivial rt->rt_src conversions in net/ipv4/route.c
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      bluetooth: Fix warnings in l2cap_core.c
      Merge branch 'master' of git://git.kernel.org/.../bwh/sfc-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-2.6
      ipv4: Don't use enums as bitmasks in ip_fragment.c
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      sfc: Don't use enums as a bitmask.
      ipv4: Kill RT_CACHE_DEBUG
      ipv4: Make caller provide flowi4 key to inet_csk_route_req().
      ipv4: Pass explicit destination address to rt_get_peer().
      ipv4: Pass explicit destination address to rt_bind_peer().
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      9p: Kill set but not used variable 'ret' in parse_opts()
      9p: Kill unused variable 'ret' in trans_rdma.c:parse_opts()
      isdn: capi: Use pr_debug() instead of ifdefs.
      pkt_sched: Kill set but unused variable 'protocol' in tc_classify()
      rxrpc: Kill set but unused variable 'sp' in rxrpc_rotate_tx_window()
      rxrpc: Kill set but unused variable 'sp' in rxrpc_process_connection()
      rxrpc: Kill set but unused variable 'local' in rxrpc_UDP_error_handler()
      rxrpc: Fix set but unused variable 'usage' in rxrpc_get_peer().
      atl1c: atl1c_resume() is only used when CONFIG_PM_SLEEP is defined.
      irda: Kill set but unused vars 'saddr' and 'daddr' in irlan_provider_connect_indication()
      be2net: Kill set but unused variable 'req' in lancer_fw_download()
      rxrpc: Fix set but unused variable 'usage' in rxrpc_get_transport()
      irda: Kill set but unused variable 'clen' in ircomm_connect_indication()
      irda: Kill set but unused variable 'bytes' in irlan_check_command_param()
      irda: Fix error propagation in ircomm_lmp_connect_response()

Dimitris Michailidis (2):
      cxgb4: drop phys_id interface and implement the newer set_phys_id
      cxgb4vf: drop phys_id interface and implement the newer set_phys_id

Dmitry Kravkov (8):
      bnx2x: Update firmware to 6.2.9
      bnx2x: don't write dcb/llfc fields in STORM memory
      bnx2x, cnic: Disable iSCSI if DCBX negotiation is successful
      bnx2x: allow WoL on every function in MF modes
      bnx2x: Do storage mac address validation for SF mode.
      bnx2x: improve memory handling, low memory recovery flows
      bnx2x: update year to 2011 and version to 1.62.12-0
      bnx2x: function descriptions format fixed

Don Fry (2):
      iwlagn: mod param cleanup
      iwlagn: semaphore and calib cleanup

Don Skidmore (7):
      ixgbe: cleanup short msleep's (<20ms) to use usleep_range
      ixgbe: enable SCTP checksum offload for X540
      ixgbe: Bump version
      ixgbe: fix X540 ethtool loopback test.
      ixgbe: fix typo error with software defined pins on 82599
      ixgbe: Cleanup PCIe bus speed info
      ixgbe: Add support for new 82599 adapter

Eliad Peller (15):
      wl12xx: set the actual tid instead of the ac
      wl12xx: rearrange some ELP wake_up/sleep calls
      wl12xx: sleep instead of wakeup after tx work
      wl12xx: avoid premature elp entrance
      wl12xx: print actual rx packet size (without padding)
      wl12xx: avoid redundant join on interface reconfiguration
      wl12xx: configure rates when working in ibss mode
      wl12xx: add debugfs entries for dtim_interval and beacon_interval
      wl12xx: simplify wl1271_ssid_set()
      wl12xx_sdio: set interrupt as wake_up interrupt
      wl12xx: declare suspend/resume callbacks (for wowlan)
      wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
      wl12xx: prevent scheduling while suspending (WoW enabled)
      wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
      wl12xx: enter/exit psm on wowlan suspend/resume

Emil Tantilov (23):
      ixgbe: fix return value checks
      ixgbe: correct function number for some 82598 parts
      ixgbe: fix namespacecheck issue
      ixgbe: refactor common start_hw code for 82599 and x540
      ixgbe: move disabling of relaxed ordering in start_hw()
      ixgbe: fix 82599 KR downshift coexistence with LESM FW module
      ixgbe: fix semaphores in eeprom routines for x540
      ixgbe: add support for new HW
      ixgbe: explicitly disable 100H for x540
      ixgbe: make device_caps() generic
      ixgbe: explicitly disable 100H for x540
      ixgbe: register defines cleanup
      ixgbe: add support for 64k EEPROM for 82599
      ixgbe: add LED blink code for x540
      ixgbe: convert to ethtool set_phys_id
      e100: fix build warning
      ixgbe: Use function pointer for ixgbe_acquire/release_swfw_sync()
      ixgbe: fix sparse warning
      ixgbe: improve EEPROM read/write operations
      ixgbe: add rxhash support
      ixgbe: add ethtool counters for OS2BMC
      ixgbe: force unlock on timeout
      ixgbe: fix sparse warning

Eric Dumazet (23):
      fib: add __rcu annotations
      xen: netfront: fix declaration order
      netfilter: get rid of atomic ops in fast path
      netfilter: fix ebtables compat support
      inet: constify ip headers and in6_addr
      net: filter: Just In Time compiler for x86-64
      inet: add RCU protection to inet->opt
      bpf: depends on MODULES
      net: dont hold rtnl mutex during netlink dump callbacks
      net: use batched device unregister in veth and macvlan
      garp: remove one synchronize_rcu() call
      vlan: remove one synchronize_net() call
      net: fix two lockdep splats
      l2tp: fix potential rcu race
      garp: remove last synchronize_rcu() call
      net: ping: small changes
      net: ping: dont call udp_ioctl()
      ipv4: more compliant RFC 3168 support
      net: use hlist_del_rcu() in dev_change_name()
      net: add skb_dst_force() in sock_queue_err_skb()
      ipv6: reduce per device ICMP mib sizes
      macvlan: remove one synchronize_rcu() call
      macvlan: fix panic if lowerdev in a bond

Fabrice Deyber (1):
      mac80211: Only process mesh PREPs with equal seq number if metric is better.

Felix Fietkau (48):
      ath9k: remove unnecessary debugfs return code checks
      ath9k: add an interface for overriding the value of specific GPIO pins
      ath9k: add support for overriding the MAC address through platform data
      ath9k: add support for overriding LED pin and GPIO settings from platform data
      ath9k_hw: enable a BlockAck related fixup specific to AR9100
      ath9k_hw: force rx chainmask to 7 on AR9100
      ath9k: remove the pending frames ath_txq_schedule workaround
      ath9k: fix beacon timer handling issues
      ath9k: trigger nfcal only after multiple missed beacons in AP mode
      ath9k: fix stuck beacon detection
      ath9k_hw: embed the ath_ops callbacks in the ath_hw struct
      ath9k_hw: add a new register op for read-mask-write
      ath9k_hw: replace REG_READ+REG_WRITE with REG_RMW
      ath9k_hw: turn a few big macros into functions
      ath9k_hw: remove pCap->total_queues
      ath9k_hw: remove ah->config.ht_enable
      ath9k_hw: remove pCap->reg_cap
      ath9k_hw: remove pCap->keycache_size
      ath9k_hw: remove ATH9K_HW_CAP_ENHANCEDPM
      ath9k_hw: remove pCap->tx_triglevel_max
      mac80211: fix suppressing probe responses in ad-hoc mode
      mac80211: remove the dependency on crypto_blkcipher
      ath9k: fix beacon slot processing in ad-hoc mode
      ath9k: use the hw opmode to select the beacon timer mode
      ath9k: fix PS-Poll reception on AR9160 and earlier
      ath9k: fix too early enabling of rx during ath_startrecv()
      ath9k_hw: remove unnecessary parts of the AR9380 SREV check
      ath5k: fix tx status reporting issues
      ath5k: fix short preamble rate duration value
      ath5k: fix SIFS time handling
      ath5k: fix slot time handling
      ath5k: optimize tx descriptor setup
      ath5k: remove ts_rate from ath5k_tx_status
      ath5k: optimize tx status processing
      ath5k: optimize rx status processing
      ath5k: remove ts_retry from ath5k_tx_status
      ath5k: clean up debugfs code
      ath5k: reduce interrupt load caused by rx/tx interrupts
      mac80211: receive EAP frames from a station in an AP VLAN on the main AP
      ath5k: disable 5 GHz support if a 2.4 GHz radio is detected
      ath: unshare struct ath_bus_ops between ath5k and ath9k
      ath5k: add a new bus op for reading the mac address
      ath5k: fix the EEPROM check for hw AES crypto support
      ath5k: disable 5 GHz support for the dualband PHY chip on dual-radio AR5312
      mac80211: add a function for setting the TIM bit for a specific station
      ath9k: fix powersave frame filtering/buffering in AP mode
      ath9k: assign keycache slots to unencrypted stations
      ath9k: fix a regression in PS frame filter handling

Flavio Leitner (1):
      e1000e: fix stats locking in e1000_watchdog_task

Florian Westphal (1):
      netfilter: ebtables: only call xt_compat_add_offset once per rule

Franco Fichtner (1):
      ethtool: bring back missing comma in netdev features strings

Francois Romieu (10):
      r8169: TSO fixes.
      r8169: fix merge conflict fix.
      r8169: style cleanups.
      r8169: remove some code duplication.
      r8169: rtl8169_set_speed_xmii cleanup.
      r8169: link speed selection timer rework.
      r8169: remove non-NAPI context invocation of rtl8169_rx_interrupt.
      r8169: provide some firmware information via ethtool.
      r8169: merge firmware information into the chipset description data.
      r8169: avoid late chip identifier initialisation.

Frank Blaschka (3):
      qeth: convert to hw_features part 2
      qeth: add OSA concurrent hardware trap
      qeth: use ndo_set_features callback for initial setup and recovery

Gabor Juhos (1):
      ath9k: introduce ATH9K_{PCI,AHB} config options

Garen Tamrazian (1):
      iwlagn: fix radar frame rejection

Gertjan van Wingerde (10):
      rt2x00: Linksys WUSB600N rev2 is a RT3572 device.
      rt2x00: Allow dynamic addition of PCI/USB IDs.
      rt2x00: Add USB IDs.
      rt2x00: RT33xx device support is no longer experimental.
      rt2x00: Enable support for RT53xx PCI devices by default.
      rt2x00: Merge rt2x00ht.c contents in other files.
      rt2x00: Streamline rt2800 eeprom initialisations.
      rt2x00: Introduce capability flag for Bluetooth co-existence.
      rt2x00: Initial support for RT5370 USB devices.
      rt2x00: Fix rmmod hang of rt2800pci

Giuseppe CAVALLARO (2):
      stmmac: removed not used definitions
      stmmac: fix autoneg in set_pauseparam

Giuseppe Cavallaro (1):
      stmmac: review Wol and enable the Unicast support

Greg Rose (3):
      igb: Add anti-spoofing feature documentation
      ixgbevf: Add macvlan support in the set rx mode op
      ixgbe: Add macvlan support for VF

Gustavo F. Padovan (51):
      Bluetooth: remove unnecessary function declaration
      Bluetooth: Remove unused struct item
      Bluetooth: Improve error message on wrong link type
      Bluetooth: Remove unused struct l2cap_conn item
      Bluetooth: Move bt_accept_enqueue() to outside __l2cap_chan_add
      Bluetooth: Fix HCI_RESET command synchronization
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-2.6
      Bluetooth: Remove gfp_mask param from hci_reassembly()
      Bluetooth: Don't use spin_lock_bh in user context
      Bluetooth: Use GFP_KERNEL in user context
      Bluetooth: Create struct l2cap_chan
      Bluetooth: Use struct list_head for L2CAP channels list
      Bluetooth: Remove struct del_list
      Bluetooth: Move ident to struct l2cap_chan
      Bluetooth: Move conf_{req,rsp} stuff to struct l2cap_chan
      Bluetooth: clean up l2cap_sock_recvmsg()
      Bluetooth: Move conn_state to struct l2cap_chan
      Bluetooth: Move of ERTM *_seq vars to struct l2cap_chan
      Bluetooth: Move more ERTM stuff to struct l2cap_chan
      Bluetooth: Move SDU related vars to struct l2cap_chan
      Bluetooth: Move remote info to struct l2cap_chan
      Bluetooth: Move ERTM timers to struct l2cap_chan
      Bluetooth: Move srej and busy queues to struct l2cap_chan
      Bluetooth: Move busy workqueue to struct l2cap_chan
      Bluetooth: Fix lockdep warning with skb list lock
      Bluetooth: Move SREJ list to struct l2cap_chan
      Bluetooth: Remove some sk references from l2cap_core.c
      Bluetooth: Remove unneeded uninitialized_vars()
      Bluetooth: Move tx queue to struct l2cap_chan
      Bluetooth: Fix wrong comparison in listen()
      Bluetooth: Clean up ath3k_load_firmware()
      Bluetooth: Add proper handling of received LE data
      Bluetooth: Check return value of hci_recv_stream_fragment()
      Bluetooth: Don't lock sock inside l2cap_get_sock_by_scid()
      Bluetooth: Fix another locking unbalance
      Bluetooth: Fix lockdep warning in L2CAP
      Merge master.kernel.org:/.../padovan/bluetooth-2.6
      Bluetooth: Refactor L2CAP channel allocation
      Bluetooth: Move conf_state to struct l2cap_chan
      Bluetooth: Rename l2cap_do_connect() to l2cap_chan_connect()
      Bluetooth: Move some more elements to struct l2cap_chan
      Bluetooth: Move more vars to struct l2cap_chan
      Bluetooth: Move more channel info to struct l2cap_chan
      Bluetooth: Move more vars to struct l2cap_chan
      Bluetooth: Move conn to struct l2cap_chan
      Bluetooth: Fix memory leak with L2CAP channels
      Bluetooth: Don't export l2cap_sock_ops
      Bluetooth: Add l2cap_add_psm() and l2cap_add_scid()
      Bluetooth: Handle psm == 0 case inside l2cap_add_psm()
      Bluetooth: Remove l2cap_sk_list
      Bluetooth: Remove leftover debug messages

Hans Schillstrom (2):
      IPVS: Change of socket usage to enable name space exit.
      IPVS: init and cleanup restructuring

Harvey Harrison (1):
      via-rhine: trivial sparse annotation in vlan_tci helper

Hauke Mehrtens (1):
      wl12xx: do not set queue_mapping directly

Heiko Carstens (2):
      claw: remove unused return code handling
      lcs: get rid of compile warning

Helmut Schaa (20):
      mac80211: Minor optimization in tx status handling
      rt2x00: Limit rt2x00pci rxdone processing to 16 entries at once
      rt2x00: Limit rt2800pci txdone processing to 16 entries at once
      rt2x00: Calculate tx status fifo size instead of hardcoding it
      rt2x00: Remove DRIVER_SUPPORT_WATCHDOG flag
      rt2x00: Restructure bw_comp calculation
      rt2x00: Don't recalculate HT40 compensation for each rate
      rt2x00: Indention cleanup in rt2800lib
      rt2x00: Remove obsolete rt2x00queue_align_payload
      rt2x00: Implement tx power temperature compensation
      rt2x00: Fix STBC transmissions to STAs with Rx STBC > 1
      rt2x00: Fix tx aggregation problems with some clients
      rt2x00: Add an error message when trying to send on a full queue
      rt2x00: Fix stuck queue in tx failure case
      rt2x00: Make rt2x00_queue_entry_for_each more flexible
      rt2x00: Use correct TBTT_SYNC config in AP mode
      rt2x00: Update TX_SW_CFG2 init value
      rt2x00: Use TXOP_HTTXOP for beacons
      rt2x00: Always inline rt2x00pci_enable_interrupt
      rt2x00: Optimize register access in rt2800pci

Ian Campbell (3):
      xen: netfront: assume all hw features are available until backend connection setup
      Signed bit field; int have_hotplug_status_watch:1
      xen: netback: use __CONST_RING_SIZE not __RING_SIZE

Ido Yariv (8):
      wl12xx: Clean up and fix the 128x boot sequence
      wl12xx: Clean up the block size alignment code
      wl12xx: Clean up the dummy packet mechanism
      wl12xx: Simplify TX blocks accounting
      wl12xx: Handle platforms without level trigger interrupts
      wl12xx: Modify memory configuration for 128x/AP
      wl12xx: Restart TX when TX descriptors are available
      wl12xx: Enable dynamic memory for 127x

Ivo van Doorn (11):
      rt2x00: Add support for the ZyXEL NWD-211AN USB
      rt2x00: Split rt2x00dev->flags
      rt2x00: Decrease association time for USB devices
      rt2x00: Optimize register access in rt2800usb
      rt2x00: Implement get_ringparam callback function
      rt2x00: Implement get_antenna and set_antenna callback functions
      rt2x00: Reduce tx status reading timeout
      rt2x00: Optimize TX_STA_FIFO register reading
      rt2x00: Fix optimize register access for rt2800pci
      rt2x00: Add autowake support for USB hardware
      rt2x00: Fix transfer speed regression for USB hardware

Jacek Luczak (1):
      SCTP: fix race between sctp_bind_addr_free() and sctp_bind_addr_conflict()

Jan Engelhardt (1):
      mISDN: fix "persistant" typo

Jan Kiszka (1):
      capi: Perform scheduled capifs removal

Jarkko Nikula (2):
      wl1251: Prepare for idle mode support
      wl1251: Add support for idle mode

Javier Cardona (21):
      nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
      cfg80211/nl80211: Add userspace authentication flag to mesh setup
      mac80211: ignore peers if security is enabled for this mesh
      nl80211/mac80211: let userspace authenticate stations
      mac80211: Let user space receive and send mesh auth/deauth frames
      mac80211: ignore peer link requests from unauthenticated stations.
      nl80211/mac80211: Perform PLINK_ACTION on new station
      nl80211: New notification to discover mesh peer candidates.
      mac80211: send notification on new peer candidate for our secure mesh
      nl80211: Introduce NL80211_MESH_SETUP_USERSPACE_AMPE
      mac80211: Let userspace send action frames over mesh interfaces
      mac80211: Drop MESH_PLINK category and use new ANA-approved MESH_ACTION
      open80211s: Stop using zero for address 3 in mesh plink mgmt frames
      cfg80211: Use capability info to detect mesh beacons.
      nl80211: Let userspace drive the peer link management states.
      mac80211: Check size of a new mesh path table for changes since allocation.
      mac80211: Fix locking bug on mesh path table access
      mac80211: Move call to mpp_path_lookup inside RCU-read section
      mac80211: allow setting supported rates on mesh peers
      ath9k: fix beaconing for mesh interfaces
      nl80211: Move peer link state definition to nl80211

Javier Martinez Canillas (1):
      drivers/net: Remove IRQF_SAMPLE_RANDOM flag from network drivers

Jeff Kirsher (6):
      e1000e: convert to new VLAN model
      ixgbe: update version string for Dell CEM use
      ixgb: convert to set_phys_id
      e100: implemenet set_phys_id
      e1000: convert to set_phys_id
      igb: convert to ethtool set_phys_id

Jiejing Zhang (1):
      Bluetooth: hci_uart: check the return value of recv()

Jiri Pirko (3):
      net: vlan: make non-hw-accel rx path similar to hw-accel
      bonding: move processing of recv handlers into handle_frame()
      net: call dev_alloc_name from register_netdevice

Joe Perches (14):
      smsc911x: Use pr_fmt, netdev_<level>, and netif_<level>
      via_rhine: Use netdev_<level> and pr_<level>
      via-rhine: Assign random MAC address if necessary
      tg3: Convert u32 flag,flg2,flg3 uses to bitmap
      tulip: xircom_cb: Convert #ifdef DEBUG blocks and enter/leave uses
      tulip: Convert printks to netdev_<level>
      tulip: Convert uses of KERN_DEBUG
      tulip: Use pr_<level> where appropriate
      rtlwifi: rtl8192cu: Fix memset/memcpy using sizeof(ptr) not sizeof(*ptr)
      libertas: Convert lbs_pr_<level> to pr_<level>
      libertas: Use netdev_<level> or dev_<level> where possible
      sctp: sctp_sendmsg: Don't initialize default_sinfo
      sctp: sctp_sendmsg: Don't test known non-null sinfo
      netdevice.h: Align struct net_device members

Johan Hedberg (21):
      Bluetooth: Add define for the maximum name length on HCI level
      Bluetooth: mgmt: Add local name information to read_info reply
      Bluetooth: mgmt: Add support for setting the local name
      Bluetooth: Add local Extended Inquiry Response (EIR) support
      Bluetooth: Fix missing hci_dev_lock_bh in user_confirm_reply
      Bluetooth: Add mgmt_device_found event
      Bluetooth: Add mgmt_remote_name event
      Bluetooth: Add basic discovery commands to the management interface
      Bluetooth: Add discovering event to the Management interface
      Bluetooth: Add automated SSP user confirmation responses
      Bluetooth: Add variable SSP auto-accept delay support
      Bluetooth: Fix HCI_CONN_AUTH_PEND flag for all authentication requests
      Bluetooth: Add confirm_hint parameter to user confirmation requests
      Bluetooth: Fix reason code for pairing rejection
      Bluetooth: Fix logic in hci_pin_code_request_evt
      Bluetooth: Fix link key persistent storage criteria
      Bluetooth: Fix old_key_type logic for non-persistent keys
      Bluetooth: Fix connection key type updating for buggy controllers
      Bluetooth: Remove old_key_type from mgmt_ev_new_key
      Bluetooth: Add store_hint parameter to mgmt_new_key
      Bluetooth: Fix updating conn->auth_type in hci_io_capa_request_evt

Johannes Berg (68):
      iwlagn: clean up TX aggregation code
      iwlagn: fix aggregation queue scheduler setup
      mac80211: add comment about reordering
      mac80211: clean up station cleanup timer
      iwlagn: remove unused variable
      iwlagn: clean up some 3945/4965 remnants
      iwlagn: make mac80211 handlers static
      iwlagn: clean up ucode loading
      iwlagn: remove pointless return variables
      iwlagn: simplify ucode check code
      iwlagn: verify specific ucode
      iwlagn: remove bootstrap code
      iwlagn: centralize and fix ucode restart
      iwlagn: remove ucode_data_backup
      iwlagn: add feature flags
      iwlagn: fix ucode verify message
      iwlagn: clean up alive handling
      iwlagn: init cmd_queue earlier
      iwlagn: remove BSM clock setting
      iwlagn: remove hw_wa_rev
      iwlagn: remove hw_rev
      iwlagn: remove rev_id
      iwlagn: remove rxb page bookkeeping
      iwlagn: remove ISR ops
      iwlagn: move IO functions out of line
      iwlwifi: fix bugs in change_interface
      iwlagn: clean up & autodetect statistics
      iwlagn: downgrade warning on unknown TLV
      iwlagn: remove most BUG_ON instances
      iwlagn: verify that huge commands are synchronous
      iwlagn: use huge command for beacon
      mac80211: explain padding in place of rate field
      iwlagn: simplify error table reading
      iwlagn: clean up some exit code
      iwlagn: refactor down path
      iwlagn: refactor up path
      iwlagn: extend notification wait function
      iwlagn: make iwlagn_wait_notification return error code
      iwlagn: leave notification waits on firmware errors
      iwlagn: implement synchronous firmware load
      iwlagn: combine firmware code/data
      iwlagn: remove hw_ready variable
      mac80211: tear down BA sessions properly on suspend
      iwlagn: avoid hangs when restarting device
      iwlagn: introduce silent grabbing of NIC access
      iwlagn: refactor restart
      iwlagn: use proper good CRC threshold behaviour
      iwlagn: remove spectrum measurement header
      iwlagn: improve RXON checking
      iwlagn: prefer BSS context
      nl80211/cfg80211: WoWLAN support
      mac80211: add basic support for WoWLAN
      iwlagn: remove get_hcmd_size indirection
      iwlagn: remove frame pre-allocation
      iwlagn: remove unused variable
      iwlagn: dont update bytecount table for command queue
      iwlagn: remove bytecount indirection
      iwlagn: check DMA mapping errors
      iwlagn: fix iwl_is_any_associated
      cfg80211: restrict AP beacon intervals
      mac80211: remove pointless mesh path timer RCU code
      mac80211: make key locking clearer
      mac80211: fix another key non-race
      mac80211: fix a few RCU issues
      mac80211: mesh: move some code to make it static
      cfg80211: advertise possible interface combinations
      mac80211: fix TX a-MPDU locking
      mac80211: sparse RCU annotations

Johannes Stezenbach (4):
      rt2800usb: read TX_STA_FIFO asynchronously
      rt2x00: fix queue timeout checks
      rt2800usb: handle TX status timeouts
      rt2800usb: add timer to handle TX_STA_FIFO

John Fastabend (4):
      ixgbe: DCB, further cleanups to app configuration
      ixgbe: DCB, misallocated packet buffer size with X540 device
      ixgbe: DCB, X540 devices do not respond to pause frames
      ixgbe: fix static functions

John W. Linville (26):
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      ath5k: improve pcal error handling for ENOMEM case
      ath5k: improve comments for optimized tx descriptor setup
      ath9k: avoid using trinary operator w/ TX_STAT_INC
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      mwl8k: replace rateinfo bitfields with mask and shift macros
      ath5k: fix uninitialized var warning for txf2txs
      b43: avoid uninitialized variable warnings in phy_n
      mwifiex: fix copy-n-paste 'thinko' for tsf_val
      p54: avoid uninitialized variable warning for freq
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6
      ssb: fix pcicore build breakage
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Jon Mason (3):
      vxge: always enable hardware time stamp
      vxge: spin-lock issue
      vxge: update driver version

Jouni Malinen (4):
      ath9k: Support RSN IBSS
      cfg80211: Add nl80211 event for deletion of a station entry
      nl80211: Fix set_key regression with some drivers
      cfg80211: Remove unused wiphy flag

Jozsef Kadlecsik (1):
      netfilter: ipset: SCTP, UDPLITE support added

Julia Lawall (2):
      drivers/isdn/hisax: Drop unused list
      net/rfkill/core.c: Avoid leaving freed data in a list

Julian Anastasov (1):
      ipvs: Remove all remaining references to rt->rt_{src,dst}

Jussi Kivilinna (1):
      zd1211rw: rename CR* macros to ZD_CR*

Juuso Oikarinen (3):
      wl12xx: Fix potential incorrect band in rx-status
      wl12xx: Add mutex protection for interface list
      wl12xx: Handle duplicate calling of remove interface

KOSAKI Motohiro (2):
      convert old cpumask API into new one
      net: convert to new cpumask API

Kevin Gan (1):
      Bluetooth: btmrvl: support Marvell Bluetooth device SD8787

Kurt Van Dijck (2):
      can: make struct can_proto const
      can: rename can_try_module_get to can_get_proto

Larry Finger (7):
      rtlwifi: rtl8192c{e,u}: Remove some extraneous casts on memcpy commands
      rtlwifi: Remove unused/unneeded variables
      rtlwifi: Fix unitialized variable warnings
      rtlwifi: rtl8192ce: rtl8192cu: Fix most sparse warnings
      rtlwifi: Fix typo in pci.c
      mac80211: Fix build error when CONFIG_PM is not defined
      rtlwifi: Move 2 large arrays off stack

Layne Edwards (1):
      rt2x00: Enable WLAN LED on Ralink SoC (rt305x) devices

Linus L√ºssing (5):
      batman-adv: Move bonding / iface alternating router search to own functions
      batman-adv: Make gateway_get_selected type safe
      batman-adv: Simplify gw_check_election(), use gw_get_selected()
      batman-adv: Make orig_node->router an rcu protected pointer
      batman-adv: Protect global TQ window with a spinlock

Luciano Coelho (27):
      wl12xx: add new board_tcxo_clock element to the platform data
      wl12xx: 1281/1283 support - add block size handling for sdio and spi
      wl12xx: use 1 spare TX block instead of two
      wl12xx: set the skbuff priority for dummy packets
      wl12xx: fix SG BT load value to reflect its new meaning
      wl12xx: fix a couple of sparse warnings about undeclared functions
      wl12xx: use a bitmask instead of list of booleans in scanned_ch
      wl12xx: use kstrtoul functions
      wl12xx: move hardcoded hci_io_ds value into the conf struct
      wl12xx: remove unused conf_radio_params structure
      wl12xx: fix sparse warning about undeclared wl12xx_alloc_dummy_packet
      wl12xx: strict_stroul introduced converted to kstrtoul
      Revert "wl12xx: support FW TX inactivity triggers"
      mac80211: don't drop frames where skb->len < 24 in ieee80211_scan_rx()
      mac80211: add a couple of trace event classes to reduce duplicated code
      cfg80211/nl80211: add support for scheduled scans
      mac80211: add support for HW scheduled scan
      cfg80211/nl80211: add interval attribute for scheduled scans
      cfg80211/mac80211: avoid bounce back mac->cfg->mac on sched_scan_stopped
      wl12xx: add configuration values for scheduled scan
      wl12xx: listen to scheduled scan events
      wl12xx: add scheduled scan structures and commands
      wl12xx: implement scheduled scan driver operations and reporting
      wl12xx: export scheduled scan state in debugfs
      wl12xx: prevent sched_scan when not idle or not in station mode
      wl12xx: remove unused flag WL1271_FLAG_IDLE_REQUESTED
      wl12xx: fix compilation error when CONFIG_PM is not set

Luis R. Rodriguez (7):
      ath9k_hw: remove AR9485 1.0 support
      cfg80211: fix regulatory restore upon user hints
      cfg80211: add a timer for invalid user reg hints
      ath: fix 0x6C for beaconing/passive scan flags based on country IE
      cfg80211: fix regresion on reg user timeout
      ath9k_hw: fix power for the HT40 duplicate frames
      ath9k_hw: fix dual band assumption for XB113

Mahesh Bandewar (3):
      net: Allow ethtool to set interface in loopback mode.
      tg3: Allow ethtool to enable/disable loopback.
      bnx2x: Allow ethtool to enable/disable loopback.

Mammatha Edhala (1):
      be2net: Enable SR-IOV for Lancer

Marc Yang (6):
      mwifiex: remove unnecessary _set_auth functions
      mwifiex: use IEEE80211_HT_CAP_ macros for 11n cap_info
      mwifiex: remove MWIFIEX_AUTH_MODE_ macros
      mwifiex: remove unused radio_on variable and macros
      mwifiex: remove unused macros in fw.h
      mwifiex: cleanup power save related struct and macros

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Marek Lindner (6):
      batman-adv: concentrate all curr_gw related rcu operations in select/deselect functions
      batman-adv: Make bat_priv->primary_if an rcu protected pointer
      batman-adv: remove misplaced comment
      batman-adv: multi vlan support for bridge loop detection
      batman-adv: Fix refcount imbalance in find_router
      batman-adv: reset broadcast flood protection on error

Mark Brown (1):
      net: dm9000: Fix build

Mark Davis (1):
      rt2800usb: Add seven new USB IDs

Mathieu J. Poirier (1):
      net: allow shifted access in smsc911x V2

Matt Carlson (44):
      tg3: Cleanup extended rx ring size code
      tg3: 5717_PLUS => 57765_PLUS
      tg3: Reintroduce 5717_PLUS
      tg3: Add 5720 ASIC rev
      tg3: Add 5720 NVRAM decoding
      tg3: Add 5720 H2BMC support
      tg3: Add 5720 PHY ID
      tg3: Enable 5720 support
      tg3: Support 4mb flash sizes for 5717 and 5719
      tg3: Provide full regdump on tx timeout
      tg3: Dump registers when status block shows errors
      tg3: Automatically size stat/test string arrays
      tg3: Add jumbo frame loopback tests to selftest
      tg3: Add support for extended VPD blocks
      tg3: Workaround rx_discards stat bug
      tg3: Adjust rx prod ring bd replenish thresholds
      tg3: Nullify RSS for loopback test
      tg3: Only allow phy ioctls while netif_running
      tg3: Move phy accessor functions higher
      tg3: Add read accessor for AUX CTRL phy reg
      tg3: Add write accessor for AUX CTRL phy reg
      tg3: Add macro for SMDSP toggling
      tg3: Add additional EEE messaging
      tg3: Fix int generation hw bug for 5719 / 5720
      tg3: Organize loopback test failure flags
      tg3: Add TSO loopback test
      tg3: Add EEH support
      tg3: Whitespace cleanups
      tg3: Update version to 3.118
      tg3: Set tx bug flags for more devices
      tg3: Cleanup transmit error path
      tg3: Fix 57765 B0 data corruption
      tg3: Fix IPv6 TCP problems for 5719
      tg3: Fix EEE interoperability workaround
      tg3: Consolidate autoneg advertisement setup code
      tg3: Fix TSO loopback test
      tg3: Fix stats for 5704 and later devices
      tg3: Move TSO_CAPABLE assignment
      tg3: Consolidate all netdev feature assignments
      tg3: Remove excessive parenthesis
      tg3: Apply rx_discards fix to 5719/5720
      tg3: Update version to 3.119
      tg3: Fix NETIF_F_LOOPBACK error
      tg3: Add braces around 5906 workaround.

Micha Nelissen (1):
      ipconfig wait for carrier

Michael Chan (1):
      cnic: Fix rtnl deadlock

Michael S. Tsirkin (1):
      net: Change netdev_fix_features messages loglevel

Michael Smith (2):
      fib_validate_source(): pass sk_buff instead of mark
      Disable rp_filter for IPsec packets

Michal Marek (2):
      rt2x00: Drop __TIME__ usage
      tipc: Drop __TIME__ usage

Micha≈Ç Miros≈Çaw (74):
      virtio_net: convert to hw_features
      net: convert SMSC USB net drivers to hw_features
      net: convert xen-netfront to hw_features
      jme: convert offload constraints to ndo_fix_features
      veth: convert to hw_features
      net: convert sunhme/sungem network drivers to hw_features
      net: Call netdev_features_change() from netdev_update_features()
      vlan: convert VLAN devices to use ndo_fix_features()
      net: netxen: convert to hw_features
      skge: convert to hw_features
      net: benet: convert to hw_features
      net: enic: convert to hw_features
      net: tg3: convert to hw_features
      net: atl*: convert to hw_features
      net: Remove invalid offloads
      net: benet: convert to hw_features - fixup
      net: r8169: convert to hw_features
      net: 8139cp: convert to hw_features
      net: stmmac: convert to hw_features
      net: ksz884x: convert to hw_features
      net: via-velocity: convert to hw_features
      net: bnx2: convert to hw_features
      net: add RTNL_ASSERT in __netdev_update_features()
      net: sky2: convert to hw_features
      net: ps3_gelic: convert to hw_features
      net: bna: convert to hw_features
      net: bnx2x: convert to hw_features
      net: ioc3: convert to hw_features
      net: vlan_features comment clarification
      net: spider_net: convert to hw_features
      net: dm9000: convert to hw_features
      net: forcedeth: convert to hw_features
      net: mlx4: convert to hw_features
      net: gianfar: convert to hw_features
      net: macvlan: convert to hw_features
      net: cxgb3: convert to hw_features
      net: tehuti: convert to hw_features
      net: mv643xx: convert to hw_features
      net: typhoon: convert to hw_features
      net: benet: convert to hw_features - fixup
      net: ehea: convert to hw_features
      net: niu: convert to hw_features
      net: greth: convert to hw_features
      net: ibm_newemac: convert to hw_features
      net: cxgb4{,vf}: convert to hw_features
      net: myri10ge: convert to hw_features
      net: fix section mismatches
      net: s2io: convert to hw_features
      net: chelsio: convert to hw_features
      net: vxge: convert to hw_features
      net: vmxnet3: convert to hw_features
      net: qlge: convert to hw_features
      net: dsa: remove ethtool_ops->set_sg
      net: batman-adv: remove rx_csum ethtool_ops
      Staging: convert hv network driver to hw_features
      net: infiniband/hw/nes: convert to hw_features
      net: s390: convert to hw_features
      net: infiniband/ulp/ipoib: convert to hw_features
      net: pch_gbe: convert to hw_features
      net: ibmveth: convert to hw_features
      net: qlcnic: convert to hw_features
      net: xen-netback: convert to hw_features
      net: tun: convert to hw_features
      net: fix hw_features ethtool_ops->set_flags compatibility
      net: make WARN_ON in dev_disable_lro() useful
      net: fix netdev_increment_features()
      bridge: convert br_features_recompute() to ndo_fix_features
      net: allow user to change NETIF_F_HIGHDMA
      net: ibmveth: force reconfiguring checksum settings on startup
      net: bonding: factor out rlock(bond->lock) in xmit path
      net: Fix vlan_features propagation
      net: introduce netdev_change_features()
      bonding: convert to ndo_fix_features
      net: ethtool: fix IPV6 checksum feature name string

Mohammed Shafi Shajakhan (20):
      ath9k: cleanup few redundant macros
      ath9k: remove set11n_virtualmorefrag
      ath9k_hw: remove ath9k_get_channel_edges
      mac80211: remove few obsolete flags
      {mac|nl}80211: Add station connected time
      ath9k: remove the unlikely check for autosleep
      ath9k: Add TSFOOR interrupt stats in debug info
      mac80211: Fix a warning due to skipping tailroom reservation for IV
      ath9k_hw: remove aggregation protection mode
      ath9k_hw: remove get_channel_noise function
      ath9k_hw: make antenna diversity modules chip specific
      ath9k_hw: enable Antenna diversity for AR9485
      ath9k_hw: define registers/macros to support Antenna diversity
      ath9k_hw: config diversity based on eeprom contents
      ath9k_hw: define modules to get/set Antenna diversity paramaters
      ath9k_hw: define antenna diversity group
      ath9k: Implement an API to swap main/ALT LNA's
      ath9k: configure fast_div_bias based on diversity group
      ath9k: make sure main_rssi is positive
      ath9k: make npending frames check as bool

Nicolas Cavallari (1):
      carl9170: fix allmulticast mode

Nishant Sarmukadam (9):
      mwl8k: add support for block ack commands
      mwl8k: Initiate BA sessions
      mwl8k: Handle the watchdog event from the firmware
      mwl8k: Check outgoing rate for a station to decide if ampdu can be created
      mwl8k: Queue ADDBA requests in respective data queues
      mwl8k: Do not configure tx power unconditionally
      mwl8k: interrupt handling changes
      mwl8k: Reserve buffers for tx management frames
      mwl8k: Enable life time expiry for tx packets in the hardware

Ohad Ben-Cohen (3):
      wl12xx: update bet_max_consecutive
      wl12xx: fix roaming
      wl12xx: fix "JOIN while associated" commentary

Oliver Hartkopp (1):
      can: convert protocol handling to RCU

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix timestamp support for new conntracks

Padmanabh Ratnakar (5):
      be2net: Handle error completion in Lancer
      be2net: Disable coalesce water mark mode of CQ for Lancer
      be2net: In case of UE, do not dump registers for Lancer
      be2net: Use NTWK_RX_FILTER command for promiscous mode
      be2net: Fix to prevent flooding of TX queue

Patrick McHardy (2):
      netfilter: nf_ct_sip: validate Content-Length in TCP SIP messages
      netfilter: nf_ct_sip: fix SDP parsing in TCP SIP messages for some Cisco phones

Paul Bolle (1):
      iwl4965: drop a lone pr_err()

Paul Gortmaker (1):
      tipc: make zone/cluster mask constants a define

Paul Stewart (1):
      nl80211: Add BSS parameters to station

Peter Pan(ÊΩòÂç´Âπ≥) (1):
      net:set valid name before calling ndo_init()

Pradeep Nemavat (2):
      mwl8k: Do not stop tx queues
      mwl8k: Add timestamp information for tx packets

Rafa≈Ç Mi≈Çecki (28):
      ssb: trivial: use u8 for chip_rev (it's mask is 0xF)
      ssb: pci: trivial: drop useless pointer
      ssb: pci: fix mdio writes on newer cores (rev 10+)
      ssb: pci: implement mdio reading
      ssb: pci: implement serdes workaround
      ssb: pci: trivial: correct amount of maximum retries
      ssb: cc: use correct min_msk for 0x4312
      ssb: cc: add & fix defines
      ssb: cc: clear GPIOPULL registers on init
      ssb: mark bus as powered up earlier
      ssb: update reject bit for Target State Low
      ssb: pci: separate workarounds
      ssb: pci: update PCIe workarounds
      ssb: pci: early fix for SPROM core index
      ssb: cc: prepare clockmode support for cores rev 10+
      b43: drop invalid IMCFGLO workaround
      b43legacy: drop invalid IMCFGLO workaround
      b43: drop ssb-duplicated workaround for dangling cores
      b43legacy: drop ssb-duplicated workaround for dangling cores
      b43: trivial: include ssb word in ssb specific functions
      bcma: add Broadcom specific AMBA bus driver
      ssb: update list of devices supporting multiple 80211 cores
      b43legacy: trivial: use TMSLOW def instead of magic value
      b43: move MAC PHY clock controling function
      bcma: add missing GPIO defines, use PULL register only when available
      ssb: move ssb_commit_settings and export it
      b43: implement timeouts workaround
      bcma: pci: trivial: correct amount of maximum retries

Rajesh Borundia (1):
      qlcnic: Fix LRO disable

Rajkumar Manoharan (32):
      ath9k_htc: Fix LED pin for AR9287 HTC device
      ath9k_hw: Fix throughput drops in HT40 mode for AR9287 chips
      ath: Speedup key set/reset ops for HTC driver
      ath9k_hw: Speedup register ops for HTC driver
      ath9k: deny new interface addtion on IBSS mode
      ath9k: Cleanup ath_vif struct
      ath9k: Handle BSSID/AID for multiple interfaces
      ath9k: configure beacons based on hw opmode
      ath9k_hw: Fix instable target power control b/w CCK/OFDM
      ath9k: Fix kernel panic on module unload
      ath9k_hw: Remove unused code in AR9287 eeprom
      ath9k_hw: update Ar9003 intervals to fix carrier leak
      ath9k_hw: update AR9003 low_ob_db_tx_gain to improve spur performance
      ath9k: Fix improper beacon slot selection in IBSS
      ath9k_htc: Add debugfs support to change debug mask
      ath9k_htc: Cleanup HTC debugfs
      ath9k_htc: Fix free slot value for cab queue
      ath9k: Fix beacon generation on foreign channel
      ath9k_hw: Fix Tx IQ Calibration hang issue in AR9003 chips
      ath9k: set beacon related ps flags on bss_info change
      mac80211: Fix warnings due to -Wunused-but-set-variable
      ath9k: Fix drain txq failure in flush
      mac80211: use wake_queue to restart trasmit
      mac80211: Postpond ps timer if tx is stopped by others
      ath9k_hw: do noise floor calibration only on required chains
      wireless: Fix warnings due to -Wunused-but-set-variable
      ath9k: avoid enabling interrupts while processing rx
      ath9k: process TSF out of range before RX
      ath9k_hw: Corrected xpabiaslevel register settings for AR9340
      ath9k_hw: Change DCU backoff thresh for AR9340
      ath9k: Fix rssi update in ad-hoc mode
      ath9k: Failed to set default beacon rssi in AP/IBSS mode

Ralf Baechle (1):
      NET: AX.25, NETROM, ROSE: Remove SOCK_DEBUG calls

Randy Dunlap (4):
      mac80211: fix debugfs printk format warning
      libertas: use kernel-doc notation, fix comment style
      x86/net: only select BPF_JIT when NET is enabled
      networking: NET_CLS_ROUTE4 depends on INET

Rob Landley (1):
      net: minor cleanup to net_namespace.c.

Roopa Prabhu (4):
      enic: Add support for new fw devcmds for port profile handling
      enic: Add wrapper routines for new fw devcmds for port profile handling
      enic: Cleanups in port profile helper code
      enic: Add support for PORT_REQUEST_PREASSOCIATE_RR

R√©mi Denis-Courmont (1):
      Phonet: convert bound sockets hash list to RCU

Sascha Silbe (1):
      libertas: Add libertas_disablemesh module parameter to disable mesh interface

Sathya Perla (7):
      be2net: refactor code that decides adapter->num_rx_queues
      be2net: parse vid and vtm fields of rx-compl only if vlanf bit is set
      be2net: remove redundant code in be_worker()
      be2net: cancel be_worker in be_shutdown() even when i/f is down
      be2net: remove one useless line
      be2net: handle signal reception while waiting for POST
      be2net: fix mbox polling for signal reception

Sebastian Ott (1):
      qeth: add owner to ccw driver

Selvin Xavier (1):
      be2net: Stats for Lancer

Senthil Balasubramanian (9):
      ath9k: Add RSSI information from control and extension chains
      ath9k: Update gain table for AR9485
      ath: Add a missing world regulatory domain 0x6C
      ath9k: Fix LED gpio for AR93xx chipsets.
      ath9k_hw: Fix incorrect baseband PLL phase shift for AR9485
      ath9k: optimize the usage of power save wrappers.
      ath9k: cleanup hw pll work handler
      ath9k: Add power save wrappers and modularize hw_pll handler
      ath9k_hw: Fix STA connection issues with AR9380 (XB113).

Sergei Shtylyov (1):
      iwlegacy: use pci_dev->revision

Shahar Levi (17):
      wl12xx: 1281/1283 support - move IRQ polarity
      wl12xx: 1281/1283 support - Add Definitions
      wl12xx: 1281/1283 support - Add acx commands
      wl12xx: 1281/1283 support - New radio structs and functions
      wl12xx: 1281/1283 support - Loading FW & NVS
      wl12xx: 1281/1283 support - New boot sequence
      wl12xx: 1281/1283 support - use dynamic memory for the RX/TX pools
      wl12xx: 1281/1283 support - Improve Tx & Rx path
      wl12xx: 1281/1283 support - Add dummy packet support
      wl12xx: 1281/1283 support - enable chip support
      wl12xx: Add support for 11n Rx STBC one spatial stream
      wl12xx: Set End-of-transaction Flag at Wl127x AP Mode
      wl12xx: Set correct REF CLK and TCXO CLK values to the FW
      wl12xx: FM WLAN coexistence
      wl12xx: Update Power Save Exit Retries Packets
      wl12xx: Don't filter beacons that include changed HT IEs
      wl12xx: add IEEE80211_HW_SPECTRUM_MGMT bit to the hw flags

Shan Wei (13):
      net: forcedeth: fix compile warning of not used nv_set_tso function
      net:bna: fix compile warning of ‚Äòbfa_ioc_smem_pgoff‚Äô defined but not used
      sctp: delete unused macro definition of sctp_chunk_is_control
      sctp: fix the comment of sctp_sf_violation_paramlen()
      sctp: use common head of addr parameter to access member in addr-unrelated code
      sctp: kill abandoned SCTP_CMD_TRANSMIT command
      sctp: use memdup_user to copy data from userspace
      sctp: check parameter value of length in ERROR chunk
      sctp: check invalid value of length parameter in error cause
      sctp: remove redundant check when walking through a list of TLV parameters
      sctp: handle ootb packet in chunk order as defined
      net:use help function of skb_checksum_start_offset to calculate offset
      net: drivers: kill two unused macro definitions

Shmulik Ravid (1):
      bnx2x: add support for retrieving dcb peer configuration

Shreyas Bhatewara (1):
      vmxnet3: Use single tx queue when CONFIG_PCI_MSI not defined

Shripad Nunjundarao (1):
      be2net: FW download for Lancer

Simon Horman (1):
      IPVS: combine consecutive #ifdef CONFIG_PROC_FS blocks

Simon Wunderlich (1):
      batman-adv: protect softif_neigh by rcu

Sjur Br√¶ndeland (2):
      caif: Don't resend if dev_queue_xmit fails.
      caif: Add BUG_ON if dev_info is missing in packet

Somnath Kotur (2):
      be2net: Support for FAT dump retrieval using ethtool --register-dump option
      be2net: Fixed a bug in be_cmd_get_regs().

Sony Chacko (3):
      qlcnic: Make PCI info available in all modes
      qlcnic: Memory leak fix
      qlcnic: Support for GBE port settings

Sritej Velaga (1):
      qlcnic: Use flt method to determine flash fw region

Stanislaw Gruszka (16):
      iwlegacy: MAINTAINERS
      iwlwifi: fix enqueue hcmd race conditions
      iwlwifi: more priv->mutex serialization
      iwlwifi: remove sync_cmd_mutex
      iwlwifi: fix possible data overwrite in hcmd callback
      iwlagn: fix tx power initialization
      iwlegacy: remove duplicate initialization in iwl4956_down()
      iwlegacy: enable only rfkill interrupt when device is down
      iwlegacy: simplify init geos
      iwlegacy: remove unneeded disable_hw_scan check
      iwlegacy: remove unneeded __packed
      iwlegacy: remove scan_tx_antennas
      iwlegacy: comment typo fix diable -> disable
      iwlegacy: fix enqueue hcmd race conditions
      iwlegacy: more priv->mutex serialization
      iwlegacy: remove sync_cmd_mutex

Stefan Assmann (2):
      igb: fix typo in igb_validate_nvm_checksum_82580
      igb: introduce igb_thermal_sensor_event for sensor checking

Stephen Boyd (2):
      iwlegacy: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
      iwlwifi: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning

Stephen Hemminger (3):
      caif: code cleanup
      bridge: fix accidental creation of sysfs directory
      ethtool: remove phys_id from ethtool_ops

Sucheta Chakraborty (2):
      qlcnic: fix memory leak in qlcnic_blink_led.
      qlcnic: support rcv ring configuration through ethtool

Sujith Manoharan (53):
      ath9k_htc: Remove AR7010 v1.0 support
      ath9k_htc: Rename firmware
      ath9k_htc: Add a WMI command to get the firmware version
      ath9k_htc: Fix WMI and beacon header
      ath9k_htc: Add beacon slots
      ath9k_htc: Add TSF adjust capability
      ath9k_htc: Configure the beacon queue
      ath9k_htc: Handle buffered frames in AP mode
      ath9k_htc: Fix beacon miss under heavy load
      ath9k_htc: Queue WMI events
      ath9k_htc: Move debug code to a separate file
      ath9k_htc: Add RX error statistics
      ath9k_htc: Fix RX length check
      ath9k_htc: Remove unused WMI commands
      ath9k_htc: Use SKB's private area for TX parameters
      ath9k_htc: Sync struct ath9k_htc_target_sta with FW
      ath9k_htc: Sync struct ath9k_htc_target_vif with FW
      ath9k_htc: Sync struct ath9k_htc_cap_target with FW
      ath9k_htc: Remove unused WMI_WLAN_TXCOMP_EVENTID
      ath9k_htc: Move TX specific stuff to a separate structure
      ath9k_htc: Reduce TX queue size
      ath9k_htc: Sync MGMT/DATA packet headers with firmware
      ath9k_htc: Add a new WMI event WMI_TXSTATUS_EVENTID
      ath9k_htc: Increase URB count for REG_IN pipe
      ath9k_htc: Fix TX queue management
      ath9k_htc: Introduce new HTC API
      ath9k_htc: Move endpoint header parsing to TX tasklet
      ath9k_htc: Add TX slots
      ath9k_htc: Use helper functions for TX processing
      ath9k_htc: Drain pending TX frames properly
      ath9k_htc: Optimize HTC start/stop API
      ath9k_htc: Drain packets on station removal
      ath9k_htc: Add support for TX completion
      ath9k_htc: Add a debugfs file to dump TX slot information
      ath9k_htc: Add a debugfs file showing endpoint status
      ath9k_htc: Add a timer to cleanup WMI events
      ath9k_htc: Use separate URB pool for management frames
      ath9k_htc: Use helper routines for transmission
      ath9k_htc: Add detailed firmware statistics
      ath9k_htc: Enable AP and P2P modes
      ath9k: Fix warnings from -Wunused-but-set-variable
      ath9k_htc: Fix AMPDU subframe handling
      ath9k_htc: Fix max A-MPDU size handling
      ath9k_htc: Use power save wrappers when accessing HW
      ath9k_htc: Remove unused macros and structures
      mac80211: Add new API for rate selection
      ath9k_htc: Increase credit size for AR7010 devices
      ath9k_htc: Remove unused WMI_AGGR_LIMIT_CMD
      ath9k_htc: Add a new WMI command to set a rate mask
      ath9k_htc: Add set_bitrate_mask() callback
      ath9k_htc: Dump base eeprom header for UB91/94/95
      ath9k_htc: Dump modal eeprom header for UB91/94/95
      ath9k_htc: Revamp LED management

Suraj Sumangala (1):
      Bluetooth: Increment unacked_frames count only the first transmit

Sven Eckelmann (4):
      batman-adv: Remove unnecessary hardif_list_lock
      batman-adv: Avoid deadlock between rtnl_lock and s_active
      batman-adv: Remove multiline comments from line ending
      batman-adv: Add missing hardif_free_ref in forw_packet_free

Szymon Janc (16):
      Bluetooth: Opencode macros in bnep/core.c
      Bluetooth: Fix checkpatch errors and some code style issues in bnep
      Bluetooth: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
      Bluetooth: Fix checkpatch errors, code style issues and typos in hidp
      Bluetooth: Do not use assignments in IF conditions
      Bluetooth: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
      Bluetooth: Fix checkpatch error in cmtp.h
      Bluetooth: Rename cmd to param in pending_cmd
      Bluetooth: Allow for NULL data in mgmt_pending_add
      Bluetooth: Add read_local_oob_data management command
      Bluetooth: Add add/remove_remote_oob_data management commands
      Bluetooth: Enable support for out of band association model
      Bluetooth: Use kthread API in hidp
      Bluetooth: Use kthread API in bnep
      Bluetooth: Use kthread API in cmtp
      Bluetooth: Fix Out Of Band pairing when mgmt interface is disabled

Thiago Farina (1):
      drivers/net/usb/usbnet.c: Use FIELD_SIZEOF macro in usbnet_init() function.

Thomas Gleixner (1):
      Bluetooth: Fix warning with hci_cmd_timer

Thomas Pedersen (3):
      nl80211: allow installing keys for a meshif
      nl80211: allow setting MFP flag for a meshif
      mac80211: Self-protected management frames are not robust

Tom Herbert (1):
      net: Allow no-cache copy from user on transmit

Ursula Braun (3):
      ctcm: get rid of compile warning
      iucv: get rid of compile warning
      af_iucv: get rid of compile warning

Vasanthakumar Thiagarajan (27):
      ath9k_hw: Use appropriate rx gain table for AR9485
      ath9k: Implement integer mode for AR9485
      ath9k: Register id table for platform device
      ath9k_hw: Define devid and mac version for AR9340
      ath9k_hw: Take care of few host interface register changes for AR9340
      ath9k_hw: Get AHB clock information from ath9k_platform_data
      ath9k_hw: Configure pll control register accordingly for AR9340
      ath9k_hw: Add initvals.h for ar9340
      ath9k_hw: Initialize mode registers from initvals.h for AR9340
      ath9k_hw: Don't do ani initialization for AR9340
      ath9k_hw: Initialize tx and rx gain table from initvals.h for ar9340
      ath9k_hw: Read spur frequency information from eeprom for AR9340
      ath9k_hw: Configure RF channel freqency for AR9340
      ath9k_hw: Clean up rx/tx chain configuration before AGC/IQ cal
      ath9k_hw: Fix register offset AR_PHY_65NM_CH0_THERM for AR9340
      ath9k_hw: Don't configure AR_CH0_THERM for AR9340
      ath9k_hw: Skip internal regulator configuration for AR9340
      ath9k_hw: Configure tuning capacitance value for AR9340 as well
      ath9k_hw: Enable byte Tx/Rx data swap for AR9340
      ath9k_hw: Configure chain switch table and attenuation control only for active chains
      ath9k_hw: Read iq calibration data only for active chains
      ath9k: Add AR9340 platform id to id table
      ath9k_hw: Assign macversion based on devid for built-in wmac
      ath9k_hw: Disable INTR_HOST1_FATAL to avoid interrupt strom with ar9430
      ath9k_hw: Enable AR9340 support
      ath9k: Fix bug in configuring hw timer
      ath9k: Fix warning: symbol 'ath9k_platform_id_table' was not declared. Should it be static?

Vasiliy Kulikov (2):
      net: ipv4: add IPPROTO_ICMP socket kind
      net: ping: fix build failure

Vasily Khoruzhick (1):
      libertas_spi: Add support for suspend/resume

Vinicius Costa Gomes (3):
      Bluetooth: Fix sending LE data over USB
      Bluetooth: Add support for sending connection events for LE links
      Bluetooth: Add support for disconnecting LE links via mgmt

Viresh KUMAR (1):
      net/stmmac: Move "#include <linux/platform_device.h>" to linux/stmmac.h

Vivek Natarajan (6):
      mac80211: Check for queued frames before entering power save.
      ath9k: Implement dev_tx_frames_pending callback.
      ath9k_hw: Move bt_stomp to hw from common.
      ath9k_hw: Add support for btcoexistence in AR9300.
      ath9k_hw: Enable generic timer interrupt.
      ath9k: Use ps wrappers for btcoex logic.

Vlad Yasevich (9):
      sctp: teach CACC algorithm about removed transports
      sctp: Allow bindx_del to accept 0 port
      sctp: Release all routes when processing acks ADD_IP or DEL_IP
      sctp: remove completely unsed EMPTY state
      sctp: bail from sctp_endpoint_lookup_assoc() if not bound
      sctp: cache the ipv6 source after route lookup
      sctp: make sctp over IPv6 work with IPsec
      sctp: remove useless arguments from get_saddr() call
      sctp: clean up route lookup calls

Vladislav Zolotarov (1):
      bnx2x: link report improvements

Waldemar Rymarkiewicz (7):
      Bluetooth: Add definitions for link key types
      Bluetooth: Don't modify sec_level if auth failed
      Bluetooth: Map sec_level to link key requirements
      Bluetooth: Ignore key unauthenticated for high security
      Bluetooth: Respect local MITM req in io_cap reply
      Bluetooth: Add secure flag for mgmt_pin_code_req
      Bluetooth: Double check sec req for pre 2.1 device

Wei Yongjun (7):
      net: fix skb_add_data_nocache() to calc csum correctly
      sctp: fix to check the source address of COOKIE-ECHO chunk
      sctp: make heartbeat information in sctp_make_heartbeat()
      sctp: move chunk from retransmit queue to abandoned list
      sctp: implement socket option SCTP_GET_ASSOC_ID_LIST
      sctp: change auth event type name to SCTP_AUTHENTICATION_EVENT
      sctp: implement event notification SCTP_SENDER_DRY_EVENT

Weixing Shi (1):
      sctp: fix sctp to work with ipv6 source address routing

Wey-Yi Guy (34):
      iwlegacy: MAINTAINERS
      iwlagn: use 6030 configuration for 6035 series
      iwlwifi: remove legacy isr tasklet
      iwlagn: remove 3945 only station code
      iwlagn: remove reference to 3945 and 4965
      iwlagn: remove deprecated module parameters
      iwlagn: remove more 3945/4965 related defines
      iwlagn: return send calibration result
      iwlagn: change Copyright to 2011
      iwlagn: check more error return code
      iwlagn: remove un-necessary function pointer
      iwlagn: PAPD read for 2000 series devices
      iwlagn: no 3945 define needed
      iwlagn: remove unused 3945 define
      iwlagn: cleanup to remove the reference for 3945
      iwlagn: remove more reference to legacy devices
      iwlagn: remove un-needed configuration
      iwlagn: more cleanup to remove unused reference
      iwlagn: all _agn devices support power save mode
      iwlagn: tx power calib always done in firmware
      iwlagn: sensitivity and chain noise done by driver
      iwlagn: use direct call for led functions
      iwlagn: always support uCode trace
      iwlagn: temperature should be measure for all _agn devices
      iwlagn: no 5.2GHz/HT40 support for bgn devices
      iwlagn: remove un-necessary ieee80211_ops
      iwlagn: remove legacy ops
      iwlagn: remove led_ops
      iwlagn: make rxon_assoc static function
      iwlagn: remove 5000 from rxon_assoc structure
      iwlagn: connect and disconnect sequence for RXON
      iwlagn: new 105 series device
      iwlagn: remove un-necessary debugfs callback
      iwlagn: led stay solid on when no traffic

Xose Vazquez Perez (1):
      wireless: rt2x00: rt{2500,73}usb.c fix duplicate ids

Yaniv Rosner (1):
      ethtool: Add 20G bit definitions

Yi Zou (2):
      ixgbe: do not clear FCoE DDP error status for received ABTS
      net: group FCoE related feature flags

Yogesh Ashok Powar (14):
      mwifiex: remove helper functions for displaying 11n capabilities
      mwifiex: remove redundant encryption_mode mapping
      mwifiex: use common keyinfo bitmap for different key types
      mwl8k: Fix checkpatch.pl and sparse warnings and errors
      mwifiex: remove redundant "return" at end of void function
      mwifiex: remove redundant local variables and comments
      mac80211: Skip tailroom reservation for full HW-crypto devices
      mwl8k: Reducing extra_tx_headroom for tx optimization in AP mode
      mwifiex: remove unnecessary variable initialization
      mwl8k: Fix broken WEP
      mwl8k: Do not ask mac80211 to generate IV for crypto keys
      mac80211: Fix mesh-related build breakage...
      cfg80211: make stripping of 802.11 header optional from AMSDU
      mwifiex: use ieee80211_amsdu_to_8023s routine

amit salecha (2):
      net: ethtool support to configure number of channels
      pktgen: create num frags requested

cozybit Inc (1):
      mac80211: Allocate new mesh path and portal tables before taking locks

hayeswang (3):
      net/r8169: add a new chip for RTL8105
      net/r8169: add a new chip for RTL8168DP
      net/r8169: support RTL8168E

roel (2):
      ath9k_hw: index out of bounds
      ath9k: index out of bounds

root (1):
      iwlwifi: remove extranious macro from firmware define

simon (3):
      usb: plusb: Whitespace
      usb: plusb: Add support for PL-25A1
      usb: plusb: Add debug to reset function

sjur.brandeland@stericsson.com (10):
      caif: Use rcu_read_lock in CAIF mux layer.
      caif: Use RCU instead of spin-lock in caif_dev.c
      caif: Use RCU and lists in cfcnfg.c for managing caif link layers
      caif: Add ref-count to framing layer
      caif: Move refcount from service layer to sock and dev.
      caif: Protected in-flight packets using dev or sock refcont.
      caif: prepare support for namespaces
      caif: Handle dev_queue_xmit errors.
      caif: Bugfix debugfs directory name must be unique.
      caif: remove unesesarry exports

stephen hemminger (25):
      pkt_sched: QFQ - quick fair queue scheduler
      bridge: change arguments to fdb_create
      bridge: track last used time in forwarding table
      bridge: split rcu and no-rcu cases of fdb lookup
      bridge: add netlink notification on forward entry changes
      bridge: allow creating/deleting fdb entries via netlink
      bridge: allow creating bridge devices with netlink
      bridge: range check STP parameters
      sky2: support ethtool set_phys_id
      skge: implement set_phys_id
      tg3: implement ethtool set_phys_id
      cxgb3: implement set_phys_id
      vxge: convert to set_phys_id
      bnx2: convert to set_phys_id
      bnx2x: convert to set_phys_id
      benet: convert to set_phys_id
      pcnet32: convert to set_phys_id
      niu: convert to new ethtool set_phys_id
      s2io: convert to set_phys_id (v2)
      qlcnic: convert to set_phys_id
      ewrk3: convert to set_phys_id
      qlge: use ethtool set_phys_id
      sfc: make function tables const
      qlge: make nic_operations struct const
      igbvf: remove bogus phys_id

 Documentation/ABI/testing/sysfs-bus-bcma           |   31 +
 Documentation/feature-removal-schedule.txt         |   21 -
 Documentation/networking/batman-adv.txt            |   11 +-
 Documentation/networking/bonding.txt               |   34 +-
 Documentation/networking/igb.txt                   |   13 +
 Documentation/sysctl/net.txt                       |   11 +
 MAINTAINERS                                        |   21 +-
 arch/mips/txx9/generic/setup_tx4939.c              |   21 +-
 arch/powerpc/include/asm/systbl.h                  |    1 +
 arch/powerpc/include/asm/unistd.h                  |    3 +-
 arch/sparc/include/asm/unistd.h                    |    3 +-
 arch/sparc/kernel/systbls_32.S                     |    2 +-
 arch/sparc/kernel/systbls_64.S                     |    4 +-
 arch/x86/Kbuild                                    |    1 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/ia32/ia32entry.S                          |    1 +
 arch/x86/include/asm/unistd_32.h                   |    3 +-
 arch/x86/include/asm/unistd_64.h                   |    2 +
 arch/x86/kernel/syscall_table_32.S                 |    1 +
 arch/x86/net/Makefile                              |    4 +
 arch/x86/net/bpf_jit.S                             |  140 +
 arch/x86/net/bpf_jit_comp.c                        |  654 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/atm/eni.c                                  |    5 -
 drivers/atm/he.c                                   |    4 +-
 drivers/atm/idt77252.c                             |   52 +-
 drivers/atm/iphase.c                               |   14 +-
 drivers/atm/solos-pci.c                            |    3 +-
 drivers/bcma/Kconfig                               |   33 +
 drivers/bcma/Makefile                              |    7 +
 drivers/bcma/README                                |   19 +
 drivers/bcma/TODO                                  |    3 +
 drivers/bcma/bcma_private.h                        |   28 +
 drivers/bcma/core.c                                |   51 +
 drivers/bcma/driver_chipcommon.c                   |   89 +
 drivers/bcma/driver_chipcommon_pmu.c               |  134 +
 drivers/bcma/driver_pci.c                          |  163 +
 drivers/bcma/host_pci.c                            |  196 +
 drivers/bcma/main.c                                |  247 +
 drivers/bcma/scan.c                                |  360 +
 drivers/bcma/scan.h                                |   56 +
 drivers/bluetooth/Kconfig                          |    4 +-
 drivers/bluetooth/ath3k.c                          |    4 +-
 drivers/bluetooth/btmrvl_sdio.c                    |  124 +-
 drivers/bluetooth/btmrvl_sdio.h                    |   68 +-
 drivers/bluetooth/btusb.c                          |    1 +
 drivers/bluetooth/hci_ath.c                        |    7 +-
 drivers/bluetooth/hci_h4.c                         |    7 +-
 drivers/bluetooth/hci_ldisc.c                      |    6 +-
 drivers/ieee802154/fakehard.c                      |   10 -
 drivers/infiniband/core/addr.c                     |    9 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |    3 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    3 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    5 +-
 drivers/infiniband/hw/nes/nes_hw.h                 |    1 -
 drivers/infiniband/hw/nes/nes_nic.c                |   59 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   11 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |   28 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   24 +-
 drivers/isdn/capi/Kconfig                          |   15 -
 drivers/isdn/capi/Makefile                         |    1 -
 drivers/isdn/capi/capi.c                           |  139 +-
 drivers/isdn/capi/capifs.c                         |  239 -
 drivers/isdn/capi/capifs.h                         |   28 -
 drivers/isdn/gigaset/bas-gigaset.c                 |    5 -
 drivers/isdn/gigaset/ev-layer.c                    |   26 +-
 drivers/isdn/hardware/eicon/debug.c                |    3 +-
 drivers/isdn/hardware/eicon/message.c              |   23 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |    6 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    5 +-
 drivers/isdn/hisax/arcofi.c                        |    4 +-
 drivers/isdn/hisax/elsa_cs.c                       |    2 -
 drivers/isdn/hisax/elsa_ser.c                      |    3 +-
 drivers/isdn/hisax/hfc_usb.c                       |    6 +-
 drivers/isdn/hisax/ipacx.c                         |    4 +-
 drivers/isdn/hisax/jade.c                          |    3 +-
 drivers/isdn/hisax/l3dss1.c                        |    4 +-
 drivers/isdn/hisax/l3ni1.c                         |    4 +-
 drivers/isdn/hisax/st5481.h                        |    1 -
 drivers/isdn/hisax/st5481_init.c                   |    6 +-
 drivers/isdn/hisax/teles_cs.c                      |    2 -
 drivers/isdn/hysdn/hysdn_proclog.c                 |   11 +-
 drivers/isdn/i4l/isdn_common.c                     |   11 +-
 drivers/isdn/i4l/isdn_net.c                        |    2 -
 drivers/isdn/i4l/isdn_tty.c                        |    2 -
 drivers/isdn/mISDN/layer2.c                        |   20 +-
 drivers/isdn/mISDN/socket.c                        |    3 +
 drivers/net/3c509.c                                |   16 +-
 drivers/net/3c59x.c                                |    4 +-
 drivers/net/8139cp.c                               |   46 +-
 drivers/net/acenic.c                               |   12 +-
 drivers/net/arm/etherh.c                           |    5 +-
 drivers/net/arm/ks8695net.c                        |    7 +-
 drivers/net/atl1c/atl1c_ethtool.c                  |   17 +-
 drivers/net/atl1c/atl1c_main.c                     |   27 +-
 drivers/net/atl1e/atl1e_ethtool.c                  |    7 +-
 drivers/net/atl1e/atl1e_main.c                     |   14 +-
 drivers/net/atlx/atl1.c                            |   29 +-
 drivers/net/atlx/atl2.c                            |   18 +-
 drivers/net/b44.c                                  |   13 +-
 drivers/net/bcm63xx_enet.c                         |    7 +-
 drivers/net/benet/be.h                             |   74 +-
 drivers/net/benet/be_cmds.c                        |  341 +-
 drivers/net/benet/be_cmds.h                        |  457 +-
 drivers/net/benet/be_ethtool.c                     |  227 +-
 drivers/net/benet/be_hw.h                          |    4 +
 drivers/net/benet/be_main.c                        |  637 +-
 drivers/net/bna/bfa_ioc.c                          |   13 +-
 drivers/net/bna/bna_ctrl.c                         |   21 -
 drivers/net/bna/bna_txrx.c                         |    7 +-
 drivers/net/bna/bnad.c                             |   22 +-
 drivers/net/bna/bnad.h                             |    2 -
 drivers/net/bna/bnad_ethtool.c                     |   70 +-
 drivers/net/bnx2.c                                 |  184 +-
 drivers/net/bnx2.h                                 |    3 +-
 drivers/net/bnx2x/bnx2x.h                          |   35 +-
 drivers/net/bnx2x/bnx2x_cmn.c                      |  643 +-
 drivers/net/bnx2x/bnx2x_cmn.h                      |  454 +-
 drivers/net/bnx2x/bnx2x_dcb.c                      |  202 +-
 drivers/net/bnx2x/bnx2x_dcb.h                      |   16 +-
 drivers/net/bnx2x/bnx2x_ethtool.c                  |  167 +-
 drivers/net/bnx2x/bnx2x_fw_defs.h                  |    2 +-
 drivers/net/bnx2x/bnx2x_fw_file_hdr.h              |    2 +-
 drivers/net/bnx2x/bnx2x_hsi.h                      |    4 +-
 drivers/net/bnx2x/bnx2x_init.h                     |    2 +-
 drivers/net/bnx2x/bnx2x_init_ops.h                 |    2 +-
 drivers/net/bnx2x/bnx2x_link.c                     |   14 +-
 drivers/net/bnx2x/bnx2x_main.c                     |  360 +-
 drivers/net/bnx2x/bnx2x_reg.h                      |    2 +-
 drivers/net/bnx2x/bnx2x_stats.c                    |    2 +-
 drivers/net/bnx2x/bnx2x_stats.h                    |    2 +-
 drivers/net/bonding/Makefile                       |    3 -
 drivers/net/bonding/bond_3ad.c                     |   43 +-
 drivers/net/bonding/bond_3ad.h                     |    4 +-
 drivers/net/bonding/bond_alb.c                     |   57 +-
 drivers/net/bonding/bond_alb.h                     |    1 -
 drivers/net/bonding/bond_main.c                    |  530 +-
 drivers/net/bonding/bond_procfs.c                  |    2 -
 drivers/net/bonding/bond_sysfs.c                   |   84 +-
 drivers/net/bonding/bonding.h                      |   56 +-
 drivers/net/cassini.c                              |   37 +-
 drivers/net/chelsio/common.h                       |    5 -
 drivers/net/chelsio/cxgb2.c                        |   59 +-
 drivers/net/chelsio/sge.c                          |   13 +-
 drivers/net/chelsio/tp.c                           |    5 -
 drivers/net/chelsio/tp.h                           |    1 -
 drivers/net/cnic.c                                 |   62 +-
 drivers/net/cnic.h                                 |    1 +
 drivers/net/cnic_if.h                              |    6 +-
 drivers/net/cris/eth_v10.c                         |    4 +-
 drivers/net/cxgb3/adapter.h                        |    7 -
 drivers/net/cxgb3/common.h                         |    1 -
 drivers/net/cxgb3/cxgb3_main.c                     |  117 +-
 drivers/net/cxgb3/sge.c                            |    7 +-
 drivers/net/cxgb4/cxgb4.h                          |    6 -
 drivers/net/cxgb4/cxgb4_main.c                     |  103 +-
 drivers/net/cxgb4/sge.c                            |    4 +-
 drivers/net/cxgb4vf/adapter.h                      |    6 -
 drivers/net/cxgb4vf/cxgb4vf_main.c                 |   73 +-
 drivers/net/cxgb4vf/sge.c                          |    4 +-
 drivers/net/depca.c                                |   35 +-
 drivers/net/dl2k.c                                 |   29 +-
 drivers/net/dm9000.c                               |   57 +-
 drivers/net/dummy.c                                |    4 -
 drivers/net/e100.c                                 |   78 +-
 drivers/net/e1000/e1000.h                          |    5 +-
 drivers/net/e1000/e1000_ethtool.c                  |   60 +-
 drivers/net/e1000/e1000_main.c                     |   42 +-
 drivers/net/e1000e/82571.c                         |   22 +-
 drivers/net/e1000e/e1000.h                         |   12 +-
 drivers/net/e1000e/es2lan.c                        |    5 +-
 drivers/net/e1000e/ethtool.c                       |  154 +-
 drivers/net/e1000e/hw.h                            |    1 +
 drivers/net/e1000e/ich8lan.c                       |   16 +-
 drivers/net/e1000e/lib.c                           |   18 +-
 drivers/net/e1000e/netdev.c                        |  213 +-
 drivers/net/e1000e/phy.c                           |    4 +-
 drivers/net/eepro.c                                |    2 +-
 drivers/net/ehea/ehea_ethtool.c                    |   46 +-
 drivers/net/ehea/ehea_main.c                       |    4 +-
 drivers/net/enc28j60.c                             |    5 +-
 drivers/net/enic/Makefile                          |    2 +-
 drivers/net/enic/enic.h                            |    5 +-
 drivers/net/enic/enic_dev.c                        |   62 +-
 drivers/net/enic/enic_dev.h                        |    7 +-
 drivers/net/enic/enic_main.c                       |  274 +-
 drivers/net/enic/enic_pp.c                         |  264 +
 drivers/net/enic/enic_pp.h                         |   27 +
 drivers/net/enic/enic_res.c                        |    4 +-
 drivers/net/enic/vnic_dev.c                        |   97 +-
 drivers/net/enic/vnic_dev.h                        |    6 +-
 drivers/net/enic/vnic_devcmd.h                     |   57 +-
 drivers/net/enic/vnic_vic.c                        |    5 +-
 drivers/net/enic/vnic_vic.h                        |   13 +-
 drivers/net/ewrk3.c                                |   58 +-
 drivers/net/forcedeth.c                            |  113 +-
 drivers/net/fs_enet/fs_enet-main.c                 |    2 -
 drivers/net/gianfar.c                              |   16 +-
 drivers/net/gianfar.h                              |   20 +-
 drivers/net/gianfar_ethtool.c                      |  110 +-
 drivers/net/greth.c                                |   46 +-
 drivers/net/greth.h                                |    4 -
 drivers/net/hamachi.c                              |   78 -
 drivers/net/hamradio/bpqether.c                    |    4 -
 drivers/net/hp100.c                                |   12 +-
 drivers/net/ibm_newemac/core.c                     |   17 +-
 drivers/net/ibmlana.c                              |    7 +-
 drivers/net/ibmveth.c                              |   98 +-
 drivers/net/ifb.c                                  |    4 -
 drivers/net/igb/e1000_82575.c                      |   11 +-
 drivers/net/igb/igb.h                              |    2 +-
 drivers/net/igb/igb_ethtool.c                      |   48 +-
 drivers/net/igb/igb_main.c                         |   90 +-
 drivers/net/igbvf/ethtool.c                        |   14 +-
 drivers/net/ioc3-eth.c                             |   30 +-
 drivers/net/irda/smsc-ircc2.c                      |   44 +-
 drivers/net/ixgb/ixgb.h                            |    3 -
 drivers/net/ixgb/ixgb_ethtool.c                    |   53 +-
 drivers/net/ixgbe/ixgbe.h                          |  111 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |   61 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |  178 +-
 drivers/net/ixgbe/ixgbe_common.c                   |  532 +-
 drivers/net/ixgbe/ixgbe_common.h                   |   12 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |    2 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |   77 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.h                |    2 +
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |  109 +-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  191 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |    4 +-
 drivers/net/ixgbe/ixgbe_main.c                     | 1037 +-
 drivers/net/ixgbe/ixgbe_mbx.h                      |    4 +-
 drivers/net/ixgbe/ixgbe_phy.c                      |   20 +-
 drivers/net/ixgbe/ixgbe_sriov.c                    |  100 +-
 drivers/net/ixgbe/ixgbe_type.h                     |  218 +-
 drivers/net/ixgbe/ixgbe_x540.c                     |  317 +-
 drivers/net/ixgbevf/ethtool.c                      |    8 +-
 drivers/net/ixgbevf/ixgbevf_main.c                 |   30 +
 drivers/net/ixgbevf/mbx.h                          |    1 +
 drivers/net/ixgbevf/vf.c                           |   34 +
 drivers/net/ixgbevf/vf.h                           |    1 +
 drivers/net/jme.c                                  |   80 +-
 drivers/net/jme.h                                  |    2 -
 drivers/net/ksz884x.c                              |   82 +-
 drivers/net/loopback.c                             |    3 +-
 drivers/net/macb.c                                 |   11 +-
 drivers/net/macvlan.c                              |   34 +-
 drivers/net/mdio.c                                 |   23 +-
 drivers/net/mii.c                                  |   31 +-
 drivers/net/mlx4/en_ethtool.c                      |   49 +-
 drivers/net/mlx4/en_netdev.c                       |   26 +-
 drivers/net/mlx4/en_rx.c                           |    2 +-
 drivers/net/mlx4/mlx4_en.h                         |    1 -
 drivers/net/mv643xx_eth.c                          |   34 +-
 drivers/net/myri10ge/myri10ge.c                    |   68 +-
 drivers/net/natsemi.c                              |   11 +-
 drivers/net/ne3210.c                               |   15 +-
 drivers/net/netconsole.c                           |   82 +-
 drivers/net/netxen/netxen_nic.h                    |    2 +-
 drivers/net/netxen/netxen_nic_ethtool.c            |  117 +-
 drivers/net/netxen/netxen_nic_init.c               |    3 +-
 drivers/net/netxen/netxen_nic_main.c               |   55 +-
 drivers/net/niu.c                                  |   63 +-
 drivers/net/niu.h                                  |    1 +
 drivers/net/ns83820.c                              |    8 +-
 drivers/net/pch_gbe/pch_gbe.h                      |    4 -
 drivers/net/pch_gbe/pch_gbe_ethtool.c              |   65 +-
 drivers/net/pch_gbe/pch_gbe_main.c                 |   48 +-
 drivers/net/pch_gbe/pch_gbe_param.c                |   16 +-
 drivers/net/pch_gbe/pch_gbe_phy.c                  |    4 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |    6 +-
 drivers/net/pcnet32.c                              |   90 +-
 drivers/net/phy/phy.c                              |   12 +-
 drivers/net/pptp.c                                 |   10 +-
 drivers/net/ps3_gelic_net.c                        |   34 +-
 drivers/net/ps3_gelic_net.h                        |    3 -
 drivers/net/ps3_gelic_wireless.c                   |    4 -
 drivers/net/qla3xxx.c                              |    4 +-
 drivers/net/qlcnic/qlcnic.h                        |  416 +-
 drivers/net/qlcnic/qlcnic_ctx.c                    |  250 +-
 drivers/net/qlcnic/qlcnic_ethtool.c                |  417 +-
 drivers/net/qlcnic/qlcnic_hdr.h                    |   40 +-
 drivers/net/qlcnic/qlcnic_hw.c                     |  578 +-
 drivers/net/qlcnic/qlcnic_init.c                   |   66 +-
 drivers/net/qlcnic/qlcnic_main.c                   |  634 +-
 drivers/net/qlge/qlge.h                            |    2 +-
 drivers/net/qlge/qlge_ethtool.c                    |   74 +-
 drivers/net/qlge/qlge_main.c                       |   25 +-
 drivers/net/r8169.c                                | 1006 +-
 drivers/net/s2io.c                                 |  197 +-
 drivers/net/s2io.h                                 |   13 +-
 drivers/net/sc92031.c                              |    8 +-
 drivers/net/sfc/efx.c                              |   49 +-
 drivers/net/sfc/efx.h                              |    2 +-
 drivers/net/sfc/ethtool.c                          |  118 +-
 drivers/net/sfc/falcon.c                           |    4 +-
 drivers/net/sfc/falcon_xmac.c                      |    2 +-
 drivers/net/sfc/mac.h                              |    4 +-
 drivers/net/sfc/mcdi_mac.c                         |    2 +-
 drivers/net/sfc/mcdi_phy.c                         |    8 +-
 drivers/net/sfc/mdio_10g.c                         |    6 +-
 drivers/net/sfc/mdio_10g.h                         |    2 +-
 drivers/net/sfc/net_driver.h                       |   24 +-
 drivers/net/sfc/nic.c                              |    6 +-
 drivers/net/sfc/nic.h                              |    6 +-
 drivers/net/sfc/phy.h                              |    8 +-
 drivers/net/sfc/qt202x_phy.c                       |    2 +-
 drivers/net/sfc/rx.c                               |    3 +
 drivers/net/sfc/selftest.c                         |   11 +-
 drivers/net/sfc/siena.c                            |    2 +-
 drivers/net/sfc/tenxpress.c                        |    4 +-
 drivers/net/sfc/tx.c                               |    9 +-
 drivers/net/sfc/txc43128_phy.c                     |    2 +-
 drivers/net/skge.c                                 |   93 +-
 drivers/net/skge.h                                 |    1 -
 drivers/net/sky2.c                                 |  195 +-
 drivers/net/sky2.h                                 |    1 -
 drivers/net/smc-mca.c                              |    6 +-
 drivers/net/smc911x.c                              |    4 +-
 drivers/net/smc91x.c                               |    4 +-
 drivers/net/smsc911x.c                             |  448 +-
 drivers/net/smsc911x.h                             |   22 +-
 drivers/net/spider_net.c                           |   15 +-
 drivers/net/spider_net.h                           |    7 -
 drivers/net/spider_net_ethtool.c                   |   23 +-
 drivers/net/stmmac/dwmac1000_core.c                |    5 +-
 drivers/net/stmmac/stmmac.h                        |    1 -
 drivers/net/stmmac/stmmac_ethtool.c                |   33 +-
 drivers/net/stmmac/stmmac_main.c                   |   86 +-
 drivers/net/sungem.c                               |   18 +-
 drivers/net/sunhme.c                               |   25 +-
 drivers/net/tehuti.c                               |   28 +-
 drivers/net/tg3.c                                  | 3595 +++--
 drivers/net/tg3.h                                  |  281 +-
 drivers/net/tile/tilepro.c                         |    2 +-
 drivers/net/tokenring/madgemc.c                    |    2 +-
 drivers/net/tokenring/olympic.c                    |   57 +-
 drivers/net/tulip/21142.c                          |   14 +-
 drivers/net/tulip/Makefile                         |    2 +
 drivers/net/tulip/de2104x.c                        |  183 +-
 drivers/net/tulip/de4x5.c                          |    4 +-
 drivers/net/tulip/dmfe.c                           |    9 +-
 drivers/net/tulip/eeprom.c                         |    4 +-
 drivers/net/tulip/interrupt.c                      |   48 +-
 drivers/net/tulip/media.c                          |   49 +-
 drivers/net/tulip/pnic.c                           |   22 +-
 drivers/net/tulip/pnic2.c                          |   16 +-
 drivers/net/tulip/timer.c                          |   47 +-
 drivers/net/tulip/tulip.h                          |    8 +-
 drivers/net/tulip/tulip_core.c                     |   50 +-
 drivers/net/tulip/uli526x.c                        |   71 +-
 drivers/net/tulip/winbond-840.c                    |   81 +-
 drivers/net/tulip/xircom_cb.c                      |  268 +-
 drivers/net/tun.c                                  |   69 +-
 drivers/net/typhoon.c                              |   58 +-
 drivers/net/ucc_geth_ethtool.c                     |    1 -
 drivers/net/usb/Kconfig                            |    2 +-
 drivers/net/usb/asix.c                             |   28 +-
 drivers/net/usb/catc.c                             |    2 +-
 drivers/net/usb/cdc_ncm.c                          |   13 +-
 drivers/net/usb/dm9601.c                           |    6 +-
 drivers/net/usb/plusb.c                            |   32 +-
 drivers/net/usb/rndis_host.c                       |   39 +-
 drivers/net/usb/rtl8150.c                          |   11 +-
 drivers/net/usb/smsc75xx.c                         |  131 +-
 drivers/net/usb/smsc95xx.c                         |   90 +-
 drivers/net/usb/usbnet.c                           |    6 +-
 drivers/net/veth.c                                 |   48 +-
 drivers/net/via-rhine.c                            |  242 +-
 drivers/net/via-velocity.c                         |   28 +-
 drivers/net/virtio_net.c                           |   46 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   43 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   73 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |   11 +-
 drivers/net/vxge/vxge-config.c                     |   48 +-
 drivers/net/vxge/vxge-config.h                     |   70 +-
 drivers/net/vxge/vxge-ethtool.c                    |  104 +-
 drivers/net/vxge/vxge-main.c                       |  143 +-
 drivers/net/vxge/vxge-main.h                       |   14 +-
 drivers/net/vxge/vxge-traffic.h                    |    2 +-
 drivers/net/vxge/vxge-version.h                    |    4 +-
 drivers/net/wan/dlci.c                             |    4 -
 drivers/net/wan/hdlc_fr.c                          |    9 +-
 drivers/net/wan/lapbether.c                        |    4 -
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    2 +
 drivers/net/wireless/ath/Kconfig                   |    1 -
 drivers/net/wireless/ath/Makefile                  |    1 -
 drivers/net/wireless/ath/ar9170/Kconfig            |   20 -
 drivers/net/wireless/ath/ar9170/Makefile           |    3 -
 drivers/net/wireless/ath/ar9170/ar9170.h           |  258 -
 drivers/net/wireless/ath/ar9170/cmd.c              |  127 -
 drivers/net/wireless/ath/ar9170/cmd.h              |   92 -
 drivers/net/wireless/ath/ar9170/eeprom.h           |  179 -
 drivers/net/wireless/ath/ar9170/hw.h               |  430 -
 drivers/net/wireless/ath/ar9170/led.c              |  181 -
 drivers/net/wireless/ath/ar9170/mac.c              |  519 -
 drivers/net/wireless/ath/ar9170/main.c             | 2190 ---
 drivers/net/wireless/ath/ar9170/phy.c              | 1719 ---
 drivers/net/wireless/ath/ar9170/usb.c              | 1008 --
 drivers/net/wireless/ath/ar9170/usb.h              |   82 -
 drivers/net/wireless/ath/ath.h                     |   10 +-
 drivers/net/wireless/ath/ath5k/ahb.c               |   28 +
 drivers/net/wireless/ath/ath5k/ath5k.h             |   31 +-
 drivers/net/wireless/ath/ath5k/attach.c            |    7 +-
 drivers/net/wireless/ath/ath5k/base.c              |   73 +-
 drivers/net/wireless/ath/ath5k/base.h              |    7 +-
 drivers/net/wireless/ath/ath5k/caps.c              |    3 +
 drivers/net/wireless/ath/ath5k/debug.c             |   65 +-
 drivers/net/wireless/ath/ath5k/debug.h             |   17 -
 drivers/net/wireless/ath/ath5k/desc.c              |  158 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |  158 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    9 +
 drivers/net/wireless/ath/ath5k/pci.c               |   32 +
 drivers/net/wireless/ath/ath5k/pcu.c               |   35 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |    4 +-
 drivers/net/wireless/ath/ath5k/reset.c             |    5 +
 drivers/net/wireless/ath/ath9k/Kconfig             |   21 +-
 drivers/net/wireless/ath/ath9k/Makefile            |    6 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |   18 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    6 -
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   45 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |   43 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   34 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   44 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |    6 +
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  178 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  387 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  125 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  189 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   35 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   99 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   47 +-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h   | 1525 ++
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   |  935 +--
 drivers/net/wireless/ath/ath9k/ath9k.h             |   31 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |  238 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |  100 +-
 drivers/net/wireless/ath/ath9k/btcoex.h            |   20 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   21 +-
 drivers/net/wireless/ath/ath9k/calib.h             |    1 -
 drivers/net/wireless/ath/ath9k/common.c            |   33 +-
 drivers/net/wireless/ath/ath9k/common.h            |    8 -
 drivers/net/wireless/ath/ath9k/debug.c             |  139 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   11 +
 drivers/net/wireless/ath/ath9k/eeprom.h            |    6 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   26 +
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |   34 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   11 +
 drivers/net/wireless/ath/ath9k/gpio.c              |   33 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  334 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   10 +-
 drivers/net/wireless/ath/ath9k/htc.h               |  296 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |  333 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c     |  960 ++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |  216 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  165 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  415 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  788 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   50 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h           |   25 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   17 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  384 +-
 drivers/net/wireless/ath/ath9k/hw.h                |  103 +-
 drivers/net/wireless/ath/ath9k/init.c              |   55 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  135 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    1 -
 drivers/net/wireless/ath/ath9k/main.c              |  328 +-
 drivers/net/wireless/ath/ath9k/phy.h               |   18 +-
 drivers/net/wireless/ath/ath9k/rc.c                |   15 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  228 +-
 drivers/net/wireless/ath/ath9k/reg.h               |  135 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |  126 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |   82 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  174 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    2 +
 drivers/net/wireless/ath/carl9170/main.c           |   94 +-
 drivers/net/wireless/ath/carl9170/tx.c             |  164 +-
 drivers/net/wireless/ath/key.c                     |   38 +-
 drivers/net/wireless/ath/regd.c                    |    8 +-
 drivers/net/wireless/ath/regd_common.h             |    2 +
 drivers/net/wireless/b43/main.c                    |   69 +-
 drivers/net/wireless/b43/main.h                    |    1 +
 drivers/net/wireless/b43/phy_n.c                   |   20 +-
 drivers/net/wireless/b43legacy/main.c              |   52 +-
 drivers/net/wireless/hostap/hostap_main.c          |    7 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c       |    3 -
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c        |    3 +-
 drivers/net/wireless/iwlegacy/iwl-core.c           |   20 +-
 drivers/net/wireless/iwlegacy/iwl-core.h           |    1 -
 drivers/net/wireless/iwlegacy/iwl-dev.h            |    4 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c           |    4 +-
 drivers/net/wireless/iwlegacy/iwl-helpers.h        |    6 +
 drivers/net/wireless/iwlegacy/iwl-tx.c             |   52 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c       |   22 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c       |   47 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   10 +
 drivers/net/wireless/iwlwifi/Makefile              |    6 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   61 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c            |  170 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  103 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  139 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |   47 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c     | 1073 --
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h     |   70 -
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c      |   45 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |   59 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c         |   73 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  169 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   31 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |   31 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |  274 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  247 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |  346 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1223 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h             |  113 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  812 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  270 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |  121 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   43 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         | 1074 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  349 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |  106 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |  195 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |   42 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |   25 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |   39 +-
 drivers/net/wireless/iwlwifi/iwl-io.c              |  294 +
 drivers/net/wireless/iwlwifi/iwl-io.h              |  498 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |   52 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |    3 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |   19 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |  358 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |  375 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h        |   92 -
 drivers/net/wireless/iwlwifi/iwl-sta.c             |   18 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c         |  469 +
 drivers/net/wireless/iwlwifi/iwl-testmode.h        |  151 +
 drivers/net/wireless/iwlwifi/iwl-tx.c              |  116 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    3 +-
 drivers/net/wireless/libertas/cfg.c                |   61 +-
 drivers/net/wireless/libertas/cmd.c                |  285 +-
 drivers/net/wireless/libertas/cmdresp.c            |   46 +-
 drivers/net/wireless/libertas/debugfs.c            |   41 +-
 drivers/net/wireless/libertas/decl.h               |    8 +-
 drivers/net/wireless/libertas/defs.h               |  120 +-
 drivers/net/wireless/libertas/dev.h                |   20 +-
 drivers/net/wireless/libertas/ethtool.c            |    3 +-
 drivers/net/wireless/libertas/host.h               |   33 +-
 drivers/net/wireless/libertas/if_cs.c              |   92 +-
 drivers/net/wireless/libertas/if_sdio.c            |   37 +-
 drivers/net/wireless/libertas/if_spi.c             |  282 +-
 drivers/net/wireless/libertas/if_spi.h             |   68 +-
 drivers/net/wireless/libertas/if_usb.c             |  157 +-
 drivers/net/wireless/libertas/if_usb.h             |   14 +-
 drivers/net/wireless/libertas/main.c               |  171 +-
 drivers/net/wireless/libertas/mesh.c               |  218 +-
 drivers/net/wireless/libertas/mesh.h               |    6 +-
 drivers/net/wireless/libertas/rx.c                 |   41 +-
 drivers/net/wireless/libertas/tx.c                 |   34 +-
 drivers/net/wireless/libertas/types.h              |   18 +-
 drivers/net/wireless/mac80211_hwsim.c              |   11 +-
 drivers/net/wireless/mwifiex/11n.c                 |  744 +
 drivers/net/wireless/mwifiex/11n.h                 |  161 +
 drivers/net/wireless/mwifiex/11n_aggr.c            |  298 +
 drivers/net/wireless/mwifiex/11n_aggr.h            |   32 +
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |  616 +
 drivers/net/wireless/mwifiex/11n_rxreorder.h       |   65 +
 drivers/net/wireless/mwifiex/Kconfig               |   21 +
 drivers/net/wireless/mwifiex/Makefile              |   41 +
 drivers/net/wireless/mwifiex/README                |  204 +
 drivers/net/wireless/mwifiex/cfg80211.c            | 1417 ++
 drivers/net/wireless/mwifiex/cfg80211.h            |   31 +
 drivers/net/wireless/mwifiex/cfp.c                 |  360 +
 drivers/net/wireless/mwifiex/cmdevt.c              | 1414 ++
 drivers/net/wireless/mwifiex/debugfs.c             |  770 +
 drivers/net/wireless/mwifiex/decl.h                |  129 +
 drivers/net/wireless/mwifiex/fw.h                  | 1187 ++
 drivers/net/wireless/mwifiex/init.c                |  645 +
 drivers/net/wireless/mwifiex/ioctl.h               |  331 +
 drivers/net/wireless/mwifiex/join.c                | 1423 ++
 drivers/net/wireless/mwifiex/main.c                | 1055 ++
 drivers/net/wireless/mwifiex/main.h                | 1004 ++
 drivers/net/wireless/mwifiex/scan.c                | 3025 ++++
 drivers/net/wireless/mwifiex/sdio.c                | 1754 +++
 drivers/net/wireless/mwifiex/sdio.h                |  305 +
 drivers/net/wireless/mwifiex/sta_cmd.c             | 1219 ++
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |  972 ++
 drivers/net/wireless/mwifiex/sta_event.c           |  406 +
 drivers/net/wireless/mwifiex/sta_ioctl.c           | 1593 ++
 drivers/net/wireless/mwifiex/sta_rx.c              |  200 +
 drivers/net/wireless/mwifiex/sta_tx.c              |  198 +
 drivers/net/wireless/mwifiex/txrx.c                |  200 +
 drivers/net/wireless/mwifiex/util.c                |  202 +
 drivers/net/wireless/mwifiex/util.h                |   32 +
 drivers/net/wireless/mwifiex/wmm.c                 | 1231 ++
 drivers/net/wireless/mwifiex/wmm.h                 |  110 +
 drivers/net/wireless/mwl8k.c                       |  875 +-
 drivers/net/wireless/p54/eeprom.c                  |    2 +-
 drivers/net/wireless/p54/fwio.c                    |   31 +
 drivers/net/wireless/p54/lmac.h                    |    1 +
 drivers/net/wireless/p54/main.c                    |   31 +
 drivers/net/wireless/p54/p54.h                     |    2 +
 drivers/net/wireless/p54/p54pci.c                  |    3 +-
 drivers/net/wireless/rt2x00/Kconfig                |   37 +-
 drivers/net/wireless/rt2x00/Makefile               |    1 -
 drivers/net/wireless/rt2x00/rt2400pci.c            |   35 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   34 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   91 +-
 drivers/net/wireless/rt2x00/rt2800.h               |  108 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |  369 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c            |  267 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  632 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |  122 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |  108 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c         |    4 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |   43 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  139 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c             |  133 -
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   57 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |   61 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   95 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |   19 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |   17 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  177 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   34 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |  129 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h            |   33 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   70 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |  192 +-
 drivers/net/wireless/rtlwifi/Kconfig               |   15 +-
 drivers/net/wireless/rtlwifi/Makefile              |    1 +
 drivers/net/wireless/rtlwifi/base.c                |  733 +-
 drivers/net/wireless/rtlwifi/base.h                |   60 +-
 drivers/net/wireless/rtlwifi/cam.c                 |  106 +-
 drivers/net/wireless/rtlwifi/cam.h                 |    5 +-
 drivers/net/wireless/rtlwifi/core.c                |  416 +-
 drivers/net/wireless/rtlwifi/core.h                |    1 +
 drivers/net/wireless/rtlwifi/efuse.c               |  234 +-
 drivers/net/wireless/rtlwifi/efuse.h               |    5 +-
 drivers/net/wireless/rtlwifi/pci.c                 |  609 +-
 drivers/net/wireless/rtlwifi/pci.h                 |   19 +-
 drivers/net/wireless/rtlwifi/ps.c                  |  261 +-
 drivers/net/wireless/rtlwifi/ps.h                  |    9 +
 drivers/net/wireless/rtlwifi/rc.c                  |  212 +-
 drivers/net/wireless/rtlwifi/rc.h                  |    9 +-
 drivers/net/wireless/rtlwifi/regd.c                |   97 +-
 drivers/net/wireless/rtlwifi/regd.h                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |  525 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |    2 +
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |  115 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h  |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |  128 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h |   76 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |   27 -
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c        |    2 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |  509 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h        |   34 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c       |   19 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.h       |    3 -
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |  223 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h       |   55 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |   58 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |   28 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h        |   17 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |  123 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h        |   14 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |  180 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   13 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h        |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |   14 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.h       |   14 +
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.h        |    4 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |   50 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192se/Makefile    |   15 +
 drivers/net/wireless/rtlwifi/rtl8192se/def.h       |  598 +
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |  733 +
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h        |  164 +
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c        |  654 +
 drivers/net/wireless/rtlwifi/rtl8192se/fw.h        |  375 +
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        | 2512 ++++
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h        |   79 +
 drivers/net/wireless/rtlwifi/rtl8192se/led.c       |  149 +
 drivers/net/wireless/rtlwifi/rtl8192se/led.h       |   37 +
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       | 1740 +++
 drivers/net/wireless/rtlwifi/rtl8192se/phy.h       |  101 +
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       | 1188 ++
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |  546 +
 drivers/net/wireless/rtlwifi/rtl8192se/rf.h        |   43 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |  423 +
 .../iwl-agn-led.h => rtlwifi/rtl8192se/sw.h}       |   19 +-
 drivers/net/wireless/rtlwifi/rtl8192se/table.c     |  634 +
 drivers/net/wireless/rtlwifi/rtl8192se/table.h     |   49 +
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |  976 ++
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |   45 +
 drivers/net/wireless/rtlwifi/usb.c                 |   19 +-
 drivers/net/wireless/rtlwifi/usb.h                 |    2 +
 drivers/net/wireless/rtlwifi/wifi.h                |  173 +-
 drivers/net/wireless/wl1251/cmd.h                  |    4 +-
 drivers/net/wireless/wl1251/event.c                |    6 +-
 drivers/net/wireless/wl1251/main.c                 |   22 +-
 drivers/net/wireless/wl1251/ps.c                   |   23 +-
 drivers/net/wireless/wl1251/ps.h                   |    2 +-
 drivers/net/wireless/wl1251/wl1251.h               |    9 +-
 drivers/net/wireless/wl12xx/Kconfig                |    2 +-
 drivers/net/wireless/wl12xx/acx.c                  |  201 +-
 drivers/net/wireless/wl12xx/acx.h                  |  102 +-
 drivers/net/wireless/wl12xx/boot.c                 |  283 +-
 drivers/net/wireless/wl12xx/boot.h                 |   52 +
 drivers/net/wireless/wl12xx/cmd.c                  |  113 +-
 drivers/net/wireless/wl12xx/cmd.h                  |   34 +
 drivers/net/wireless/wl12xx/conf.h                 |  116 +-
 drivers/net/wireless/wl12xx/debugfs.c              |  242 +-
 drivers/net/wireless/wl12xx/event.c                |   34 +-
 drivers/net/wireless/wl12xx/event.h                |    5 +-
 drivers/net/wireless/wl12xx/ini.h                  |   98 +-
 drivers/net/wireless/wl12xx/init.c                 |  149 +-
 drivers/net/wireless/wl12xx/init.h                 |    3 +
 drivers/net/wireless/wl12xx/io.c                   |   11 +
 drivers/net/wireless/wl12xx/io.h                   |    3 +
 drivers/net/wireless/wl12xx/main.c                 |  827 +-
 drivers/net/wireless/wl12xx/ps.c                   |   33 +-
 drivers/net/wireless/wl12xx/ps.h                   |    2 +
 drivers/net/wireless/wl12xx/reg.h                  |   15 +-
 drivers/net/wireless/wl12xx/rx.c                   |   80 +-
 drivers/net/wireless/wl12xx/scan.c                 |  260 +-
 drivers/net/wireless/wl12xx/scan.h                 |  114 +
 drivers/net/wireless/wl12xx/sdio.c                 |   95 +-
 drivers/net/wireless/wl12xx/sdio_test.c            |   20 +-
 drivers/net/wireless/wl12xx/spi.c                  |   17 +-
 drivers/net/wireless/wl12xx/testmode.c             |    6 +-
 drivers/net/wireless/wl12xx/tx.c                   |  245 +-
 drivers/net/wireless/wl12xx/tx.h                   |   62 +-
 drivers/net/wireless/wl12xx/wl12xx.h               |   78 +-
 drivers/net/wireless/zd1211rw/zd_chip.c            |  262 +-
 drivers/net/wireless/zd1211rw/zd_chip.h            |  529 +-
 drivers/net/wireless/zd1211rw/zd_rf.h              |    2 +-
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c       |  198 +-
 drivers/net/wireless/zd1211rw/zd_rf_al7230b.c      |  240 +-
 drivers/net/wireless/zd1211rw/zd_rf_rf2959.c       |   78 +-
 drivers/net/wireless/zd1211rw/zd_rf_uw2453.c       |   86 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |    4 +-
 drivers/net/wireless/zd1211rw/zd_usb.h             |    2 +-
 drivers/net/xen-netback/common.h                   |    7 +-
 drivers/net/xen-netback/interface.c                |   84 +-
 drivers/net/xen-netback/xenbus.c                   |    2 +-
 drivers/net/xen-netfront.c                         |  106 +-
 drivers/s390/net/claw.c                            |   22 +-
 drivers/s390/net/ctcm_main.c                       |    2 -
 drivers/s390/net/ctcm_mpc.c                        |   13 +-
 drivers/s390/net/lcs.c                             |   10 +-
 drivers/s390/net/netiucv.c                         |    2 -
 drivers/s390/net/qeth_core.h                       |   26 +-
 drivers/s390/net/qeth_core_main.c                  |  150 +-
 drivers/s390/net/qeth_core_mpc.h                   |   17 +-
 drivers/s390/net/qeth_core_sys.c                   |   61 +
 drivers/s390/net/qeth_l2_main.c                    |   21 +-
 drivers/s390/net/qeth_l3.h                         |    2 -
 drivers/s390/net/qeth_l3_main.c                    |  261 +-
 drivers/s390/net/qeth_l3_sys.c                     |  103 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   11 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   10 +-
 drivers/scsi/fcoe/fcoe.c                           |   11 +-
 drivers/ssb/driver_chipcommon.c                    |   68 +-
 drivers/ssb/driver_chipcommon_pmu.c                |    2 +
 drivers/ssb/driver_pcicore.c                       |  255 +-
 drivers/ssb/main.c                                 |   54 +-
 drivers/ssb/scan.c                                 |    7 +-
 drivers/staging/hv/netvsc_drv.c                    |    3 +-
 firmware/Makefile                                  |    6 +-
 firmware/WHENCE                                    |    9 +-
 firmware/bnx2x/bnx2x-e1-6.2.5.0.fw.ihex            | 9483 ------------
 firmware/bnx2x/bnx2x-e1-6.2.9.0.fw.ihex            | 9484 ++++++++++++
 firmware/bnx2x/bnx2x-e1h-6.2.5.0.fw.ihex           |13181 -----------------
 firmware/bnx2x/bnx2x-e1h-6.2.9.0.fw.ihex           |13192 +++++++++++++++++
 firmware/bnx2x/bnx2x-e2-6.2.5.0.fw.ihex            |15456 -------------------
 firmware/bnx2x/bnx2x-e2-6.2.9.0.fw.ihex            |15473 ++++++++++++++++++++
 include/linux/ath9k_platform.h                     |    7 +
 include/linux/bcma/bcma.h                          |  224 +
 include/linux/bcma/bcma_driver_chipcommon.h        |  302 +
 include/linux/bcma/bcma_driver_pci.h               |   89 +
 include/linux/bcma/bcma_regs.h                     |   34 +
 include/linux/can/core.h                           |    4 +-
 include/linux/ethtool.h                            |  317 +-
 include/linux/filter.h                             |   76 +
 include/linux/ieee80211.h                          |   20 +-
 include/linux/if_ether.h                           |    1 +
 include/linux/if_vlan.h                            |   11 +-
 include/linux/mod_devicetable.h                    |   17 +
 include/linux/mroute.h                             |    1 +
 include/linux/net.h                                |    1 +
 include/linux/netdevice.h                          |   46 +-
 include/linux/netfilter/ipset/ip_set_getport.h     |    2 +
 include/linux/netfilter/x_tables.h                 |   96 +-
 include/linux/nl80211.h                            |  371 +-
 include/linux/pkt_sched.h                          |   15 +
 include/linux/rfkill-regulator.h                   |   48 +
 include/linux/skbuff.h                             |    2 +-
 include/linux/smsc911x.h                           |    1 +
 include/linux/socket.h                             |    2 +
 include/linux/ssb/ssb.h                            |    3 +-
 include/linux/ssb/ssb_driver_chipcommon.h          |   11 +-
 include/linux/ssb/ssb_regs.h                       |    2 +-
 include/linux/stmmac.h                             |    2 +
 include/linux/syscalls.h                           |    2 +
 include/linux/tipc.h                               |    2 +-
 include/linux/usb/rndis_host.h                     |    2 +
 include/linux/wl12xx.h                             |   29 +-
 include/net/addrconf.h                             |   25 +-
 include/net/af_rxrpc.h                             |    3 -
 include/net/af_unix.h                              |    2 -
 include/net/atmclip.h                              |    2 -
 include/net/bluetooth/hci.h                        |   51 +-
 include/net/bluetooth/hci_core.h                   |   42 +-
 include/net/bluetooth/l2cap.h                      |  182 +-
 include/net/bluetooth/mgmt.h                       |   57 +-
 include/net/caif/caif_dev.h                        |   50 +-
 include/net/caif/cfcnfg.h                          |   71 +-
 include/net/caif/cfctrl.h                          |   15 +-
 include/net/caif/cffrml.h                          |    7 +-
 include/net/caif/cfmuxl.h                          |    2 -
 include/net/caif/cfpkt.h                           |   76 -
 include/net/caif/cfsrvl.h                          |   32 +-
 include/net/cfg80211.h                             |  311 +-
 include/net/compat.h                               |    2 +
 include/net/dst.h                                  |   13 +-
 include/net/flow.h                                 |   25 +-
 include/net/garp.h                                 |    2 +
 include/net/if_inet6.h                             |   11 +-
 include/net/inet6_connection_sock.h                |    2 +-
 include/net/inet_connection_sock.h                 |    6 +-
 include/net/inet_sock.h                            |   26 +-
 include/net/inetpeer.h                             |    2 +-
 include/net/ip.h                                   |   29 +-
 include/net/ip6_fib.h                              |   13 +-
 include/net/ip6_route.h                            |   26 +-
 include/net/ip_fib.h                               |    9 +-
 include/net/ip_vs.h                                |   14 +-
 include/net/ipv6.h                                 |   30 +-
 include/net/ipx.h                                  |    2 -
 include/net/mac80211.h                             |   99 +
 include/net/ndisc.h                                |    9 +-
 include/net/netevent.h                             |    2 -
 include/net/netfilter/nf_conntrack.h               |    2 -
 include/net/netfilter/nf_conntrack_tuple.h         |    4 -
 include/net/netfilter/nf_nat.h                     |    4 -
 include/net/netns/ipv4.h                           |    2 +
 include/net/phonet/pn_dev.h                        |    2 +-
 include/net/ping.h                                 |   55 +
 include/net/rawv6.h                                |    4 -
 include/net/route.h                                |  163 +-
 include/net/sctp/command.h                         |    1 -
 include/net/sctp/constants.h                       |   18 +-
 include/net/sctp/sctp.h                            |    2 -
 include/net/sctp/sm.h                              |    5 +-
 include/net/sctp/structs.h                         |   21 +-
 include/net/sctp/ulpevent.h                        |    3 +
 include/net/sctp/user.h                            |   33 +-
 include/net/snmp.h                                 |   14 +
 include/net/sock.h                                 |   54 +
 include/net/transp_v6.h                            |    4 -
 include/net/wimax.h                                |    5 -
 include/net/xfrm.h                                 |   15 +-
 include/rdma/ib_addr.h                             |   13 +-
 kernel/sys_ni.c                                    |    2 +
 net/802/garp.c                                     |   22 +-
 net/8021q/vlan.c                                   |   38 +-
 net/8021q/vlan.h                                   |    2 -
 net/8021q/vlan_core.c                              |   85 +-
 net/8021q/vlan_dev.c                               |  225 +-
 net/9p/client.c                                    |    9 +-
 net/9p/trans_fd.c                                  |    2 -
 net/9p/trans_rdma.c                                |    2 -
 net/Kconfig                                        |   14 +
 net/atm/lec.c                                      |    4 -
 net/ax25/af_ax25.c                                 |   16 +-
 net/ax25/ax25_iface.c                              |    3 +-
 net/batman-adv/aggregation.c                       |   31 +-
 net/batman-adv/aggregation.h                       |    4 +-
 net/batman-adv/bat_debugfs.c                       |    4 +-
 net/batman-adv/bat_sysfs.c                         |   16 +-
 net/batman-adv/gateway_client.c                    |  296 +-
 net/batman-adv/gateway_client.h                    |    2 +-
 net/batman-adv/hard-interface.c                    |  107 +-
 net/batman-adv/hard-interface.h                    |   18 +
 net/batman-adv/icmp_socket.c                       |   37 +-
 net/batman-adv/main.c                              |   20 +-
 net/batman-adv/main.h                              |   44 +-
 net/batman-adv/originator.c                        |   82 +-
 net/batman-adv/originator.h                        |    1 +
 net/batman-adv/packet.h                            |    5 +-
 net/batman-adv/routing.c                           |  572 +-
 net/batman-adv/routing.h                           |    6 +-
 net/batman-adv/send.c                              |   72 +-
 net/batman-adv/send.h                              |    2 +-
 net/batman-adv/soft-interface.c                    |  463 +-
 net/batman-adv/translation-table.c                 |  474 +-
 net/batman-adv/translation-table.h                 |   24 +-
 net/batman-adv/types.h                             |   56 +-
 net/batman-adv/unicast.c                           |   20 +-
 net/batman-adv/vis.c                               |  146 +-
 net/bluetooth/bnep/bnep.h                          |  148 +-
 net/bluetooth/bnep/core.c                          |   71 +-
 net/bluetooth/bnep/sock.c                          |    2 +-
 net/bluetooth/cmtp/capi.c                          |    6 +-
 net/bluetooth/cmtp/cmtp.h                          |   11 +-
 net/bluetooth/cmtp/core.c                          |   28 +-
 net/bluetooth/cmtp/sock.c                          |    2 +-
 net/bluetooth/hci_conn.c                           |   95 +-
 net/bluetooth/hci_core.c                           |  154 +-
 net/bluetooth/hci_event.c                          |  267 +-
 net/bluetooth/hci_sysfs.c                          |   71 +-
 net/bluetooth/hidp/core.c                          |   96 +-
 net/bluetooth/hidp/hidp.h                          |    6 +-
 net/bluetooth/hidp/sock.c                          |    7 +-
 net/bluetooth/l2cap_core.c                         | 1966 ++--
 net/bluetooth/l2cap_sock.c                         |  330 +-
 net/bluetooth/mgmt.c                               |  612 +-
 net/bluetooth/rfcomm/core.c                        |   23 +-
 net/bluetooth/rfcomm/sock.c                        |    5 +-
 net/bridge/br.c                                    |    1 +
 net/bridge/br_device.c                             |  100 +-
 net/bridge/br_fdb.c                                |  311 +-
 net/bridge/br_if.c                                 |  104 +-
 net/bridge/br_input.c                              |    5 +-
 net/bridge/br_ioctl.c                              |   40 +-
 net/bridge/br_multicast.c                          |   12 +-
 net/bridge/br_netfilter.c                          |    4 +-
 net/bridge/br_netlink.c                            |   60 +-
 net/bridge/br_notify.c                             |   11 +-
 net/bridge/br_private.h                            |   22 +-
 net/bridge/br_private_stp.h                        |   13 +
 net/bridge/br_stp.c                                |   48 +
 net/bridge/br_stp_if.c                             |   21 +-
 net/bridge/br_sysfs_br.c                           |   39 +-
 net/bridge/br_sysfs_if.c                           |   26 +-
 net/caif/Makefile                                  |    2 +-
 net/caif/caif_config_util.c                        |   99 -
 net/caif/caif_dev.c                                |  387 +-
 net/caif/caif_socket.c                             |  106 +-
 net/caif/cfcnfg.c                                  |  507 +-
 net/caif/cfctrl.c                                  |  196 +-
 net/caif/cfdgml.c                                  |    7 +-
 net/caif/cffrml.c                                  |   60 +-
 net/caif/cfmuxl.c                                  |  162 +-
 net/caif/cfpkt_skbuff.c                            |  205 +-
 net/caif/cfrfml.c                                  |    4 +-
 net/caif/cfserl.c                                  |    7 +-
 net/caif/cfsrvl.c                                  |   40 +-
 net/caif/cfutill.c                                 |    7 +-
 net/caif/cfveil.c                                  |   11 +-
 net/caif/cfvidl.c                                  |    5 +-
 net/caif/chnl_net.c                                |   45 +-
 net/can/af_can.c                                   |   67 +-
 net/can/bcm.c                                      |    2 +-
 net/can/raw.c                                      |    2 +-
 net/compat.c                                       |   16 +-
 net/core/dev.c                                     |  187 +-
 net/core/dst.c                                     |   54 +-
 net/core/ethtool.c                                 |  196 +-
 net/core/fib_rules.c                               |    3 +-
 net/core/filter.c                                  |   65 +-
 net/core/net-sysfs.c                               |   26 +-
 net/core/net_namespace.c                           |   12 +-
 net/core/netpoll.c                                 |   28 +-
 net/core/pktgen.c                                  |  199 +-
 net/core/rtnetlink.c                               |   25 +-
 net/core/skbuff.c                                  |    3 +
 net/core/sysctl_net_core.c                         |    9 +
 net/core/utils.c                                   |   24 +
 net/dccp/ipv4.c                                    |   53 +-
 net/dccp/ipv6.c                                    |   10 +-
 net/dccp/output.c                                  |    4 +-
 net/decnet/dn_dev.c                                |   10 +-
 net/decnet/dn_route.c                              |   15 +-
 net/decnet/dn_table.c                              |    4 +-
 net/dsa/slave.c                                    |    1 -
 net/econet/af_econet.c                             |    8 -
 net/ipv4/Makefile                                  |    2 +-
 net/ipv4/af_inet.c                                 |   53 +-
 net/ipv4/ah4.c                                     |    7 +-
 net/ipv4/cipso_ipv4.c                              |  113 +-
 net/ipv4/datagram.c                                |   22 +-
 net/ipv4/devinet.c                                 |    4 +-
 net/ipv4/esp4.c                                    |    7 +-
 net/ipv4/fib_frontend.c                            |   16 +-
 net/ipv4/fib_trie.c                                |  110 +-
 net/ipv4/icmp.c                                    |  133 +-
 net/ipv4/igmp.c                                    |   22 +-
 net/ipv4/inet_connection_sock.c                    |   59 +-
 net/ipv4/inet_diag.c                               |    2 +-
 net/ipv4/inet_lro.c                                |    4 +-
 net/ipv4/ip_forward.c                              |    2 +-
 net/ipv4/ip_fragment.c                             |   58 +-
 net/ipv4/ip_gre.c                                  |   70 +-
 net/ipv4/ip_input.c                                |    4 +-
 net/ipv4/ip_options.c                              |   57 +-
 net/ipv4/ip_output.c                               |  158 +-
 net/ipv4/ip_sockglue.c                             |   37 +-
 net/ipv4/ipcomp.c                                  |    4 +-
 net/ipv4/ipconfig.c                                |   35 +-
 net/ipv4/ipip.c                                    |   36 +-
 net/ipv4/ipmr.c                                    |   39 +-
 net/ipv4/netfilter/arp_tables.c                    |   18 +-
 net/ipv4/netfilter/ip_tables.c                     |   28 +-
 net/ipv4/netfilter/nf_nat_helper.c                 |    2 +-
 net/ipv4/ping.c                                    |  935 ++
 net/ipv4/raw.c                                     |   92 +-
 net/ipv4/route.c                                   |  385 +-
 net/ipv4/syncookies.c                              |   22 +-
 net/ipv4/sysctl_net_ipv4.c                         |   68 +
 net/ipv4/tcp.c                                     |    7 +-
 net/ipv4/tcp_ipv4.c                                |   98 +-
 net/ipv4/tcp_output.c                              |    2 +-
 net/ipv4/udp.c                                     |   78 +-
 net/ipv4/xfrm4_policy.c                            |   38 +-
 net/ipv4/xfrm4_state.c                             |    2 +-
 net/ipv6/addrconf.c                                |   42 +-
 net/ipv6/af_inet6.c                                |    2 +-
 net/ipv6/anycast.c                                 |   16 +-
 net/ipv6/esp6.c                                    |    5 +-
 net/ipv6/icmp.c                                    |    8 +-
 net/ipv6/inet6_connection_sock.c                   |    2 +-
 net/ipv6/ip6_fib.c                                 |   20 +-
 net/ipv6/ip6_input.c                               |    6 +-
 net/ipv6/ip6_output.c                              |   50 +-
 net/ipv6/ip6_tunnel.c                              |   46 +-
 net/ipv6/ip6mr.c                                   |    4 +-
 net/ipv6/ipcomp6.c                                 |    5 +-
 net/ipv6/mcast.c                                   |   36 +-
 net/ipv6/mip6.c                                    |    8 +-
 net/ipv6/ndisc.c                                   |   51 +-
 net/ipv6/netfilter.c                               |   10 +-
 net/ipv6/netfilter/ip6_tables.c                    |   21 +-
 net/ipv6/netfilter/ip6table_mangle.c               |    3 +-
 net/ipv6/proc.c                                    |   40 +-
 net/ipv6/raw.c                                     |   18 +-
 net/ipv6/reassembly.c                              |    4 +-
 net/ipv6/route.c                                   |  157 +-
 net/ipv6/sit.c                                     |   40 +-
 net/ipv6/syncookies.c                              |   13 +-
 net/ipv6/tcp_ipv6.c                                |   50 +-
 net/ipv6/udp.c                                     |   22 +-
 net/ipv6/xfrm6_mode_beet.c                         |    2 -
 net/ipv6/xfrm6_mode_tunnel.c                       |    6 +-
 net/ipv6/xfrm6_policy.c                            |    2 +-
 net/ipv6/xfrm6_tunnel.c                            |   10 +-
 net/irda/ircomm/ircomm_core.c                      |    6 -
 net/irda/ircomm/ircomm_lmp.c                       |    5 +-
 net/irda/ircomm/ircomm_tty.c                       |   14 +-
 net/irda/irlan/irlan_filter.c                      |    4 -
 net/irda/irlan/irlan_provider.c                    |    3 -
 net/irda/irlap_event.c                             |    3 -
 net/irda/irproc.c                                  |    5 +-
 net/iucv/af_iucv.c                                 |    9 +-
 net/iucv/iucv.c                                    |   77 +-
 net/key/af_key.c                                   |    2 +-
 net/l2tp/l2tp_core.c                               |   28 +-
 net/l2tp/l2tp_ip.c                                 |   52 +-
 net/l2tp/l2tp_netlink.c                            |    3 +-
 net/mac80211/Kconfig                               |    1 -
 net/mac80211/aes_ccm.c                             |    6 +-
 net/mac80211/agg-rx.c                              |    3 +-
 net/mac80211/agg-tx.c                              |   59 +-
 net/mac80211/cfg.c                                 |  188 +-
 net/mac80211/debugfs.c                             |   91 +-
 net/mac80211/debugfs_key.c                         |   21 +-
 net/mac80211/debugfs_sta.c                         |   26 +
 net/mac80211/driver-ops.h                          |   87 +-
 net/mac80211/driver-trace.h                        |  275 +-
 net/mac80211/ht.c                                  |   27 +-
 net/mac80211/ibss.c                                |   21 +-
 net/mac80211/ieee80211_i.h                         |   51 +-
 net/mac80211/iface.c                               |    7 +-
 net/mac80211/key.c                                 |   51 +-
 net/mac80211/key.h                                 |    4 +
 net/mac80211/main.c                                |   69 +-
 net/mac80211/mesh.c                                |   62 +-
 net/mac80211/mesh.h                                |    9 +-
 net/mac80211/mesh_hwmp.c                           |   42 +-
 net/mac80211/mesh_pathtbl.c                        |  166 +-
 net/mac80211/mesh_plink.c                          |  112 +-
 net/mac80211/mlme.c                                |   48 +-
 net/mac80211/pm.c                                  |   29 +-
 net/mac80211/rc80211_minstrel.c                    |    4 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   27 +-
 net/mac80211/rx.c                                  |   94 +-
 net/mac80211/scan.c                                |  122 +-
 net/mac80211/sta_info.c                            |   52 +-
 net/mac80211/sta_info.h                            |   56 +-
 net/mac80211/status.c                              |   19 +-
 net/mac80211/tkip.c                                |    4 +-
 net/mac80211/tkip.h                                |    4 +-
 net/mac80211/tx.c                                  |   27 +-
 net/mac80211/util.c                                |   21 +-
 net/mac80211/wep.c                                 |   34 +-
 net/mac80211/wep.h                                 |    4 +-
 net/mac80211/work.c                                |    6 +-
 net/mac80211/wpa.c                                 |   62 +-
 net/netfilter/ipset/ip_set_getport.c               |   16 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c         |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |    2 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |    2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   24 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    3 -
 net/netfilter/ipvs/ip_vs_xmit.c                    |   97 +-
 net/netfilter/nf_conntrack_sip.c                   |   16 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 net/netfilter/nfnetlink_log.c                      |    2 -
 net/netfilter/x_tables.c                           |    9 +-
 net/netlabel/netlabel_cipso_v4.c                   |    4 -
 net/netrom/af_netrom.c                             |   12 +-
 net/packet/af_packet.c                             |    2 +-
 net/phonet/pn_dev.c                                |    6 +-
 net/phonet/pn_netlink.c                            |    4 +-
 net/phonet/socket.c                                |   45 +-
 net/rfkill/Kconfig                                 |   11 +
 net/rfkill/Makefile                                |    1 +
 net/rfkill/core.c                                  |    2 +-
 net/rfkill/rfkill-regulator.c                      |  164 +
 net/rose/af_rose.c                                 |   16 +-
 net/rxrpc/ar-ack.c                                 |    2 -
 net/rxrpc/ar-connevent.c                           |    3 -
 net/rxrpc/ar-error.c                               |    5 +-
 net/rxrpc/ar-peer.c                                |    6 +-
 net/rxrpc/ar-transport.c                           |    3 +-
 net/sched/Kconfig                                  |   12 +
 net/sched/Makefile                                 |    1 +
 net/sched/sch_api.c                                |    2 -
 net/sched/sch_qfq.c                                | 1137 ++
 net/sched/sch_sfq.c                                |    2 +-
 net/sctp/bind_addr.c                               |   10 +-
 net/sctp/debug.c                                   |    1 -
 net/sctp/endpointola.c                             |   20 +-
 net/sctp/input.c                                   |   19 +-
 net/sctp/ipv6.c                                    |  185 +-
 net/sctp/outqueue.c                                |   19 +-
 net/sctp/protocol.c                                |   71 +-
 net/sctp/sm_make_chunk.c                           |   62 +-
 net/sctp/sm_sideeffect.c                           |    9 +-
 net/sctp/sm_statefuns.c                            |   89 +-
 net/sctp/sm_statetable.c                           |   78 +-
 net/sctp/socket.c                                  |   95 +-
 net/sctp/transport.c                               |   27 +-
 net/sctp/ulpevent.c                                |   30 +-
 net/socket.c                                       |  219 +-
 net/tipc/addr.h                                    |    7 +-
 net/tipc/bcast.c                                   |   22 +-
 net/tipc/bearer.c                                  |   45 +-
 net/tipc/core.c                                    |    3 +-
 net/tipc/discover.c                                |  150 +-
 net/tipc/discover.h                                |   11 +-
 net/tipc/link.c                                    |  104 +-
 net/tipc/link.h                                    |    1 +
 net/tipc/msg.c                                     |   25 +-
 net/tipc/msg.h                                     |  161 +-
 net/tipc/port.c                                    |   55 +-
 net/tipc/port.h                                    |   14 +-
 net/tipc/socket.c                                  |   27 +-
 net/tipc/subscr.c                                  |    4 +-
 net/wireless/core.c                                |  106 +-
 net/wireless/core.h                                |   33 +
 net/wireless/lib80211_crypt_wep.c                  |    3 +-
 net/wireless/mesh.c                                |   23 +-
 net/wireless/mlme.c                                |   19 +
 net/wireless/nl80211.c                             |  790 +-
 net/wireless/nl80211.h                             |   11 +
 net/wireless/reg.c                                 |   74 +-
 net/wireless/scan.c                                |   77 +-
 net/wireless/sysfs.c                               |    2 +-
 net/wireless/util.c                                |  126 +-
 net/xfrm/xfrm_policy.c                             |    3 +-
 net/xfrm/xfrm_state.c                              |   12 +-
 scripts/mod/file2alias.c                           |   22 +
 1198 files changed, 126876 insertions(+), 79638 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-bcma
 create mode 100644 arch/x86/net/Makefile
 create mode 100644 arch/x86/net/bpf_jit.S
 create mode 100644 arch/x86/net/bpf_jit_comp.c
 create mode 100644 drivers/bcma/Kconfig
 create mode 100644 drivers/bcma/Makefile
 create mode 100644 drivers/bcma/README
 create mode 100644 drivers/bcma/TODO
 create mode 100644 drivers/bcma/bcma_private.h
 create mode 100644 drivers/bcma/core.c
 create mode 100644 drivers/bcma/driver_chipcommon.c
 create mode 100644 drivers/bcma/driver_chipcommon_pmu.c
 create mode 100644 drivers/bcma/driver_pci.c
 create mode 100644 drivers/bcma/host_pci.c
 create mode 100644 drivers/bcma/main.c
 create mode 100644 drivers/bcma/scan.c
 create mode 100644 drivers/bcma/scan.h
 delete mode 100644 drivers/isdn/capi/capifs.c
 delete mode 100644 drivers/isdn/capi/capifs.h
 create mode 100644 drivers/net/enic/enic_pp.c
 create mode 100644 drivers/net/enic/enic_pp.h
 delete mode 100644 drivers/net/wireless/ath/ar9170/Kconfig
 delete mode 100644 drivers/net/wireless/ath/ar9170/Makefile
 delete mode 100644 drivers/net/wireless/ath/ar9170/ar9170.h
 delete mode 100644 drivers/net/wireless/ath/ar9170/cmd.c
 delete mode 100644 drivers/net/wireless/ath/ar9170/cmd.h
 delete mode 100644 drivers/net/wireless/ath/ar9170/eeprom.h
 delete mode 100644 drivers/net/wireless/ath/ar9170/hw.h
 delete mode 100644 drivers/net/wireless/ath/ar9170/led.c
 delete mode 100644 drivers/net/wireless/ath/ar9170/mac.c
 delete mode 100644 drivers/net/wireless/ath/ar9170/main.c
 delete mode 100644 drivers/net/wireless/ath/ar9170/phy.c
 delete mode 100644 drivers/net/wireless/ath/ar9170/usb.c
 delete mode 100644 drivers/net/wireless/ath/ar9170/usb.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9340_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_debug.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-led.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-io.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-sv-open.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-testmode.h
 create mode 100644 drivers/net/wireless/mwifiex/11n.c
 create mode 100644 drivers/net/wireless/mwifiex/11n.h
 create mode 100644 drivers/net/wireless/mwifiex/11n_aggr.c
 create mode 100644 drivers/net/wireless/mwifiex/11n_aggr.h
 create mode 100644 drivers/net/wireless/mwifiex/11n_rxreorder.c
 create mode 100644 drivers/net/wireless/mwifiex/11n_rxreorder.h
 create mode 100644 drivers/net/wireless/mwifiex/Kconfig
 create mode 100644 drivers/net/wireless/mwifiex/Makefile
 create mode 100644 drivers/net/wireless/mwifiex/README
 create mode 100644 drivers/net/wireless/mwifiex/cfg80211.c
 create mode 100644 drivers/net/wireless/mwifiex/cfg80211.h
 create mode 100644 drivers/net/wireless/mwifiex/cfp.c
 create mode 100644 drivers/net/wireless/mwifiex/cmdevt.c
 create mode 100644 drivers/net/wireless/mwifiex/debugfs.c
 create mode 100644 drivers/net/wireless/mwifiex/decl.h
 create mode 100644 drivers/net/wireless/mwifiex/fw.h
 create mode 100644 drivers/net/wireless/mwifiex/init.c
 create mode 100644 drivers/net/wireless/mwifiex/ioctl.h
 create mode 100644 drivers/net/wireless/mwifiex/join.c
 create mode 100644 drivers/net/wireless/mwifiex/main.c
 create mode 100644 drivers/net/wireless/mwifiex/main.h
 create mode 100644 drivers/net/wireless/mwifiex/scan.c
 create mode 100644 drivers/net/wireless/mwifiex/sdio.c
 create mode 100644 drivers/net/wireless/mwifiex/sdio.h
 create mode 100644 drivers/net/wireless/mwifiex/sta_cmd.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_cmdresp.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_event.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_ioctl.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_rx.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_tx.c
 create mode 100644 drivers/net/wireless/mwifiex/txrx.c
 create mode 100644 drivers/net/wireless/mwifiex/util.c
 create mode 100644 drivers/net/wireless/mwifiex/util.h
 create mode 100644 drivers/net/wireless/mwifiex/wmm.c
 create mode 100644 drivers/net/wireless/mwifiex/wmm.h
 delete mode 100644 drivers/net/wireless/rt2x00/rt2x00ht.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/sw.c
 rename drivers/net/wireless/{iwlwifi/iwl-agn-led.h => rtlwifi/rtl8192se/sw.h} (69%)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192se/trx.h
 delete mode 100644 firmware/bnx2x/bnx2x-e1-6.2.5.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e1-6.2.9.0.fw.ihex
 delete mode 100644 firmware/bnx2x/bnx2x-e1h-6.2.5.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e1h-6.2.9.0.fw.ihex
 delete mode 100644 firmware/bnx2x/bnx2x-e2-6.2.5.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e2-6.2.9.0.fw.ihex
 create mode 100644 include/linux/bcma/bcma.h
 create mode 100644 include/linux/bcma/bcma_driver_chipcommon.h
 create mode 100644 include/linux/bcma/bcma_driver_pci.h
 create mode 100644 include/linux/bcma/bcma_regs.h
 create mode 100644 include/linux/rfkill-regulator.h
 create mode 100644 include/net/ping.h
 delete mode 100644 net/caif/caif_config_util.c
 create mode 100644 net/ipv4/ping.c
 create mode 100644 net/rfkill/rfkill-regulator.c
 create mode 100644 net/sched/sch_qfq.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
