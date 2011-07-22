Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1GVOdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:33:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48617 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab1GVOdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:33:45 -0400
Date: Fri, 22 Jul 2011 07:33:39 -0700 (PDT)
Message-Id: <20110722.073339.1236244143490935644.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 22 Jul 2011 07:33:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6MEYGTC020898


A bit less going on than in the past few releases, most notable this
time is:

1) There are currently 3 or 4 ways to add VLAN support for a driver,
   which is just crazy.  Jiri Pirko is trying to consolidate things so
   we have less of a mess here.

2) The Neighbour layer has been simplifier and sped up.  It had complexity
   purely for the sake of allowing situations that simply never happen.
   This removed some indirect calls in the fast path.

   It even had a method pointer that everyone assigned to the same global
   routine. :-)

   There will be more activity in this area in the future.

3) New driver for rtl8192de wireless chipset.

4) PowerPC 64-bit now has a BPF JIT too.

5) Get more drivers supporting 64-bit device stats, thanks to Stephen
   Hemminger.

6) Sometimes a config change can happen mid-dump in netlink, we can now
   detect this situation using sequence numbers and decide to rescan
   if we want to.

7) SKB zero-copy buffer support for virtualization from Shirley Ma.

8) Improve scalability of inetpeer table by removing the explicit
   unused list and killing off some false sharing.  From Eric Dumazet.

9) AF_PACKET sockets now support a "fanout" facility, whereby you can
   distribute packet capture amongst a group of sockets.  This will be
   used by userland traffic analysis tools such as suricata.

Please pull, thanks a lot!

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next.git master

Ajit Khaparde (1):
      be2net: move to new vlan model

Alexander Duyck (19):
      v2 ethtool: remove support for ETHTOOL_GRXNTUPLE
      ixgbe: remove ntuple filtering
      ixgbe: fix flags relating to perfect filters to support coexistence
      ixgbe: update perfect filter framework to support retaining filters
      ixgbe: add basic support for setting and getting nfc controls
      ixgbe: add support for displaying ntuple filters via the nfc interface
      ixgbe: add support for nfc addition and removal of filters
      ixgbe: fix ring assignment issues for SR-IOV and drop cases
      ixgbe: pass adapter struct instead of netdev for interrupt data
      ixgbe: Convert IXGBE_DESC_UNUSED from macro to static inline function
      ixgbe: Move all values that deal with count, next_to_use, next_to_clean to u16
      ixgbe: Add one function that handles most of context descriptor setup
      ixgbe: Update method used for determining descriptor count for an skb
      ixgbe: Make certain to initialize the fdir_perfect_lock in all cases
      ixgbe: Update ATR to use recorded TX queues instead of CPU for routing
      ixgbe: inline the ixgbe_maybe_stop_tx function
      ixgbe: add structure for containing RX/TX rings to q_vector
      ixgbe: Move interrupt related values out of ring and into q_vector
      ixgbe: Pass staterr instead of re-reading status and error bits from descriptor

Alexander Smirnov (2):
      ieee802154: free skb buffer if dev isn't running
      Exclude duplicated checking for iface-up. This flags is checked in 'is_skb_forwardable' function, which is subroutine of 'dev_forward_skb'.

Alexey Dobriyan (3):
      net: remove interrupt.h inclusion from netdevice.h
      net: fix MIPS fallout from "net: remove interrupt.h inclusion from netdevice.h"
      net: remove mm.h inclusion from netdevice.h

Allan Stephens (20):
      tipc: Convert fatal broadcast sanity check to non-fatal check
      tipc: Remove unused sanity test macro
      tipc: Standardize exit logic for message rejection handling
      tipc: Add sanity check to detect rejection of non-payload messages
      tipc: Optimize routing of returned payload messages
      tipc: Optimizations & corrections to message rejection
      tipc: Eliminate message header routines for caching destination node
      tipc: Eliminate redundant masking in message header routines
      tipc: Partition name table instance array info into two parts
      tipc: Convert name table publication lists to standard kernel lists
      tipc: Eliminate checks for empty zone list during name translation
      tipc: Correct typo in link statistics output
      tipc: Eliminate unused field in bearer structure
      tipc: Remove unnecessary includes in socket code
      tipc: Eliminate useless check when creating internal message
      tipc: Cleanup of message header size terminology
      tipc: Optimize creation of FIN messages
      tipc: Reject connection protocol message sent to unconnected port
      tipc: Don't create payload message using connection protocol routine
      tipc: Optimize creation of connection protocol messages

Aloisio Almeida Jr (3):
      NFC: add NFC socket family
      NFC: pn533: add NXP pn533 nfc device driver
      NFC: add Documentation/networking/nfc.txt

Amit Kumar Salecha (5):
      qlcnic: fix default operating state of interface
      net: add external loopback test in ethtool self test
      qlcnic: add external loopback support
      qlcnic: define error code for loopback test
      netxen: add fw version compatibility check

Amitkumar Karwar (7):
      mwifiex: remove support for old chipsets W0/W1
      mwifiex: get rid of global adapter pointer
      mwifiex: remove casts of void pointers
      mwifiex: modify SDIO aggregation Tx/Rx buffer size
      mwifiex: fix regression in WEP security mode
      mwifiex: fix minor issue in debugfs command 'info'
      mwifiex: 11n specific configuration for transmit

Amos Kong (1):
      tun: do not put self in waitq if doing a nonblock read

Anderson Briglia (7):
      Bluetooth: Add advertising report meta event structs
      Bluetooth: Implement the first SMP commands
      Bluetooth: Start SMP procedure
      Bluetooth: Add simple SMP pairing negotiation
      Bluetooth: Add LE SMP Cryptoolbox functions
      Bluetooth: Add SMP confirmation structs
      Bluetooth: Add SMP confirmation checks methods

Anderson Lizardo (1):
      Bluetooth: fix missing parameter for HCI_OP_DISCONNECT

Andre Guedes (15):
      Bluetooth: LE advertising cache
      Bluetooth: Add Advertising Report Meta Event handler
      Bluetooth: Clear advertising cache before scanning
      Bluetooth: Advertising entries lifetime
      Bluetooth: Add 'dst_type' field to struct hci_conn
      Bluetooth: Remove useless check in hci_connect()
      Bluetooth: Check advertising cache in hci_connect()
      Bluetooth: Set 'peer_addr_type' in hci_le_connect()
      Bluetooth: Add extfeatures to struct hci_dev
      Bluetooth: Write LE Host Supported command
      Bluetooth: Add enable_le module parameter
      Bluetooth: Add lmp_host_le_capable() macro
      Bluetooth: Remove enable_smp parameter
      Bluetooth: Fix potential deadlock in hci_core
      Bluetooth: Fix potential deadlock in mgmt

Andre Heider (3):
      ps3_gelic: Fix typos
      ps3_gelic: Fix start_xmit kick error path
      ps3_gelic: Don't kill the device on DMA failure

Andrew Morton (1):
      drivers/net/wireless/rtlwifi/rtl8192de/phy.c: fix udelay() usage

Andy Gospodarek (1):
      ixgbe: only enable WoL for magic packet by default

Andy Shevchenko (1):
      net: can: remove custom hex_to_bin()

Anirban Chakraborty (4):
      qlcnic: Remove holding api lock while taking the dump
      qlcnic: Add code to tune FW dump
      qlcnic: Add support to enable/disable FW dump capability
      qlcnic: change capture mask for FW dump

Antonio Quartulli (19):
      batman-adv: move neigh_node->if_incoming->if_status check in find_router()
      batman-adv: move smallest_signed_int(), seq_before() and seq_after() into main.h
      batman-adv: use is_broadcast_ether_addr() instead of compare_eth(.., brd_addr)
      batman-adv: a multiline comment should precede the variable it is describing
      batman-adv: Unify the first 3 bytes in each packet
      batman-adv: improved client announcement mechanism
      batman-adv: improved roaming mechanism
      batman-adv: protect the local and the global trans-tables with rcu
      batman-adv: add wrapper function to throw uevent in userspace
      batman-adv: gateway election code refactoring
      batman-adv: throw uevent in userspace on gateway add/change/del event
      batman-adv: improved gateway tq-based selection
      batman-adv: unify flags for tt_change/tt_local_entry/tt_global_entry
      batman-adv: add_bcast_packet_to_list() takes the sending delay as parameter
      batman-adv: pass a unique flag arg instead of a sequence of bool ones
      batman-adv: initialise last_ttvn and tt_crc for the orig_node structure
      batman-adv: keep local table consistency for further TT_RESPONSE
      batman-adv: keep global table consistency in case of roaming
      batman-adv: request the full table if tt_crc doesn't match

Antti Julku (2):
      Bluetooth: Move blacklisting functions to hci_core
      Bluetooth: Add blacklisting support for mgmt interface

Arend van Spriel (3):
      lib: crc8: add new library module providing crc8 algorithm
      lib: cordic: add library module providing cordic angle calculation
      drivers: bcma: export bcma_core_disable() function

Ariel Elior (2):
      bnx2x: Renaming the "reset_task" to "sp_rtnl_task"
      bnx2x: Multiple concurrent l2 traffic classes

Arik Nemtsov (11):
      mac80211: reestablish mis-configured existing Rx BA sessions
      mac80211: dynamic PS - don't enter PS when TX frames are pending
      mac80211: propagate information about STA WME support down
      wl12xx: AP-mode - use mac80211 indication about STA WME support
      wl12xx: AP mode - support FW TX inactivity triggers
      wl12xx: use 802.11 header location after relocation to frame start
      wl12xx: schedule TX packets according to FW occupancy
      wl12xx: implement Tx watermarks per AC
      wl12xx: initialize max_power levels for 11a channels
      wl12xx: always initialize AP-mode max power level
      wl12xx: start/stop queues according to global per-AC counters

Barry Grussling (1):
      DSA: Enable cascading in multi-chip 6131 configuration

Bastian Blank (1):
      xen/netback: Add module alias for autoloading

Ben Dooks (1):
      net: DM9000: Add support for byte EEPROM access

Ben Greear (2):
      af-packet: Hold reference to bound network devices.
      af-packet: Use existing netdev reference for bound sockets.

Ben Hutchings (7):
      sfc: Fix loop condition for efx_filter_search() when !for_insert
      sfc: Allow resets to be upgraded; use atomic ops for safety
      sfc: Fix mapping of reset reasons and flags to methods
      sfc: Fix assertions in efx_filter_rfs()
      sfc: Remove 'Solarstorm' from Kconfig descriptions
      sfc: Remove 'Communications' after 'Solarflare' in references to hardware
      ethtool: Allow zero-length register dumps again

Benjamin Herrenschmidt (1):
      sungem: Spring cleaning and GRO support

Bill Sommerfeld (1):
      ipv4: Constrain UFO fragment sizes to multiples of 8 bytes

Bj√∏rn Mork (1):
      Disable router anycast address for /127 prefixes

Bruce Allan (8):
      e1000e: disable far-end loopback mode on ESB2
      e1000e: 82579 intermittently disabled during S0->Sx
      e1000e: log when swflag is cleared unexpectedly on ICH/PCH devices
      e1000e: do not schedule the Tx queue until ready
      e1000e: access multiple PHY registers on same page at the same time
      e1000e: Clear host wakeup bit on 82577/8 without touching PHY page 800
      e1000e: remove redundant reverse dependency on CRC32
      e1000e: update driver version

Carolyn Wyborny (5):
      igb: Change version to remove number after -k in kernel versions.
      igb: Fix lack of flush after register write and before delay
      igb: Update copyright on all igb driver files.
      igb: Add support of SerDes Forced mode for certain hardware
      e1000e: Add Jumbo Frame support to 82583 devices

Chaoming Li (12):
      rtlwifi: rtl8192de: Merge def.h
      rtlwifi: rtl8192de: Merge dynamic management routines
      rtlwifi: rtl8192de: Merge firmware routines
      rtlwifi: rtl8192de: Merge hardware routines
      rtlwifi: rtl8192de: Merge led routines
      rtlwifi: rtl8192de: Merge phy routines
      rtlwifi: rtl8192de: Merge register definitions
      rtlwifi: rtl8192de: Merge rf routines
      rtlwifi: rtl8192de: Merge main (sw) routines
      rtlwifi: rtl8192de: Merge table routines
      rtlwifi: rtl8192de: Merge TX and RX routines
      rtlwifi: rtl8192de: Modify Kconfig and Makefile routines for new driver

Chetan Loke (1):
      af-packet: fix - avoid reading stale data

Choi, Jong-Hwan (1):
      net: Kobj and queues_kset should be used when CONFIG_XPS is enabled

Chris Friesen (1):
      netfilter: ipset: fix compiler warnings "'hash_ip4_data_next' declared inline after being called"

Christian Lamparter (6):
      carl9170: import 1.9.4 firmware headers
      carl9170: enable IEEE80211_HW_NEED_DTIM_PERIOD
      carl9170: allow PSM if the 5 GHz band is selected
      mac80211: fix smatch complains
      carl9170: use carl9170 queue enums
      carl9170: Implement tx_frames_pending mac80211 callback function

Connor Hansen (1):
      drivers/ssb/driver_chipcommon_pmu.c: uninitilized warning

Dan Carpenter (9):
      b43: check for allocation failures
      rtnetlink: unlock on error path in netlink_dump()
      iwlegacy: fix up brokenness caused by cleanup
      dcb: use nlmsg_free() instead of kfree()
      mwifiex: restore handling of NULL parameters
      rtlwifi: potential forever loop in rtl92de_hw_init()
      wanxl: remove a stray irq enable
      dcbnl: unlock on an error path in dcbnl_cee_fill()
      skbuff: fix error handling in pskb_copy()

Daniel Baluta (1):
      skbuff: update struct sk_buff members comments

Daniel Drake (2):
      libertas: add sd8686 reset_card support
      libertas: fix handling of command timeout, completion and interruption

Daniel Halperin (1):
      iwlwifi: disambiguate invalid DMA index warnings

Daniele Furlan (1):
      batman-adv: accept delayed rebroadcasts to avoid bogus routing under heavy load

David Howells (1):
      batman-adv: count_real_packets() in batman-adv assumes char is signed

David Lamparter (2):
      net: add 802.1ad / 802.1ah / QinQ ethertypes
      net: vlan, qlcnic: make vlan_find_dev private

David Miller (4):
      Bluetooth: Kill set but not used variable 'l2cap_sk' in rfcomm_sock_getsockopt_old()
      Bluetooth: Do not ignore errors returned from strict_strtol()
      Bluetooth: Kill set but unused variable 'cmd' in cmtp_recv_capimsg()
      ipv4: Inline neigh binding.

David S. Miller (59):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      sctp: Guard IPV6 specific code properly.
      Merge branch 'can/at91-sam9x5' of git://git.pengutronix.de/git/mkl/linux-2.6
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Fix build failures due to ip_is_fragment()
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'tipc-Jun24-2011' of git://git.kernel.org/.../paulg/net-next-2.6
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'for-next' of git://git2.kernel.org/.../lowpan/lowpan
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/linux-merge
      packet: Add helpers to register/unregister ->prot_hook
      packet: Add fanout support.
      ipv4: Add ip_defrag() agent IP_DEFRAG_AF_PACKET.
      packet: Add pre-defragmentation support for ipv4 fanouts.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      veth: Kill unused code label and code block.
      packet: Add 'cpu' fanout policy.
      packet: Fix leak in pre-defrag support.
      rose: Delete commented out references to ancient firewalling code.
      packet: Fix build with INET disabled.
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/linux-merge
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      neigh: Store hash shift instead of mask.
      ipv4: Use universal hash for ARP.
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      netdevice: Kill 'feature' test macros.
      net: Push protocol type directly down to header_ops->cache()
      net: Kill support for multiple hh_cache entries per neighbour
      net: Embed hh_cache inside of struct neighbour.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'davem-next.r8169' of git://git.kernel.org/.../romieu/netdev-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      ipv4: Use calculated 'neigh' instead of re-evaluating dst->neighbour
      ipv6: Use calculated 'neigh' instead of re-evaluating dst->neighbour
      net: Create and use new helper, neigh_output().
      neigh: Simply destroy handling wrt. hh_cache.
      neigh: Kill neigh_ops->hh_output
      neigh: Kill hh_cache->hh_output
      neigh: Kill ndisc_ops->queue_xmit
      neigh: Pass neighbour entry to output ops.
      ipv6: Get rid of rt6i_nexthop macro.
      net: Abstract dst->neighbour accesses behind helpers.
      net: Add ->neigh_lookup() operation to dst_ops
      Merge branch 'davem-next.r8169' of git://git.kernel.org/.../romieu/netdev-2.6
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      net: Fix ppc64 BPF JIT dependencies.
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      icmp: Fix regression in nexthop resolution during replies.

Dmitry Eremin-Solenikov (3):
      fakehard: stop setting platform_data as it's unused anymore
      ieee802154: support specifying hw address for created devices
      ieee802154: it's IEEE 802.15.4, not ZigBee

Dmitry Kravkov (16):
      bnx2x: do not allocate FCoE ring if disabled
      bnx2x: remove references to intr_sem
      bnx2x: put start bd csum in separate function
      bnx2x: avoid release of unrequested irqs
      bnx2x: disable fairness if ETS is enabled
      bnx2x: dump FW memory when appropriate msglvl is raised
      bnx2x: use bnx2x_reload_if_running
      bnx2x: removed unused variables
      bnx2x: update DCB data during PMF migration
      bnx2x: Cosmetic changes.
      bnx2x: PFC support for 578xx
      bnx2x: Fix compilation when CNIC is not selected in config
      bnx2x: add missing command in error handling flow
      bnx2x: DCB rework
      bnx2x: fix MB index for 4-port devices
      bnx2x: disable FCoE for 578xx devices since not yet supported

Dmitry.Tarnyagin (1):
      caif: Add CAIF HSI Link layer driver

Don Fry (1):
      iwlagn: remove iwlagn_hcmd_utils structure and call directly

Don Skidmore (2):
      ixgbe: update driver version string
      ixgbe: convert to ndo_fix_features

Eddie Wai (1):
      cnic: Randomize initial TCP port for iSCSI connections

Eduardo Bacchi Kienetz (1):
      rt2800usb: Add new device ID for Belkin

Eliad Peller (18):
      mac80211: add ieee80211_get_operstate() function
      mac80211: add cancel_hw_scan() callback
      mac80211: quiesce vif before suspending
      wl12xx: add support for rx streaming
      wl12xx: add automatic rx streaming triggers
      wl12xx: add rx_streaming debugfs entry
      wl12xx: remove unused crc7 references
      wl12xx: fix erroneous commit (cb5ae0)
      wl12xx: don't check wow param on suspend/resume
      wl12xx: clear wl->wow_enabled on resume
      wl12xx: enable/disable beacon filtering on ap suspend/resume
      wl12xx_sdio: enable wowlan only if enable_irq_wake() succeeded
      wl12xx: check the vif's operstate after join
      wl12xx: use _ni version of ieee80211_tx_status
      wl12xx: use freezable workqueue for netstack_work
      wl12xx: configure suspend/resume only if associated/started
      wl12xx: add stop_scan command
      wl12xx: implement cancel_hw_scan() callback

Emil Tantilov (5):
      ixgbe: add support for Dell CEM
      ixgbe: move setting RSC into a separate function
      ixgbe: move reset code into a separate function
      ixgbe: disable RSC when Rx checksum is off
      ixgbe: remove ifdef check for non-existent define

Emmanuel Grumbach (28):
      iwlagn: solve sparse warning
      iwlagn: free the ICT ISR when the request_irq failed
      iwlagn: don't disable interrupts after the NIC has been reset
      iwlagn: add a iwl_pci.[ch] files that will contain all PCI specific code
      iwlagn: remove uneeded include to pci.h and dma_mapping.h from a few files
      iwlagn: introduce iwl_bus and iwl_bus_ops
      iwlagn: add get_dev to iwl_bus_ops
      iwlagn: move PCI related operations from probe and remove to PCI layer
      iwlagn: don't use the PCI wrappers for DMA operation
      iwlagn: add a method to get the HW ID description as a string to iwl_bus_ops
      iwlagn: don't read the PCI_REVISION_ID from iwl-agn.c
      iwlagn: add a get_irq method to iwl_bus_ops and use it
      iwlagn: finally kill the pointer to pci_dev from iwl-dev.h
      iwlagn: waterfall the bus level if prepare card failed
      iwlagn: fix misplaced bracket
      iwlagn: warn about nested SYNC commands
      iwlagn: store the irq number to iwl_bus just like dev
      iwlagn: introduce transport layer and implement rx_init
      iwlagn: add rx_free to transport layer
      iwlagn: move the tx allocation funcs to the transport layer
      iwlagn: remove the indirection for the rx write pointer
      iwlagn: remove the CMD_MAPPED flag
      iwlagn: add an API to free the TX context
      iwlagn: add an API for RX stop
      iwlagn: add an API for TX stop
      iwlagn: remove code duplication
      iwlagn: consolidate the API that sends host commands and move to transport
      iwlagn: provide heplers to access the transport ops

Eric Dumazet (23):
      inetpeer: remove unused list
      inetpeer: lower false sharing effect
      snmp: reduce percpu needs by 50%
      l2tp: fix l2tp_ip_sendmsg() route handling
      veth: fix 64bit stats on 32bit arches
      myricom: remove stats_lock
      b44: use dev_kfree_skb() in b44_tx()
      veth: Kill unused tx_dropped
      net: sched: constify tcf_proto and tc_action
      sky2: use GFP_KERNEL allocations at device setup
      af_packet: lock imbalance
      bna: use netdev_alloc_skb_ip_align()
      net: introduce __netdev_alloc_skb_ip_align
      e1000e: remove e1000_queue_stats
      inetpeer: kill inet_putpeer race
      be2net: account for skb allocation failures
      netfilter: nfnetlink: add RCU in nfnetlink_rcv_msg()
      netfilter: nfnetlink_queue: provide rcu enabled callbacks
      ipv4: save cpu cycles from check_leaf()
      netfilter: nfnetlink_queue: assert monotonic packet ids
      ipv6: unshare inetpeers
      ipv6: make fragment identifications less predictable
      acenic: include NET_SKB_PAD headroom to incoming skbs

Fabrice Deyber (1):
      ath9k: Further fix for mesh beaconing

Felipe Balbi (5):
      net: wl12xx: sdio: id_tables should be __devinitconst
      net: wl12xx: remove some unnecessary prints
      net: wl12xx: care for optional operations
      net: wl12xx: remove the nops
      net: wl12xx: remove unnecessary prints

Felix Fietkau (20):
      ath9k: unify edma and non-edma tx code, improve tx fifo handling
      ath9k_hw: remove ath9k_hw_get_desc_link
      ath9k: show excessive-retry MPDUs in debugfs
      ath9k_hw: remove hardcoded PLL overrides for AR9280
      ath9k_hw: always enable 5 GHz fast clock for AR9280
      ath9k_hw: fix MAC clock for half/quarter rate
      ath9k_hw: fix MAC clock rate for AR9287 v1.3+
      ath9k_hw: initialize more timing related registers for half/quarter channels
      ath9k_hw: remove ar9287 v1.3+ specific hardcoded register hacks
      ath9k_hw: set 5 GHz half/quarter channels on AR9002 using fractional mode
      ath9k_hw: fix synth delay for half/quarter channels
      ath9k_hw: add a missing delay for an analog register
      ath5k: add missing checks for rfgain probe
      ath5k: apply the synth voltage tweak only on AR5112 rev 2
      ath5k: fix reference clock frequency for spur mitigation on AR2413
      ath5k: initialize common->clockrate
      ath5k: delay full calibration after reset
      ath5k: fix reference clock usec duration setting restore
      ath5k: disable 32KHz sleep clock operation by default
      ath5k: do not call ieee80211_stop_queue for queues not managed by mac80211

Florian Westphal (1):
      netfilter: nfnetlink_queue: batch verdict support

Francois Romieu (4):
      r8169: move the firmware down into the device private data.
      r8169: explicit firmware format check.
      r8169: check firmware content sooner.
      r8169: fix sticky accepts packet bits in RxConfig.

Fry, Donald H (3):
      iwlagn: remove the indirection for update_chain_flags
      iwlagn: remove the indirection for iwl_apm_init
      iwlagn: remove indirection for eeprom_query_addr

Gabor Juhos (32):
      ath9k: define mac version for AR9330
      ath9k: define device id for AR9330
      ath9k: add MAC revision detection for AR9330
      ath9k: add platform device id for AR9330
      ath9k: add AR9330 initvals
      ath9k: initialize mode registers for AR9330
      ath9k: initialize tx gain table for AR9330
      ath9k: initialize rx gain table for AR9330
      ath9k: add AR9330 specific PLL initialization
      ath9k: use different BB watchdog timeout value for AR9330
      ath9k: don't enable LDPC for AR9330
      ath9k: read spur frequency information from eeprom for AR9330
      ath9k: fix channel frequency calculation for AR9340
      ath9k: configure RF channel frequency for AR9330
      ath9k: enable TX/RX data byte swap for AR9330
      ath9k: skip internal regulator configuration for AR9330
      ath9k: enable tuning capacitance configuration for AR9330
      ath9k: use correct EEPROM base for AR9330
      ath9k: configure xpa bias level for AR9330
      ath9k: set NF limits for AR9330
      ath9k: enable antenna diversity for AR9330
      ath9k: use correct max_streams for AR9330
      ath9k: add a missing case statement to ath_ant_div_comb_alt_check
      ath9k: fix antenna diversity configuration for non AR9485 chips
      ath9k: remove superfluous parentheses
      ath9k: add fast_div_bias configuration for diversity group 1
      ath9k: set diversity group for AR9330
      ath9k: fix few register offsets for AR9330
      ath9k: configure diversity based on eeprom contents for AR9330
      ath9k: configure internal regulator for AR9330
      ath9k: add external_reset callback to ath9k_platfom_data for AR9330
      ath9k: enable support for AR9330

Geert Uytterhoeven (2):
      net/m68k: Include <linux/interrupt.h> where needed
      bcma: main.c needs to include <linux/slab.h>

Geoff Levand (1):
      net/ps3: Fix gelic RX DMA restart

Gerrit Renker (6):
      dccp: Clean up slow-path input processing
      dccp: combine the functionality of enqeueing and cloning
      dccp: cosmetics of info message
      dccp ccid-2: move rfc 3390 function into header file
      dccp ccid-2: Use existing function to test for data packets
      dccp ccid-2: Perform congestion-window validation

Gertjan van Wingerde (12):
      rt2x00: Enable PA_PE bits in TX_PIN_CFG according to active band.
      rt2x00: Don't disable G0 PA_PE bit in case of BT coexistence.
      rt2x00: Add support for RT3572/RT3592/RT3592+Bluetooth combo card
      rt2x00: Interface sequence lock doesn't have to disable interrupts.
      rt2x00: Move rt2800_txdone and rt2800_txdone_entry_check to rt2800usb.
      rt2x00: Enabled rt35xx device support by default.
      rt2x00: Serialize TX operations on a queue.
      rt2x00: Don't use queue entry as parameter when creating TX descriptor.
      rt2x00: Reduce window of a queue's tx lock.
      rt2x00: Add device ID for RT539F device.
      rt2x00: Properly identify rt2800usb devices.
      rt2x00: Implement tx_frames_pending mac80211 callback function.

Giuseppe CAVALLARO (4):
      stmmac: update the version (V2)
      stmmac: remove warning when compile as built-in (V2)
      stmmac: unify MAC and PHY configuration parameters (V2)
      stmmac: improve and up-to-date the documentation

Greg Dietsche (10):
      iwlegacy: remove unreachable code
      iwlegacy: remove unecessary if statement
      iwlegacy: return -EINVAL instead of -1
      iwlegacy: propagate error return value
      iwlegacy: add missing null check
      qlge: remove unecessary if statement
      iwlwifi: remove unecessary if statement
      net: icplus: remove unnecessary code
      e1000: remove unnecessary code
      net: rds: fix const array syntax

Greg Rose (3):
      rtnetlink: Compute and store minimum ifinfo dump size
      ixgbevf: Update the driver string
      ixgbevf: Fix bungled declaration of ixgbevf_mbx_ops

Guo-Fu Tseng (3):
      jme: Fix compile warning introduced by new pm macro
      jme: Cleanup PM operations after using new PM API
      jme: Fix unmap error (Causing system freeze)

Gustavo F. Padovan (23):
      Bluetooth: fix set but not used warning
      Bluetooth: Create __l2cap_chan_close()
      Bluetooth: Create l2cap_chan_send()
      Bluetooth: Add chan->chan_type struct member
      Bluetooth: create channel timer to replace sk_timer
      Bluetooth: Remove export of l2cap_chan_clear_timer()
      Bluetooth: Rename __l2cap_chan_close() to l2cap_chan_close()
      Merge master.kernel.org:/.../padovan/bluetooth-2.6
      Bluetooth: Merge l2cap_chan_create() in the l2cap_sock_alloc()
      Bluetooth: Add l2cap_chan_ops abstraction
      Bluetooth: add recv() callback to l2cap_chan_ops
      Bluetooth: add close() callback to l2cap_chan_ops
      Bluetooth: Add state tracking to struct l2cap_chan
      Bluetooth: Add refcnt to struct l2cap_chan
      Bluetooth: Make timer functions generic
      Bluetooth: keep reference if any ERTM timer is enabled
      Bluetooth: Don't forget to check for LE_LINK
      Bluetooth: use bit operation on conf_state
      Bluetooth: Use bit operations on conn_state
      Bluetooth: Fix locking in blacklist code
      Merge master.kernel.org:/.../padovan/bluetooth-2.6
      Bluetooth: Fix bad locking balance
      Bluetooth: Clean up unused struct hci_conn items

Hans Schillstrom (4):
      IPVS remove unused var from migration to netns
      IPVS: rename of netns init and cleanup functions.
      IPVS: labels at pos 0
      IPVS: remove unused init and cleanup functions.

Hauke Mehrtens (3):
      ssb: add __devinit to some functions
      ssb: fix ssb clock rate according to broadcom source
      bcma: add check if sprom is available before accessing it.

Hayes Wang (8):
      r8169: support new firmware format.
      r8169: adjust some registers.
      r8169: modify the flow of the hw reset.
      r8169: add ERI functions.
      r8169: support RTL8111E-VL.
      r8169: fix wake on lan setting for non-8111E.
      r8169: don't enable rx when shutdown.
      r8169: adjust the RxConfig settings.

Ian Abbott (1):
      lib/checksum.c: optimize do_csum a bit

Ido Yariv (4):
      wl12xx: Check for FW quirks as soon as the FW boots
      wl12xx: Avoid recovery while one is already in progress
      wl12xx: Support routing FW logs to the host
      wl12xx: Increase low & high TX watermarks

Ilia Kolomisnky (1):
      Bluetooth: Fixes l2cap "command reject" reply according to spec

Jaikumar Ganesh (1):
      Bluetooth: Add BT_POWER L2CAP socket option.

Jan Engelhardt (1):
      netfilter: xt_CT: provide info on why a rule was rejected

Jason Wang (3):
      virtio_net: introduce VIRTIO_NET_HDR_F_DATA_VALID
      vhost: init used ring after backend was set
      vhost: set log when updating used flags or avail event

Javier Lopez (1):
      mac80211_hwsim driver support userspace frame tx/rx

Jean Delvare (1):
      ipw2100: Fix command list for debugging

Jeff Kirsher (2):
      e1000e: use GFP_KERNEL allocations at init time
      68360enet: Remove Kconfig/Makefile references

Jeffrey Huang (1):
      bnx2: Add MCP dump

Jerry Chu (1):
      tcp: RFC2988bis + taking RTT sample from 3WHS for the passive open side

Jesper Juhl (4):
      Remove redundant linux/version.h includes from net/
      net: Remove unneeded version.h includes from drivers/net/
      net, wireless: Don't return uninitialized in __cfg80211_stop_sched_scan()
      drivers/net: static should be at beginning of declaration

Jesse Gross (2):
      vmxnet3: Convert to new vlan model.
      vmxnet3: Enable GRO support.

Jiri Bohac (1):
      bonding: clean up bond_del_vlan()

Jiri Pirko (47):
      bonding: allow all slave speeds
      vlan: finish removing vlan_find_dev from public header
      vlan: introduce __vlan_find_dev_deep()
      nes: do vlan cleanup
      ehea: do vlan cleanup
      lro: kill lro_vlan_hwaccel_receive_skb
      lro: kill lro_vlan_hwaccel_receive_frags
      lro: do vlan cleanup
      amd8111e: do vlan cleanup
      atl1c: do vlan cleanup
      atl1e: do vlan cleanup
      bnad: do vlan cleanup
      chelsio: do vlan cleanup
      cxgb4vf: do vlan cleanup
      cxgb4: remove forgotten unused vlan_group
      enic: do vlan cleanup
      gianfar: do vlan cleanup
      igbvf: do vlan cleanup
      jme: do vlan cleanup
      mlx4: do vlan cleanup
      qlge: do vlan cleanup
      s2io: do vlan cleanup
      spider_net: do not mention dying vlan_hwaccel_receive_skb
      tehuti: do vlan cleanup
      vlan: kill vlan_hwaccel_receive_skb
      ixgbevf: do vlan cleanup
      acenic: do vlan cleanup
      via-velocity: do vlan cleanup
      starfire: do vlan cleanup
      ns83820: do vlan cleanup
      atl1: do vlan cleanup
      atl2: do vlan cleanup
      cxgb3: do vlan cleanup
      vlan: kill __vlan_hwaccel_rx and vlan_hwaccel_rx
      e1000: do vlan cleanup
      forcedeth: do vlan cleanup
      igb: do vlan cleanup
      vxge: do vlan cleanup
      qeth: do vlan cleanup
      vlan: kill vlan_gro_frags and vlan_gro_receive
      stmmac: do vlan cleanup
      qlcnic: remove usage of vlan_group_get_device
      staging: et131x: remove unused prototype et131x_vlan_rx_register
      bonding: do vlan cleanup
      macvlan: do vlan cleanup
      vlan: kill ndo_vlan_rx_register
      vlan: move vlan_group_[gs]et_device to public header

Joe Perches (47):
      net: 8021q: Add pr_fmt
      net: Remove unnecessary semicolons
      drivers/net: Remove unnecessary semicolons
      include/net: Remove unnecessary semicolons
      net: Remove casts of void *
      gianfar: Use pr_<level>, netdev_<level> and netif_<level>
      drivers/net: Remove casts of void *
      ariadne: Update style, neaten, restructure to eliminate prototypes
      a2065: Use pr_fmt, pr_<level> and netdev_<level>
      lib8390: Use pr_<level> and netdev_<level>
      lib8390: Indent braces appropriately
      lib8390: Normalize source code spacing
      lib8390: Convert include <asm to include <linux
      lib8390: Remove unnecessary extern
      zorro8390: Update style, neaten, restructure to eliminate prototypes
      generic_hdlc: Update to current logging forms
      cosa: Update to current logging forms
      cyclom: Update to current logging forms
      frame relay dlci/frad: Update to current logging forms
      dscc4: Update to current logging forms
      farsync: Update to current logging forms
      ixp4xx_hss: Update to current logging forms
      wan: Update to current logging forms
      rt2x00: Fix unspeficied typo
      caif: Fix recieve/receive typo
      Bluetooth: Rename function bt_err to bt_to_errno
      Bluetooth: Add bt_printk
      appletalk: Reduce switch/case indent
      decnet: Reduce switch/case indent
      econet: Reduce switch/case indent
      ipconfig: Reduce switch/case indent
      netfilter: Reduce switch/case indent
      ipv4: Reduce switch/case indent
      ipv6: Reduce switch/case indent
      lapb: Reduce switch/case indent
      netrom: Reduce switch/case indent
      sctp: Reduce switch/case indent
      sunrpc: Reduce switch/case indent
      x25: Reduce switch/case indent
      netpoll: Remove unused EXPORT_SYMBOLs of netpoll_poll and netpoll_poll_dev
      netpoll: Remove wrapper function netpoll_poll
      af_econet: Use current logging styles and neatening
      b44: Use pr_<level>_once and DRV_DESCRIPTION
      benet: Add missing comma between constant string array
      ath5k: Add missing breaks in switch/case
      iwlegacy: Add missing comma between constant string array
      iwlagn: Add missing comma between constant string array

Johan Hedberg (1):
      Bluetooth: Remove unnecessary use of hci_dev_list_lock

Johannes Berg (30):
      iwlagn: fix dual-mode RXON
      iwlagn: advertise interface combinations
      iwlagn: fix interface combinations
      Bluetooth: fix sparse & gcc warnings
      iwlagn: don't check ucode subtype
      netlink: advertise incomplete dumps
      nl80211: use netlink consistent dump feature for BSS dumps
      iwlagn: use PM ops macro
      iwlagn: fix cmd queue unmap
      iwlagn: extend host command timeout
      iwlagn: fill beacon TX rate properly
      iwlagn: don't use CCK rates for P2P interfaces
      wireless: unify QoS control field definitions
      mac80211: restrict advertised HW scan rates
      iwlagn: verify mutex held for sync commands
      mac80211: allow driver to impose WoWLAN restrictions
      mac80211: allow driver to iterate keys
      cfg80211/nl80211: support GTK rekey offload
      mac80211: support GTK rekey offload
      mac80211: fix TKIP races, make API easier to use
      mac80211: fix CCMP races
      mac80211: fix CMAC races
      mac80211: use AES_BLOCK_SIZE
      mac80211: simplify RX PN/IV handling
      mac80211: allow drivers to access key sequence counter
      mac80211: allow driver to generate P1K for IV32
      cfg80211: fix docbook
      mac80211: fix docbook
      mac80211: allocate only one RX queue
      mac80211: allow driver to disconnect after resume

John Fastabend (21):
      macvlan: add VLAN filters to lowerdev
      ixgbe: dcbnl reduce duplicated code and indentation
      ixgbe: consolidate packet buffer allocation
      ixgbe: consolidate MRQC and MTQC handling
      ixgbe: configure minimal packet buffers to support TC
      ixgbe: DCB use existing TX and RX queues
      ixgbe: DCB 82598 devices, tx_idx and rx_idx swapped
      ixgbe: setup redirection table for multiple packet buffers
      ixgbe: fix bit mask for DCB version
      ixgbe: DCB and perfect filters can coexist
      ixgbe: DCB, remove unneeded ixgbe_dcb_txq_to_tc() routine
      dcb: Add DCBX capabilities bitmask to the get_ieee response
      net: dcbnl, add multicast group for DCB
      dcb: Add ieee_dcb_setapp() to be used for IEEE 802.1Qaz APP data
      dcb: Add ieee_dcb_delapp() and dcb op to delete app entry
      dcb: Add dcb_ieee_getapp_mask() for drivers to query APP settings
      dcb: fix return type on dcb_setapp()
      dcb: Add missing error check in dcb_ieee_set()
      ixgbe: complete FCoE initialization from setapp() routine
      ixgbe: remove unused fcoe.tc field and fcoe_setapp()
      ixgbe: implement DCB ops dcb_ieee_del()

John W. Linville (16):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      ath5k: free sc->ah in ath5k_deinit_softc
      Merge branch 'master' of master.kernel.org:/.../padovan/bluetooth-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of master.kernel.org:/.../padovan/bluetooth-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Jon Mason (25):
      myri_sbus: remove driver
      tg3: remove unnecessary read of PCI_CAP_ID_EXP
      mlx4: remove unnecessary read of PCI_CAP_ID_EXP
      cxgb3: remove unnecessary read of PCI_CAP_ID_EXP
      e1000e: remove unnecessary reads of PCI_CAP_ID_EXP
      igb: remove unnecessary reads of PCI_CAP_ID_EXP
      bnx2: remove unnecessary read of PCI_CAP_ID_EXP
      bnx2x: remove unnecessary read of PCI_CAP_ID_EXP
      niu: remove unnecessary read of PCI_CAP_ID_EXP
      r8169: remove unnecessary read of PCI_CAP_ID_EXP
      sky2: remove unnecessary reads of PCI_CAP_ID_EXP
      vxge: remove unnecessary reads of PCI_CAP_ID_EXP
      myri10ge: ensure tx queues remain stopped
      myri10ge: Mask PCI Surprise Link Down Events
      myri10ge: rework parity error check and cleanup
      myri10ge: allow small_bytes = 0
      myri10ge: add support for set_phys_id
      myri10ge: remove unnecessary read of PCI_CAP_ID_EXP
      myri10ge: misc style cleanups
      myri10ge: update version
      myri10ge: Update MAINTAINERS
      iwlegacy: remove unnecessary read of PCI_CAP_ID_EXP
      rtlwifi: remove unnecessary read of PCI_CAP_ID_EXP
      rtlwifi: use PCI_VENDOR_ID_*
      iwlwifi: remove unnecessary read of PCI_CAP_ID_EXP

Jozsef Kadlecsik (17):
      netfilter: ipset: timeout can be modified for already added elements
      netfilter: ipset: whitespace fixes: some space before tab slipped in
      netfilter: ipset: options and flags support added to the kernel API
      netfilter: ipset: support listing setnames and headers too
      netfilter: ipset: fix adding ranges to hash types
      netfilter: ipset: set type support with multiple revisions added
      netfilter: ipset: support range for IPv4 at adding/deleting elements for hash:*net* types
      netfilter: ipset: adding ranges to hash types with timeout could still fail, fixed
      netfilter: ipset: take into account cidr value for the from address when creating the set
      netfilter: ipset: use unified from/to address masking and check the usage
      netfilter: ipset: add xt_action_param to the variant level kadt functions, ipset API change
      netfilter: ipset: fix return code for destroy when sets are in use
      netfilter: ipset: use the stored first cidr value instead of '1'
      netfilter: ipset: hash:net,iface type introduced
      netfilter: ipset: whitespace and coding fixes detected by checkpatch.pl
      netfilter: ipset: make possible to hash some part of the data element only
      netfilter: ipset: hash:net,iface fixed to handle overlapping nets behind different interfaces

Julian Anastasov (1):
      ipvs: support more FTP PASV responses

Jussi Kivilinna (6):
      zd1211rw: fix invalid signal values from device
      zd1211rw: make 'handle_rx_packet: invalid, small RX packet' message debug-only
      zd1211rw: only update HW beacon if new beacon differs from currect
      zd1211rw: handle lost read-reg interrupts
      zd1211rw: don't let zd_mac_config_beacon() run too long from beacon interrupt handler
      zd1211rw: detect stalled beacon interrupt faster

Kalle Valo (4):
      iwlegacy: fix stop/wake queue hacks
      iwlwifi: fix stop/wake queue hacks
      zd1211rw: include mac80211.h from zd_chip.h
      rtlwifi: include mac80211.h from core.h

Krishna Kumar (2):
      Remove redundant variable/code in __qdisc_run
      virtio_net: Fix panic in virtnet_remove

Kuninori Morimoto (1):
      net: sh_eth: tidyup compile warning

Kurt Van Dijck (1):
      can: remove useless defaults in Kconfig

Larry Finger (17):
      b43: Fix warnings from gcc 4.6.0
      rtlwifi: Fix warnings from gcc 4.6.0
      rtl8192c-common: Fix warnings from gcc 4.6.0
      rtl8192ce: Fix warnings from gcc 4.6.0
      rtl8192cu: Fix warnings from gcc 4.6.0
      rtl8192se: Fix warnings from gcc 4.6.0
      b43legacy: Fix warnings from gcc 4.6.0
      rtlwifi: rtl8192se: Use write barrier when assigning ownership
      rtlwifi: rtl8192se: Synchronize IRQ after disabling it
      rtlwifi: Fix warnings on parisc arch
      rtlwifi: Fix build problems introduced by merging rtl8192de
      rtlwifi: rtl8192de: Fix build errors when using allyes configuration
      rtlwifi: rtl8192de: Remove irq_enabled boolean
      rtlwifi: rtl8192de: Remove comparison of boolean with true
      rtlwifi: rtl8192de: Replace loops calling udelay with single mdelay
      rtlwifi: rtl8192de: Fix error exit from hw_init
      rtlwifi: rtl8192cu: Fix duplicate if test

Lauro Ramos Venancio (3):
      NFC: add nfc subsystem core
      NFC: add nfc generic netlink interface
      NFC: add the NFC socket raw protocol

Lior Levy (1):
      ixgbe: A fix to VF TX rate limit

Luciano Coelho (2):
      wl12xx: split channel array per band in sched_scan
      cfg80211: return -ENOENT when stopping sched_scan while not running

Luis R. Rodriguez (1):
      cfg80211: skip disabled channels on channel survey

Luiz Augusto von Dentz (1):
      Bluetooth: fix shutdown on SCO sockets

Manuel Zerpies (2):
      net/can: use printk_ratelimited() instead of printk_ratelimit()
      net/rds: use prink_ratelimited() instead of printk_ratelimit()

Marc Kleine-Budde (10):
      can: at91_can: don't align struct definitions
      can: at91_can: fix comment about priv->tx_next
      can: at91_can: don't copy data to rx'ed RTR frames
      can: at91_can: let get_tx_* functions return unsigned int
      can: at91_can: directly define AT91_MB_RX_LAST
      can: at91_can: rename AT91_MB_RX_MASK to AT91_IRQ_MB_RX
      can: at91_can: convert derived mailbox constants into functions
      can: at91_can: add id_table and convert prime mailbox constats to functions
      can: at91_can: register mb0 sysfs entry only on at91sam9263
      can: at91_can: add support for the AT91SAM9X5 SOCs

Marek Lindner (3):
      batman-adv: use NO_FLAGS define instead of hard-coding 0
      batman-adv: broadcast primary OGM on all active hard-interfaces
      batman-adv: aggregation checks should use the primary_if pointer

Marek Vasut (1):
      ASIX: Add AX88772B USB ID

Mat Martineau (8):
      Bluetooth: Restore accidentally-deleted line
      Bluetooth: Fix check for the ERTM local busy state
      Bluetooth: Fix indentation whitespace
      Bluetooth: ERTM timeouts need to be converted to jiffies
      Bluetooth: Check earlier for L2CAP ERTM frames to drop
      Bluetooth: Move code for ERTM local busy state to separate functions
      Bluetooth: Use event-driven approach for handling ERTM receive buffer
      Bluetooth: Remove L2CAP busy queue

Matt Carlson (23):
      tg3: Workaround tagged status update bug
      tg3: Remove 40BIT_DMA_LIMIT_BUG
      tg3: Remove 4G_DMA_BNDRY_BUG flag
      tg3: Add more selfboot formats to NVRAM selftest
      tg3: Fix EEE debounce timer values
      tg3: Show flowctrl settings through get_settings()
      tg3: Migrate phy preprocessor defs to system defs
      tg3: Create funcs for power source switching
      tg3: Detect APE enabled devs earlier
      tg3: Move power state transitions to init_one
      tg3: Check transitions to D0 power state
      tg3: Determine PCI function number in one place
      tg3: Create critical section around GPIO toggling
      tg3: Add function status reporting
      tg3: Match power source to driver state
      tg3: Fix io failures after chip reset
      tg3: Fix link flap at 100Mbps with EEE enabled
      tg3: Fix link down notify failure when EEE disabled
      tg3: Add 5719 and 5720 to EEE_CAP list
      tg3: Fix RSS indirection table distribution
      tg3: Fix int selftest for recent devices.
      tg3: Return size from tg3_vpd_readblock()
      tg3: Fix NVRAM selftest failures for 5720 devs

Matt Evans (1):
      net: filter: BPF 'JIT' compiler for PPC64

Matvejchikov Ilya (6):
      slip: remove redundant NULL-pointer check before calling slhc_free
      slip: fix MTU comparation operation when reallocating buffers
      slip: remove redundant check slip_devs for NULL
      slip: remove dead code within the slip initialization
      slip: remove unused 'line' field from the 'slip' structure
      slcan: remove unused 'leased', 'line' and 'pid' fields from the 'slcan' structure

Max Matveev (2):
      Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem tunables
      Update documented default values for various TCP/UDP tunables

Meenakshi Venkataraman (2):
      mac80211: add driver RSSI threshold events
      iwlagn: Enable/disable PS poll based on RSSI and BT coex traffic state

Michael B√ºsch (1):
      b43: Add RX side DMA memory barrier

Michael Chan (16):
      cnic: Fix interrupt logic
      cnic: Fix race conditions with firmware
      cnic: Improve NETDEV_UP event handling
      cnic, bnx2: Check iSCSI support early in bnx2_init_one()
      cnic: Move indexing function pointers to struct kcq_info
      cnic, bnx2i: Add support for new devices - 57800, 57810, and 57840
      cnic: Replace get_random_bytes() with random32()
      cnic: Fix port_mode setting
      cnic: Fix ring setup/shutdown code
      cnic: Return proper error code if we fail to send netlink message
      bnx2: Read iSCSI config from shared memory during ->probe()
      bnx2: Close device if tx_timeout reset fails
      cnic: Fix Context ID space calculation
      cnic: Wait for all Context IDs to be deleted before sending FCOE_DESTROY_FUNC
      cnic: Add VLAN ID as a parameter during netevent upcall
      bnx2: Fix endian swapping on firmware version string

Michael S. Tsirkin (4):
      vhost: vhost TX zero-copy support
      vhost: fix zcopy reference counting
      vhost: optimize interrupt enable/disable
      vhost-net: update used ring on backend change

Michal Simek (1):
      net: emaclite: Add missing linux/interrupt.h header

Micha≈Ç Miros≈Çaw (9):
      e1000: convert to ndo_fix_features
      igb: convert to ndo_fix_features
      net: Add documentation for netdev features handling
      net: m68k/nfeth: Remove wrong usage of dev->flags
      net: vlan: remove reduntant check in ndo_fix_features callback
      net: cleanup vlan_features setting in register_netdev
      net: unexport netdev_fix_features()
      net: remove /sys/class/net/*/features
      net: remove SK_ROUTE_CAPS from meta ematch

Michio Honda (6):
      sctp: Add ADD/DEL ASCONF handling at the receiver.
      sctp: Add Auto-ASCONF support (core).
      sctp: Add sysctl support for Auto-ASCONF.
      sctp: Add socket option operation for Auto-ASCONF.
      sctp: Add ASCONF operation on the single-homed host
      sctp: kzalloc() error handling on deleting last address

Mike Frysinger (2):
      can: bfin_can: simplify xmit id1 setup
      can: bfin_can: auto-calculate accessor sizes

Mike McCormack (16):
      rtlwifi: Synchronize IRQ after disabling it
      rtlwifi: Remove set_rfpowerstate_inprogress
      rtlwifi: Store loop index in local variable
      rtlwifi: Run IPS leave work in a tasklet
      rtlwifi: Don't block interrupts in spinlocks
      rtlwifi: Assign rx buffer ownership to hardware last
      rtlwifi: Use write barrier when assigning ownership
      rtlwifi: Fix logic in rx_interrupt
      rtlwifi: Remove unnecessary indent
      rtlwifi: Resubmit skbs with bad CRC early
      rtlwifi: Free skb in one place
      rtlwifi: Factor out code to receive one packet
      rtlwifi: Fix typo in variable name
      rtlwifi: rtl8192cu: Remove unused parameter
      rtlwifi: rtl8192{c,ce,cu,se}: Remove comparisons of booleans with true
      rtlwifi: rtl8192{ce,cu,se} Remove irq_enabled

Mohammed Shafi Shajakhan (19):
      ath9k: remove redundant if check
      ath9k: make ath9k_setpower function as static
      ath9k: mark few functions as static
      ath9k: wake up chip before initializing PAPRD table
      ath9k: Add a debug entry to start/stop ANI
      ath9k: better position PAPRD debug message
      ath9k: make use of a helper to get paprd scale factor
      ath9k: Add debug messages to track PAPRD failures
      ath9k: remove a redundant call to pcipowersave
      ath9k: Fix a corner case failure in sending PAPRD frames in HT40
      ath9k_hw: make sure PAPRD training is properly done
      ath9k_hw: Fix calculation of PAPRD training power at 5Ghz
      ath9k_hw: Add carrier leak correction in desired gain calculation
      ath9k_hw: make use of the gain_table_entry macro
      ath9k: move few descriptor macros to ath9k.h
      ath9k_htc: Add device ID for Sony UWA-BR100
      ath9k_hw: Disable PAPRD based on paprd_ht20_mask for 5GHz
      ath9k: remove an unnecessary function declaration
      mac80211: remove a redundant check

Mr Dash Four (1):
      netfilter: add SELinux context support to AUDIT target

Neil Horman (1):
      vmxnet3: remove unused variable

Nicolas Schichan (1):
      e1000: always call e1000_check_for_link() on e1000_ce4100 MACs.

Nikanth Karthikesan (1):
      if_spi: Fix compilation warning - unused variable

Ohad Ben-Cohen (2):
      wl12xx: don't bail if mmc isn't MMC_CAP_POWER_OFF_CARD
      wl12xx: one SDIO initialization is enough

Oliver Hartkopp (1):
      slcan: remove obsolete code in slcan initialisation

Olivier Sobrie (1):
      libertas: fix errors in functions accessing module registers

Oz Krakowski (1):
      wl12xx: fix Tx security sequence number handling

Padmanabh Ratnakar (1):
      be2net: Enable NETIF_F_TSO6 for VLAN traffic for BE

Patrick McHardy (2):
      Merge branch 'master' of /repos/git/net-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../horms/ipvs-next-2.6

Paul Gortmaker (1):
      ip: introduce ip_is_fragment helper inline function

Paul Stewart (3):
      cfg80211: Ignore downstream DEAUTH for authtry_bsses
      mac80211: Start monitor work on restart
      mac80211: Drop DS Channel PARAM in directed probe

Pavel Roskin (19):
      ath9k: use standard max(), remove A_MAX macro
      ath9k: typo fix in a comment
      ath5k: minor cleanup
      ath5k: annotate reg in ath5k_hw_nic_reset() as __iomem
      ath5k: add missing ieee80211_free_hw() on unload in AHB code
      ath5k: remove PRIV_ENTRY and PRIV_ASSIGN macros, they obfuscate the code
      ath5k: replace spaces with tabs as suggested by checkpatch.pl
      ath5k: remove unneeded parentheses after return
      ath5k: use KERN_WARNING in ATH5K_PRINTF
      ath5k: use DEFINE_PCI_DEVICE_TABLE in led.c, mark users with __devinit
      ath5k: use more readable way to clear MAC address
      ath5k: don't use volatile, it's not needed
      ath5k: use parentheses around macro definitions
      ath5k: fix misplaced or extraneous braces found by checkpatch.pl
      ath5k: fix formatting errors found by checkpatch.pl
      ath5k: use kstrtoint() to parse numbers coming from sysfs
      ath5k: read sc->imask with sc->irqlock held
      ath5k: validate mode in ath5k_ani_init() before trying to set it
      ath5k: fix typos, bad comment formatting and GHz in place of MHz

Peter Pan(ÊΩòÂç´Âπ≥) (6):
      bonding: make 802.3ad use latest lacp_rate
      bonding:delete lacp_fast from ad_bond_info
      bonding:delete agg_select_mode from ad_bond_info
      bonding: delete unused ad_timer
      bonding: delete unused arp_mon_pt
      bonding:delete a dereference before check

Po-Yu Chuang (1):
      net: add Faraday FTGMAC100 Gigabit Ethernet driver

Rafa≈Ç Mi≈Çecki (60):
      b43: rename ssb_device variable in ssb specific functions
      b43: add bus device abstraction layer
      b43: bus: abstract R/W operations
      b43: bus: abstract 80211 core info
      b43: bus: abstract SPROM
      b43: bus: abstract device structs and irq
      b43: bus: abstract chip info
      b43: bus: abstract board info
      b43: bus: abstract bus and core operations
      bcma: add IRQ number and pointer to DMA dev
      bcma: pci: implement interrupts control
      b43: LP-PHY: use new pointers path to access ssb_device
      b43: SDIO: use new pointers path to access ssb_device
      b43: use new pointers path to access ssb_device in SSB specific places
      b43: bus: add helpers for checking host type
      bcma: host pci: implement block R/W operations
      b43: do not use SSB specific flags when calling core reset function
      bcma: read SPROM and extract MAC from it
      b43: add an option to register BROKEN bcma driver
      b43: add BCMA 80211 core specific defines
      b43: define new PHYs and radio regs for cores >= 24
      b43: HT-PHY: add place for writing HT PHY support
      b43: add Kconfig option for compiling SSB driver
      b43: HT-PHY: implement radio ops
      b43: HT-PHY: implement switching analog
      bcma: enable support for 14e4:4357 (BCM43225)
      bcma: fix BCM43224 rev 0 workaround
      bcma: clean exports of functions
      b43: HT-PHY: implement killing radio
      b43: HT-PHY: enable radio
      b43: HT-PHY: define standard structs for channel switching
      b43: HT-PHY: add place for implementing channel switching
      b43: HT-PHY: switch radio to requested channel
      b43: N-PHY: update switching analog on/off
      b43: N-PHY: move declarations of chantables functions to correct files
      b43: HT-PHY: calibrate radio after switching channel
      b43: HT-PHY: prepare place for HT-PHY tables
      b43: HT-PHY: upload PHY values when switching channel
      b43: HT-PHY: perform some tables ops on channel switching
      b43: HT-PHY: add channel switching tables for 2 GHz band
      b43: HT-PHY: implement lacking 0x908 PHY reg op
      b43: HT-PHY: replace radio routing magic numbers
      b43: HT-PHY: init radio when enabling it
      b43: HT-PHY: add init tables
      b43: HT-PHY: basic PHY init
      b43: HT-PHY: correct 0x2059 radio init
      bcma: detect PCI core working in hostmode
      b43: make b43_wireless_init bus generic
      b43: implement BCMA bus ops
      b43: use switches for SSB specific code
      b43: handle BCMA in bus switches
      b43: bus: add helpers for getting/setting wldev from/in bus core
      b43: change selecting ucode for newer cores
      b43: select BLOCKIO for BCMA
      b43: use radio ID reading code to older cores only
      b43: read radio ID on new cores
      b43: LCN-PHY add place for new PHY support
      b43: define firmwares for HT and LCN PHYs
      b43: LCN-PHY: include new PHY in common code
      b43: HT-PHY: define dummy TX power functions

Rajkumar Manoharan (10):
      ath9k: Remove ATH9K_BEACON_PERIOD mask
      ath9k: Handle IBSS status changes in BSS_CHANGED_IBSS
      ath9k_hw: Fix false tx hung detection in AR9003 chips
      ath9k: Fix locking issue during tx completion
      ath9k_htc: do not configure filter before driver is started
      mac80211: Restart STA timers only on associated state
      ath9k_hw: Update AR9003 interval to improve 5G Tx EVM
      ath9k_hw: Disable power detector calibration for AR9003
      ath9k_hw: Remove read-only registers from AR9003 intervals
      ath9k_htc: Inform stack about tx ack status

Randy Dunlap (3):
      irda: fix smsc-ircc2 section mismatch warning
      Bluetooth: uses crypto interfaces, select CRYPTO
      bluetooth: uses crypto interfaces, select CRYPTO

Richard Cochran (29):
      net: export time stamp utility function for Ethernet MAC drivers
      fec: enable transmit and receive time stamping.
      davinci_emac: pass ioctls through to phy device.
      davinci_emac: enable transmit time stamping.
      tg3: enable transmit time stamping.
      dnet: enable transmit time stamping.
      ethoc: enable transmit time stamping.
      r6040: enable transmit time stamping.
      stmmac: enable transmit time stamping.
      smsc9420: enable transmit time stamping.
      net: correct comment on where to place transmit time stamp hook.
      fec: fix race in transmit time stamping.
      tg3: fix race in transmit time stamping.
      r6040: fix race in transmit time stamping.
      stmmac: fix race in transmit time stamping.
      smsc9420: fix race in transmit time stamping.
      davinci_emac: fix race in transmit time stamping.
      net: export the receive time stamping hook for non-NAPI drivers
      lib8390: enable transmit and receive time stamping.
      emaclite: enable transmit and receive time stamping.
      ll_temac: enable transmit and receive time stamping.
      fec_mpc52xx: enable transmit and receive time stamping.
      macb: enable transmit time stamping.
      fs_enet: enable transmit time stamping.
      smsc911x: enable transmit time stamping.
      pxa168_eth: enable transmit time stamping.
      ucc_geth: enable transmit time stamping.
      mv643xx_eth: fix race in trasmit path.
      mv643xx_eth: enable transmit time stamping.

Robert Healy (1):
      igb: Fix for DH89xxCC near end loopback test

Roopa Prabhu (1):
      enic: Add support for MTU change via port profile on a dynamic vnic

Ruiyi Zhang (1):
      Bluetooth: Allow unsegmented SDU retries on sock_queue_rcv_skb failure

Sathya Perla (8):
      be2net: support multiple TX queues
      be2net: fix netdev_stats_update
      be2net: get rid of multi_rxq module param
      be2net: fix initialization of vlan_prio_bmap
      be2net: fix certain cmd failure logging
      be2net: create/destroy rx-queues on interface open/close
      be2net: clear intr bit in be_probe()
      be2net: request native mode each time the card is reset

Satoru Moriya (2):
      udp: add tracepoints for queueing skb to rcvbuf
      core: add tracepoints for queueing skb to rcvbuf

Sebastian Andrzej Siewior (1):
      net/b43: don't return IRQ_HANDLED if nothing was done

Sebastian Poehn (2):
      gianfar v5: implement nfc
      gianfar v2: code cleanups

Selvin Xavier (1):
      be2net: Fix Rx pause counter for lancer

Senthil Balasubramanian (1):
      ath9k_hw: Fix incorrect key_miss handling

Sergei Shtylyov (7):
      ssb: use pci_dev->revision
      iwlwifi: use pci_dev->revision, again
      mlx4: use pci_dev->revision
      ssb: PCI revision ID register is 8-bit wide
      ssb: use pci_dev->revision
      ssb: use pci_dev->subsystem_{vendor,device}
      lanai: use pci_dev->subsystem_device

Shahar Levi (4):
      mac80211: Stop BA session event from device
      wl12xx: Stop BA session event from device
      wl12xx: Enable beacon early termination in 2.4GHz band only
      wl12xx: Add Support for Low Power DRPw (LPD) Mode

Shan Wei (4):
      net: Kill unuseful net/TUNABLE doc in kernel source
      net: Add GSO to vlan_features initialization
      net: fix warning of versioncheck
      net: doc: fix compile warning of no format arguments in ifenslave.c

Shiraz Hashim (1):
      stmmac: add memory barriers at appropriate places

Shirley Ma (5):
      sock.h: Add a new sock zero-copy flag
      skbuff: skb supports zero-copy buffers
      macvtap: macvtapTX zero-copy support
      skbuff: clear tx zero-copy flag
      vhost: handle wrap around in # of bufs math

Shmulik Ravid (3):
      dcbnl: Aggregated CEE GET operation
      dcbnl: Add CEE notification
      bnx2x: Add dcbnl notification

Shreyas Bhatewara (2):
      vmxnet3: set netdev parant device before calling netdev_info
      vmxnet3: fix publicity of NETIF_F_HIGHDMA

Shyam Iyer (1):
      Separate handling of irq type flags variable from the irq_flags request_irq variable

Somnath Kotur (1):
      be2net: Fallback to the older opcode if MCC_CREATE_EXT opcode is not supported on the card

Srinivas Kandagatla (1):
      stmmac: Allow SOCs to use Store forward mode eventhough tx_coe is 0. (V2)

Sritej Velaga (3):
      qlcnic: Add capability to take FW dump deterministically
      qlcnic: fix chip reset logic
      qlcnic: updated supported cards information

Stanislaw Gruszka (10):
      iwlagn: refactor iwlagn_mac_channel_switch
      iwlegacy: remove unused power commands defines
      iwlegacy: remove recover from statistics
      iwlegacy: remove reset rf infrastructure
      iwlegacy: remove firmware event log
      iwlegacy: remove unused agg_tids_count
      iwlegacy: refactor iwl4965_mac_channel_switch
      rt2x00: fix possible memory corruption in case of invalid rxdesc.size
      rt2x00: reset usb devices at probe
      iwlagn: fix rmmod crash

Stephen Boyd (1):
      Bluetooth: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning

Stephen Hemminger (1):
      ixgbevf: remove unnecessary ampersands

Stephen Rothwell (5):
      net: add needed interrupt.h
      net/staging: add needed interrupt.h and hardirq.h includes
      Bluetooth: include scatterlist.h where needed
      net: include io.h in sja1000_of_platform.c for iounmap etc
      net: include dma-mapping.h in ll_temac_main.c for dma_map_single etc

Steve Hodgson (1):
      sfc: Fix Siena mac statistics on big endian platforms

Steven.Li (1):
      Bluetooth: Add Atheros AR3012 one PID/VID supported

Sucheta Chakraborty (5):
      netxen: suppress false lro warning messages
      qlcnic: fix initial number of msix entries in adapter.
      qlcnic: multi protocol internal loopback support added.
      qlcnic: enable mac-learning in promiscous mode.
      qlcnic: fix race in skb->len access.

Sven Eckelmann (21):
      batman-adv: Use kzalloc rather than kmalloc followed by memset with 0
      batman-adv: Annotate functions with format strings
      batman-adv: Print jiffies as unsigned long
      batman-adv: Remove comparising < 0 for unsigned type
      batman-adv: Don't do pointer arithmetic with void*
      batman-adv: Add const type qualifier for pointers
      batman-adv: Only use int up and down gw representation
      batman-adv: Remove explicit casts cast from void* for store
      batman-adv: Remove casts from type x to type x
      batman-adv: Calculate sizeof using variable insead of types
      batman-adv: Use rcu_dereference_protected by update-side
      batman-adv: Check type of x and y in seq_(before|after)
      batman-adv: Ensure that we really have route changes in update_route
      batman-adv: Don't return value in void function
      batman-adv: Fix signedness problem in parse_gw_bandwidth
      batman-adv: Rewrite debugfs kobj_to_* helpers as functions
      batman-adv: Use enums for related constants
      batman-adv: Move compare_orig to originator.c
      batman-adv: Keep interface_tx as local function
      batman-adv: Reduce usage of char
      batman-adv: Replace version info instead of appending them

Thadeu Lima de Souza Cascardo (1):
      can: make function can_get_bittiming static

Thomas Graf (1):
      rtnl: provide link dump consistency info

Tobias Klauser (15):
      net: am79c961a: Omit check for multicast bit in netdev_for_each_mc_addr
      net: depca: Omit check for multicast bit in netdev_for_each_mc_addr
      net: iseries_veth: Omit check for multicast bit in netdev_for_each_mc_addr
      net: ucc_geth: Omit check for multicast bit in netdev_for_each_mc_addr
      net: de4x5: Omit check for multicast bit in netdev_for_each_mc_addr
      net: e1000e: Use is_multicast_ether_addr helper
      net: de4x5: Use helpers from linux/etherdevice.h
      net: igb: Use is_multicast_ether_addr helper
      net: iseries_veth: Use is_unicast_ether_addr helper
      net: rionet: Use is_multicast_ether_addr
      net: depca: Use helpers from linux/etherdevice.h
      net: ewrk3: Use helpers from linux/etherdevice.h
      net: vxge: Use is_multicast_ether_addr helper
      net/wireless: ipw2x00: Use helpers from linux/etherdevice.h
      drivers/net: Omit check for multicast bit in netdev_for_each_mc_addr

Uwe Kleine-K√∂nig (1):
      net/can: allow CAN_AT91 on AT91SAM9X5

Vasanthy Kolluri (5):
      enic: Pass 802.1p bits for packets tagged with vlan zero
      enic: Log device configuration in detail during driver load
      enic: Get/Set interrupt resource index for transmit and receive queues
      enic: Bug Fix: Fix hardware transmit queue indexing in enic_poll_controller
      enic: Add support to configure hardware interrupt coalesce timers in a platform independent way

Vasu Dev (1):
      ixgbe: setup per CPU PCI pool for FCoE DDP

Ville Tervo (1):
      Bluetooth: Do not send SET_EVENT_MASK for 1.1 and earlier devices

Vincent Zweije (1):
      networking: fix warning about unused label wake_up

Vinicius Costa Gomes (25):
      Bluetooth: Add support for using the crypto subsystem
      Bluetooth: Add support for LE Start Encryption
      Bluetooth: Remove debug statements
      Bluetooth: Add support for resuming socket when SMP is finished
      Bluetooth: Fix initial security level of LE links
      Bluetooth: Update the security level when link is encrypted
      Bluetooth: Add support for building pairing commands
      Bluetooth: Add support for Pairing features exchange
      Bluetooth: Add support for SMP timeout
      Bluetooth: Add key size checks for SMP
      Bluetooth: Fix crash when setting a LE socket to ready
      Bluetooth: Remove useless access to the socket
      Bluetooth: Fix not setting the chan state
      Bluetooth: Add support for SMP phase 3 (key distribution)
      Bluetooth: Add new structures for supporting SM key distribution
      Bluetooth: Add functions to manipulate the link key list for SMP
      Bluetooth: Reject an encryption request when the key isn't found
      Bluetooth: Fix SM pairing parameters negotiation
      Bluetooth: Add support for storing the LTK
      Bluetooth: Use the link key list to temporarily store the STK
      Bluetooth: Use the stored LTK for restabilishing security
      Bluetooth: Remove unused field in hci_conn
      Bluetooth: Add support for communicating keys with userspace
      Bluetooth: Add support for storing the key size
      Bluetooth: Add support for returning the encryption key size

Vitaliy Ivanov (1):
      net: wimax: Remove of unused 'rfkill_input' pointer

Vlad Zolotarov (1):
      New 7.0 FW: bnx2x, cnic, bnx2i, bnx2fc

Vladislav Zolotarov (14):
      bnx2x: Created bnx2x_sp
      bnx2x: 57712 parity handling
      bnx2x: Update date to 2011/06/13 and version to 1.70.00-0
      bnx2x: use correct dma_sync function
      bnx2x: stop tx before CNIC_STOP
      bnx2x: remove unnecessary dma_sync
      bnx2x: disable loacal BH when scheduling FCOE napi
      bnx2x: use BNX2X_Q_FLG_TPA_IPV6 for TPA queue configuration
      bnx2x: fix memory barriers
      bnx2x: Implementation for netdev->ndo_fcoe_get_wwn
      bnx2x: Fixed ethtool -d for 578xx
      bnx2x: Read FIP mac from SHMEM in single function mode
      bnx2x: Parity errors recovery for 578xx
      bnx2x: Broken self-test in SF mode on 578xx

Waldemar Rymarkiewicz (6):
      Bluetooth: Fix auth_complete_evt for legacy units
      Bluetooth: Refactor hci_auth_complete_evt function
      Bluetooth: Remove a magic number
      Bluetooth: Verify a pin code in pin_code_reply
      Bluetooth: Simplify hci_conn_accept_secure check
      Bluetooth: Clean up some code style issues

Wang Shaoyan (1):
      ATM: Delete no use FILL_RX_POOLS_IN_BH marco

Werner Almesberger (1):
      IEEE 802.15.4: do not enable driver debugging by default

Wey-Yi Guy (52):
      nl80211: add testmode dump support
      iwlagn: send tx power command if defer cause by RXON not match
      iwlagn: remove un-necessary tx power ops
      iwlagn: change the logging level for aggregation enable check
      iwlagn: change log to better represent the state of aggregation process
      iwlagn: save the latest smps mode
      iwlagn: set smps mode after assoc for 1000 device
      iwlagn: move all post scan functions in one place
      iwlagn: direct call to post_scan function
      iwlagn: call commit_rxon function directly
      iwlagn: usersapce application decide the size of trace buffer
      iwlagn: add dumpit support for testmode trace function
      iwlagn: move bt_coex_active as part of iwlagn_mod_params
      iwlagn: move led_mode as part of iwlagn_mod_params
      iwlagn: move no_sleep_autoadjust as part of iwlagn_mod_params
      iwlagn: Band capabilities in EEPROM
      iwlagn: use sku capabilities information from EEPROM
      iwlagn: add coex debug flag
      iwlagn: add debug message for coex related activities
      iwlagn: use IWL_DEBUG_TEMP for temperature related debug
      iwlagn: use IWL_DEBUG_FW for firmware related debug msg
      iwlagn: remove unused debug flag
      iwlagn: generic temperature location in EEPROM
      iwlagn: group similar defines together
      iwlagn: merge duplicated code into single place
      iwlagn: Sanity check for 11n capability
      iwlagn: Sanity check for valid context
      iwlagn: Remove un-necessary indirect call
      iwlagn: add PAN to tx flush
      iwlagn: Support flush queues for specified interface
      iwlagn: move PCI power related functions to the PCI layer
      iwlagn: add power_save module parameter
      iwlagn: Add power_level module parameter
      iwlagn: add offset define for subsystem id
      iwlagn: code alignment
      iwlagn: merge duplicate code into single function
      iwlagn: remove incorrect define
      iwlagn: re-define the testmode cmd and attr enum
      iwlagn: add correct firmware name for 135 series
      iwlagn: add module parameter to disable stuck queue watchdog timer
      iwlagn: scd memory boundary
      iwlagn: call bt_coex directlly
      iwlagn: remove hcmd ops
      iwlagn: remove the indirection for the dma channel num
      iwlagn: remove double level temperature indirect call
      iwlagn: use bt handler for 2030 and 135 series devices
      iwlagn: declare static
      iwlagn: add CMD_ON_DEMAND flag for host command from testmode
      iwlagn: allow application own the uCode operation
      iwlagn: block regular host commands if driver don't own uCode
      iwlagn: separate and enhance the fixed rate from
      iwlagn: fix warning in testmode attribute table

Williams, Mitch A (1):
      igbvf: update version number

YOSHIFUJI Hideaki (1):
      sctp: Allow regular C expression in 4th argument for SCTP_DEBUG_PRINTK_IPADDR macro.

Yaniv Rosner (27):
      bnx2x: Add new phy BCM8722
      bnx2x: Fix port type display
      bnx2x: Change return status type
      bnx2x: Add TX fault check for fiber PHYs
      bnx2x: Fix over current port display
      bnx2x: Fix BCM84833 settings
      bnx2x: Fix grammar and relocate code
      bnx2x: Adjust BCM8726 module detection settings
      bnx2x: Fix link status sync
      bnx2x: Modify XGXS functions
      bnx2x: Improve cl45 access methods
      bnx2x: do not call link update without HW notification
      bnx2x: Add new MAC support for 578xx
      bnx2x: Add Warpcore support for 578xx
      bnx2x: Add new PHY 54616s
      bnx2x: Adjust ETS to 578xx
      bnx2x: Adjust BCM84833 to BCM578xx
      bnx2x: Add a periodic task for link PHY events
      bnx2x: Rename LASI registers to definitions in mdio.h
      bnx2x: PFC fixes
      bnx2x: Change BCM54616S to BCM54618SE
      bnx2x: Add CL37 BAM for Warpcore
      bnx2x: Reset PHY due to fan failure for 578xx
      bnx2x: Fix false link indication at link partner when DAC is used
      bnx2x: Fix BCM84833 initialization
      bnx2x: Add autogrEEEn support
      bnx2x: Fix warning message during 57712/8727 initialization

Yogesh Ashok Powar (7):
      mwifiex: remove list traversal in mwifiex_num_pkts_in_txq
      mwifiex: Remove redundant skb_queue_empty checks
      mwifiex: adding check for enough space before padding
      mwifiex: disable transmission buffer aggregation for AMSDU packets
      mac80211: Skip tailroom reservation for full HW-crypto devices with race fix
      mwifiex: 4-byte alignment in mwifiex_process_sta_txpd()
      mwifiex: add cfg80211 handler for set_bitrate_mask

Yoshihiro Shimoda (1):
      net: sh_eth: remove __flush_purge_region

Zefir Kurtisi (1):
      minstrel_ht: fixed rate mode through debugfs

fran√ßois romieu (1):
      8139cp: convert to new VLAN model.

jamal (1):
      net_sched: fix dequeuer fairness

stephen hemminger (24):
      iph: use default get_stats
      ipv6: generate link local address for GRE tunnel
      vmxnet3: convert to 64 bit stats interface
      veth: convert to 64 bit statistics
      netxen: convert to 64 bit statistics
      enic: update to support 64 bit stats
      myricom: update to 64 bit stats
      niu: support 64 bit stats interface
      tun: reserves space for network in skb
      tun: dont force inline of functions
      ifb: convert to 64 bit stats
      vxge: fix 64 bit access on 32 bit platforms
      xen: convert to 64 bit stats interface
      bonding: add min links parameter to 802.3ad
      virtio-net: per cpu 64 bit stats (v2)
      skge: cleanup pci id table
      add pci-id for DGE-530T
      skge: make support for old Genesis chips optional
      skge: update version
      sky2: force receive checksum when using RSS on some hardware (v2)
      sky2: use correct Inter Packet Gap at 10/100mbit
      sky2: support for new Optima chipsets (EXPERIMENTAL)
      sky2: version 1.29
      skge/sky2: change config references to Marvell

 Documentation/DocBook/80211.tmpl                   |    5 +-
 Documentation/networking/ifenslave.c               |   18 +-
 Documentation/networking/ip-sysctl.txt             |   29 +-
 Documentation/networking/netdev-features.txt       |  154 +
 Documentation/networking/nfc.txt                   |  128 +
 Documentation/networking/stmmac.txt                |  200 +-
 MAINTAINERS                                        |    2 +-
 arch/arm/mach-davinci/board-mityomapl138.c         |    1 +
 arch/arm/mach-davinci/dm646x.c                     |    1 +
 arch/arm/mach-davinci/pm.c                         |    1 +
 arch/arm/mach-imx/dma-v1.c                         |    1 +
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    1 +
 arch/arm/mach-iop13xx/setup.c                      |    1 +
 arch/arm/mach-mxs/devices/platform-auart.c         |    1 +
 arch/arm/mach-mxs/devices/platform-dma.c           |    1 +
 arch/arm/mach-mxs/devices/platform-fec.c           |    1 +
 arch/arm/plat-mxc/devices/platform-fec.c           |    1 +
 arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c  |    1 +
 arch/arm/plat-mxc/devices/platform-imx-fb.c        |    1 +
 arch/arm/plat-mxc/devices/platform-ipu-core.c      |    1 +
 arch/arm/plat-mxc/devices/platform-mxc-ehci.c      |    1 +
 arch/arm/plat-mxc/devices/platform-mxc-mmc.c       |    1 +
 arch/arm/plat-nomadik/include/plat/ste_dma40.h     |    1 +
 arch/m68k/emu/nfeth.c                              |    2 +-
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/Makefile                              |    3 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   40 +
 arch/powerpc/net/Makefile                          |    4 +
 arch/powerpc/net/bpf_jit.h                         |  227 +
 arch/powerpc/net/bpf_jit_64.S                      |  138 +
 arch/powerpc/net/bpf_jit_comp.c                    |  694 ++
 arch/x86/kernel/tboot.c                            |    1 +
 crypto/async_tx/raid6test.c                        |    1 +
 drivers/Kconfig                                    |    2 -
 drivers/Makefile                                   |    1 +
 drivers/atm/ambassador.c                           |   11 +-
 drivers/atm/ambassador.h                           |    4 -
 drivers/atm/eni.h                                  |    1 +
 drivers/atm/firestream.c                           |    1 +
 drivers/atm/horizon.c                              |    1 +
 drivers/atm/idt77252.c                             |    1 +
 drivers/atm/iphase.c                               |    1 +
 drivers/atm/lanai.c                                |    9 +-
 drivers/atm/zatm.c                                 |    1 +
 drivers/bcma/Kconfig                               |   11 +
 drivers/bcma/Makefile                              |    3 +-
 drivers/bcma/bcma_private.h                        |   11 +-
 drivers/bcma/core.c                                |    3 +-
 drivers/bcma/driver_chipcommon_pmu.c               |    6 +-
 drivers/bcma/driver_pci.c                          |   62 +-
 drivers/bcma/driver_pci_host.c                     |   14 +
 drivers/bcma/host_pci.c                            |   53 +
 drivers/bcma/main.c                                |   14 +-
 drivers/bcma/sprom.c                               |  165 +
 drivers/bluetooth/ath3k.c                          |    5 +
 drivers/bluetooth/btusb.c                          |   12 +-
 drivers/char/random.c                              |   15 +
 drivers/dma/coh901318.c                            |    1 +
 drivers/dma/dmaengine.c                            |    1 +
 drivers/dma/dmatest.c                              |    1 +
 drivers/dma/ipu/ipu_idmac.c                        |    1 +
 drivers/dma/ste_dma40.c                            |    1 +
 drivers/firewire/net.c                             |    6 +-
 drivers/ieee802154/Makefile                        |    2 -
 drivers/ieee802154/fakehard.c                      |    2 -
 drivers/infiniband/core/addr.c                     |    7 +-
 drivers/infiniband/core/netlink.c                  |    2 +-
 drivers/infiniband/hw/amso1100/c2.c                |    1 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |   12 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   42 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |   19 +-
 drivers/infiniband/hw/nes/nes_hw.h                 |    4 -
 drivers/infiniband/hw/nes/nes_nic.c                |   50 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   41 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   20 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |    1 +
 drivers/isdn/hardware/mISDN/avmfritz.c             |    1 +
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    1 +
 drivers/isdn/hardware/mISDN/hfcpci.c               |    1 +
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |    1 +
 drivers/isdn/hardware/mISDN/mISDNipac.c            |    1 +
 drivers/isdn/hardware/mISDN/netjet.c               |    1 +
 drivers/isdn/hardware/mISDN/speedfax.c             |    1 +
 drivers/isdn/hardware/mISDN/w6692.c                |    1 +
 drivers/isdn/hisax/hisax.h                         |    1 +
 drivers/isdn/hisax/hisax_fcpcipnp.c                |    1 +
 drivers/isdn/i4l/isdn_net.c                        |    5 +-
 drivers/media/dvb/b2c2/flexcop-common.h            |    1 +
 drivers/media/dvb/dm1105/dm1105.c                  |    1 +
 drivers/media/dvb/mantis/mantis_ca.c               |    1 +
 drivers/media/dvb/mantis/mantis_common.h           |    1 +
 drivers/media/dvb/mantis/mantis_evm.c              |    1 +
 drivers/media/dvb/mantis/mantis_hif.c              |    1 +
 drivers/media/dvb/mantis/mantis_ioc.c              |    1 +
 drivers/media/dvb/mantis/mantis_pcmcia.c           |    1 +
 drivers/media/dvb/mantis/mantis_uart.c             |    1 +
 drivers/media/dvb/mantis/mantis_vp1034.c           |    1 +
 drivers/media/dvb/pluto2/pluto2.c                  |    1 +
 drivers/mmc/host/tmio_mmc_dma.c                    |    1 +
 drivers/mtd/nand/atmel_nand.c                      |    1 +
 drivers/net/3c503.c                                |    1 +
 drivers/net/7990.c                                 |    9 +-
 drivers/net/8139cp.c                               |   84 +-
 drivers/net/8139too.c                              |    1 +
 drivers/net/8390.h                                 |    1 +
 drivers/net/Kconfig                                |   43 +-
 drivers/net/Makefile                               |    3 +-
 drivers/net/a2065.c                                |  356 +-
 drivers/net/ac3200.c                               |    1 +
 drivers/net/acenic.c                               |   66 +-
 drivers/net/acenic.h                               |    8 +-
 drivers/net/amd8111e.c                             |   37 +-
 drivers/net/amd8111e.h                             |    3 -
 drivers/net/apne.c                                 |    1 +
 drivers/net/appletalk/ltpc.c                       |    8 +-
 drivers/net/arcnet/arc-rimi.c                      |    1 +
 drivers/net/arcnet/com20020-isa.c                  |    1 +
 drivers/net/arcnet/com20020-pci.c                  |    1 +
 drivers/net/arcnet/com20020.c                      |    1 +
 drivers/net/arcnet/com90io.c                       |    1 +
 drivers/net/arcnet/com90xx.c                       |    1 +
 drivers/net/ariadne.c                              | 1267 ++--
 drivers/net/arm/am79c961a.c                        |   14 +-
 drivers/net/arm/at91_ether.c                       |    1 +
 drivers/net/arm/ep93xx_eth.c                       |    1 +
 drivers/net/arm/ks8695net.c                        |    2 +
 drivers/net/atl1c/atl1c.h                          |    3 +-
 drivers/net/atl1c/atl1c_main.c                     |   74 +-
 drivers/net/atl1e/atl1e.h                          |    3 +-
 drivers/net/atl1e/atl1e_main.c                     |   84 +-
 drivers/net/atlx/atl1.c                            |   21 +-
 drivers/net/atlx/atl1.h                            |    1 -
 drivers/net/atlx/atl2.c                            |   81 +-
 drivers/net/atlx/atl2.h                            |    3 -
 drivers/net/atlx/atlx.c                            |   57 +-
 drivers/net/b44.c                                  |   21 +-
 drivers/net/bcm63xx_enet.c                         |    1 +
 drivers/net/benet/be.h                             |   16 +-
 drivers/net/benet/be_cmds.c                        |  142 +-
 drivers/net/benet/be_cmds.h                        |   29 +-
 drivers/net/benet/be_ethtool.c                     |   55 +-
 drivers/net/benet/be_main.c                        |  430 +-
 drivers/net/bmac.c                                 |    9 +-
 drivers/net/bna/bfa_cee.c                          |    2 +-
 drivers/net/bna/bnad.c                             |   67 +-
 drivers/net/bna/bnad.h                             |    3 +-
 drivers/net/bna/cna.h                              |    3 +-
 drivers/net/bnx2.c                                 |   97 +-
 drivers/net/bnx2.h                                 |   15 +
 drivers/net/bnx2x/Makefile                         |    2 +-
 drivers/net/bnx2x/bnx2x.h                          | 1105 ++--
 drivers/net/bnx2x/bnx2x_cmn.c                      | 1497 +++--
 drivers/net/bnx2x/bnx2x_cmn.h                      |  675 ++-
 drivers/net/bnx2x/bnx2x_dcb.c                      |  851 ++-
 drivers/net/bnx2x/bnx2x_dcb.h                      |   30 +-
 drivers/net/bnx2x/bnx2x_dump.h                     | 1721 ++++--
 drivers/net/bnx2x/bnx2x_ethtool.c                  |  698 ++-
 drivers/net/bnx2x/bnx2x_fw_defs.h                  |  519 +-
 drivers/net/bnx2x/bnx2x_hsi.h                      | 5489 ++++++++++------
 drivers/net/bnx2x/bnx2x_init.h                     |  409 +-
 drivers/net/bnx2x/bnx2x_init_ops.h                 |  194 +-
 drivers/net/bnx2x/bnx2x_link.c                     | 6671 ++++++++++++++++----
 drivers/net/bnx2x/bnx2x_link.h                     |  183 +-
 drivers/net/bnx2x/bnx2x_main.c                     | 6227 +++++++++++--------
 drivers/net/bnx2x/bnx2x_reg.h                      |  957 +++-
 drivers/net/bnx2x/bnx2x_sp.c                       | 5692 +++++++++++++++++
 drivers/net/bnx2x/bnx2x_sp.h                       | 1297 ++++
 drivers/net/bnx2x/bnx2x_stats.c                    |  908 ++--
 drivers/net/bnx2x/bnx2x_stats.h                    |  228 +-
 drivers/net/bonding/bond_3ad.c                     |   53 +-
 drivers/net/bonding/bond_3ad.h                     |    8 +-
 drivers/net/bonding/bond_alb.c                     |    4 +-
 drivers/net/bonding/bond_ipv6.c                    |    8 +-
 drivers/net/bonding/bond_main.c                    |  127 +-
 drivers/net/bonding/bond_procfs.c                  |    1 +
 drivers/net/bonding/bond_sysfs.c                   |   34 +
 drivers/net/bonding/bonding.h                      |    8 +-
 drivers/net/caif/Kconfig                           |    9 +
 drivers/net/caif/Makefile                          |    3 +
 drivers/net/caif/caif_hsi.c                        | 1219 ++++
 drivers/net/caif/caif_serial.c                     |    2 +-
 drivers/net/caif/caif_shm_u5500.c                  |    1 -
 drivers/net/caif/caif_shmcore.c                    |    2 +-
 drivers/net/caif/caif_spi.c                        |    1 -
 drivers/net/caif/caif_spi_slave.c                  |    1 -
 drivers/net/can/Kconfig                            |    8 +-
 drivers/net/can/at91_can.c                         |  366 +-
 drivers/net/can/bfin_can.c                         |  137 +-
 drivers/net/can/c_can/c_can.c                      |    1 -
 drivers/net/can/c_can/c_can_platform.c             |    1 -
 drivers/net/can/dev.c                              |    2 +-
 drivers/net/can/janz-ican3.c                       |    1 +
 drivers/net/can/sja1000/sja1000.h                  |    1 +
 drivers/net/can/sja1000/sja1000_of_platform.c      |    1 +
 drivers/net/can/slcan.c                            |   63 +-
 drivers/net/can/softing/softing_fw.c               |    1 +
 drivers/net/can/softing/softing_main.c             |    2 +-
 drivers/net/cassini.c                              |    1 +
 drivers/net/chelsio/common.h                       |    2 -
 drivers/net/chelsio/cxgb2.c                        |   39 +-
 drivers/net/chelsio/sge.c                          |   18 +-
 drivers/net/chelsio/sge.h                          |    2 +-
 drivers/net/cnic.c                                 |  412 +-
 drivers/net/cnic.h                                 |   52 +-
 drivers/net/cnic_defs.h                            | 6488 +++++++++++--------
 drivers/net/cnic_if.h                              |   15 +-
 drivers/net/cpmac.c                                |    1 +
 drivers/net/cxgb3/adapter.h                        |    2 -
 drivers/net/cxgb3/common.h                         |    1 -
 drivers/net/cxgb3/cxgb3_main.c                     |   51 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |   19 +-
 drivers/net/cxgb3/sge.c                            |   35 +-
 drivers/net/cxgb3/t3_hw.c                          |   11 +-
 drivers/net/cxgb4/cxgb4.h                          |    1 -
 drivers/net/cxgb4/cxgb4_main.c                     |    2 +-
 drivers/net/cxgb4vf/adapter.h                      |    2 +-
 drivers/net/cxgb4vf/cxgb4vf_main.c                 |   68 +-
 drivers/net/cxgb4vf/sge.c                          |   34 +-
 drivers/net/cxgb4vf/t4vf_hw.c                      |    1 -
 drivers/net/davinci_cpdma.c                        |    2 +-
 drivers/net/davinci_emac.c                         |    7 +-
 drivers/net/declance.c                             |   47 +-
 drivers/net/depca.c                                |   31 +-
 drivers/net/dl2k.c                                 |    4 +-
 drivers/net/dm9000.c                               |   27 +-
 drivers/net/dnet.c                                 |    3 +
 drivers/net/e100.c                                 |    2 +
 drivers/net/e1000/e1000.h                          |    2 +-
 drivers/net/e1000/e1000_ethtool.c                  |   69 -
 drivers/net/e1000/e1000_hw.c                       |    7 +-
 drivers/net/e1000/e1000_main.c                     |  203 +-
 drivers/net/e1000e/82571.c                         |    5 +-
 drivers/net/e1000e/e1000.h                         |   51 +-
 drivers/net/e1000e/es2lan.c                        |    8 +
 drivers/net/e1000e/ethtool.c                       |    1 +
 drivers/net/e1000e/hw.h                            |   21 +-
 drivers/net/e1000e/ich8lan.c                       |  191 +-
 drivers/net/e1000e/lib.c                           |    4 +-
 drivers/net/e1000e/netdev.c                        |  171 +-
 drivers/net/e1000e/phy.c                           |  352 +-
 drivers/net/e2100.c                                |    1 +
 drivers/net/ehea/ehea.h                            |    1 -
 drivers/net/ehea/ehea_main.c                       |   54 +-
 drivers/net/ehea/ehea_qmr.c                        |    2 +-
 drivers/net/enic/enic.h                            |    4 +-
 drivers/net/enic/enic_dev.c                        |   11 +
 drivers/net/enic/enic_dev.h                        |    1 +
 drivers/net/enic/enic_main.c                       |  153 +-
 drivers/net/enic/enic_res.c                        |   30 +-
 drivers/net/enic/vnic_cq.c                         |    2 +
 drivers/net/enic/vnic_cq.h                         |    1 +
 drivers/net/enic/vnic_dev.c                        |   60 +
 drivers/net/enic/vnic_dev.h                        |    5 +
 drivers/net/enic/vnic_devcmd.h                     |   19 +
 drivers/net/enic/vnic_enet.h                       |   11 +-
 drivers/net/enic/vnic_intr.c                       |    7 +-
 drivers/net/enic/vnic_intr.h                       |    6 +-
 drivers/net/epic100.c                              |    4 +-
 drivers/net/es3210.c                               |    1 +
 drivers/net/ethoc.c                                |    3 +
 drivers/net/ewrk3.c                                |   39 +-
 drivers/net/fealnx.c                               |    4 +-
 drivers/net/fec.c                                  |    9 +-
 drivers/net/fec_mpc52xx.c                          |    6 +-
 drivers/net/forcedeth.c                            |   68 +-
 drivers/net/fs_enet/fs_enet-main.c                 |    2 +
 drivers/net/ftgmac100.c                            | 1365 ++++
 drivers/net/ftgmac100.h                            |  246 +
 drivers/net/gianfar.c                              |  182 +-
 drivers/net/gianfar.h                              |   57 +-
 drivers/net/gianfar_ethtool.c                      |  958 +++-
 drivers/net/greth.c                                |    2 +
 drivers/net/hamachi.c                              |    4 +-
 drivers/net/hamradio/baycom_ser_fdx.c              |    1 +
 drivers/net/hamradio/baycom_ser_hdx.c              |    1 +
 drivers/net/hp-plus.c                              |    1 +
 drivers/net/hp.c                                   |    1 +
 drivers/net/hp100.c                                |   18 +-
 drivers/net/ibmveth.c                              |    1 +
 drivers/net/ifb.c                                  |   57 +-
 drivers/net/igb/Makefile                           |    2 +-
 drivers/net/igb/e1000_82575.c                      |   22 +-
 drivers/net/igb/e1000_82575.h                      |    4 +-
 drivers/net/igb/e1000_defines.h                    |   17 +-
 drivers/net/igb/e1000_hw.h                         |    2 +-
 drivers/net/igb/e1000_mac.c                        |    5 +-
 drivers/net/igb/e1000_mac.h                        |    2 +-
 drivers/net/igb/e1000_mbx.c                        |    2 +-
 drivers/net/igb/e1000_mbx.h                        |    2 +-
 drivers/net/igb/e1000_nvm.c                        |    2 +-
 drivers/net/igb/e1000_nvm.h                        |    2 +-
 drivers/net/igb/e1000_phy.c                        |    2 +-
 drivers/net/igb/e1000_phy.h                        |    2 +-
 drivers/net/igb/e1000_regs.h                       |    2 +-
 drivers/net/igb/igb.h                              |    6 +-
 drivers/net/igb/igb_ethtool.c                      |  102 +-
 drivers/net/igb/igb_main.c                         |  128 +-
 drivers/net/igbvf/igbvf.h                          |    4 +-
 drivers/net/igbvf/netdev.c                         |   46 +-
 drivers/net/ioc3-eth.c                             |    9 +-
 drivers/net/ipg.c                                  |    1 +
 drivers/net/irda/ali-ircc.c                        |    1 +
 drivers/net/irda/donauboe.c                        |    1 +
 drivers/net/irda/nsc-ircc.c                        |    1 +
 drivers/net/irda/pxaficp_ir.c                      |    2 +
 drivers/net/irda/sir_dev.c                         |    1 +
 drivers/net/irda/smsc-ircc2.c                      |    3 +-
 drivers/net/irda/via-ircc.c                        |    1 +
 drivers/net/irda/via-ircc.h                        |    2 +-
 drivers/net/irda/vlsi_ir.c                         |    1 +
 drivers/net/irda/w83977af_ir.c                     |    1 +
 drivers/net/iseries_veth.c                         |   14 +-
 drivers/net/ixgbe/ixgbe.h                          |  102 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |   43 +
 drivers/net/ixgbe/ixgbe_82599.c                    |  645 +-
 drivers/net/ixgbe/ixgbe_common.c                   |  244 +-
 drivers/net/ixgbe/ixgbe_common.h                   |    5 +
 drivers/net/ixgbe/ixgbe_dcb.c                      |   10 +-
 drivers/net/ixgbe/ixgbe_dcb.h                      |    7 -
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |   43 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.h                |    3 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |  119 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.h                |   14 +-
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |  129 +-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  589 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |  279 +-
 drivers/net/ixgbe/ixgbe_fcoe.h                     |   12 +-
 drivers/net/ixgbe/ixgbe_main.c                     | 1354 ++--
 drivers/net/ixgbe/ixgbe_sriov.c                    |   16 +
 drivers/net/ixgbe/ixgbe_type.h                     |   99 +-
 drivers/net/ixgbe/ixgbe_x540.c                     |    2 +
 drivers/net/ixgbevf/ixgbevf.h                      |    8 +-
 drivers/net/ixgbevf/ixgbevf_main.c                 |   88 +-
 drivers/net/ixp2000/ixpdev.c                       |    1 +
 drivers/net/jme.c                                  |   73 +-
 drivers/net/jme.h                                  |    7 +-
 drivers/net/korina.c                               |    7 +-
 drivers/net/ks8842.c                               |    1 +
 drivers/net/ks8851.c                               |    1 +
 drivers/net/ks8851_mll.c                           |    4 +-
 drivers/net/ksz884x.c                              |    3 +-
 drivers/net/lib8390.c                              |  290 +-
 drivers/net/ll_temac_main.c                        |    7 +-
 drivers/net/lne390.c                               |    1 +
 drivers/net/macb.c                                 |    3 +
 drivers/net/mace.c                                 |    1 +
 drivers/net/macmace.c                              |    2 +-
 drivers/net/macvlan.c                              |   27 +-
 drivers/net/macvtap.c                              |  134 +-
 drivers/net/mipsnet.c                              |    1 +
 drivers/net/mlx4/en_netdev.c                       |   49 +-
 drivers/net/mlx4/en_port.c                         |   23 +-
 drivers/net/mlx4/en_rx.c                           |   26 +-
 drivers/net/mlx4/en_tx.c                           |    5 +-
 drivers/net/mlx4/main.c                            |    4 +-
 drivers/net/mlx4/mlx4_en.h                         |    6 +-
 drivers/net/mlx4/reset.c                           |    2 +-
 drivers/net/mv643xx_eth.c                          |    8 +-
 drivers/net/myri10ge/myri10ge.c                    |  268 +-
 drivers/net/myri10ge/myri10ge_mcp_gen_header.h     |    2 +
 drivers/net/myri_sbus.c                            | 1187 ----
 drivers/net/myri_sbus.h                            |  311 -
 drivers/net/netx-eth.c                             |    1 +
 drivers/net/netxen/netxen_nic.h                    |    5 +-
 drivers/net/netxen/netxen_nic_ctx.c                |   16 +-
 drivers/net/netxen/netxen_nic_hw.c                 |    6 +
 drivers/net/netxen/netxen_nic_init.c               |   74 +-
 drivers/net/netxen/netxen_nic_main.c               |   13 +-
 drivers/net/niu.c                                  |   39 +-
 drivers/net/ns83820.c                              |   34 +-
 drivers/net/octeon/octeon_mgmt.c                   |    1 +
 drivers/net/pcnet32.c                              |    9 +-
 drivers/net/phy/icplus.c                           |    6 +-
 drivers/net/plip.c                                 |    6 +-
 drivers/net/ppp_async.c                            |    1 +
 drivers/net/ppp_synctty.c                          |    1 +
 drivers/net/pptp.c                                 |    1 -
 drivers/net/ps3_gelic_net.c                        |   44 +-
 drivers/net/ps3_gelic_net.h                        |    1 -
 drivers/net/pxa168_eth.c                           |    5 +-
 drivers/net/qla3xxx.c                              |    5 +-
 drivers/net/qlcnic/qlcnic.h                        |   46 +-
 drivers/net/qlcnic/qlcnic_ctx.c                    |   37 +-
 drivers/net/qlcnic/qlcnic_ethtool.c                |  163 +-
 drivers/net/qlcnic/qlcnic_hw.c                     |   74 +-
 drivers/net/qlcnic/qlcnic_init.c                   |  133 +-
 drivers/net/qlcnic/qlcnic_main.c                   |   78 +-
 drivers/net/qlge/qlge.h                            |    4 +-
 drivers/net/qlge/qlge_ethtool.c                    |    2 -
 drivers/net/qlge/qlge_main.c                       |  167 +-
 drivers/net/r6040.c                                |    3 +
 drivers/net/r8169.c                                |  628 ++-
 drivers/net/rionet.c                               |    2 +-
 drivers/net/s2io.c                                 |   90 +-
 drivers/net/s2io.h                                 |    1 -
 drivers/net/sc92031.c                              |    1 +
 drivers/net/sfc/Kconfig                            |    7 +-
 drivers/net/sfc/efx.c                              |   60 +-
 drivers/net/sfc/enum.h                             |    3 +-
 drivers/net/sfc/ethtool.c                          |   27 +-
 drivers/net/sfc/falcon.c                           |   51 +-
 drivers/net/sfc/filter.c                           |   47 +-
 drivers/net/sfc/net_driver.h                       |   12 +-
 drivers/net/sfc/nic.c                              |    1 +
 drivers/net/sfc/siena.c                            |   49 +-
 drivers/net/sgiseeq.c                              |    1 +
 drivers/net/sh_eth.c                               |   12 +-
 drivers/net/sis190.c                               |    1 +
 drivers/net/sis900.c                               |    4 +-
 drivers/net/skge.c                                 |  103 +-
 drivers/net/skge.h                                 |    1 +
 drivers/net/sky2.c                                 |  165 +-
 drivers/net/sky2.h                                 |   16 +-
 drivers/net/slhc.c                                 |    2 +-
 drivers/net/slip.c                                 |   35 +-
 drivers/net/slip.h                                 |    1 -
 drivers/net/smc-mca.c                              |    1 +
 drivers/net/smc-ultra.c                            |    1 +
 drivers/net/smc911x.c                              |    5 -
 drivers/net/smc9194.c                              |    5 -
 drivers/net/smc91x.c                               |    5 -
 drivers/net/smsc911x.c                             |    2 +
 drivers/net/smsc9420.c                             |    3 +
 drivers/net/spider_net.c                           |    5 +-
 drivers/net/starfire.c                             |   90 +-
 drivers/net/stmmac/dwmac1000_core.c                |    1 +
 drivers/net/stmmac/dwmac1000_dma.c                 |    1 +
 drivers/net/stmmac/dwmac100_core.c                 |    1 +
 drivers/net/stmmac/dwmac100_dma.c                  |    1 +
 drivers/net/stmmac/stmmac.h                        |   11 +-
 drivers/net/stmmac/stmmac_ethtool.c                |    2 +
 drivers/net/stmmac/stmmac_main.c                   |  192 +-
 drivers/net/stmmac/stmmac_mdio.c                   |   84 +-
 drivers/net/sunbmac.c                              |    8 +-
 drivers/net/sungem.c                               |  898 ++--
 drivers/net/sungem.h                               |   25 -
 drivers/net/sunhme.c                               |   16 +-
 drivers/net/sunlance.c                             |    8 +-
 drivers/net/sunqe.c                                |    7 +-
 drivers/net/tehuti.c                               |   37 +-
 drivers/net/tehuti.h                               |    1 -
 drivers/net/tg3.c                                  |  788 ++-
 drivers/net/tg3.h                                  |   30 +-
 drivers/net/tlan.c                                 |    2 +
 drivers/net/tokenring/3c359.c                      |    6 +-
 drivers/net/tokenring/ibmtr.c                      |    3 +-
 drivers/net/tokenring/madgemc.c                    |    2 +-
 drivers/net/tsi108_eth.c                           |    1 +
 drivers/net/tulip/de2104x.c                        |    1 +
 drivers/net/tulip/de4x5.c                          |   12 +-
 drivers/net/tulip/pnic.c                           |    1 +
 drivers/net/tulip/tulip_core.c                     |    1 +
 drivers/net/tun.c                                  |   32 +-
 drivers/net/typhoon.c                              |    2 +-
 drivers/net/ucc_geth.c                             |    7 +-
 drivers/net/usb/asix.c                             |    4 +
 drivers/net/usb/cdc-phonet.c                       |    1 +
 drivers/net/usb/cdc_ncm.c                          |    1 -
 drivers/net/usb/ipheth.c                           |   15 +-
 drivers/net/usb/kalmia.c                           |   12 +-
 drivers/net/veth.c                                 |   73 +-
 drivers/net/via-velocity.c                         |   51 +-
 drivers/net/via-velocity.h                         |    2 +-
 drivers/net/virtio_net.c                           |   79 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  120 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   53 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |    8 +-
 drivers/net/vxge/vxge-config.c                     |   57 +-
 drivers/net/vxge/vxge-config.h                     |    2 +
 drivers/net/vxge/vxge-main.c                       |  159 +-
 drivers/net/vxge/vxge-main.h                       |   53 +-
 drivers/net/vxge/vxge-traffic.c                    |    6 +-
 drivers/net/wan/c101.c                             |   30 +-
 drivers/net/wan/cosa.c                             |  226 +-
 drivers/net/wan/cycx_drv.c                         |   81 +-
 drivers/net/wan/cycx_main.c                        |   32 +-
 drivers/net/wan/cycx_x25.c                         |  177 +-
 drivers/net/wan/dlci.c                             |   22 +-
 drivers/net/wan/dscc4.c                            |   81 +-
 drivers/net/wan/farsync.c                          |    8 +-
 drivers/net/wan/hd64570.c                          |    8 +-
 drivers/net/wan/hd64572.c                          |    8 +-
 drivers/net/wan/hdlc.c                             |   16 +-
 drivers/net/wan/hdlc_cisco.c                       |   21 +-
 drivers/net/wan/hdlc_fr.c                          |   96 +-
 drivers/net/wan/hdlc_ppp.c                         |    9 +-
 drivers/net/wan/hdlc_x25.c                         |   12 +-
 drivers/net/wan/hostess_sv11.c                     |   11 +-
 drivers/net/wan/ixp4xx_hss.c                       |   28 +-
 drivers/net/wan/lapbether.c                        |   18 +-
 drivers/net/wan/n2.c                               |   42 +-
 drivers/net/wan/pc300_drv.c                        |    4 +-
 drivers/net/wan/pc300_tty.c                        |    2 +-
 drivers/net/wan/pc300too.c                         |   36 +-
 drivers/net/wan/pci200syn.c                        |   29 +-
 drivers/net/wan/sbni.c                             |   67 +-
 drivers/net/wan/sdla.c                             |   52 +-
 drivers/net/wan/sealevel.c                         |   11 +-
 drivers/net/wan/wanxl.c                            |   93 +-
 drivers/net/wan/x25_asy.c                          |   47 +-
 drivers/net/wan/z85230.c                           |   34 +-
 drivers/net/wireless/adm8211.c                     |    1 +
 drivers/net/wireless/ath/ath.h                     |    1 +
 drivers/net/wireless/ath/ath5k/ahb.c               |    5 +-
 drivers/net/wireless/ath/ath5k/ani.c               |    9 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |  174 +-
 drivers/net/wireless/ath/ath5k/attach.c            |   24 +-
 drivers/net/wireless/ath/ath5k/base.c              |   87 +-
 drivers/net/wireless/ath/ath5k/base.h              |   11 +-
 drivers/net/wireless/ath/ath5k/caps.c              |    4 +-
 drivers/net/wireless/ath/ath5k/debug.c             |  207 +-
 drivers/net/wireless/ath/ath5k/desc.h              |    4 +-
 drivers/net/wireless/ath/ath5k/dma.c               |    8 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |   46 +-
 drivers/net/wireless/ath/ath5k/eeprom.h            |   12 +-
 drivers/net/wireless/ath/ath5k/initvals.c          |   14 +-
 drivers/net/wireless/ath/ath5k/led.c               |    8 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   10 +-
 drivers/net/wireless/ath/ath5k/pci.c               |   14 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |   16 +-
 drivers/net/wireless/ath/ath5k/phy.c               |  100 +-
 drivers/net/wireless/ath/ath5k/reg.h               |   89 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   49 +-
 drivers/net/wireless/ath/ath5k/rfbuffer.h          |    4 +-
 drivers/net/wireless/ath/ath5k/rfgain.h            |    8 +-
 drivers/net/wireless/ath/ath5k/sysfs.c             |   10 +-
 drivers/net/wireless/ath/ath5k/trace.h             |   15 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |    4 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |    5 +
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   39 -
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |    6 -
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   34 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   39 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  182 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   19 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |  131 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   41 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    9 +-
 .../net/wireless/ath/ath9k/ar9330_1p1_initvals.h   | 1147 ++++
 .../net/wireless/ath/ath9k/ar9330_1p2_initvals.h   | 1080 ++++
 drivers/net/wireless/ath/ath9k/ath9k.h             |   18 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   30 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   59 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    1 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    9 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |    5 -
 drivers/net/wireless/ath/ath9k/hw.c                |  196 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   14 +-
 drivers/net/wireless/ath/ath9k/init.c              |   14 +-
 drivers/net/wireless/ath/ath9k/mac.c               |    3 +-
 drivers/net/wireless/ath/ath9k/main.c              |  179 +-
 drivers/net/wireless/ath/ath9k/rc.c                |   56 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  147 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   21 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  346 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    3 +-
 drivers/net/wireless/ath/carl9170/fw.c             |    2 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h          |   19 +-
 drivers/net/wireless/ath/carl9170/fwdesc.h         |   18 +-
 drivers/net/wireless/ath/carl9170/hw.h             |   15 +-
 drivers/net/wireless/ath/carl9170/main.c           |   19 +-
 drivers/net/wireless/ath/carl9170/phy.c            |    6 -
 drivers/net/wireless/ath/carl9170/rx.c             |    2 +-
 drivers/net/wireless/ath/carl9170/version.h        |    6 +-
 drivers/net/wireless/ath/carl9170/wlan.h           |   25 +-
 drivers/net/wireless/atmel.c                       |    1 +
 drivers/net/wireless/b43/Kconfig                   |   32 +
 drivers/net/wireless/b43/Makefile                  |    5 +
 drivers/net/wireless/b43/b43.h                     |   56 +-
 drivers/net/wireless/b43/bus.c                     |  256 +
 drivers/net/wireless/b43/bus.h                     |   70 +
 drivers/net/wireless/b43/dma.c                     |   48 +-
 drivers/net/wireless/b43/leds.c                    |   15 +-
 drivers/net/wireless/b43/lo.c                      |    6 +-
 drivers/net/wireless/b43/main.c                    |  612 ++-
 drivers/net/wireless/b43/main.h                    |    2 +-
 drivers/net/wireless/b43/phy_a.c                   |   21 +-
 drivers/net/wireless/b43/phy_common.c              |   20 +-
 drivers/net/wireless/b43/phy_common.h              |    6 +
 drivers/net/wireless/b43/phy_g.c                   |   92 +-
 drivers/net/wireless/b43/phy_ht.c                  |  406 ++
 drivers/net/wireless/b43/phy_ht.h                  |   46 +
 drivers/net/wireless/b43/phy_lcn.c                 |   52 +
 drivers/net/wireless/b43/phy_lcn.h                 |   14 +
 drivers/net/wireless/b43/phy_lp.c                  |  135 +-
 drivers/net/wireless/b43/phy_n.c                   |  120 +-
 drivers/net/wireless/b43/pio.c                     |   10 +-
 drivers/net/wireless/b43/radio_2055.h              |    5 +
 drivers/net/wireless/b43/radio_2056.h              |    5 +
 drivers/net/wireless/b43/radio_2059.c              |  165 +
 drivers/net/wireless/b43/radio_2059.h              |   54 +
 drivers/net/wireless/b43/rfkill.c                  |    9 +-
 drivers/net/wireless/b43/sdio.c                    |   10 +-
 drivers/net/wireless/b43/sysfs.c                   |    4 +-
 drivers/net/wireless/b43/tables_lpphy.c            |   15 +-
 drivers/net/wireless/b43/tables_nphy.h             |    8 -
 drivers/net/wireless/b43/tables_phy_ht.c           |  750 +++
 drivers/net/wireless/b43/tables_phy_ht.h           |   22 +
 drivers/net/wireless/b43/tables_phy_lcn.c          |   34 +
 drivers/net/wireless/b43/tables_phy_lcn.h          |    6 +
 drivers/net/wireless/b43/wa.c                      |   24 +-
 drivers/net/wireless/b43/xmit.c                    |    5 +-
 drivers/net/wireless/b43legacy/dma.c               |   10 +-
 drivers/net/wireless/b43legacy/main.c              |   10 +-
 drivers/net/wireless/b43legacy/xmit.c              |    2 -
 drivers/net/wireless/hostap/hostap_wlan.h          |    1 +
 drivers/net/wireless/ipw2x00/ipw2100.c             |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.h             |    1 +
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    4 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c           |    1 +
 drivers/net/wireless/iwlegacy/iwl-3945.c           |    4 -
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c       |   79 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c        |    3 +
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c        |   78 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c        |    3 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c           |   10 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h       |    7 -
 drivers/net/wireless/iwlegacy/iwl-core.c           |   91 +-
 drivers/net/wireless/iwlegacy/iwl-core.h           |   17 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c        |  192 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h            |   61 +-
 drivers/net/wireless/iwlegacy/iwl-devtrace.c       |    3 -
 drivers/net/wireless/iwlegacy/iwl-devtrace.h       |   60 -
 drivers/net/wireless/iwlegacy/iwl-eeprom.c         |    1 -
 drivers/net/wireless/iwlegacy/iwl-helpers.h        |    9 +
 drivers/net/wireless/iwlegacy/iwl-rx.c             |   21 -
 drivers/net/wireless/iwlegacy/iwl-scan.c           |   92 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c       |  301 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c       |  465 +--
 drivers/net/wireless/iwlwifi/Makefile              |    2 +
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   21 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c            |   83 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |   58 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |   59 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |   15 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h       |    7 -
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c      |   20 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |  142 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h          |    7 -
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  312 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   30 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |  136 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |   20 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c          |   38 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  233 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |   67 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  884 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h             |   52 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |   38 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  150 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |  136 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |   18 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  130 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |   32 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   26 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |   34 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |    9 +
 drivers/net/wireless/iwlwifi/iwl-io.h              |    6 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |   17 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c             |  560 ++
 drivers/net/wireless/iwlwifi/iwl-pci.h             |   69 +
 drivers/net/wireless/iwlwifi/iwl-power.c           |   42 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |   19 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |   94 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |   20 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |   20 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c         |  190 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.h        |  251 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c           |  571 ++
 drivers/net/wireless/iwlwifi/iwl-trans.h           |  105 +
 drivers/net/wireless/iwlwifi/iwl-tx.c              |  311 +-
 drivers/net/wireless/iwmc3200wifi/fw.c             |    2 +-
 drivers/net/wireless/libertas/cfg.c                |    1 +
 drivers/net/wireless/libertas/cmd.c                |   47 +-
 drivers/net/wireless/libertas/cmd.h                |    2 +
 drivers/net/wireless/libertas/cmdresp.c            |    7 +-
 drivers/net/wireless/libertas/debugfs.c            |    1 +
 drivers/net/wireless/libertas/ethtool.c            |    1 +
 drivers/net/wireless/libertas/if_sdio.c            |   34 +
 drivers/net/wireless/libertas/if_spi.c             |    8 +-
 drivers/net/wireless/libertas/main.c               |   13 +-
 drivers/net/wireless/libertas/mesh.c               |    1 +
 drivers/net/wireless/libertas/rx.c                 |    1 +
 drivers/net/wireless/libertas/tx.c                 |    1 +
 drivers/net/wireless/libertas_tf/cmd.c             |    1 +
 drivers/net/wireless/libertas_tf/main.c            |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  464 ++-
 drivers/net/wireless/mac80211_hwsim.h              |  133 +
 drivers/net/wireless/mwifiex/11n.c                 |   33 +-
 drivers/net/wireless/mwifiex/11n.h                 |   14 +-
 drivers/net/wireless/mwifiex/11n_aggr.c            |   54 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |    5 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h       |    5 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |   56 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |   28 +-
 drivers/net/wireless/mwifiex/debugfs.c             |    2 +-
 drivers/net/wireless/mwifiex/decl.h                |    4 +-
 drivers/net/wireless/mwifiex/fw.h                  |   11 +
 drivers/net/wireless/mwifiex/join.c                |   23 +-
 drivers/net/wireless/mwifiex/main.c                |   36 +-
 drivers/net/wireless/mwifiex/main.h                |   29 +-
 drivers/net/wireless/mwifiex/scan.c                |    6 +-
 drivers/net/wireless/mwifiex/sdio.c                |   89 +-
 drivers/net/wireless/mwifiex/sdio.h                |    6 +-
 drivers/net/wireless/mwifiex/sta_cmd.c             |  113 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |   50 +-
 drivers/net/wireless/mwifiex/sta_rx.c              |    2 +-
 drivers/net/wireless/mwifiex/sta_tx.c              |   13 +-
 drivers/net/wireless/mwifiex/txrx.c                |    2 +-
 drivers/net/wireless/mwifiex/wmm.c                 |   30 +-
 drivers/net/wireless/mwl8k.c                       |    1 +
 drivers/net/wireless/orinoco/main.c                |    2 +-
 drivers/net/wireless/p54/p54pci.h                  |    1 +
 drivers/net/wireless/prism54/islpci_dev.c          |    1 +
 drivers/net/wireless/prism54/islpci_dev.h          |    1 +
 drivers/net/wireless/prism54/islpci_hotplug.c      |    1 +
 drivers/net/wireless/rt2x00/Kconfig                |    9 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c            |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c            |    1 +
 drivers/net/wireless/rt2x00/rt2800.h               |   16 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |  378 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    1 -
 drivers/net/wireless/rt2x00/rt2800pci.c            |    8 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |   90 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |    2 +
 drivers/net/wireless/rt2x00/rt2x00crypto.c         |    6 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   13 +
 drivers/net/wireless/rt2x00/rt2x00lib.h            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   14 +
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  113 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |    1 +
 drivers/net/wireless/rt2x00/rt61pci.c              |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c              |    1 +
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    1 +
 drivers/net/wireless/rtlwifi/Kconfig               |   15 +-
 drivers/net/wireless/rtlwifi/Makefile              |    1 +
 drivers/net/wireless/rtlwifi/base.c                |    6 +-
 drivers/net/wireless/rtlwifi/core.c                |   12 +-
 drivers/net/wireless/rtlwifi/core.h                |    2 +
 drivers/net/wireless/rtlwifi/efuse.c               |   14 +-
 drivers/net/wireless/rtlwifi/pci.c                 |  249 +-
 drivers/net/wireless/rtlwifi/pci.h                 |   12 -
 drivers/net/wireless/rtlwifi/ps.c                  |   97 +-
 drivers/net/wireless/rtlwifi/ps.h                  |    3 +-
 drivers/net/wireless/rtlwifi/rc.c                  |    2 +-
 drivers/net/wireless/rtlwifi/regd.c                |   18 -
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |    2 -
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |   12 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   21 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |   14 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |    2 +
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |   12 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |   11 -
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |    2 -
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/Makefile    |   14 +
 drivers/net/wireless/rtlwifi/rtl8192de/def.h       |  269 +
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        | 1355 ++++
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h        |  212 +
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c        |  790 +++
 drivers/net/wireless/rtlwifi/rtl8192de/fw.h        |  155 +
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        | 2329 +++++++
 drivers/net/wireless/rtlwifi/rtl8192de/hw.h        |   66 +
 drivers/net/wireless/rtlwifi/rtl8192de/led.c       |  159 +
 drivers/net/wireless/rtlwifi/rtl8192de/led.h       |   38 +
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       | 3831 +++++++++++
 drivers/net/wireless/rtlwifi/rtl8192de/phy.h       |  178 +
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h       | 1313 ++++
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |  628 ++
 drivers/net/wireless/rtlwifi/rtl8192de/rf.h        |   44 +
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c        |  423 ++
 drivers/net/wireless/rtlwifi/rtl8192de/sw.h        |   37 +
 drivers/net/wireless/rtlwifi/rtl8192de/table.c     | 1690 +++++
 drivers/net/wireless/rtlwifi/rtl8192de/table.h     |   57 +
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |  959 +++
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |  756 +++
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c        |    2 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |   26 +-
 drivers/net/wireless/rtlwifi/rtl8192se/led.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |   22 +-
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   12 +-
 drivers/net/wireless/rtlwifi/wifi.h                |   10 +-
 drivers/net/wireless/wl1251/sdio.c                 |    1 +
 drivers/net/wireless/wl1251/spi.c                  |    1 +
 drivers/net/wireless/wl12xx/Kconfig                |    2 +-
 drivers/net/wireless/wl12xx/acx.c                  |   61 +-
 drivers/net/wireless/wl12xx/acx.h                  |   20 +-
 drivers/net/wireless/wl12xx/boot.c                 |   40 +-
 drivers/net/wireless/wl12xx/cmd.c                  |  109 +-
 drivers/net/wireless/wl12xx/cmd.h                  |   62 +
 drivers/net/wireless/wl12xx/conf.h                 |   65 +-
 drivers/net/wireless/wl12xx/debugfs.c              |  153 +-
 drivers/net/wireless/wl12xx/event.c                |  101 +-
 drivers/net/wireless/wl12xx/event.h                |   29 +-
 drivers/net/wireless/wl12xx/ini.h                  |    3 +
 drivers/net/wireless/wl12xx/init.c                 |   27 +-
 drivers/net/wireless/wl12xx/io.c                   |    7 +-
 drivers/net/wireless/wl12xx/io.h                   |   15 +
 drivers/net/wireless/wl12xx/main.c                 |  793 ++-
 drivers/net/wireless/wl12xx/ps.c                   |   21 +-
 drivers/net/wireless/wl12xx/rx.c                   |   39 +-
 drivers/net/wireless/wl12xx/rx.h                   |   12 +
 drivers/net/wireless/wl12xx/scan.c                 |   90 +-
 drivers/net/wireless/wl12xx/scan.h                 |   18 +-
 drivers/net/wireless/wl12xx/sdio.c                 |   83 +-
 drivers/net/wireless/wl12xx/spi.c                  |   16 +-
 drivers/net/wireless/wl12xx/testmode.c             |    2 +-
 drivers/net/wireless/wl12xx/tx.c                   |  176 +-
 drivers/net/wireless/wl12xx/tx.h                   |   28 +-
 drivers/net/wireless/wl12xx/wl12xx.h               |   63 +-
 drivers/net/wireless/zd1211rw/zd_chip.h            |    2 +
 drivers/net/wireless/zd1211rw/zd_def.h             |    6 +
 drivers/net/wireless/zd1211rw/zd_mac.c             |  118 +-
 drivers/net/wireless/zd1211rw/zd_mac.h             |    1 +
 drivers/net/wireless/zd1211rw/zd_usb.c             |  129 +-
 drivers/net/wireless/zd1211rw/zd_usb.h             |    5 +-
 drivers/net/xen-netback/netback.c                  |    1 +
 drivers/net/xen-netfront.c                         |   69 +-
 drivers/net/xilinx_emaclite.c                      |   14 +-
 drivers/net/yellowfin.c                            |    6 +-
 drivers/net/znet.c                                 |    2 +-
 drivers/net/zorro8390.c                            |  673 +-
 drivers/nfc/Kconfig                                |   24 +-
 drivers/nfc/Makefile                               |    3 +
 drivers/nfc/pn533.c                                | 1632 +++++
 drivers/s390/net/ctcm_mpc.h                        |    1 +
 drivers/s390/net/qeth_core.h                       |    2 +-
 drivers/s390/net/qeth_core_main.c                  |    1 -
 drivers/s390/net/qeth_l3_main.c                    |  125 +-
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h              | 1162 ++--
 drivers/scsi/bnx2fc/bnx2fc.h                       |   10 +-
 drivers/scsi/bnx2fc/bnx2fc_constants.h             |  139 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c                   |    7 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   12 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |  442 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |   23 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   24 +-
 drivers/scsi/bnx2i/57xx_iscsi_constants.h          |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h                |   12 +-
 drivers/scsi/bnx2i/bnx2i.h                         |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    8 +-
 drivers/scsi/bnx2i/bnx2i_init.c                    |   21 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |    4 +-
 drivers/ssb/driver_chipcommon_pmu.c                |    4 +-
 drivers/ssb/driver_gige.c                          |   13 +-
 drivers/ssb/driver_pcicore.c                       |   10 +-
 drivers/ssb/main.c                                 |   33 +-
 drivers/ssb/pci.c                                  |    9 +-
 drivers/ssb/pcihost_wrapper.c                      |    6 +-
 drivers/ssb/scan.c                                 |    3 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    2 +
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |    2 +
 drivers/staging/et131x/et131x_netdev.c             |    1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    9 -
 drivers/staging/pohmelfs/crypto.c                  |    1 +
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    1 +
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    1 +
 drivers/staging/rtl8187se/r8180.h                  |    1 +
 drivers/staging/rtl8187se/r8180_core.c             |    1 +
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |    1 +
 drivers/staging/rtl8192e/r8192E.h                  |    1 +
 drivers/staging/rtl8192e/r8192E_core.c             |    2 +
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    1 +
 drivers/staging/wlags49_h2/wl_internal.h           |    7 -
 drivers/tty/serial/ifx6x60.c                       |    1 +
 drivers/usb/gadget/f_phonet.c                      |    1 +
 drivers/vhost/net.c                                |   91 +-
 drivers/vhost/test.c                               |    5 +
 drivers/vhost/vhost.c                              |  213 +-
 drivers/vhost/vhost.h                              |   32 +
 include/crypto/if_alg.h                            |    1 +
 include/linux/arcdevice.h                          |    1 +
 include/linux/ath9k_platform.h                     |    2 +
 include/linux/audit.h                              |    7 +
 include/linux/bcma/bcma.h                          |   26 +
 include/linux/bcma/bcma_driver_chipcommon.h        |    1 +
 include/linux/bcma/bcma_driver_pci.h               |    2 +
 include/linux/cordic.h                             |   48 +
 include/linux/crc8.h                               |  101 +
 include/linux/dcbnl.h                              |   25 +-
 include/linux/dccp.h                               |    1 +
 include/linux/dma-direction.h                      |   13 +
 include/linux/dma-mapping.h                        |   10 +-
 include/linux/dmaengine.h                          |    4 +-
 include/linux/etherdevice.h                        |    2 +-
 include/linux/ethtool.h                            |   35 +-
 include/linux/ieee80211.h                          |   18 +-
 include/linux/if_ether.h                           |    5 +
 include/linux/if_packet.h                          |    6 +
 include/linux/if_vlan.h                            |   91 +-
 include/linux/inet_lro.h                           |   19 -
 include/linux/mii.h                                |    2 +
 include/linux/netdevice.h                          |   55 +-
 include/linux/netfilter/ipset/ip_set.h             |   50 +-
 include/linux/netfilter/ipset/ip_set_ahash.h       |  154 +-
 include/linux/netfilter/ipset/ip_set_hash.h        |    4 +
 include/linux/netfilter/ipset/ip_set_timeout.h     |    5 +-
 include/linux/netfilter/ipset/pfxlen.h             |   11 +-
 include/linux/netfilter/nfnetlink.h                |    3 +
 include/linux/netfilter/nfnetlink_queue.h          |    1 +
 include/linux/netfilter/xt_set.h                   |   15 +-
 include/linux/netlink.h                            |    8 +-
 include/linux/netpoll.h                            |    2 -
 include/linux/nfc.h                                |  126 +
 include/linux/nl80211.h                            |   42 +-
 include/linux/pci_ids.h                            |    9 +
 include/linux/random.h                             |    1 +
 include/linux/rtnetlink.h                          |    2 +
 include/linux/skbuff.h                             |   73 +-
 include/linux/socket.h                             |    4 +-
 include/linux/ssb/ssb.h                            |    2 +-
 include/linux/stmmac.h                             |   25 +-
 include/linux/tc_ematch/tc_em_meta.h               |    2 +-
 include/linux/tcp.h                                |    1 +
 include/linux/virtio_net.h                         |    1 +
 include/net/act_api.h                              |    6 +-
 include/net/arp.h                                  |   31 +-
 include/net/bluetooth/bluetooth.h                  |   27 +-
 include/net/bluetooth/hci.h                        |   77 +
 include/net/bluetooth/hci_core.h                   |   96 +-
 include/net/bluetooth/l2cap.h                      |  140 +-
 include/net/bluetooth/mgmt.h                       |   12 +
 include/net/bluetooth/rfcomm.h                     |    9 +-
 include/net/bluetooth/smp.h                        |   47 +
 include/net/caif/caif_hsi.h                        |  145 +
 include/net/cfg80211.h                             |   38 +
 include/net/dcbnl.h                                |   11 +-
 include/net/dst.h                                  |   41 +-
 include/net/dst_ops.h                              |    1 +
 include/net/genetlink.h                            |   32 +
 include/net/inetpeer.h                             |   39 +-
 include/net/ip.h                                   |   10 +-
 include/net/ip6_fib.h                              |    1 -
 include/net/ip_vs.h                                |   34 +-
 include/net/ipv6.h                                 |   12 +-
 include/net/mac80211.h                             |  261 +-
 include/net/neighbour.h                            |   34 +-
 include/net/net_namespace.h                        |    1 +
 include/net/netlink.h                              |   24 +
 include/net/nfc.h                                  |  156 +
 include/net/pkt_sched.h                            |    4 +-
 include/net/rtnetlink.h                            |    7 +-
 include/net/sch_generic.h                          |   12 +-
 include/net/sctp/sctp.h                            |   15 +-
 include/net/sctp/structs.h                         |   17 +
 include/net/sctp/user.h                            |    1 +
 include/net/snmp.h                                 |   86 +-
 include/net/sock.h                                 |    2 +
 include/net/tcp.h                                  |   11 +-
 include/net/wimax.h                                |    1 -
 include/trace/events/sock.h                        |   68 +
 include/trace/events/udp.h                         |   32 +
 kernel/audit.c                                     |   29 +
 lib/Kconfig                                        |   14 +
 lib/Makefile                                       |    3 +
 lib/checksum.c                                     |   13 +-
 lib/cordic.c                                       |  101 +
 lib/crc8.c                                         |   86 +
 net/8021q/vlan.c                                   |   19 +-
 net/8021q/vlan.h                                   |   31 +
 net/8021q/vlan_core.c                              |   46 +-
 net/8021q/vlan_dev.c                               |    7 +-
 net/8021q/vlanproc.c                               |    6 +-
 net/Kconfig                                        |    1 +
 net/Makefile                                       |    1 +
 net/TUNABLE                                        |   50 -
 net/appletalk/aarp.c                               |  138 +-
 net/appletalk/ddp.c                                |  398 +-
 net/atm/clip.c                                     |   22 +-
 net/atm/mpc.c                                      |    2 +-
 net/atm/pppoatm.c                                  |    1 +
 net/batman-adv/Kconfig                             |    1 +
 net/batman-adv/aggregation.c                       |   73 +-
 net/batman-adv/aggregation.h                       |   13 +-
 net/batman-adv/bat_debugfs.c                       |   11 +-
 net/batman-adv/bat_sysfs.c                         |  102 +-
 net/batman-adv/bat_sysfs.h                         |    2 +
 net/batman-adv/bitarray.c                          |   12 +-
 net/batman-adv/bitarray.h                          |   10 +-
 net/batman-adv/gateway_client.c                    |  268 +-
 net/batman-adv/gateway_client.h                    |    3 +-
 net/batman-adv/gateway_common.c                    |   25 +-
 net/batman-adv/hard-interface.c                    |   46 +-
 net/batman-adv/hard-interface.h                    |   20 +-
 net/batman-adv/hash.c                              |    7 +-
 net/batman-adv/hash.h                              |    6 +-
 net/batman-adv/icmp_socket.c                       |    4 +-
 net/batman-adv/main.c                              |   31 +-
 net/batman-adv/main.h                              |   85 +-
 net/batman-adv/originator.c                        |   36 +-
 net/batman-adv/originator.h                        |   18 +-
 net/batman-adv/packet.h                            |  142 +-
 net/batman-adv/ring_buffer.c                       |    4 +-
 net/batman-adv/ring_buffer.h                       |    2 +-
 net/batman-adv/routing.c                           |  376 +-
 net/batman-adv/routing.h                           |   15 +-
 net/batman-adv/send.c                              |  147 +-
 net/batman-adv/send.h                              |   14 +-
 net/batman-adv/soft-interface.c                    |   66 +-
 net/batman-adv/soft-interface.h                    |    5 +-
 net/batman-adv/translation-table.c                 | 1566 ++++-
 net/batman-adv/translation-table.h                 |   49 +-
 net/batman-adv/types.h                             |   74 +-
 net/batman-adv/unicast.c                           |   33 +-
 net/batman-adv/unicast.h                           |    8 +-
 net/batman-adv/vis.c                               |  104 +-
 net/bluetooth/Kconfig                              |    9 +
 net/bluetooth/Makefile                             |    2 +-
 net/bluetooth/cmtp/capi.c                          |    3 +-
 net/bluetooth/hci_conn.c                           |   79 +-
 net/bluetooth/hci_core.c                           |  264 +-
 net/bluetooth/hci_event.c                          |  289 +-
 net/bluetooth/hci_sock.c                           |   70 +-
 net/bluetooth/l2cap_core.c                         | 1052 ++--
 net/bluetooth/l2cap_sock.c                         |  442 +-
 net/bluetooth/lib.c                                |   23 +-
 net/bluetooth/mgmt.c                               |  281 +-
 net/bluetooth/rfcomm/sock.c                        |    6 +-
 net/bluetooth/sco.c                                |    4 +-
 net/bluetooth/smp.c                                |  702 ++
 net/bridge/br_netfilter.c                          |   16 +-
 net/bridge/br_netlink.c                            |   15 +-
 net/caif/caif_dev.c                                |    1 -
 net/caif/chnl_net.c                                |    2 +-
 net/can/af_can.c                                   |    5 +-
 net/can/bcm.c                                      |    1 +
 net/ceph/crypto.c                                  |    2 +-
 net/core/dev.c                                     |   26 +-
 net/core/dst.c                                     |   17 +-
 net/core/ethtool.c                                 |  313 +-
 net/core/fib_rules.c                               |    6 +-
 net/core/neighbour.c                               |  191 +-
 net/core/net-sysfs.c                               |    2 -
 net/core/net-traces.c                              |    2 +
 net/core/net_namespace.c                           |    1 +
 net/core/netpoll.c                                 |   13 +-
 net/core/rtnetlink.c                               |   64 +-
 net/core/skbuff.c                                  |   84 +-
 net/core/sock.c                                    |   11 +-
 net/core/timestamping.c                            |    2 +
 net/dcb/dcbnl.c                                    |  677 ++-
 net/dccp/ccid.c                                    |    4 +-
 net/dccp/ccids/ccid2.c                             |  109 +-
 net/dccp/ccids/ccid2.h                             |   25 +-
 net/dccp/input.c                                   |   61 +-
 net/dccp/output.c                                  |   14 +-
 net/decnet/af_decnet.c                             |  697 +-
 net/decnet/dn_dev.c                                |   78 +-
 net/decnet/dn_fib.c                                |   81 +-
 net/decnet/dn_neigh.c                              |   42 +-
 net/decnet/dn_nsp_in.c                             |  182 +-
 net/decnet/dn_route.c                              |  143 +-
 net/decnet/dn_table.c                              |   23 +-
 net/decnet/netfilter/dn_rtmsg.c                    |   18 +-
 net/decnet/sysctl_net_decnet.c                     |   17 +-
 net/dsa/mv88e6131.c                                |    8 +-
 net/econet/af_econet.c                             |  172 +-
 net/ethernet/eth.c                                 |    3 +-
 net/ieee802154/af_ieee802154.c                     |    2 +-
 net/ieee802154/dgram.c                             |    2 +-
 net/ieee802154/nl-phy.c                            |   31 +
 net/ipv4/af_inet.c                                 |   52 +-
 net/ipv4/arp.c                                     |   41 +-
 net/ipv4/devinet.c                                 |    6 +-
 net/ipv4/fib_frontend.c                            |    6 +-
 net/ipv4/fib_trie.c                                |   12 +-
 net/ipv4/gre.c                                     |    1 -
 net/ipv4/icmp.c                                    |   14 +-
 net/ipv4/inet_diag.c                               |    2 +-
 net/ipv4/inet_lro.c                                |   74 +-
 net/ipv4/inetpeer.c                                |  293 +-
 net/ipv4/ip_fragment.c                             |    5 +-
 net/ipv4/ip_gre.c                                  |    2 +-
 net/ipv4/ip_input.c                                |    4 +-
 net/ipv4/ip_output.c                               |   16 +-
 net/ipv4/ipconfig.c                                |   75 +-
 net/ipv4/ipmr.c                                    |    3 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   26 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |    2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |  210 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |    2 +-
 net/ipv4/raw.c                                     |   36 +-
 net/ipv4/route.c                                   |   94 +-
 net/ipv4/syncookies.c                              |    1 +
 net/ipv4/sysctl_net_ipv4.c                         |   14 -
 net/ipv4/tcp_input.c                               |   46 +-
 net/ipv4/tcp_ipv4.c                                |   11 +-
 net/ipv4/tcp_minisocks.c                           |    6 +-
 net/ipv4/udp.c                                     |    2 +
 net/ipv4/xfrm4_policy.c                            |    2 +-
 net/ipv6/addrconf.c                                |   55 +-
 net/ipv6/addrlabel.c                               |    9 +-
 net/ipv6/ip6_fib.c                                 |    5 +-
 net/ipv6/ip6_output.c                              |   58 +-
 net/ipv6/ip6mr.c                                   |    3 +-
 net/ipv6/ndisc.c                                   |   16 +-
 net/ipv6/raw.c                                     |  145 +-
 net/ipv6/route.c                                   |   85 +-
 net/ipv6/sit.c                                     |    4 +-
 net/ipv6/syncookies.c                              |    1 +
 net/ipv6/tcp_ipv6.c                                |    5 +
 net/ipv6/udp.c                                     |    2 +-
 net/irda/af_irda.c                                 |    4 +-
 net/irda/ircomm/ircomm_tty_attach.c                |    2 +-
 net/irda/irda_device.c                             |    2 +-
 net/irda/iriap.c                                   |    8 +-
 net/irda/irlan/irlan_client.c                      |   10 +-
 net/irda/irlan/irlan_common.c                      |   10 +-
 net/irda/irlan/irlan_eth.c                         |    2 +-
 net/irda/irlan/irlan_provider.c                    |   10 +-
 net/irda/irqueue.c                                 |    4 +-
 net/irda/irttp.c                                   |   18 +-
 net/key/af_key.c                                   |   20 +-
 net/l2tp/l2tp_ip.c                                 |   19 +-
 net/lapb/lapb_iface.c                              |   30 +-
 net/lapb/lapb_in.c                                 |  881 ++--
 net/mac80211/aes_ccm.c                             |   37 +-
 net/mac80211/aes_ccm.h                             |    2 -
 net/mac80211/aes_cmac.c                            |   10 +-
 net/mac80211/aes_cmac.h                            |    2 +-
 net/mac80211/agg-rx.c                              |   21 +-
 net/mac80211/cfg.c                                 |   62 +-
 net/mac80211/debugfs_key.c                         |   13 +-
 net/mac80211/driver-ops.h                          |   28 +
 net/mac80211/driver-trace.h                        |  101 +
 net/mac80211/ht.c                                  |    6 +
 net/mac80211/ieee80211_i.h                         |   36 +-
 net/mac80211/iface.c                               |    7 +-
 net/mac80211/key.c                                 |  171 +-
 net/mac80211/key.h                                 |   32 +-
 net/mac80211/mesh_pathtbl.c                        |    4 +-
 net/mac80211/mlme.c                                |  111 +-
 net/mac80211/pm.c                                  |   51 +-
 net/mac80211/rc80211_minstrel.c                    |    9 +
 net/mac80211/rc80211_minstrel.h                    |   12 +
 net/mac80211/rc80211_minstrel_ht.c                 |    7 +
 net/mac80211/rx.c                                  |   38 +-
 net/mac80211/scan.c                                |   45 +-
 net/mac80211/sta_info.h                            |    6 +-
 net/mac80211/tkip.c                                |  108 +-
 net/mac80211/tkip.h                                |    8 +-
 net/mac80211/tx.c                                  |   17 +-
 net/mac80211/util.c                                |   90 +-
 net/mac80211/wme.c                                 |    3 +-
 net/mac80211/wme.h                                 |    5 -
 net/mac80211/work.c                                |    2 +-
 net/mac80211/wpa.c                                 |   94 +-
 net/netfilter/ipset/Kconfig                        |   10 +
 net/netfilter/ipset/Makefile                       |    1 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   35 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   38 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |   31 +-
 net/netfilter/ipset/ip_set_core.c                  |  166 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |   49 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |   69 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c         |   73 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |  137 +-
 net/netfilter/ipset/ip_set_hash_net.c              |   88 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |  786 +++
 net/netfilter/ipset/ip_set_hash_netport.c          |  119 +-
 net/netfilter/ipset/ip_set_list_set.c              |  106 +-
 net/netfilter/ipset/pfxlen.c                       |   23 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   14 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |    4 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   78 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   28 +-
 net/netfilter/ipvs/ip_vs_est.c                     |   13 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   52 +-
 net/netfilter/ipvs/ip_vs_proto.c                   |    4 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |   13 +-
 net/netfilter/nf_conntrack_netlink.c               |    4 +-
 net/netfilter/nfnetlink.c                          |   40 +-
 net/netfilter/nfnetlink_queue.c                    |  170 +-
 net/netfilter/xt_AUDIT.c                           |    5 +
 net/netfilter/xt_CT.c                              |   11 +-
 net/netfilter/xt_HL.c                              |   64 +-
 net/netfilter/xt_hl.c                              |   32 +-
 net/netfilter/xt_set.c                             |  153 +-
 net/netlabel/netlabel_unlabeled.c                  |   10 +-
 net/netlink/af_netlink.c                           |   20 +-
 net/netlink/genetlink.c                            |    2 +-
 net/netrom/nr_route.c                              |   22 +-
 net/nfc/Kconfig                                    |   16 +
 net/nfc/Makefile                                   |    7 +
 net/nfc/af_nfc.c                                   |   98 +
 net/nfc/core.c                                     |  468 ++
 net/nfc/netlink.c                                  |  537 ++
 net/nfc/nfc.h                                      |  117 +
 net/nfc/rawsock.c                                  |  354 ++
 net/packet/af_packet.c                             |  438 ++-
 net/phonet/pn_netlink.c                            |   13 +-
 net/rds/bind.c                                     |    4 +-
 net/rds/ib.h                                       |    1 +
 net/rds/ib_cm.c                                    |    6 +-
 net/rds/ib_send.c                                  |    4 +-
 net/rds/iw.h                                       |    1 +
 net/rds/iw_cm.c                                    |    9 +-
 net/rds/iw_rdma.c                                  |    9 +-
 net/rds/iw_send.c                                  |    4 +-
 net/rds/send.c                                     |    7 +-
 net/rds/tcp_stats.c                                |    2 +-
 net/rose/rose_link.c                               |    7 -
 net/rose/rose_route.c                              |    5 -
 net/sched/act_api.c                                |   11 +-
 net/sched/act_csum.c                               |    2 +-
 net/sched/act_gact.c                               |    3 +-
 net/sched/act_ipt.c                                |    2 +-
 net/sched/act_mirred.c                             |    2 +-
 net/sched/act_nat.c                                |    2 +-
 net/sched/act_pedit.c                              |    2 +-
 net/sched/act_police.c                             |    2 +-
 net/sched/act_simple.c                             |    3 +-
 net/sched/act_skbedit.c                            |    2 +-
 net/sched/cls_api.c                                |   12 +-
 net/sched/cls_basic.c                              |    2 +-
 net/sched/cls_cgroup.c                             |    2 +-
 net/sched/cls_flow.c                               |    6 +-
 net/sched/cls_fw.c                                 |    2 +-
 net/sched/cls_route.c                              |    2 +-
 net/sched/cls_rsvp.h                               |    4 +-
 net/sched/cls_tcindex.c                            |    2 +-
 net/sched/cls_u32.c                                |    2 +-
 net/sched/em_meta.c                                |    7 -
 net/sched/sch_api.c                                |   18 +-
 net/sched/sch_atm.c                                |    1 +
 net/sched/sch_choke.c                              |    2 +-
 net/sched/sch_generic.c                            |   10 +-
 net/sched/sch_netem.c                              |    1 +
 net/sched/sch_sfq.c                                |    2 +-
 net/sched/sch_teql.c                               |    4 +-
 net/sctp/associola.c                               |    6 +
 net/sctp/bind_addr.c                               |   17 +-
 net/sctp/input.c                                   |    3 +-
 net/sctp/ipv6.c                                    |    2 +
 net/sctp/outqueue.c                                |   13 +
 net/sctp/protocol.c                                |  152 +-
 net/sctp/sm_make_chunk.c                           |   55 +-
 net/sctp/sm_sideeffect.c                           |    2 +-
 net/sctp/sm_statefuns.c                            |   51 +-
 net/sctp/socket.c                                  |  200 +-
 net/sctp/sysctl.c                                  |    7 +
 net/sunrpc/auth.c                                  |    2 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   46 +-
 net/sunrpc/clnt.c                                  |   25 +-
 net/sunrpc/rpc_pipe.c                              |   14 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    1 +
 net/sunrpc/xprtrdma/verbs.c                        |    1 +
 net/tipc/bcast.c                                   |    6 +-
 net/tipc/bearer.c                                  |    1 -
 net/tipc/bearer.h                                  |    2 -
 net/tipc/core.h                                    |    6 -
 net/tipc/link.c                                    |    6 +-
 net/tipc/msg.c                                     |    6 +-
 net/tipc/msg.h                                     |   34 +-
 net/tipc/name_distr.c                              |    6 +-
 net/tipc/name_table.c                              |  289 +-
 net/tipc/name_table.h                              |   14 +-
 net/tipc/port.c                                    |  284 +-
 net/tipc/socket.c                                  |    3 -
 net/wireless/mlme.c                                |   15 +-
 net/wireless/nl80211.c                             |  232 +-
 net/wireless/nl80211.h                             |    4 +
 net/wireless/scan.c                                |    7 +-
 net/x25/af_x25.c                                   |  473 +-
 net/x25/x25_dev.c                                  |   44 +-
 net/x25/x25_in.c                                   |  118 +-
 net/x25/x25_link.c                                 |   87 +-
 net/x25/x25_subr.c                                 |   78 +-
 net/xfrm/xfrm_policy.c                             |    9 +-
 net/xfrm/xfrm_user.c                               |    3 +-
 security/apparmor/lib.c                            |    1 +
 1296 files changed, 94607 insertions(+), 36995 deletions(-)
 create mode 100644 Documentation/networking/netdev-features.txt
 create mode 100644 Documentation/networking/nfc.txt
 create mode 100644 arch/powerpc/net/Makefile
 create mode 100644 arch/powerpc/net/bpf_jit.h
 create mode 100644 arch/powerpc/net/bpf_jit_64.S
 create mode 100644 arch/powerpc/net/bpf_jit_comp.c
 create mode 100644 drivers/bcma/driver_pci_host.c
 create mode 100644 drivers/bcma/sprom.c
 create mode 100644 drivers/net/bnx2x/bnx2x_sp.c
 create mode 100644 drivers/net/bnx2x/bnx2x_sp.h
 create mode 100644 drivers/net/caif/caif_hsi.c
 create mode 100644 drivers/net/ftgmac100.c
 create mode 100644 drivers/net/ftgmac100.h
 delete mode 100644 drivers/net/myri_sbus.c
 delete mode 100644 drivers/net/myri_sbus.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
 create mode 100644 drivers/net/wireless/b43/bus.c
 create mode 100644 drivers/net/wireless/b43/bus.h
 create mode 100644 drivers/net/wireless/b43/phy_ht.c
 create mode 100644 drivers/net/wireless/b43/phy_ht.h
 create mode 100644 drivers/net/wireless/b43/phy_lcn.c
 create mode 100644 drivers/net/wireless/b43/phy_lcn.h
 create mode 100644 drivers/net/wireless/b43/radio_2059.c
 create mode 100644 drivers/net/wireless/b43/radio_2059.h
 create mode 100644 drivers/net/wireless/b43/tables_phy_ht.c
 create mode 100644 drivers/net/wireless/b43/tables_phy_ht.h
 create mode 100644 drivers/net/wireless/b43/tables_phy_lcn.c
 create mode 100644 drivers/net/wireless/b43/tables_phy_lcn.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.h
 create mode 100644 drivers/net/wireless/mac80211_hwsim.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192de/trx.h
 create mode 100644 drivers/nfc/pn533.c
 create mode 100644 include/linux/cordic.h
 create mode 100644 include/linux/crc8.h
 create mode 100644 include/linux/dma-direction.h
 create mode 100644 include/linux/nfc.h
 create mode 100644 include/net/caif/caif_hsi.h
 create mode 100644 include/net/nfc.h
 create mode 100644 include/trace/events/sock.h
 create mode 100644 include/trace/events/udp.h
 create mode 100644 lib/cordic.c
 create mode 100644 lib/crc8.c
 delete mode 100644 net/TUNABLE
 create mode 100644 net/bluetooth/smp.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_netiface.c
 create mode 100644 net/nfc/Kconfig
 create mode 100644 net/nfc/Makefile
 create mode 100644 net/nfc/af_nfc.c
 create mode 100644 net/nfc/core.c
 create mode 100644 net/nfc/netlink.c
 create mode 100644 net/nfc/nfc.h
 create mode 100644 net/nfc/rawsock.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
