Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2LLUL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:11:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56263 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab2LLULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:11:21 -0500
Date: Wed, 12 Dec 2012 15:11:16 -0500 (EST)
Message-Id: <20121212.151116.143443755590581447.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBCKBh8u021181


There is one merge conflict to resolve in net/sched/cls_cgroup.c,
one commit changes the name of some members to "css_*" (this came
from Tejun's tree) and another commit adds an "attach" method.

Keep all the "css_*" fields from Tejun's changes, and take only the
".attach = cgrp_attach," addtion from the net-next tree.

1) Allow to dump, monitor, and change the bridge multicast database
   using netlink.  From Cong Wang.

2) RFC 5961 TCP blind data injection attack mitigation, from Eric
   Dumazet.

3) Networking user namespace support from Eric W. Biederman.

4) tuntap/virtio-net multiqueue support by Jason Wang.

5) Support for checksum offload of encapsulated packets (basically,
   tunneled traffic can still be checksummed by HW).  From Joseph
   Gasparakis.

6) Allow BPF filter access to VLAN tags, from Eric Dumazet and
   Daniel Borkmann.

7) Bridge port parameters over netlink and BPDU blocking support
   from Stephen Hemminger.

8) Improve data access patterns during inet socket demux by rearranging
   socket layout, from Eric Dumazet.

9) TIPC protocol updates and cleanups from Ying Xue, Paul Gortmaker, and
   Jon Maloy.

10) Update TCP socket hash sizing to be more in line with current day
    realities.  The existing heurstics were choosen a decade ago.
    From Eric Dumazet.

11) Fix races, queue bloat, and excessive wakeups in ATM and
    associated drivers, from Krzysztof Mazur and David Woodhouse.

12) Support DOVE (Distributed Overlay Virtual Ethernet) extensions
    in VXLAN driver, from David Stevens.

13) Add "oops_only" mode to netconsole, from Amerigo Wang.

14) Support set and query of VEB/VEPA bridge mode via PF_BRIDGE, also
    allow DCB netlink to work on namespaces other than the initial
    namespace.  From John Fastabend.

15) Support PTP in the Tigon3 driver, from Matt Carlson.

16) tun/vhost zero copy fixes and improvements, plus turn it on
    by default, from Michael S. Tsirkin.

17) Support per-association statistics in SCTP, from Michele
    Baldessari.

And many, many, driver updates, cleanups, and improvements.  Too
numerous to mention individually.

Please pull, thanks a lot.

The following changes since commit e9296e89b85604862bd9ec2d54dc43edad775c0d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-11-28 21:54:07 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 520dfe3a3645257bf83660f672c47f8558f3d4c4:

  net/mlx4_en: Add support for destination MAC in steering rules (2012-12-12 13:02:30 -0500)

----------------------------------------------------------------
Aarthi Thiruvengadam (1):
      ath6kl: use custom MAC address for newly created interfaces

Abhijit Pawar (2):
      net: remove obsolete simple_strto<foo>
      net: remove obsolete simple_strto<foo>

Akeem G. Abodunrin (3):
      igb: Support for modifying UDP RSS flow hashing
      igb: Ethtool support to enable and disable EEE
      igb: Acquire, release semaphore for writing each EEPROM page

Akinobu Mita (2):
      sctp: use bitmap_weight
      mISDN: improve bitops usage

Alan Cox (4):
      brcm80211: remove some truely barftastic code
      isdn: remove dead code
      l2tp: session is an array not a pointer
      ipvs: remove silly double assignment

Alan Ott (3):
      6lowpan: consider checksum bytes in fragmentation threshold
      mac802154: fix memory leaks
      mac802154: use kfree_skb() instead of dev_kfree_skb()

Alexander Duyck (31):
      ixgbe: Initialize q_vector cpu and affinity masks correctly
      ixgbe: Enable jumbo frames support w/ SR-IOV
      ixgbe: Move message handling routines into their own functions
      ixgbe: Add mailbox API version negotiation support to ixgbe PF
      igb: Split Rx timestamping into two separate functions
      igb: Do not use header split, instead receive all frames into a single buffer
      igb: Combine post-processing of skb into a single function
      igb: Map entire page and sync half instead of mapping and unmapping half pages
      igb: Move rx_buffer related code in Rx cleanup path into separate function
      igb: Lock buffer size at 2K even on systems with larger pages
      igb: Combine q_vector and ring allocation into a single function
      igb: Move the calls to set the Tx and Rx queues into igb_open
      igb: Split igb_update_dca into separate Tx and Rx functions
      ixgbe: Add support for IPv6 and UDP to ixgbe_get_headlen
      ixgbe: Add support for tracking the default user priority to SR-IOV
      ixgbe: Add support for GET_QUEUES message to get DCB configuration
      ixgbe: Enable support for VF API version 1.1 in the PF.
      ixgbevf: Add VF DCB + SR-IOV support
      ixgbe: Drop unnecessary addition from ixgbe_set_rx_buffer_len
      ixgbe: Fix possible memory leak in ixgbe_set_ringparam
      ixgbe: Do not decrement budget in ixgbe_clean_rx_irq
      igb: Fix sparse warning in igb_ptp_rx_pktstamp
      ixgbe: Do not use DCA to prefetch the entire packet into the cache
      igb: Make TSO check for CHECKSUM_PARTIAL to avoid skb_is_gso check
      igb: Update igb Tx flags to improve code efficiency
      igb: Improve performance and reduce size of igb_tx_map
      ioat: Do not enable DCA if tag map is invalid
      igb: Do not parse past IP header on fragments beyond the first
      ixgbe: Drop RLPML configuration from x540 RXDCTL register configuration
      ixgbe: Do not parse past IP header on fragments beyond the first
      net: Handle encapsulated offloads before fragmentation or handing to lower dev

Alexander Shiyan (1):
      irda: ep7211-sir: Convert to platform_diver

Alexander Stein (1):
      can: Do not call dev_put if restart timer is running upon close

Amerigo Wang (10):
      ipv6: use IS_ENABLED()
      vlan: use IS_ENABLED()
      ipv6: remove a useless NULL check
      ipv6: introduce ip6_rt_put()
      netconsole: add oops_only module option
      virtio_net: use net_*_ratelimited() helpers
      net: convert __IPTUNNEL_XMIT() to an inline function
      net: unify for_each_ip_tunnel_rcu()
      bridge: implement multicast fast leave
      virtio_net: fix a typo in virtnet_alloc_queues()

Amir Vadai (3):
      MAINTAINERS: Add Mellanox ethernet driver - mlx4_en
      net/mlx4_en: Fix TX moderation info loss after set_ringparam is called
      net/mlx4_en: Set number of rx/tx channels using ethtool

Amitkumar Karwar (8):
      cfg80211: code rearrangement to avoid forward declarations
      mwifiex: use LOW_PRIORITY scan flag provided in scan request
      mwifiex: abort scan upon interface down
      mwifiex: minor cleanup and a fix in scan semaphore usage
      mwifiex: disable channel filtering for SSID specific scan from user
      Revert "mwifiex: retrieve correct max_power information in reg_notifier handler"
      nl/cfg80211: advertise OBSS scan requirement
      mwifiex: add support for SDIO card reset

Andi Kleen (1):
      ath6kl: fix uninitialized variable in ath6kl_sdio_enable_scatter()

Andreas Larsson (2):
      can: grcan: Add device driver for GRCAN and GRHCAN cores
      can: sja1000: Make sja1000_of_platform selectable and compilable on SPARC

Andrei Emeltchenko (84):
      Bluetooth: Add HCI logical link cmds definitions
      Bluetooth: A2MP: Create amp_mgr global list
      Bluetooth: AMP: Use HCI cmd to Read AMP Info
      Bluetooth: AMP: Use HCI cmd to Read Loc AMP Assoc
      Bluetooth: A2MP: Process Discover Response
      Bluetooth: AMP: Physical link struct and helpers
      Bluetooth: AMP: Remote AMP ctrl definitions
      Bluetooth: AMP: Handle create / disc phylink req
      Bluetooth: A2MP: Process A2MP Getinfo Rsp
      Bluetooth: A2MP: Process A2MP Get AMP Assoc Rsp
      Bluetooth: Choose connection based on capabilities
      Bluetooth: AMP: Add AMP key calculation
      Bluetooth: AMP: Create Physical Link
      Bluetooth: AMP: Write remote AMP Assoc
      Bluetooth: A2MP: Add fallback to normal l2cap init sequence
      Bluetooth: AMP: Process Chan Selected event
      Bluetooth: AMP: Accept Physical Link
      Bluetooth: AMP: Handle Accept phylink command status evt
      Bluetooth: Use %pMR in debug instead of batostr
      Bluetooth: Use %pMR in sprintf/seq_printf instead of batostr
      Bluetooth: Use %pMR instead of baswap in seq_show
      bluetooth: Remove unneeded batostr function
      Bluetooth: Factor out hci_queue_acl
      Bluetooth: Factor out Create Configuration Response
      Bluetooth: Use %zu print specifier for size_t type
      Bluetooth: A2MP: Correct assoc_len size
      Bluetooth: btmrvl: Correct num_block name
      Bluetooth: btmrvl: Use DIV_ROUND_UP macro
      Bluetooth: btmrvl: Fix skb buffer overflow
      Bluetooth: A2MP: Fix potential NULL dereference
      Bluetooth: AMP: Fix possible NULL dereference
      Bluetooth: Fix dereference after NULL check
      Bluetooth: AMP: Factor out amp_ctrl_add
      Bluetooth: AMP: Factor out phylink_add
      Bluetooth: AMP: Use block_mtu for AMP controller
      Bluetooth: Adjust L2CAP Max PDU size for AMP packets
      Bluetooth: L2CAP: Fix using default Flush Timeout for EFS
      Bluetooth: btmrv: Use %*ph specifier instead of print_hex_dump_bytes
      Bluetooth: Allow to set flush timeout
      Bluetooth: AMP: Handle AMP_LINK timeout
      Bluetooth: AMP: Add handle to hci_chan structure
      Bluetooth: AMP: Handle number of compl blocks for AMP_LINK
      Bluetooth: AMP: Handle AMP_LINK connection
      Bluetooth: AMP: Hanlde AMP_LINK case in conn_put
      Bluetooth: AMP: Use Loglink handle in ACL Handle field
      Bluetooth: AMP: Handle complete frames in l2cap
      Bluetooth: AMP: Drop packets when no l2cap conn exist
      Bluetooth: Send EFS Conf Rsp only for BR/EDR chan
      Bluetooth: Zero bredr pointer when chan is deleted
      Bluetooth: AMP: Get amp_mgr reference in HS hci_conn
      mwifiex: Using %*phD instead of print_hex_dump_bytes
      Bluetooth: trivial: Remove unneeded assignment
      Bluetooth: Use helper function sending EFS conf rsp
      Bluetooth: AMP: Process Physical Link Complete evt
      Bluetooth: AMP: Process Logical Link complete evt
      Bluetooth: Add put(hcon) when deleting hchan
      Bluetooth: trivial: Fix braces style and remove empty line
      Bluetooth: Save hs_hchan instead of hs_hcon in loglink complete
      Bluetooth: Return correct L2CAP response type
      Bluetooth: Derive remote and local amp id from chan struct
      Bluetooth: AMP: Add Logical Link Create function
      Bluetooth: AMP: Process Disc Logical Link
      Bluetooth: AMP: Process Disc Physical Link Complete evt
      Bluetooth: AMP: Remove hci_conn receiving error command status
      Bluetooth: Disconnect logical link when deleting chan
      Bluetooth: AMP: Check for hs_hcon instead of ctrl_id
      Bluetooth: AMP: Use l2cap_physical_cfm in phylink complete evt
      Bluetooth: Process Create Chan Request
      Bluetooth: Rename ctrl_id to remote_amp_id
      Bluetooth: Use __l2cap_no_conn_pending helper
      Bluetooth: Remove unneeded local_amp_id initialization
      Bluetooth: Refactor locking in amp_physical_cfm
      Bluetooth: Disable FCS only for new HS channels
      Bluetooth: trivial: Use __constant for constants
      Bluetooth: Fix sending L2CAP Create Chan Req
      Bluetooth: Set local_amp_id after getting Phylink Completed evt
      Bluetooth: Improve error message printing
      Bluetooth: AMP: Set no FCS for incoming L2CAP chan
      Bluetooth: Refactor l2cap_send_disconn_req
      Bluetooth: AMP: Mark controller radio powered down after HCIDEVDOWN
      Bluetooth: AMP: Check that AMP is present and active
      Bluetooth: Fix missing L2CAP EWS Conf parameter
      Bluetooth: Process receiving FCS_NONE in L2CAP Conf Rsp
      Bluetooth: trivial: Change NO_FCS_RECV to RECV_NO_FCS

Andrew Gallatin (4):
      myri10ge: Convert from LRO to GRO
      myri10ge: Add vlan rx for better GRO perf.
      myri10ge: fix incorrect use of ntohs()
      myri10ge: fix most sparse warnings

Andrey Vagin (1):
      ipv6: adapt connect for repair move

Andy Shevchenko (1):
      rtlwifi: rtl8192ce: rtl8192cu: use %*phC to dump small buffers

AnilKumar Ch (1):
      can: c_can: Add d_can raminit support

Ansis Atteka (3):
      ipv6: improve ipv6_find_hdr() to skip empty routing headers
      openvswitch: add ipv6 'set' action
      openvswitch: add skb mark matching and set action

Antonio Quartulli (34):
      nl/cfg80211: force scan using an AP vif if requested
      batman-adv: use check_unicast_packet() in recv_roam_adv()
      batman-adv: return proper value in case of hash_add failure
      batman-adv: properly store the roaming time
      batman-adv: print packets re-routing on DBG_TT and ratelimit it
      batman-adv: check for more space before accessing the skb
      batman-adv: properly convert flag into a boolean value
      batman-adv: pass the WIFI flag from the local to global entry
      batman-adv: add kernel-doc for enum batadv_dbg_level
      if_ether.h: add B.A.T.M.A.N.-Advanced Ethertype
      nl/cfg80211: add the NL80211_CMD_SET_MCAST_RATE command
      mac80211: implement set_mcast_rate() callback
      cfg80211: store the ssid into wirless_dev in AP mode
      nl80211: send the NL80211_ATTR_SSID in nl80211_send_iface()
      batman-adv: add UNICAST_4ADDR packet type
      batman-adv: Distributed ARP Table - add a new debug log level
      batman-adv: Distributed ARP Table - create DHT helper functions
      batman-adv: Distributed ARP Table - implement local storage
      batman-adv: Distributed ARP Table - add ARP parsing functions
      batman-adv: Distributed ARP Table - add snooping functions for ARP messages
      batman-adv: Distributed ARP Table - add compile option
      batman-adv: Distributed ARP Table - add runtime switch
      batman-adv: enable fast client detection using unicast_4addr packets
      batman-adv: fix wrong spinlock inline comment
      batman-adv: prevent using any virtual device created on batman-adv as hard-interface
      batman-adv: substitute tt_poss_change with a per-tt_entry flag
      batman-adv: refactor code to simplify long lines
      batman-adv: refactor tt_global_del_struct()
      batman-adv: roaming handling mechanism redesign
      batman-adv: support array of debugfs general attributes
      mac80211: in ADHOC don't update last_rx if sta is not authorized
      mac80211: in ADHOC print debug message for every Auth message
      batman-adv: use ETH_P_BATMAN
      mac80211: allow userspace registration for probe requests in IBSS

Arend van Spriel (57):
      wireless: drivers: make use of WLAN_EID_VENDOR_SPECIFIC
      wireless: gelic: make use of WLAN_EID_VENDOR_SPECIFIC
      wireless: remove duplicate enum ieee80211_eid definitions
      brcmfmac: remove 'always false' condition from brcmf_c_mkiovar_bsscfg
      brcmfmac: extend struct brcmf_if with bssidx field
      brcmfmac: rework driver initialization in brcmf_bus_start()
      brcmfmac: use bssidx from struct brcmf_if for bsscfg specific commands
      brcmfmac: add function converting ieee80211_channel to chanspec
      brcmfmac: use struct brcmf_if as interface object for fwil functions
      brcmfmac: change parameter list for send_key_to_dongle()
      brcmfmac: remove brcmf_find_bssidx() function
      brcmfmac: introduce brcmf_cfg80211_vif structure
      brcmfmac: store profile information per virtual interface
      brcmfmac: use vif struct to check_sys_up() function
      brcmfmac: separate connection status from scanning status
      brcmfmac: remove debugfs functionality from wl_cfg80211.c
      brcmfmac: cleanup brcmf_cfg80211_profile structure
      brcmfmac: remove unused enumeration wl_prof_list
      brcmfmac: rename check_sys_up() to check_vif_up()
      brcmfmac: use memset when setting a broadcast mac address
      brcmfmac: add virtual interface support in brcmf_cfg80211_suspend()
      brcmfmac: remove unnecessary macro usage in brcmf_cfg80211_resume()
      brcmfmac: store IEs per virtual interface
      wireless: add peer-to-peer related definitions
      brcmfmac: remove obsolete structure ap_info
      brcmfmac: simplify if-else condition in brcmf_cfg80211_escan()
      brcmfmac: restrict error condition in brcmf_inform_bss()
      brcmfmac: make pointer type constant in brcmf_set_management_ie()
      brcmfmac: change parameter of brcmf_set_management_ie()
      brcmfmac: remove obsolete variable from brcmf_cfg80211_start_ap()
      brcmfmac: fix NULL pointer access in brcmf_create_iovar()
      brcmfmac: fix build regression
      brcmfmac: use struct brcmf_if parameter in firmware event callbacks
      brcmfmac: rework firmware event handling code
      brcmfmac: change parameter in brcmf_add_if() function
      brcmfmac: fix for multiple netdevice interface support
      brcmfmac: correct handling IF firmware event
      brcmfmac: change mac address parameter in brcmf_add_if()
      brcmfmac: remove mac address validation from brcmf_net_attach()
      brcmfmac: fix wrong usage of unaligned include file
      brcmfmac: ignore IF event if it is a add for ifidx 0
      brcmfmac: restructure handling of IF event
      mac80211: check add_chanctx callback before use in ieee80211_reconfig
      cfg80211: change function signature of cfg80211_get_p2p_attr()
      brcm80211: update the MAINTAINERS file
      brcmfmac: get rid of struct brcmf_cfg80211_info::link_up attribute
      brcmfmac: remove mode from struct brcmf_cfg80211_conf
      brcmfmac: rework bus interface
      brcmsmac: fix uninitialized variable warning on arm architecture
      brcmfmac: use one list of event defintions
      brcmfmac: error messages should not be suppressed
      brcmfmac: consolidate debug macros in wl_cfg80211
      brcmfmac: replace WL_ERR() with brcmf_err()
      brcmfmac: replace WL_INFO() macro
      brcmfmac: remove WL_TRACE() macro
      brcmfmac: remove WL_SCAN() macro
      brcmfmac: remove WL_CONN() macro

Arron Wang (7):
      NFC: Set local gb and DEP registries
      NFC: Pass hardware specific HCI event to driver
      NFC: Handle pn544 continue activation
      NFC: Implement HCI DEP link up and down
      NFC: Implement HCI DEP send and receive data
      NFC: Add pn544 presence check for different targets
      NFC: Fix sparse warnings due to missing static

Ashok Nagarajan (1):
      mac80211: move out the non-statistics variable estab_plinks from mesh_stat

Assaf Krauss (2):
      iwlwifi: remove MFP Kconfig option
      mac80211: expose AES-CMAC subkey calculation

Avinash Patil (4):
      mwifiex: handle extended supported rates IE for AP
      mwifiex: rx path enhancement to derive priv only once
      mwifiex: add multi-queue support
      mwifiex: advertise GreenField, 40MHz intolerance support to cfg80211

Bala Shanmugam (3):
      ath6kl: Add support for AR6004 hardware version 1.3
      ath9k: Set appropriate bit for AR9565 in btc control register
      ath9k: turn off RXIQ calibration while re-calibrating radio

Barak Witkowski (6):
      bnx2x: parity recovery flow enhancement
      bnx2x: Management can control PFC/ETS
      bnx2x: IGU parse error cause probe failure
      bnx2x: prevent DCB if disabled in nvram
      bnx2x: Correct PFC disablement
      bnx2x: Prevent link flaps when booting from SAN.

Ben Greear (1):
      cfg80211: allow registering more than one beacon listener

Ben Hutchings (28):
      pps, ptp: Remove dependencies on EXPERIMENTAL
      ptp: Make PTP_1588_CLOCK select rather than depend on PPS
      ptp: Enable clock drivers along with associated net/PHY drivers
      sfc: Select PTP_1588_CLOCK
      bridge: Use is_link_local() in store_group_addr()
      eth: Make is_link_local() consistent with other address tests
      eth: Rename and properly align br_reserved_address array
      net: Fix continued iteration in rtnl_bridge_getlink()
      pch_gbe, ptp_pch: Fix the dependency direction between these drivers
      mlx4_en: Remove remnants of LRO support
      ehea: Remove remnants of LRO support
      net: Remove bogus dependencies on INET
      dsa: Hide core config options; make drivers select what they need
      cxgb3: Restore dependency on INET
      sfc: Fix byte order warnings for ethtool RX filter interface
      sfc: Fix byte order warning in self-test
      sfc: Really disable flow control while flushing
      sfc: Delete redundant page_addr variable from efx_init_rx_buffers_page()
      sfc: Fix check for failure of MC_CMD_FLUSH_RX_QUEUES
      sfc: Remove confusing MMIO functions
      sfc: Correctly initialise reset_method in siena_test_chip()
      sfc: Do not initialise buffer in efx_alloc_special_buffer()
      sfc: Reset driver's MAC stats after MC reboot seen
      sfc: Fix timekeeping in efx_mcdi_poll()
      sfc: Make module parameters really boolean
      bonding: Fix check for ethtool get_link operation support
      caif_usb: Check driver name before reading driver state in netdev notifier
      caif_usb: Make the driver name check more efficient

Beni Lev (2):
      cfg80211: add tracing to rdev-ops
      cfg80211: add cfg80211 exported function tracing

Bill Pemberton (121):
      ARCNET: remove __dev* attributes
      can: remove __dev* attributes
      drivers/net/ethernet/amd/am79c961a.c: remove __dev* attributes
      i825xx/ether1.c: remove __dev* attributes
      i825xx: remove __dev* attributes
      3c59x: remove __dev* attributes
      typhoon: remove __dev* attributes
      3c509: remove __dev* attributes
      8390: remove __dev* attributes
      acenic: remove __dev* attributes
      starfire: remove __dev* attributes
      bfin_mac: remove __dev* attributes
      aeroflex: remove __dev* attributes
      pcnet32: remove __dev* attributes
      b44: remove __dev* attributes
      bnx2: remove __dev* attributes
      tg3: remove __dev* attributes
      bna: remove __dev* attributes
      cxgb3: remove __dev* attributes
      cxgb4: remove __dev* attributes
      cxgb4vf: remove __dev* attributes
      chelsio: remove __dev* attributes
      enic: remove __dev* attributes
      dm9000: remove __dev* attributes
      dlink: remove __dev* attributes
      fs_enet: remove __dev* attributes
      be2net: remove __dev* attributes
      ehea: remove __dev* attributes
      hp100: remove __dev* attributes
      ibmveth: remove __dev* attributes
      ibm/emac: remove __dev* attributes
      skge: remove __dev* attributes
      mlx4_core: remove __dev* attributes
      enc28j60: remove __dev* attributes
      natsemi: remove __dev* attributes
      vxge/s2io: remove __dev* attributes
      nuvoton: remove __dev* attributes
      forcedeth: remove __dev* attributes
      lpc_eth: remove __dev* attributes
      net/octeon_mgmt: remove __dev* attributes
      packetengines: remove __dev* attributes
      netxen: remove __dev* attributes
      qlcnic: remove __dev* attributes
      qla3xxx: remove __dev* attributes
      qlge: remove __dev* attributes
      r8169: remove __dev* attributes
      8139too: remove __dev* attributes
      r6040: remove __dev* attributes
      seeq: remove __dev* attributes
      sfc: remove __dev* attributes
      sc92031: remove __dev* attributes
      stmmac: remove __dev* attributes
      sis190: remove __dev* attributes
      sis900: remove __dev* attributes
      smc91x: remove __dev* attributes
      smsc911x: remove __dev* attributes
      smc911x: remove __dev* attributes
      smsc9420: remove __dev* attributes
      tulip: remove __dev* attributes
      epic100: remove __dev* attributes
      cpmac: remove __dev* attributes
      tlan: remove __dev* attributes
      cpsw: remove __dev* attributes
      tehuti: remove __dev* attributes
      tc35815: remove __dev* attributes
      via-rhine: remove __dev* attributes
      via-velocity: remove __dev* attributes
      xilinx_axienet: remove __dev* attributes
      ixp4xx_eth: remove __dev* attributes
      icplus: remove __dev* attributes
      jme: remove __dev* attributes
      net/amd: remove __dev* attributes
      net/apple: remove __dev* attributes
      net/atheros: remove __dev* attributes
      net/cadence: remove __dev* attributes
      net/freescale: remove __dev* attributes
      net/micrel: remove __dev* attributes
      net/pasemi: remove __dev* attributes
      net/sgi: remove __dev* attributes
      net/sun: remove __dev* attributes
      net/davinci_emac: remove __dev* attributes
      net/ps3_gelic_net: remove __dev* attributes
      net/spider_net: remove __dev* attributes
      net/ps3_gelic_wireless: remove __dev* attributes
      net/wiznet: remove __dev* attributes
      net/xilinx: remove __dev* attributes
      net/ethernet: remove __dev* attributes
      fddi: remove __dev* attributes
      hippi: remove __dev* attributes
      ieee802154: remove __dev* attributes
      irda: remove __dev* attributes
      net/phy: remove __dev* attributes
      virtio_net: remove __dev* attributes
      vmxnet3: remove __dev* attributes
      dscc4: remove __dev* attributes
      farsync: remove __dev* attributes
      net/hdlc: remove __dev* attributes
      ixp4xx_hss: remove __dev* attributes
      net/lmc: remove __dev* attributes
      xen-netfront: remove __dev* attributes
      net/broadcom: remove __dev* attributes
      bnx2x: remove __dev* attributes
      net/intel: remove __dev* attributes
      rfkill: remove __dev* attributes
      wireless: remove __dev* attributes
      ath5k: remove __dev* attributes
      atmel: remove __dev* attributes
      b43: remove __dev* attributes
      brcm80211: remove __dev* attributes
      ipw2x00: remove __dev* attributes
      iwlegacy: remove __dev* attributes
      iwlwifi: remove __dev* attributes
      libertas: remove __dev* attributes
      mwl8k: remove __dev* attributes
      orinoco: remove __dev* attributes
      p54: remove __dev* attributes
      rt2x00: remove __dev* attributes
      rtl8187: remove __dev* attributes
      rtl8187: remove __dev* attributes
      wlcore/wl18xx/wl12xx: remove __dev* attributes
      rtlwifi: remove __dev* attributes

Bing Zhao (2):
      mwifiex: use sizeof(array) to print_hex_dump_bytes
      mwifiex: process RX packets in SDIO IRQ thread directly

Bj√∏rn Mork (12):
      net: cdc_ncm: workaround NTB input size firmware bug
      net: cdc_ncm: process chained NDPs
      net: cdc_ncm: splitting rx_fixup for code reuse
      net: cdc_ncm: refactoring for tx multiplexing
      net: cdc_ncm: export shared symbols and definitions
      net: cdc_mbim: build the MBIM driver
      net: cdc_ncm: do not bind to NCM compatible MBIM devices
      net: cdc_ncm: map MBIM IPS SessionID to VLAN ID
      net: cdc_mbim: Device Service Stream support
      net: cdc_ncm: big endian fix
      net: cdc_ncm: error path lock fix
      net: sierra: shut up sparse restricted type warnings

Brian Haley (1):
      sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name

Bruce Allan (1):
      e1000e: cosmetic cleanup of comments

Carolyn Wyborny (13):
      igb: Update get cable length function for i210/i211
      igb: Update version
      igb: Update firmware version info for ethtool output.
      igb: Remove workaround for EEE configuration on i210/I211
      igb: Add function to read i211's invm version
      igb: Fix EEPROM writes via ethtool on i210
      igb: Clear Go Link Disconnect for 82580 and later devices
      igb: Updates to read nvm function for i211 device
      igb: Refactoring of i210 file.
      igb: Workaround for global device reset problem on 82580.
      igb: Unset sigdetect for SERDES loopback on 82580 and i350
      igb: Fix SerDes autoneg flow control.
      igb: Update igb version to 4.1.2

Chaitanya (1):
      mac80211: warn only once if ampdu_action isn't assigned

Christian Lamparter (7):
      carl9170: handle traps from firmware loader
      carl9170: fix spurious transmissions in sniffer mode
      carl9170: split up carl9170_handle_mpdu
      p54: improve TSF timestamp precision
      carl9170: fix signal strength reporting issues
      carl9170: explain why sta cannot be NULL for ampdus
      carl9170: fix copy and paste mishap in carl9170_handle_mpdu

Christoph Paasch (1):
      sctp: Fix compiler warning when CONFIG_DEBUG_SECTION_MISMATCH=y

Chuansheng Liu (1):
      can: janz-ican3: Fix the usage of wait_for_completion_timeout

Claudio Fontana (1):
      net/ipv4/ipconfig: add device address to a KERN_INFO message

Claudiu Manoil (1):
      gianfar: Fix alloc_skb_resources on -ENOMEM cleanup path

Cong Ding (2):
      tools:virtio: fix compilation warning
      ssb: use WARN in main.c

Cong Wang (6):
      net: fix some compiler warning in net/core/neighbour.c
      bridge: export multicast database via netlink
      rtnetlink: add missing message types to selinux perm table
      bridge: fix seq check in br_mdb_dump()
      bridge: notify mdb changes via netlink
      bridge: add support of adding and deleting mdb entries

Cyril Roelandt (1):
      bna: remove useless calls to memset().

Dan Carpenter (7):
      orinoco_usb: clean up some signedness issues
      brcmfmac: Using zero instead of NULL
      ar5523: make buffer size variable unsigned
      ath5k: precedence error in ath5k_hw_nic_wakeup()
      mac80211: fix potential NULL dereference
      p54: potential signedness issue in p54_parse_rssical()
      bridge: make buffer larger in br_setlink()

Daniel Borkmann (8):
      packet: minor: remove unused err assignment
      pktgen: clean up ktime_t helpers
      sparc: bpf_jit_comp: add VLAN instructions for BPF JIT
      doc: packet_mmap: update doc to implementation status
      ARM: net: bpf_jit_32: add XOR instruction for BPF JIT
      ARM: net: bpf_jit_32: add VLAN instructions for BPF JIT
      PPC: net: bpf_jit_comp: add XOR instruction for BPF JIT
      PPC: net: bpf_jit_comp: add VLAN instructions for BPF JIT

Daniel Pieczko (2):
      sfc: Work-around flush timeout when flushes have completed
      sfc: lock TX queues when calling netif_device_detach()

Daniel Stamer (1):
      rtlwifi: rtl8192se: Fixed coding style issues in the driver

Daniel Wagner (5):
      cgroup: net_prio: Mark local used function static
      cgroup: net_cls: Fix local variable type decleration
      cgroup: net_cls: Remove rcu_read_lock/unlock
      cgroup: net_cls: Pass in task to sock_update_classid()
      cgroup: net_cls: Rework update socket logic

David Howells (4):
      UAPI: Fix compilation of the wanxl firmware blob.
      UAPI: (Scripted) Disintegrate include/linux/hdlc
      Fix the wanxl firmware to include missing constants
      Make the wanxl firmware array const

David S. Miller (40):
      Merge branch 'at91'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      net: Update args to dummy sock_update_classid().
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'tipc_net-next' of git://git.kernel.org/.../paulg/linux
      Merge git://git.kernel.org/.../davem/net
      Revert "8139cp: revert "set ring address before enabling receiver""
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge git://git.infradead.org/users/dwmw2/atm
      Merge tag 'dev_removal' of git://git.kernel.org/.../gregkh/net-next
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      ipv6: Protect ->mc_forwarding access with CONFIG_IPV6_MROUTE
      bridge: implement multicast fast leave
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'tipc_net-next_v2' of git://git.kernel.org/.../paulg/linux

David Stevens (1):
      add DOVE extensions for VXLAN

David Woodhouse (14):
      8139cp: set ring address after enabling C+ mode
      8139cp: enable bql
      8139cp: re-enable interrupts after tx timeout
      atm: br2684: Fix excessive queue bloat
      solos-pci: wait for pending TX to complete when releasing vcc
      atm: add release_cb() callback to vcc
      br2684: don't send frames on not-ready vcc
      pppoatm: fix missing wakeup in pppoatm_send()
      br2684: fix module_put() race
      pppoatm: optimise PPP channel wakeups after sock_owned_by_user()
      solos-pci: clean up pclose() function
      solos-pci: use GFP_KERNEL where possible, not GFP_ATOMIC
      solos-pci: remove list_vccs() debugging function
      solos-pci: fix double-free of TX skb in DMA mode

Dayanidhi Sreenivasan (1):
      r8169: remove unused macros.

Dengke Qiu (1):
      ath6kl: fix link speed when using sgi

Denis Kirjanov (2):
      Bluetooth:Replace list_for_each with list_for_each_entry() helper
      sundance: Enable WoL support

Devendra Naga (2):
      realtek: r8169: use module_pci_driver macro
      dlink: dl2k: use the module_pci_driver macro

Dmitry Kasatkin (1):
      Bluetooth: Add function to derive AMP key using hmac

Dmitry Kravkov (1):
      bnx2x: Filter packets on FCoE rings

Don Skidmore (3):
      ixgbe: Add function ixgbe_reset_pipeline_82599
      ixgbe: Add support for pipeline reset
      ixgbe: bump version number

Doug Goldstein (1):
      vlan: set sysfs device_type to 'vlan'

Eddie Wai (1):
      cnic: Fix rare race condition during iSCSI disconnect.

Eliad Peller (1):
      mac80211: make remain_on_channel() op pass vif param

Emil Tantilov (4):
      ixgbe: add WOL support for new subdevice id
      ixgbe: clean up the condition for turning on/off the laser
      ixgbe: fix default setting of TXDCTL.WTHRESH
      ixgbevf: fix possible use of uninitialized variable

Emmanuel Grumbach (32):
      iwlwifi: wipe out the status of the SCD when we disable a queue
      iwlwifi: use the new macro for the SCD Q STTS bits
      iwlwifi: first deactivate a queue, then wipe out its data
      iwlwifi: don't print the Intel banner twice
      iwlwifi: don't WARN when a non empty queue is disabled
      iwlwifi: don't leak Tx skb when a queue is disabled
      iwlwifi: handle RFKILL logic in the transport layer
      iwlwifi: don't call stop_device twice
      iwlwifi: check the SCD conf from ALIVE response
      iwlwifi: zero trans_cfg before settings its fields
      mac80211: include export.h in aes_cmac
      iwlwifi: don't warn if transport's allocation failed
      iwlwifi: don't enable interrupt as a W/A when MSI is enabled
      iwlwifi: add comments for the PCIe transport statuses
      iwlwifi: rename functions in transport layer
      iwlwifi: init the replenish work in rx_init
      iwlwifi: continue clean up - pcie/rx.c
      iwlwifi: continue clean up - pcie/trans.c
      iwlwifi: continue clean up - pcie/tx.c
      iwlwifi: merge 2 functions in reclaim flow
      iwlwifi: make iwl_queue_used return bool
      iwlwifi: more cleanup in pcie/rx.c
      iwlwifi: make iwl_pcie_rxq_inc_wr_ptr static
      iwlwifi: update the RB_TIMEOUT to 0x11
      iwlwifi: remove effectless assignment
      iwlwifi: read the Rx write pointer only once
      iwlwifi: clear trans->op_mode pointer when it is leaving
      iwlwifi: return real info in probe failure
      iwlwifi: move prph handling into the transport
      iwlwifi: reset_ict in stop_hw
      iwlwifi: silently ignore fw flaws in Tx path
      iwlwifi: don't handle masked interrupt

Eric Dumazet (23):
      pkt_sched: use ns_to_ktime() helper
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
      tcp: speedup SIOCINQ ioctl
      ipv4: 16 slots in initial fib_info hash table
      ipv4: tcp: clean up tcp_v4_early_demux()
      net: filter: add vlan tag access
      x86: bpf_jit_comp: add vlan tag support
      tcp: better retrans tracking for defer-accept
      ipv4: avoid a test in ip_rt_put()
      htb: fix two bugs
      mlx4: change TX coalescing defaults
      ipip: add GSO support
      net: use right lock in __dev_remove_offload
      ipv4: ipmr: various fixes and cleanups
      net: move inet_dport/inet_num in sock_common
      tcp: change default tcp hash size
      net: fix sparse endianness warnings on sock_common
      ipv6: avoid taking locks at socket dismantle
      bnx2x: use netdev_alloc_frag()
      net: fix a race in gro_cell_poll()
      net: gro: dev_gro_receive() cleanup
      net: gro: avoid double copy in skb_gro_receive()
      pkt_sched: avoid requeues if possible

Eric Lapuyade (7):
      NFC: HCI check presence must not fail when driver doesn't support it
      NFC: Separate pn544 hci driver in HW dependant and independant parts
      NFC: Fix hci_connect_gate() when a pre-opened pipe is passed
      NFC: Ignore err when chip doesn't implement HW/SW info registers
      NFC: Dot not dispatch HCI event received on unopened pipe
      NFC: Export nfc_hci_result_to_errno as it can be needed by HCI drivers
      NFC: Export nfc_hci_sak_to_protocol()

Eric W. Biederman (18):
      netns: Deduplicate and fix copy_net_ns when !CONFIG_NET_NS
      userns: make each net (net_ns) belong to a user_ns
      sysctl: Pass useful parameters to sysctl permissions
      net: Don't export sysctls to unprivileged users
      net: Push capable(CAP_NET_ADMIN) into the rtnl methods
      net: Update the per network namespace sysctls to be available to the network namespace owner
      net: Allow userns root to force the scm creds
      net: Allow userns root control of the core of the network stack.
      net: Allow userns root to control ipv4
      net: Allow userns root to control ipv6
      net: Allow userns root to control llc, netfilter, netlink, packet, and xfrm
      net: Allow userns root to control the network bridge code.
      net: Allow the userns root to control vlans.
      net: Enable some sysctls that are safe for the userns root
      net: Enable a userns root rtnl calls that are safe for unprivilged users
      net: Make CAP_NET_BIND_SERVICE per user namespace
      net: Allow userns root to control tun and tap devices
      netfilter: Remove the spurious \ in __ip_vs_lblc_init

Erik Hugne (2):
      tipc: return POLLOUT for sockets in an unconnected state
      tipc: remove obsolete flush of stale reassembly buffer

Eytan Lifshitz (1):
      iwlwifi: Change define and struct names in iwl-eeprom-parse.h

Felix Fietkau (4):
      Revert "ath9k_hw: Update AR9003 high_power tx gain table"
      ath9k_hw: Fix signal strength / channel noise reporting
      ath5k: fix tx path skb leaks
      b43: fix tx path skb leaks

Flavio Leitner (1):
      netxen: explicity handle pause autoneg parameter

Florian Fainelli (1):
      mwl8k: remove useless pci shutdown callback and stray debugging

Florian Westphal (4):
      netfilter: ipv6: add getsockopt to retrieve origdst
      netfilter: ipv6: only provide sk_bound_dev_if for link-local addr
      netfilter: kill support for per-af queue backends
      netfilter: ctnetlink: nla_policy updates

Frank Li (6):
      net: fec: move fec_enet_private to header file
      ARM: dts: imx6q: Add ENET PTP clock pin and clock source
      ARM: imx6q: Set enet tx reference clk from anatop to support 1588
      FEC: Add time stamping code and a PTP hardware clock
      net: fec: default select FEC_PTP at mx6 platform
      net: fec: reduce spin lock time in fec_ptp_adjfreq

Franky Lin (7):
      brcmfmac: fix sparse warnings
      brcmfmac: streamline header parse code of sdio glom read
      brcmfmac: use dynamically allocated control frame buffer
      brcmfmac: decrease the range of SDIO access lock
      brcmfmac: protect consecutive SDIO access with sdio_claim_host
      brcmfmac: remove brcmf_sdbrcm_wait_for_event
      brcmfmac: change return type of brcmf_sdio_hdparser

Fr√©d√©ric Dalleau (2):
      Bluetooth: Add BT_DEFER_SETUP option to sco socket
      Bluetooth: Implement deferred sco socket setup

Gabor Juhos (10):
      rt2x00: rt2800lib: fix indentation of some rt2x00_rt calls
      rt2x00: rt2800lib: fix indentation in rt2800_init_rfcsr
      rt2x00: rt2800lib: remove trailing semicolons from RFCSR3_* defines
      rt2x00: rt2800lib: introduce RFCSR3_VCOCAL_EN
      ath9k: ar9003: fix OTP register offsets for AR9340
      ath9k: move duplicated debug message to 'ath9k_hw_nvram_read'
      ath9k: add EEPROM offset to debug message
      ath9k: use 'struct ath_hw *' as the first argument for 'ath9k_hw_nvram_read'
      ath9k: allow to load EEPROM content via firmware API
      ath9k: check pdata variable before dereferencing it

Giuseppe CAVALLARO (6):
      stmmac: remove dead code for STMMAC_TIMER support
      stmmac: add the initial tx coalesce schema
      stmmac: add Rx watchdog support to mitigate the DMA irqs
      stmmac: get/set coalesce parameters via ethtool
      stmmac: update the doc with new IRQ mitigation
      stmmac: update the driver version to Nov_2012

Greg Kroah-Hartman (1):
      drivers/net: fix up function prototypes after __dev* removals

Greg Rose (17):
      ixgbevf: Check for error on dma_map_single call
      ixgbevf: Update version string
      ixgbe: Fix return value from macvlan filter function
      ixgbe: Return success or failure on VF MAC filter set
      ixgbevf: Do not forward LLDP type frames
      igbvf: Check for error on dma_map_single call
      ixgbevf: Add flag to indicate when rx is in net poll
      ixgbevf: Reduce size of maximum rx buffer
      ixgbevf: Streamline the rx buffer allocation
      ixgbevf: Fix unnecessary dereference where local var is available.
      ixgbevf: Remove the ring adapter pointer value
      ixgbevf: Remove checking for mac.ops function pointers
      ixgbevf: Remove mailbox spinlock from the reset function
      ixgbevf: White space and comments clean up
      ixgbevf: Remove unneeded and obsolete comment
      ixgbevf: Add checksum statistics counters to rings
      ixgbe: Make the bridge mode setting sticky

Greg Suarez (4):
      USB: cdc: add MBIM constants and structures
      net: cdc_ncm: adding MBIM support to ncm_setup
      net: cdc_ncm: refactor bind preparing for MBIM support
      net: cdc_mbim: adding MBIM driver

Gustavo Padovan (14):
      Bluetooth: Fix two warnings in BT_DBG
      Bluetooth: Fix L2CAP coding style
      Bluetooth: Remove GFP_ATOMIC usage from l2cap_core.c
      Bluetooth: use l2cap_chan_set_err()
      Bluetooth: Use locked l2cap_state_change()
      Bluetooth: Call ops->teardown() without checking for NULL
      Bluetooth: Move bt_accept_enqueue() to l2cap_sock.c
      Bluetooth: Add chan->ops->defer()
      Bluetooth: Rename __l2cap_connect() to l2cap_connect()
      Bluetooth: Replace *_init() for *_setup()
      Bluetooth: Add missing lock nesting notation
      Bluetooth: cancel power_on work when unregistering the device
      Bluetooth: Move double negation to macros
      Revert "Bluetooth: Fix possible deadlock in SCO code"

Haiyang Zhang (2):
      hyperv: Remove unnecessary comments in rndis_filter_receive_data()
      hyperv: Add an error message to rndis_filter_set_device_mac()

Hannes Frederic Sowa (2):
      veth: allow changing the mac address while interface is up
      ipv6: add knob to send unsolicited ND on link-layer address change

Hans Zhang (1):
      netlink: cleanup the unnecessary return value check

Hante Meuleman (28):
      brcmfmac: refactor firmware interface layer.
      brcmfmac: remove unused iswl variable.
      brcmfmac: change testmode command to use new firmware interface layer
      brcmfmac: remove redundant function brcmf_c_mkiovar_bsscfg
      brcmfmac: clean usb download code.
      brcmfmac: use fwil for default configuration setup.
      brcmfmac: remove obsolete i-scan and clean up related code.
      brcmfmac: use fwil for netdev callbacks.
      brcmfmac: handle exceptions in brcmf_bus_start correct.
      brcmfmac: use wait_event_timeout for 8021x pending count
      brcmfmac: fix pkt_filter sizeof calculation.
      brcmfmac: remove obsolete function brcmf_c_mkiovar
      brcmfmac: return immediately error for out of range key_idx.
      brcmfmac: check bus state to be data before sending data.
      brcmfmac: on halting driver check before release or free.
      brcmfmac: add dedicated USB log level.
      brcmfmac: cleanup of usb firmware download routines
      brcmfmac: usb suspend/resume.
      brcmfmac: fix NULL pointer access in brcmf_fweh_detach()
      brcmfmac: Any error should result in failure of probe.
      brcmfmac: Handle mmc exceptions during init correct.
      brcmfmac: sdio unload fix.
      brcmfmac: avoid usage of func->card->dev in sdio probe.
      brcmfmac: sdio module load fix.
      brcmfmac: limit hex dump on fwil.
      brcmfmac: code cleanup
      brcmfmac: fix bug in setting mgmt ie and parsing vndrs ie.
      brcmfmac: change debug output for received event.

Harro Haan (1):
      add Marvell 88W8688 support to libertas_sdio

Hauke Mehrtens (34):
      bcma: just do the necessary things in early register on SoCs
      bcma: init sprom struct earlier
      bcma: mark pflash as present when available
      bcma: add and use constants for the flash windows
      bcma: mark nflash if it is the boot flash
      bcma: extract drv_cc in bcma_core_mips_flash_detect()
      bcma: add some more flash chips for serial flash
      ssb: move parallel flash config into an own struct
      ssb: add attribute to indicate a parallel flash is available
      bcma: use fallback sprom if sprom on card was not valid
      bcma: add an extra pcie core struct
      bcma: do not initialize deactivated PCIe cores
      ssb: add PCI ID 0x4350
      ssb: handle BCM43222 in pmu code.
      bcma: add more package IDs
      bcma: handle return value of pci_assign_resource
      ssb: extif: fix compile errors
      ath9k: use SIMPLE_DEV_PM_OPS
      p54pci: use SIMPLE_DEV_PM_OPS
      rtlwifi: use SIMPLE_DEV_PM_OPS
      ssb/bcma: add common header for watchdog
      bcma: add bcma_chipco_alp_clock
      bcma: set the pmu watchdog if available
      bcma: add methods for watchdog driver
      bcma: register watchdog driver
      ssb: get alp clock from devices with PMU
      ssb: set the PMU watchdog if available
      ssb: add methods for watchdog driver
      ssb: extif: add check for max value before setting watchdog register
      ssb: extif: add methods for watchdog driver
      ssb: register watchdog driver
      brcmsmac: add support for cores with revision 17
      brcmsmac: do a read after the write of the objmem on broken PCIe controllers
      brcmsmac: add support for BCM43224 with PCI id of 14e4:a8d8

Havard Skinnemoen (4):
      net/macb: memory barriers cleanup
      net/macb: change debugging messages
      net/macb: clean up ring buffer logic
      net/macb: Offset first RX buffer by two bytes

Helmut Schaa (5):
      mac80211: reject setting masked mac addresses
      mac80211: don't reinit rate control when mesh sta exists
      rt2x00: Use addr_mask to disallow invalid MAC addresses in mutli-bssid mode
      mac80211: skip radiotap space calculation if no monitor exists
      rt2x00: Only specify interface combinations if more then one interface is possible

Hila Gonen (1):
      cfg80211: add wrappers for registered_device_ops

Jacob Keller (6):
      ixgbe: (PTP) refactor init, cyclecounter and reset
      ixgbe: fix uninitialized event.type in ixgbe_ptp_check_pps_event
      ixgbe: use ETQF filter name instead of magic number
      ixgbe: remove needless queuing for L4 ptp packets
      ixgbe: ethtool correctly identify autoneg setting
      ixgbe: check whether thermal sensor is enabled.

Jakub Kicinski (1):
      ixgbevf: make sure probe fails on MSI-X enable error

Jan Glauber (2):
      3com: make 3c59x depend on HAS_IOPORT
      chelsio: remove get_clock and use ktime_get

Jason Wang (11):
      tuntap: log the unsigned informaiton with %u
      tuntap: move socket to tun_file
      tuntap: RCUify dereferencing between tun_struct and tun_file
      tuntap: introduce multiqueue flags
      tuntap: multiqueue support
      tuntap: add ioctl to attach or detach a file form tuntap device
      tuntap: choose the txq based on rxq
      tuntap: attach queue 0 before registering netdevice
      virtio-net: separate fields of sending/receiving queue from virtnet_info
      virtio_net: multiqueue support
      virtio-net: support changing the number of queue pairs through ethtool

Jaume Delcl√≤s (1):
      Wireless: rt2x00: Add device id for Sweex LW323 to rt2800usb.c

Jean-Christophe PLAGNIOL-VILLARD (5):
      net/macb: add pinctrl consumer support
      net: at91_ether: add dt support
      net: at91_ether: add pinctrl support
      net: add micrel KSZ8873MLL switch support
      asix: use ramdom hw addr if the one read is not valid

Jeff Cook (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Jefferson Delfes (1):
      Bluetooth: Force the process of unpair command if disconnect failed

Jesper Dangaard Brouer (8):
      ipvs: Trivial changes, use compressed IPv6 address in output
      ipvs: IPv6 extend ICMPv6 handling for future types
      ipvs: Use config macro IS_ENABLED()
      ipvs: Fix faulty IPv6 extension header handling in IPVS
      ipvs: Complete IPv6 fragment handling for IPVS
      ipvs: API change to avoid rescan of IPv6 exthdr
      ipvs: SIP fragment handling
      ipvs: fix build errors related to config option combinations

Jesse Brandeburg (1):
      maintainers: update with official intel support link, new maintainer

Jesse Gross (2):
      ipv6: Move ipv6_find_hdr() out of Netfilter code.
      openvswitch: Use RCU callback when detaching netdevices.

Jiri Benc (1):
      ixgbe: reduce PTP rx path overhead

Jiri Bohac (1):
      bonding: delete migrated IP addresses from the rlb hash table

Jiri Pirko (1):
      net: call notifiers for mtu change even if iface is not up

Jiri Slaby (1):
      MAINTAINERS: fix bouncing tun/tap entries

Joachim Eastwood (31):
      net/macb: add AT91RM9200 specific registers and bits to header
      net/at91_ether: use macb register definitions
      net/at91_ether: use macb access functions
      net/at91_ether: use macb defs for rx dma buffers
      net/at91_ether/macb: absorb at91_private in to macb private struct
      net/at91_ether: use pclk member instead of ether_clk
      net/macb: export some symbols for at91_ether
      net/at91_ether: compile macb for exported functions
      net/at91_ether: use ethtool and mdio from macb
      net/at91_ether: share macb_set_rx_mode with macb
      net/at91_ether: use macb dma description struct
      net/at91_ether: clean up rx buffer handling
      net/at91_ether: convert to devm_* functions
      ARM: AT91: remove old RM9200 EMAC register definitions
      net/macb: fix truncate warnings
      net/cadence: get rid of HAVE_NET_MACB
      net/at91_ether: select MACB in Kconfig
      net/at91_ether: add pdata flag for reverse Eth addr
      net/cadence: depend on HAS_IOMEM
      net/macb: check all address registers sets
      net/macb: support reversed hw addr
      net/macb: export macb_set_hwaddr and macb_get_hwaddr
      net/at91_ether: use macb functions for get/set hwaddr
      net/at91_ether: use stat function from macb
      net/at91_ether: drop board_data private struct member
      net/at91_ether: clean up print outs
      net/at91_ether: fix comment and style issues
      net/phy/davicom: add irq functions to DM9161E and DM9161A
      net/macb: add support for phy irq via gpio pin
      net/macb: clear unused address register
      net/ethernet: remove useless is_valid_ether_addr from drivers ndo_open

Joe Perches (9):
      pktgen: Use ipv6_addr_any
      ethernet: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
      wireless: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
      smsc: Add logging message newlines
      MAINTAINERS: Add Q: patchwork entries for net/ and drivers/net/
      ipv4/ipmr and ipv6/ip6mr: Convert int mroute_do_<foo> to bool
      brcmsmac: Add __printf verification to logging prototypes
      ip6mr: Add sizeof verification to MRT6_ASSERT and MT6_PIM
      ixgbe: Use is_valid_ether_addr

Johan Hedberg (19):
      Bluetooth: Add initial support for LE-only controllers
      Bluetooth: Fix LE MTU reporting for HCIGETDEVINFO
      Bluetooth: Add setting of the LE event mask
      Bluetooth: Read adversiting channel TX power during init sequence
      Bluetooth: Fix HCI command sending when powering on LE-only adapters
      Bluetooth: mgmt: Restrict BR/EDR settings to BR/EDR-only adapters
      Bluetooth: Fix updating host feature bits for LE
      Bluetooth: Add missing feature test macros
      Bluetooth: Make use feature test macros
      Bluetooth: Add flag for LE GAP Peripheral role
      Bluetooth: Disallow LE scanning and connecting in peripheral role
      Bluetooth: Fix setting host feature bits for SSP
      Bluetooth: Fix sending unnecessary HCI_Write_SSP_Mode command
      Bluetooth: Fix unnecessary EIR update during powering on
      Bluetooth: Fix sending unnecessary HCI_LE_Host_Enable
      Bluetooth: Fix parameter order of hci_get_route
      Bluetooth: Use proper invalid value for tx_power
      Bluetooth: Add support for setting LE advertising data
      Bluetooth: Fix updating advertising state flags and data

Johannes Berg (99):
      iwlwifi: improve oversized command warning
      iwlwifi: make data frame tracing optional
      iwlwifi: remove unused variables
      mac80211: check channel context methods
      mac80211: track whether to use channel contexts
      mac80211: use channel contexts
      mac80211: track needed RX chains for channel contexts
      mac80211: add channel context iterator
      wireless: use OR operation to set wiphy features
      mac80211: remove unimplemented mesh vendor sync
      mac80211: remove some unused code
      mac80211: use __printf attribute in debugfs
      mac80211: fix WDS channel context test
      cfg80211: add tracing for P2P Device start/stop
      mac80211: use non-atomic bitmap operation for local variable
      mac80211: complete bss_info tracing
      mac80211: a few formatting fixes
      mac80211: move AP teardown code to correct place
      mac80211: add explicit AP/GO driver operations
      iwlwifi: support host command with copied data
      iwlwifi: clarify NOCOPY/DUP documentation
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      mac80211_hwsim: allow using channel contexts
      nl80211: move "can set channel" check
      cfg80211: allow per interface TX power setting
      mac80211: handle TX power per virtual interface
      mac80211_hwsim: print per interface TX power
      mac80211: combine status/drop reporting
      mac80211: use a counter for remain-on-channel cookie
      mac80211: send deauth only with channel context
      iwlwifi: fix flush command
      iwlwifi: don't clear CTL_AMPDU on frame status
      iwlwifi: fix queue flush confusion
      iwlwifi: use list_first_entry
      wireless: add utility function to get P2P attribute
      mac80211: pass P2P powersave parameters to driver
      iwlwifi: remove EEPROM version message by default
      iwlwifi: remove SKU/antenna messages by default
      iwlwifi: remove useless messages
      iwlwifi: fix typo in RX data tracing
      mac80211: use mac_pton
      mac80211: fix race in TKIP MIC test debugfs file
      mac80211: use kstrtoull return value
      mac80211: fix TX error path
      mac80211: add debugfs file for HW queues
      mac80211: remove unused tracepoint
      mac80211: call driver method when restart completes
      mac80211: clarify interface iteration and make it configurable
      mac80211: reassign channel contexts before stations
      iwlwifi: return commands with error on FW error
      mwifiex: don't select lib80211
      lib80211: hide Kconfig symbol
      iwlwifi: disallow MFP with software crypto
      mac80211: use CMAC_PN_LEN
      mac80211: introduce IEEE80211_NUM_TIDS and use it
      mac80211: support radiotap vendor namespace RX data
      net: remove unnecessary wireless includes
      mac80211: fix channel context suspend/reconfig handling
      mac80211: fix radiotap vendor area skipping
      mac80211: fix RX chains configuration
      mac80211: rename IEEE80211_STA_DISABLE_11N to HT
      mac80211: disable HT advertising unless AP supports it
      cfg80211: use DS or HT operation IEs to determine BSS channel
      mac80211: fix managed mode channel flags handling
      cfg80211: remove remain-on-channel channel type
      nl80211: add documentation for channel type
      cfg80211: pass a channel definition struct
      nl80211/cfg80211: support VHT channel configuration
      mac80211: convert to channel definition struct
      nl80211/cfg80211: add VHT MCS support
      mac80211: support drivers reporting VHT RX
      mac80211: support VHT rates in TX info
      wireless: add definitions for VHT MCS support
      mac80211_hwsim: advertise VHT support
      mac80211_hwsim: remove printing scan config
      cfg80211: fix some tracing output issues
      iwlegacy: initialize rx_status
      iwlwifi: initialize rx_status
      cfg80211: rework chandef checking and export it
      mac80211: support VHT association
      mac80211: support (partial) VHT radiotap information
      nl80211: support P2P GO powersave configuration
      mac80211: support P2P GO powersave configuration
      nl80211: remove unnecessary checks
      cfg80211: don't BUG_ON BSS struct issues
      cfg80211: fix whitespace in scan handling
      cfg80211: fix cmp_hidden_bss
      mac80211: make ieee80211_build_preq_ies safer
      mac80211: remove probe response temporary buffer allocation
      cfg80211: fix BSS struct IE access races
      mac80211: simplify loop in minstrel_ht
      mwifiex: fix struct member mismatch
      cfg80211: check no-OFDM flag for channels wider than 20 MHz
      wireless: fix VHT max AMPDU exponent definition
      mac80211: cancel work instead of waiting for it to do nothing
      iwlwifi: change TX code to suppress smatch warning
      wext: explicitly cast -110 to u8
      mac80211: a few whitespace fixes
      minstrel: update stats after processing status

John Fastabend (9):
      ixgbevf: make netif_napi_add and netif_napi_del symmetric
      ixgbevf: fix softirq-safe to unsafe splat on internal mbx_lock
      net, ixgbe: handle link local multicast addresses in SR-IOV mode
      net: create generic bridge ops
      net: set and query VEB/VEPA bridge mode via PF_BRIDGE
      ixgbe: add setlink, getlink support to ixgbe and ixgbevf
      net: fix bridge notify hook to manage flags correctly
      ixgbe: fdb: only allow NUD_PERM fdb entries
      net: Allow DCBnl to use other namespaces besides init_net

John Greene (1):
      8139cp: properly support change of MTU values [v2]

John W. Linville (30):
      Merge branch 'master' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge tag 'nfc-next-3.8-1' of git://git.kernel.org/.../sameo/nfc-3.0
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge tag 'nfc-next-3.8-2' of git://git.kernel.org/.../sameo/nfc-3.0
      brcmfmac: check return from kzalloc in brcmf_fweh_process_event
      brcmfmac: include linux/vmalloc.h from usb.c
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      rtl8723ae: fix build break from "mac80211: support RX_FLAG_MACTIME_END"
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge tag 'nfc-fixes-3.7-2' of git://git.kernel.org/.../sameo/nfc-3.0
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      rt2800usb: reorganize 2001:3c1e in usb id table Wi-Fi adapter
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.sipsolutions.net/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jon Maloy (2):
      tipc: introduce message to synchronize broadcast link
      tipc: change sk_receive_queue upper limit

Joseph Gasparakis (3):
      net: Add support for hardware-offloaded encapsulation
      vxlan: capture inner headers during encapsulation
      vxlan: Add capability of Rx checksum offload for inner packet

Josh Hay (2):
      ixgbe: add/update descriptor maps in comments
      ixgbe: Reformat output of ixgbe_dump

Jouni Malinen (5):
      mac80211: Take status code as parameter to ieee80211_send_auth
      mac80211: Add debug print on unexpect authentication state
      cfg80211: Allow user space to specify non-IEs to SAE Authentication
      mac80211: Allow station mode SAE to be implemented in user space
      cfg80211: Add TDLS event to allow drivers to request operations

Jozsef Kadlecsik (2):
      netfilter: ipset: Increase the number of maximal sets automatically
      netfilter: nf_nat: Handle routing changes in MASQUERADE target

Julia Lawall (2):
      drivers/net/ethernet/ibm/emac/mal.c: use WARN
      drivers/net/wireless/ath/ath6kl/hif.c: drop if around WARN_ON

Kalle Valo (5):
      ath6kl: move ath6kl_wmi_startscan_cmd()
      ath6kl: refactor wmi scan command
      ath6kl: add support for changing contry code
      ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
      ath6kl: support NL80211_USER_REG_HINT_CELL_BASE events

Kees Cook (3):
      NFC: Remove CONFIG_EXPERIMENTAL
      NFC: Remove CONFIG_EXPERIMENTAL from the LLCP Makefile
      NFC: Remove CONFIG_EXPERIMENTAL from the NCI Makefile

Kirill Smelkov (2):
      r8169: Kill SafeMtu macro
      r8169: Drop tp arg from rtl8169_tx_vlan_tag()

Krzysztof Mazur (7):
      atm: add owner of push() callback to atmvcc
      pppoatm: allow assign only on a connected socket
      pppoatm: fix module_put() race
      pppoatm: take ATM socket lock in pppoatm_send()
      pppoatm: drop frames to not-ready vcc
      pppoatm: do not inline pppoatm_may_send()
      br2684: allow assign only on a connected socket

Kumar Amit Mehta (2):
      drivers: ethernet: qlogic: qlge_dbg.c: Fixed a coding style issue
      drivers: ethernet: qlogic: netxen_nic_ethtool.c: Fixed a coding style issue

Larry Finger (6):
      rtlwifi: rtl8192c: rtl8192ce: Add support for B-CUT version of RTL8188CE
      rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192se: rtl8192de: Shorten some variable names
      rtlwifi: rtl8723ae: Add new driver
      rtlwifi: Modify files for addition of rtl8723ae
      rtlwifi: rtl8192ce: rtl8192cu: rtl8192se: rtl81723ae: Turn on building of the new driver
      b43legacy: Fix firmware loading when driver is built into the kernel

Lee Jones (1):
      bridge: Avoid 'statement with no effect' compiler warnings

Li RongQing (2):
      ipv6: remove rt6i_peer_genid from rt6_info and its handler
      ipv6: remove obsolete comments in route.c

Lino Sanfilippo (1):
      sky2: fix cleanup sequence in probe() function

Luis R. Rodriguez (2):
      carl9170: kill MODULE_VERSION
      brcmfmac: convert struct spinlock to spinlock_t

Mahesh Palivela (4):
      ieee80211: Rename VHT cap struct
      mac80211: VHT peer STA caps
      {nl,cfg}80211: Peer STA VHT caps
      cfg80211: Remove unused VHT chan code

Maia Kozheva (1):
      rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-Fi adapter

Marc Kleine-Budde (14):
      net: sched: enable CAN Identifier to be build into kernel
      can: bfin_can: add MODULE_ALIAS
      can: ti_hecc: add MODULE_ALIAS
      can: sja1000_platform: add MODULE_ALIAS
      can: cc770_platform: add MODULE_ALIAS and MODULE_DEVICE_TABLE
      can: flexcan: add MODULE_DEVICE_TABLE
      can: at91_can: add MODULE_DEVICE_TABLE
      can: c_can_platform: add MODULE_DEVICE_TABLE
      can: mpc5xxx_can: add MODULE_DEVICE_TABLE
      can: mscan: remove obsolete variable open_time
      can: sja1000: remove obsolete variable open_time
      can: ems_usb: remove obsolete variable open_time
      can: esd_usb2: remove obsolete variable open_time
      can: pcan_usb_core: remove obsolete variable open_time

Marcel Holtmann (3):
      NFC: Remove unused details from pn544.h header file
      NFC: Move pn544.h to linux/platform_data/
      MAINTAINERS: Add reference to pn544.h platform data header

Marco Porsch (8):
      mac80211: fix copy-paste typo in Kconfig
      mac80211: make client powersave independent of interface type
      mac80211: move Mesh Capability field definition to ieee80211.h
      mac80211: refactor ieee80211_set_qos_hdr
      mac80211: remove mesh config macros from mesh_plink.c
      mac80211: fix for mesh sync to indicate TBTT adjustment
      cfg80211: fix channel error on mesh join
      mac80211: don't drop mesh peering frames from unknown STA

Marek Lindner (3):
      batman-adv: split hard_iface struct for each routing protocol
      batman-adv: consolidate duplicated primary_if checking code
      batman-adv: sysfs documentation should keep alphabetical order

Marina Makienko (1):
      ath6kl: check usb_register() return value

Martin Hundeb√∏ll (2):
      batman-adv: Add get_ethtool_stats() support for DAT
      batman-adv: Add wrapper to look up neighbor and send skb

Masanari Iida (2):
      isdn: Fix typo in drivers/isdn
      wireless: mwifiex: Fix typo in wireless/mwifiex driver

Mat Martineau (20):
      Bluetooth: Process create response and connect response identically
      Bluetooth: Factor out common L2CAP connection code
      Bluetooth: Add new l2cap_chan struct members for high speed channels
      Bluetooth: Add L2CAP create channel request handling
      Bluetooth: Remove unnecessary intermediate function
      Bluetooth: Lookup channel structure based on DCID
      Bluetooth: Channel move request handling
      Bluetooth: Add new ERTM receive states for channel move
      Bluetooth: Add move channel confirm handling
      Bluetooth: Add state to hci_chan
      Bluetooth: Move channel response
      Bluetooth: Add logical link confirm
      Bluetooth: Add move confirm response handling
      Bluetooth: Handle physical link completion
      Bluetooth: Flag ACL frames as complete for AMP controllers
      Bluetooth: Do not send data during channel move
      Bluetooth: Configure appropriate timeouts for AMP controllers
      Bluetooth: Ignore BR/EDR packet size constraints when fragmenting for AMP
      Bluetooth: Do not retransmit data during a channel move
      Bluetooth: Start channel move when socket option is changed

Matt Carlson (4):
      tg3: PTP - Add header definitions, initialization and hw access functions.
      tg3: PTP - Implement the ptp api and ethtool functions
      tg3: PTP - Add the hardware timestamp ioctl
      tg3: PTP - Enable the timestamping feature in hardware and fill skb tx/rx timestamps

Matthew Leach (3):
      net: dm9000: use io{read,write}*_rep accessors
      net: 8390: use io{read,write}*_rep accessors
      net: smc911x: use io{read,write}*_rep accessors

Matthew Vick (4):
      igb: Enable auto-crossover during forced operation on 82580 and above.
      igb: Update PTP Rx filters
      igb: No longer rely on APME to determine WoL settings
      igb: Use a 32-bit mask when calculating the flow control watermarks

Matthias Fuchs (2):
      can: usb: esd_usb2: Add support for listen-only mode
      can: usb: esd_usb2: Add support for CAN-USB/Micro

Maxime Bizon (1):
      e1000: fix concurrent accesses to PHY from watchdog and ethtool

Mehak Mahajan (1):
      openvswitch: Process RARP packets with ethertype 0x8035 similar to ARP packets.

Merav Sicron (3):
      bnx2x: HSI change for 'update' ramrod
      bnx2x: Support loading cnic resources at run-time
      bnx2x: Add static declaration to several functions

Michael Chan (9):
      tg3: Support 5717 C0
      tg3: Use tp->rxq_cnt when checking RSS tables.
      cnic: Reset iSCSI EQ during shutdown.
      bnx2: Rename register read and write macros
      bnx2: Add BNX2 prefix to descriptor structures and macros
      bnx2: Add BNX2 prefix to CHIP ID and name macros
      cnic: Include bnx2x.h
      cnic, bnx2x, bnx2: Simplify cnic probing.
      bnx2: Fix accidental reversions.

Michael S. Tsirkin (14):
      skb: report completion status for zero copy skbs
      skb: api to report errors for zero copy skbs
      tun: report orphan frags errors to zero copy callback
      vhost-net: cleanup macros for DMA status tracking
      vhost: track zero copy failures using DMA length
      vhost: move -net specific code out
      vhost-net: select tx zero copy dynamically
      vhost-net: reduce vq polling on tx zerocopy
      vhost-net: initialize zcopy packet counters
      tun: only queue packets on device
      vhost: avoid backend flush on vring ops
      vhost-net: flush outstanding DMAs on memory change
      vhost-net: skip head management if no outstanding
      vhost-net: enable zerocopy tx by default

Michal Kazior (4):
      mac80211: introduce channel context skeleton code
      mac80211: introduce new ieee80211_ops
      mac80211: use channel context notifications
      mac80211: reuse channels for channel contexts

Michal Kubeƒçek (1):
      bonding: in balance-rr mode, set curr_active_slave only if it is up

Michele Baldessari (1):
      sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call

Ming Lei (16):
      usbnet: introduce usbnet 3 command helpers
      usbnet: asix: apply introduced usb command APIs
      usbnet: cdc-ncm: apply introduced usb command APIs
      usbnet: dm9601: apply introduced usb command APIs
      usbnet: int51x1: apply introduced usb command APIs
      usbnet: mcs7830: apply introduced usb command APIs
      usbnet: net1080: apply introduced usb command APIs
      usbnet: plusb: apply introduced usb command APIs
      usbnet: sierra_net: apply introduced usb command APIs
      usbnet: smsc75xx: apply introduced usb command APIs
      usbnet: smsc95xx: apply introduced usb command APIs
      usbnet: introduce usbnet_{read|write}_cmd_nopm
      usbnet: smsc75xx: apply the introduced usbnet_{read|write}_cmd_nopm
      usbnet: smsc95xx: fix memory leak in smsc95xx_suspend
      usbnet: smsc95xx: apply the introduced usbnet_{read|write}_cmd_nopm
      usbnet: runtime wake up device before calling usbnet_{read|write}_cmd

Mitch A Williams (2):
      igbvf: work around i350 erratum
      igbvf: update version number

Mohammed Shafi Shajakhan (12):
      mac80211: Use appropriate debug wrapper
      ath6kl: trivial cleanup on interface type selection
      ath6kl: Remove obselete USB device related checks
      ath6kl: Return error case when ath6kl_usb_alloc_pipe_resources fails
      ath6kl: Rename ATH6KL_HW_FLAG_64BIT_RATES
      ath6kl: Fix inactivity timeout for AR6004
      ath6kl: Fix mapping uplink endpoint for AR6004
      ath6kl: Add a hardware flag for SDIO CRC error workaround
      ath9k: Ensure we set FTP_STOMP_LOW weight when WLAN is idle
      ath9k_htc: Advertise interface combinations supported
      ath9k_htc: Remove interface combination specific checks
      ath9k: Advertize beacon_int_infra_match

Mugunthan V N (6):
      drivers: net: ethernet: cpsw: add multicast address to ALE table
      net: cpsw: halt network stack before halting the device during suspend
      ARM: OMAP3+: hwmod: Add AM33XX HWMOD data for davinci_mdio module
      ARM: OMAP2+: omap2plus_defconfig: Enable CPSW support
      arm/dts: am33xx: Add CPSW and MDIO module nodes for AM33XX
      net: ethernet: cpsw: fix build warnings for CPSW when CPTS not selected

Muhammad Ghias (1):
      can: sja1000: plx_pci: add support for Connect Tech Inc's Canpro/104-Plus Opto CAN board

Nathan Williams (1):
      solos-pci: Fix leak of skb received for unknown vcc

Neal Cardwell (2):
      ipv6: tcp: clean up tcp_v6_early_demux() icsk variable
      tcp: remove dead prototype for tcp_v4_get_peer()

Neil Horman (4):
      sctp: Make hmac algorithm selection for cookie generation dynamic
      MAINTAINERS: Add myself to list of SCTP maintainers
      sctp: Clean up type-punning in sctp_cmd_t union
      sctp: send abort chunk when max_retrans exceeded

Nick Bowler (1):
      phylib: mdio: Add sysfs attribute for PHY identifiers.

Nicolas Dichtel (38):
      ipv6: add support of equal cost multipath (ECMP)
      ipv6: fix sparse warnings in rt6_info_hash_nhsfn()
      rtnl: add a new type of msg to advertise protocol configuration
      rtnl/ipv6: use netconf msg to advertise forwarding status
      rtnl/ipv6: add support of RTM_GETNETCONF
      rtnl/ipv4: use netconf msg to advertise forwarding status
      rtnl/ipv4: add support of RTM_GETNETCONF
      rtnl/ipv4: use netconf msg to advertise rp_filter status
      ipv6/multipath: remove flag NLM_F_EXCL after the first nexthop
      ndisc: fix a typo in a comment in ndisc_recv_na()
      ipip: advertise tunnel param via rtnl
      sit: advertise tunnel param via rtnl
      ip6tnl: advertise tunnel param via rtnl
      ip6tnl/rtnl: add IFLA_IPTUN_PROTO on dump
      ip6tnl: rename rtnl functions for consistency
      ip6tnl: add support of link creation via rtnl
      ipip: always notify change when params are updated
      ipip/rtnl: add IFLA_IPTUN_PMTUDISC on dump
      ipip: add support of link creation via rtnl
      sit: always notify change when params are updated
      sit/rtnl: add missing parameters on dump
      sit: rename rtnl functions for consistency
      sit: add support of link creation via rtnl
      ipip: fix sparse warnings in ipip_netlink_parms()
      sit: fix sparse warnings
      ip6tnl: fix sparse warnings in ip6_tnl_netlink_parms()
      ipv6: export IP6_RT_PRIO_* to userland
      sit: allow to configure 6rd tunnels via netlink
      ip6tnl/sit: drop packet if ECN present with not-ECT
      netconf: advertise mc_forwarding status
      ip6mr: use nla_nest_* helpers
      ipmr/ip6mr: advertise mfc stats via rtnetlink
      ipmr/ip6mr: report origin of mfc entry into rtnl msg
      ipmr/ip6mr: allow to get unresolved cache via netlink
      ipmr: advertise new mfc entries via rtnl
      ip6mr: advertise new mfc entries via rtnl
      ip6mr: fix rtm_family of rtnl msg
      ipv4/route/rtnl: get mcast attributes when dst is multicast

Nicolas Ferre (6):
      net/macb: remove macb_get_drvinfo()
      net/macb: tx status is more than 8 bits now
      net/macb: ethtool interface: add register dump feature
      net/macb: better manage tx errors
      net/macb: move to circ_buf macros and fix initial condition
      net/macb: GEM DMA configuration register update

Nishant Sarmukadam (3):
      mwl8k: Unmap the pci DMA address in xmit error path
      mwl8k: Do not expire eapol frames
      mwl8k: Set packet timestamp to 0 when life time expiry is not used

Nithin Nayak Sujir (5):
      tg3: Call tg3_netif_stop() from tg3_stop()
      tg3: Set 10_100_ONLY flag for additional 10/100 Mbps devices
      tg3: Prevent spurious tx timeout by setting carrier off before tx disable.
      tg3: Cleanup hardcoded ethtool test array indexes
      tg3: Fix inconsistent locking for tg3_netif_start().

Nobuhiro Iwamatsu (2):
      irda: sh-irda: Remove SH7367 support
      irda: sh-irda: Remove SH7377 support

Olivier Sobrie (1):
      can: kvaser_usb: Add support for Kvaser CAN/USB devices

Pablo Neira Ayuso (3):
      Merge branch 'master' of git://git.kernel.org/.../horms/ipvs-next
      netfilter: nf_conntrack: improve nf_conn object traceability
      netfilter: ctnetlink: dump entries from the dying and unconfirmed lists

Padmanabh Ratnakar (15):
      be2net: Fix driver load failure for different FW configs in Lancer
      be2net: Fix setting QoS for VF for Lancer
      be2net: Fix change MAC operation for VF for Lancer
      be2net: Wait till resources are available for VF in error recovery
      be2net: Fix configuring VLAN for VF for Lancer
      be2net: Fix error messages while driver load for VFs
      be2net: Fix ethtool get_settings output for VF
      be2net: Fix issues in error recovery due to wrong queue state
      be2net: Fix unnecessary delay in PCI EEH
      be2net: Fix VF driver load on newer Lancer FW
      be2net: Enabling Wake-on-LAN is not supported in S5 state
      be2net: Fix FW flashing on Skyhawk-R
      be2net: Fix skyhawk VF PCI Device ID
      be2net: Update driver version
      be2net: Fix smatch warnings in be_main.c

Pandiyarajan Pitchaimuthu (5):
      ath6kl: Make use of return value from ath6kl_diag_read()
      ath6kl: Max clients reached notification
      ath6kl: Blocked client notification
      ath6kl: Array index out of bounds check
      ath6kl: Check for valid endpoint ID in ath6kl_tx_complete()

Paolo Valente (1):
      pkt_sched: QFQ Plus: fair-queueing service at DRR cost

Parikh, Neerav (1):
      ixgbe: Fix incorrect disabling of Tx hang check in case of PFC

Patrice Vilchez (1):
      net/macb: Add support for Gigabit Ethernet mode

Patrick Trantham (2):
      net: phy: smsc: Re-enable EDPD mode for LAN87xx
      net: phy: smsc: Fix config_init typo

Paul Bolle (3):
      atp: remove set_rx_mode_8012()
      ewrk3: silence GCC warning
      ewrk3: remove outdated comment

Paul Chavent (1):
      packet: tx_ring: allow the user to choose tx data offset

Paul Gortmaker (3):
      tipc: delete TIPC_ADVANCED Kconfig variable
      tipc: standardize across connect/disconnect function naming
      tipc: refactor accept() code for improved readability

Paul Marks (1):
      ipv6: Fix default route failover when CONFIG_IPV6_ROUTER_PREF=n

Paul Moore (1):
      tun: correctly report an error in tun_flow_init()

Pavel Emelyanov (4):
      unix: Remove unused field from unix_sock
      sockopt: Make SO_BINDTODEVICE readable
      sock-diag: Report shutdown for inet and unix sockets (v2)
      sk-filter: Add ability to get socket filter program (v2)

Peter Senna Tschudin (1):
      ath/ath9k/ar9003_eeprom.c: Remove semicolon after if

Piotr Haber (7):
      ssb: fix SPROM offset
      brcmsmac: handle packet drop during transmit correctly
      brcmsmac: cleanup in isr code
      brcmsmac: fix bounds checking in tx/rx
      brcmsmac: hardware info in debugfs
      brcmsmac: move PHY functions
      brcmsmac: support 4313iPA

Pontus Fuchs (3):
      ar5523: Add new driver
      ar5523: Fix sparse endianness warnings
      ar5523: Don't dereference sta if NULL

Rafa≈Ç Mi≈Çecki (2):
      bcma: unify naming schema for clock functions
      bcma: mips: fix clearing device IRQ

Raja Mani (3):
      ath6kl: Avoid null ptr dereference while printing reg domain pair
      ath6kl: Check for valid rate table index
      ath6kl: Check for valid endpoint ID values in ath6kl_control_tx()

Rajkumar Manoharan (24):
      ath9k: perform ANI cycle in idle state
      ath9k: Send WLAN channel info to BT
      ath9k: Add concurrent WLAN and BT tx support for MCI based chips
      ath9k: fill channel mode in caldata
      ath9k: adjust WLAN and BT concurrent transmission
      ath9k_hw: Enable OSLA hw fix for AR9565
      ath9k_hw: Fix selfgen chainmask for 9565
      ath9k_hw: Disable MCI stat counter by default for AR9565
      ath9k_hw: Fix frequent BT rx recovery
      ath9k_hw: Fix max rx rate drop for AR9565
      ath9k_hw: Configure new switch table for AR9565 BTCOEX
      ath9k_hw: Set default MCI config for AR9565
      ath9k: adjust duty cycle for FTP profile for AR9565
      ath9k: Add new BT profile info A2DP_Voice
      ath9k_hw: Enable hw PLL power save for AR9462
      ath9k_hw: Enable hw PLL power save for AR9565
      ath9k_hw: Fix concurrent tx on lower tx power
      ath9k_hw: validate MCI stuck after RTC wakeup
      ath9k: Dump BTCOEX tuning parameters
      ath9k_hw: Fix wrong peak detector DC offset
      ath9k: Process FATAL interrupts at first
      ath9k: Fix MCI reset in BT cal_req
      ath9k: stomp audio profiles on weak signal strength
      ath9k: Fix buffer overflow error

Rami Rosen (9):
      Bluetooth: remove unused member of hci_dev.
      net:dev: remove double indentical assignment in dev_change_net_namespace().
      mac80211: remove duplicate check in ieee80211_rx_mgmt_beacon
      vxlan: remove unused variable.
      tun: change tun_get_iff() prototype.
      vtun: fix typos.
      tun: put correct method name in a debug message.
      core: make GRO methods static.
      rtnelink: remove unused parameter from rtnl_create_link().

Rasesh Mody (7):
      bna: Code Cleanup and Enhancements
      bna: Tx and Rx Optimizations
      bna: TX Intr Coalescing Fix
      bna: Rx Page Based Allocation
      bna: Add RX State
      bna: Firmware update
      bna: Driver Version Updated to 3.1.2.1

Richard Cochran (21):
      ptp: add an ioctl to compare PHC time with system time
      bfin_mac: only advertise hardware time stamped when enabled.
      bfin_mac: replace sys time stamps with raw ones instead.
      bfin_mac: offer a PTP Hardware Clock.
      time: remove the timecompare code.
      cpsw: rename register banks to match the reference manual
      cpsw: add missing fields to the CPSW_SS register bank.
      cpsw: remember the silicon version
      cpsw: support both silicon versions
      cpts: introduce time stamping code and a PTP hardware clock.
      cpsw: add a DT field for the cpts offset
      cpsw: add a DT field for the active time stamping port
      cpts: specify the input clock frequency via DT
      cpsw: support the HWTSTAMP ioctl and the CPTS
      ptp: fixup Kconfig for two PHC drivers.
      cpsw: rename register banks to match the reference manual, part 2
      cpsw: fix leaking IO mappings
      cpsw: simplify the setup of the register pointers
      ptp: reduce stack usage when reading external time stamps
      ptp: reduce stack usage when measuring the system time offset
      cpts: add missing kconfig dependency

Rick Jones (2):
      doc: make the description of how tcp_ecn works more explicit and clear
      doc: Tighten-up and clarify description of tcp_fin_timeout

Rob Herring (6):
      net: calxedaxgmac: enable operate on 2nd frame mode
      net: calxedaxgmac: remove explicit rx dma buffer polling
      net: calxedaxgmac: use raw i/o accessors in rx and tx paths
      net: calxedaxgmac: drop some unnecessary register writes
      net: calxedaxgmac: rework transmit ring handling
      net: calxedaxgmac: ip align receive buffers

Sachin Kamat (5):
      iwlwifi: Remove duplicate inclusion of iwl-trans.h in pcie/drv.c
      vhost: Remove duplicate inclusion of linux/vhost.h
      bnx2x: Remove duplicate inclusion of bnx2x_hsi.h
      caif: Remove redundant null check before kfree in cfctrl.c
      net: Remove redundant null check before kfree in dev.c

Sam Leffler (4):
      {nl,cfg}80211: add a flags word to scan requests
      cfg80211: add scan flag to indicate its priority
      cfg80211: add support for flushing old scan results
      mac80211: add support for tx to abort low priority scan requests

Samuel Ortiz (17):
      NFC: Avoid falling back to SYMM when sk is NULL
      NFC: Use llcp_allocate_pdu to build the DISC frames
      NFC: Add SNL frame building routine
      NFC: Initial SNL support
      NFC: Reserve LLCP ssap when replying to an SNL frame
      NFC: Check for connection less sockets when looking for a service name
      NFC: Keep connection less bound sockets alive when DEP link goes down
      NFC: Handle LLCP UI frames
      NFC: Forward LLCP datagrams to userspace
      NFC: UI frame sending routine implementation
      NFC: Implement LLCP connection less Tx path
      NFC: Return NULL when no LLCP socket for a dsap,ssap couple is found
      NFC: Use IDR library to assing NFC devices IDs
      NFC: Purge LLCP socket Tx queues when being disconnected
      NFC: Copy user space buffer when sending UI frames
      NFC: Stop sending LLCP frames when tx queues are getting too deep
      NFC: Queue a copy of the transmitted LLCP skb

Saravana (5):
      mac80211: add debugfs file for last ack signal
      mac80211: add debugfs file for current tx rate
      mac80211: re-organize the rx rate calculation logic
      mac80211: add debugfs file for last rx rate
      mac80211: add debug file for mic failure

Sasha Levin (2):
      Bluetooth: don't attempt to free a channel that wasn't created
      vmxnet3: convert BUG_ON(true) into a simple BUG()

Sathya Perla (9):
      be2net: remove LANCER A0 workaround
      be2net: fix wrong usage of adapter->generation
      be2net: do not use sli_family to identify skyhawk-R chip
      be2net: re-factor bar mapping code
      be2net: fix access to SEMAPHORE reg
      be2net: remove roce on lancer
      be2net: remove adapter->eq_next_idx
      be2net: fix a possible events_get() race on BE2
      be2net: fix INTx ISR for interrupt behaviour on BE2

Serge Hallyn (1):
      net: dev_change_net_namespace: send a KOBJ_REMOVED/KOBJ_ADD

Seth Forshee (25):
      brcmsmac: Introduce AMPDU sessions for assembling AMPDUs
      brcmsmac: Don't weight AMPDU packets in txfifo
      brcmsmac: Add helper function for updating txavail count
      brcmsmac: Remove unimplemented flow control functions
      brcmsmac: Use IEEE 802.11 AC levels for pktq precedence levels
      brcmsmac: Remove internal tx queue
      brcmsmac: Use correct descriptor count when calculating next rx descriptor
      brcmsmac: Reduce number of entries in tx DMA rings
      brcm80211: Allow trace support to be enabled separately from debug
      brcm80211: Convert log message levels to debug levels
      brcmsmac: Add module parameter for setting the debug level
      brcmsmac: Add support for writing debug messages to the trace buffer
      brcmsmac: Use debug macros for general error and debug statements
      brcmsmac: Add brcms_dbg_mac80211() debug macro
      brcmsmac: Add rx and tx debug macros
      brcmsmac: Add brcms_dbg_int() debug macro
      brcmsmac: Add brcms_dbg_dma() debug macro
      brcmsmac: Add brcms_dbg_ht() debug macro
      brcmsmac: Improve tx trace and debug support
      brcmsmac: Add tracepoint for macintstatus
      brcmsmac: Add tracepoint for AMPDU session information
      brcmsmac: Remove some noisy and uninformative debug messages
      brcmsmac: Remove unused wlc_prio2prec_map and _BRCMS_PREC_* constants
      brcmsmac: Remove stray argument from debug macro
      brcmsmac: Fix possible NULL pointer dereference in _dma_ctrlflags()

Shahed Shaikh (1):
      qlcnic: fix sparse check endian warnings

Shan Wei (7):
      net: xfrm: use __this_cpu_read per-cpu helper
      net: openvswitch: use this_cpu_ptr per-cpu helper
      net: core: use this_cpu_ptr per-cpu helper
      net: rds: use this_cpu_* per-cpu helper
      net: neighbour: prohibit negative value for unres_qlen_bytes parameter
      net: doc: add default value for neighbour parameters
      net: doc : use more suitable word 'unexpected' to replace 'secluded'

Shmulik Ladkani (2):
      ipv6: unify logic evaluating inet6_dev's accept_ra property
      ipv6: Make 'addrconf_rs_timer' send Router Solicitations (and re-arm itself) if Router Advertisements are accepted

Simon Wunderlich (11):
      batman-adv: don't allow ECTP traffic on batman-adv
      batman-adv: don't rely on positions in struct for hashing
      batman-adv: send announcement when backbone gw is registered
      batman-adv: allow bla traffic only after first worker period
      batman-adv: wait multiple periods before activating bla
      batman-adv: fix bla compare function
      batman-adv: Fix broadcast duplist for fragmentation
      nl80211: Fix HT_IBSS feature check in ibss_join
      mac80211: Fix typo in mac80211.h
      mac80211: return if CSA is not handle
      mac80211: adapt slot time in IBSS mode

Sony Chacko (15):
      qlcnic: fix compiler warnings
      qlcnic: fix sparse warnings
      qlcnic: create file qlcnic_io.c for datapath routines
      qlcnic: fix coding style issues in qlcnic_io.c
      qlcnic: create file qlcnic_sysfs.c for sysfs routines
      qlcnic: fix style issues in qlcnic_sysfs.c file
      qlcnic: create file qlcnic_minidump.c for dump utility
      qlcnic: fix coding style issues in qlcnic_minidump.c
      qlcnic: add 82xx adapter specific checks
      qlcnic: move HW specific data to seperate structure
      qlcnic: modify PCI and register access routines
      qlcnic: get board name API
      qlcnic: update NIC partition interface routines
      qlcnic: fix bug in LRO descriptor access macro
      qlcnic: rename module params with module_param_named

Stanislav Yakovlev (2):
      net/wireless: ipw2x00: remove unreachable code
      net/wireless: ipw2200: introduce ipw_set_geo function

Stanislaw Gruszka (9):
      rt2800: use BBP_R1 for setting tx power
      rt2800: limit TX_PWR_CFG_ values to 0xc
      rt2800: compensate tx power also for non 11b rates on 2GHz
      rt2800: use eeprom OFDM 6M TX power as criterion
      rt2800: pass channel pointer to rt2800_config_txpower
      rt2800: allow to reduce tx power on devices not exporting power limit
      rt2800: comment tx power settings
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"

Stefan Assmann (2):
      igb: remove duplicate code for fallback interrupt initialization
      igb: release already assigned MSI-X interrupts if setup fails

Stefan Raspl (4):
      qeth: Remove unused variable
      qeth: Clarify card type naming for virtual NICs
      qeth: Consolidate tracing of card features
      qeth: Remove BUG_ONs

Steffen Klassert (2):
      xfrm: Use a static gc threshold value for ipv6
      xfrm6: Remove commented out function call to xfrm6_input_fini

Stephan Gatzka (1):
      net/phy: Add interrupt support for dp83640 phy.

Steve Glendinning (22):
      smsc95xx: add wol support for more frame types
      smsc75xx: add wol support for more frame types
      smsc95xx: fix error checking of usbnet_resume
      smsc95xx: detect chip revision specific features
      smsc95xx: support PHY wakeup source
      smsc95xx: refactor entering suspend modes
      smsc75xx: check return code from smsc75xx_reset
      smsc75xx: refactor entering suspend modes
      smsc75xx: support PHY wakeup source
      smsc75xx: fix error handling in suspend failure case
      smsc75xx: add support for USB dynamic autosuspend
      smsc75xx: don't enable remote wakeup directly
      smsc75xx: don't call usbnet_resume if usbnet_suspend fails
      smsc75xx: expand check_ macros
      smsc95xx: fix suspend buffer overflow
      smsc95xx: fix error handling in suspend failure case
      smsc95xx: don't enable remote wakeup directly
      smsc95xx: fix smsc_crc return type
      smsc95xx: expand check_ macros
      smsc75xx: only set mac address once on bind
      smsc95xx: fix register dump of last register
      smsc95xx: fix async register writes on big endian platforms

Sujith Manoharan (29):
      mac80211: Notify new IBSS network creation
      cfg80211: Disallow HT/WEP in IBSS mode
      ath9k: Use a helper routine for MCI/FTP tuning
      ath9k: Fix BT_OP_SCAN usage
      ath9k_hw: Update AR9485 initvals
      ath9k: Remove unused workaround
      ath9k_hw: Program filter coefficients correctly
      ath9k: Fix BTCOEX debugfs file usage
      mac80211: Add debugfs callbacks for station addition/removal
      ath9k/ath9k_htc: Remove WME macros
      ath9k: Fix the 'xmit' debugfs file
      ath9k: Add a debugfs file to dump queue statistics
      ath9k: Fill remove_sta_debugfs() callback
      ath9k: Fix rate control debugging
      ath9k: Remove 'stations' debugfs file
      ath9k: Move ethtool functions to debug.c
      ath9k: Replace WME_NUM_TID with IEEE80211_NUM_TIDS
      ath9k: Implement sta_add_debugfs/sta_remove_debugfs
      ath9k: Remove redundant NULL assignment
      ath9k: Fix regression in 'xmit' debugfs file
      ath9k_hw: Fix PAPRD registers for AR9485
      ath9k_hw: Fix PAPRD training
      ath9k: Add a few debug messages for PAPRD
      ath9k: Fix redundant PS wrappers
      ath9k_hw: Various trivial fixes for PAPRD
      ath9k_hw: Fix PAPRD retraining for AR9485
      ath9k_hw: Add HW cap for PAPRD
      ath9k_hw: Calculate the correct training power for PAPRD
      ath9k_hw: Update intivals for AR9340

Sven Eckelmann (13):
      ath_hw: Use common REG_WRITE parameter order
      batman-adv: Remove unused define BAT_ATTR_HIF_UINT
      batman-adv: Set special lockdep classes to avoid lockdep warning
      batman-adv: Remove extra check in batadv_bit_get_packet
      batman-adv: Check return value of try_module_get
      batman-adv: Only increase refcounter once for alternate router
      batman-adv: Reserve extra bytes in skb for better alignment
      batman-adv: Mark correctly aligned headers not as __packed
      batman-adv: Remove instant overwritten variable initialization
      batman-adv: Mark best gateway in transtable_global debugfs
      batman-adv: Add function to calculate crc32c for the skb payload
      batman-adv: Start new development cycle
      batman-adv: Use packing of 2 for all headers before an ethernet header

Syam Sidhardhan (7):
      Bluetooth: Use __constant modifier for L2CAP SMP CID
      Bluetooth: Use __constant modifier for RFCOMM PSM
      Bluetooth: trivial: Remove newline before EOF
      Bluetooth: Replace include linux/module.h with linux/export.h
      Bluetooth: Remove unnecessary include export.h
      Bluetooth: mgmt: Use __constant when dealing with constants
      ath5k: Use module_platform_driver macro for ahb.c

Szymon Janc (9):
      NFC: Use NFC_MAX_GT_LEN to check len in nci_set_local_general_bytes
      NFC: Remove not needed local variable in nci_set_local_general_bytes
      NFC: Remove unneeded LLCP function return calls
      NFC: Small nfc_hci_create_pipe refactoring
      NFC: Fix not propagating return code in nfc_hci_clear_all_pipes
      NFC: Fix style issues with logical operations
      NFC: Fix some code style and whitespace issues
      Bluetooth: Increase HCI command tx timeout
      Bluetooth: Remove OOB data if device was discovered in band

Thierry Escande (3):
      NFC: Set rf_mode to NFC_RF_NONE where necessary
      NFC: Add NFC_ATTR_RF_MODE when sending device netlink properties
      NFC: Extend netlink interface for LTO, RW, and MIUX parameters support

Thomas Graf (3):
      sctp: verify length provided in heartbeat information parameter
      sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
      sctp: Add RCU protection to assoc->transport_addr_list

Thomas Pedersen (12):
      mac80211: mesh STAs only process mesh beacons
      ath6kl: support rssi threshold for sched scan
      ath6kl: support TX error rate notification
      ath6kl: configure wow filters per-vif
      ath6kl: restart concurrent vifs on failed connect
      ath6kl: reconfigure RSN capabilities when restarting AP
      ath6kl: rework scheduled scan
      ath6kl: consolidate WoW pattern length
      mac80211: support RX_FLAG_MACTIME_END
      ath9k: RX timestamp is reported at end of frame
      ath9k_htc: RX timestamp is reported at end of frame
      ath5k: RX timestamp is reported at end of frame

Tim Gardner (1):
      iwlwifi: iwlagn_request_scan: Fix check for priv->scan_request

Tommi Rantala (1):
      sctp: fix CONFIG_SCTP_DBG_MSG=y null pointer dereference in sctp_v6_get_dst()

Tushar Dave (3):
      igb: Correcting and improving small packet check and padding
      ixgbe: Correcting small packet padding
      e1000e: Minimum packet size must be 17 bytes

Ulrich Weber (1):
      xfrm: remove redundant replay_esn check

Ursula Braun (2):
      ctcm: remove BUG_ONs
      claw: remove BUG_ONs

Vaibhav Hiremath (2):
      net: davinci_mdio: Fix typo mistake in calling runtime-pm api
      net: cpsw: Add parent<->child relation support between cpsw and mdio

Vasanthakumar Thiagarajan (12):
      ath6kl: Fix potential skb double free in ath6kl_wmi_sync_point()
      ath6kl: Fix potential memory leak in ath6kl_tx_complete()
      ath6kl: Refactor ath6kl_init_hw_start() and ath6kl_init_hw_stop()
      ath6kl: Recover from fw crash
      ath6kl: Add support to detect fw error through heart beat
      ath6kl: Recover from "wmi ctrl ep is full" condition
      ath6kl: Fix bug in scheduling hb_timer
      ath6kl: Remove unnecessary recovery state check in ath6kl_recovery_hb_timer()
      ath6kl: Add a bit to ath6kl_dev_state for recovery cleanup state
      ath6kl: Make fw error recovery configurable
      ath6kl: Fix reconnection issue after recovery
      ath6kl: Fix random rx data corruption

Vimalkumar (1):
      htb: improved accuracy at high rates

Vincent Bernat (1):
      vxlan: allow a user to set TTL value

Vitalii Demianets (1):
      macb: Keep driver's speed/duplex in sync with actual NCFGR

Vlad Yasevich (17):
      net: Add generic packet offload infrastructure.
      net: Switch to using the new packet offload infrustructure
      net: Add net protocol offload registration infrustructure
      ipv6: Add new offload registration infrastructure.
      ipv4: Switch to using the new offload infrastructure.
      ipv6: Switch to using new offload infrastructure.
      ipv6: Separate ipv6 offload support
      ipv6: Separate tcp offload functionality
      ipv6: Separate out UDP offload functionality
      ipv6: Move exthdr offload support into separate file
      ipv6: Update ipv6 static library with newly needed functions
      ipv4: Pull GSO registration out of inet_init()
      ipv6: Pull IPv6 GSO registration out of the module
      net: Remove code duplication between offload structures
      net: Make IPv6 build depend on CONFIG_INET
      ipv6: Fix build error with udp_offload
      ipv6: Preserve ipv6 functionality needed by NET

Vladimir Kondratiev (1):
      wireless: allow Atheros card to not depend on ath.ko

Waldemar Rymarkiewicz (3):
      NFC: pn533: Fix in/out frame buffer allocation
      NFC: pn533: Remove unused arg parameter
      NFC: Fix incorrect llcp pointer dereference

Wei Yongjun (14):
      ixgbe: using is_zero_ether_addr() to simplify the code
      ath6kl: use list_move_tail instead of list_del/list_add_tail
      qla3xxx: use module_pci_driver to simplify the code
      qla3xxx: remove unused variable in ql_process_mac_tx_intr()
      ksz884x: use module_pci_driver to simplify the code
      ar5523: use module_usb_driver to simplify the code
      brcmfmac: remove duplicated include from dhd_dbg.c
      rtlwifi: use eth_zero_addr() to assign zero address
      ixgbe: convert to use simple_open()
      qlcnic: remove duplicated include from qlcnic_sysfs.c
      net: neterion: use for_each_pci_dev to simplify the code
      tcm_vhost: remove unused variable in vhost_scsi_allocate_cmd()
      brcmsmac: remove duplicated include from debug.c
      ipw2200: return error code on error in ipw_wx_get_auth()

Will Deacon (1):
      net: smc91x: use io{read, write}*_rep accessors instead of string functions

Willem de Bruijn (1):
      net: compute skb->rxhash if nic hash may be 3-tuple

Willy Tarreau (1):
      tcp: don't abort splice() after small transfers

Wu Fengguang (1):
      netfilter: nf_nat: use PTR_RET

YOSHIFUJI Hideaki (1):
      ndisc: Unexport ndisc_{build,send}_skb().

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (3):
      net: sh_eth: Fix a typo - replace regist with register.
      net: neterion: Do not break word unregister.
      ipv6 ndisc: Use pre-defined in6addr_linklocal_allnodes.

Yan Burman (3):
      net: ethtool: Add destination MAC address to flow steering API
      net/mlx4_en: Use generic etherdevice.h functions.
      net/mlx4_en: Add support for destination MAC in steering rules

Yaniv Rosner (11):
      bnx2x: Activate LFA
      bnx2x: Add support for 20G-KR2
      bnx2x: Change MDIO clock settings
      bnx2x: Fix SFP+ current leakage
      bnx2x: Add support for BCM84834
      bnx2x: Always take PHY lock
      bnx2x: Cosmetic changes
      bnx2x: Add warning message in case of non-10G SFP module
      bnx2x: Change duplex setting in EEE function
      bnx2x: Handle a rarely missed interrupt
      bnx2x: recognize fan failure

Yi Zou (1):
      8021q: fix vlan device to inherit the unicast filtering capability flag

Ying Xue (11):
      tipc: fix race/inefficiencies in poll/wait behaviour
      tipc: wake up all waiting threads at socket shutdown
      tipc: remove the bearer congestion mechanism
      tipc: remove supportable flag from bclink structure
      tipc: rename supported flag to recv_permitted
      tipc: eliminate an unnecessary cast of node variable
      tipc: eliminate aggregate sk_receive_queue limit
      tipc: consolidate connection-oriented message reception in one function
      tipc: introduce non-blocking socket connect
      tipc: eliminate connection setup for implied connect in recv_msg()
      tipc: add lock nesting notation to quiet lockdep warning

Yogesh Ashok Powar (3):
      mwl8k: defining interface combinations
      mwl8k: recheck if station still has valid rates
      mwl8k: Send BASTREAM firmware commands per vif

Yuanhan Liu (1):
      bcma: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP

Yuval Mintz (6):
      bnx2x: revised and corrected SPIO access
      bnx2x: Correct advertised speed/duplex
      bnx2x: nvram enables dropless flow control
      bnx2x: Ext. config accessed only on non-E1x.
      bnx2x: mask CPL_OF interrupt
      bnx2x: fix 'Ethtool -A' when autoneg

Zefir Kurtisi (3):
      ath9k: resolve name collision in DFS detector
      ath9k: fix memory leak in DFS pattern detector
      ath9k: [DFS] add pulse width tolerance for ETSI

Zhao Hongjiang (1):
      user_ns: get rid of duplicate code in net_ctl_permissions

fran√ßois romieu (1):
      r8169: workaround for missing extended GigaMAC registers

hayeswang (2):
      r8169: enable ALDPS for power saving
      r8169: enable internal ASPM and clock request settings

joshua.a.hay@intel.com (1):
      ixgbe: eliminate Smatch warnings in ixgbe_debugfs.c

stephen hemminger (9):
      tcp: make tcp_clear_md5_list static
      ppp: make ppp_get_stats64 static
      bridge: bridge port parameters over netlink
      bridge: add template for bridge port flags
      bridge: implement BPDU blocking
      bridge: add root port blocking
      vmxnet3: fix indentation
      tun: allow setting ethernet addresss while running
      uapi: add missing netconf.h to export list

trem (1):
      net: phy: smsc: force all capable mode if the phy is started in powerdown mode

viresh kumar (1):
      net: dsa/slave: Fix compilation warnings

walimis (1):
      stmmac: remove two repeated macros

zheng.li (1):
      bonding: rlb mode of bond should not alter ARP originating via bridge

 Documentation/ABI/testing/sysfs-bus-mdio                     |    9 +
 Documentation/ABI/testing/sysfs-class-net-batman-adv         |   11 +-
 Documentation/ABI/testing/sysfs-class-net-grcan              |   35 +
 Documentation/ABI/testing/sysfs-class-net-mesh               |   40 +-
 Documentation/devicetree/bindings/net/can/grcan.txt          |   28 +
 Documentation/devicetree/bindings/net/cdns-emac.txt          |   23 +
 Documentation/devicetree/bindings/net/cpsw.txt               |   48 +-
 Documentation/kernel-parameters.txt                          |   18 +
 Documentation/networking/batman-adv.txt                      |    3 +-
 Documentation/networking/ip-sysctl.txt                       |   56 +-
 Documentation/networking/packet_mmap.txt                     |  246 +++++-
 Documentation/networking/stmmac.txt                          |   28 +-
 MAINTAINERS                                                  |   27 +-
 arch/alpha/include/asm/socket.h                              |    1 +
 arch/arm/boot/dts/am335x-bone.dts                            |    8 +
 arch/arm/boot/dts/am335x-evm.dts                             |    8 +
 arch/arm/boot/dts/am33xx.dtsi                                |   48 +
 arch/arm/boot/dts/imx6q.dtsi                                 |    5 +-
 arch/arm/configs/omap2plus_defconfig                         |    3 +
 arch/arm/mach-at91/Kconfig                                   |    4 -
 arch/arm/mach-at91/board-csb337.c                            |    2 +
 arch/arm/mach-at91/include/mach/at91rm9200_emac.h            |  138 ---
 arch/arm/mach-imx/mach-imx6q.c                               |   12 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c                   |   31 +
 arch/arm/net/bpf_jit_32.c                                    |   29 +-
 arch/arm/net/bpf_jit_32.h                                    |    2 +
 arch/avr32/Kconfig                                           |    1 -
 arch/avr32/include/uapi/asm/socket.h                         |    1 +
 arch/cris/include/asm/socket.h                               |    1 +
 arch/frv/include/uapi/asm/socket.h                           |    1 +
 arch/h8300/include/asm/socket.h                              |    1 +
 arch/ia64/include/uapi/asm/socket.h                          |    1 +
 arch/m32r/include/asm/socket.h                               |    1 +
 arch/m68k/include/uapi/asm/socket.h                          |    1 +
 arch/mips/bcm47xx/nvram.c                                    |    4 +-
 arch/mips/bcm47xx/wgt634u.c                                  |    8 +-
 arch/mips/include/uapi/asm/socket.h                          |    1 +
 arch/mn10300/include/uapi/asm/socket.h                       |    1 +
 arch/parisc/include/uapi/asm/socket.h                        |    1 +
 arch/powerpc/include/asm/ppc-opcode.h                        |    3 +
 arch/powerpc/include/uapi/asm/socket.h                       |    1 +
 arch/powerpc/net/bpf_jit.h                                   |    6 +
 arch/powerpc/net/bpf_jit_comp.c                              |   25 +
 arch/s390/include/uapi/asm/socket.h                          |    1 +
 arch/sparc/include/uapi/asm/socket.h                         |    1 +
 arch/sparc/net/bpf_jit_comp.c                                |   19 +
 arch/x86/net/bpf_jit_comp.c                                  |   21 +
 arch/xtensa/include/uapi/asm/socket.h                        |    1 +
 drivers/atm/solos-pci.c                                      |   88 +-
 drivers/bcma/bcma_private.h                                  |    6 +-
 drivers/bcma/driver_chipcommon.c                             |  135 ++-
 drivers/bcma/driver_chipcommon_nflash.c                      |    3 +
 drivers/bcma/driver_chipcommon_pmu.c                         |   44 +-
 drivers/bcma/driver_chipcommon_sflash.c                      |   35 +-
 drivers/bcma/driver_mips.c                                   |   52 +-
 drivers/bcma/driver_pci_host.c                               |   24 +-
 drivers/bcma/host_pci.c                                      |    6 +-
 drivers/bcma/main.c                                          |   62 +-
 drivers/bcma/sprom.c                                         |    5 +-
 drivers/bluetooth/btmrvl_sdio.c                              |   28 +-
 drivers/bluetooth/btusb.c                                    |    1 +
 drivers/dma/ioat/dca.c                                       |   23 +
 drivers/isdn/hardware/mISDN/hfcpci.c                         |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c                      |    2 +-
 drivers/isdn/hisax/callc.c                                   |    2 +-
 drivers/isdn/hisax/hfc_pci.c                                 |    2 +-
 drivers/isdn/hisax/hfc_sx.c                                  |    2 +-
 drivers/isdn/mISDN/l1oip_core.c                              |    5 +-
 drivers/isdn/mISDN/tei.c                                     |   20 +-
 drivers/isdn/pcbit/layer2.c                                  |    2 +-
 drivers/net/arcnet/com20020-pci.c                            |    6 +-
 drivers/net/bonding/bond_alb.c                               |  197 ++++-
 drivers/net/bonding/bond_alb.h                               |   28 +-
 drivers/net/bonding/bond_debugfs.c                           |    5 +-
 drivers/net/bonding/bond_main.c                              |   19 +-
 drivers/net/bonding/bonding.h                                |   13 +
 drivers/net/can/Kconfig                                      |    9 +
 drivers/net/can/Makefile                                     |    1 +
 drivers/net/can/at91_can.c                                   |    9 +-
 drivers/net/can/bfin_can.c                                   |    7 +-
 drivers/net/can/c_can/c_can.c                                |   12 +
 drivers/net/can/c_can/c_can.h                                |    3 +
 drivers/net/can/c_can/c_can_pci.c                            |    8 +-
 drivers/net/can/c_can/c_can_platform.c                       |   36 +-
 drivers/net/can/cc770/cc770_isa.c                            |   18 +-
 drivers/net/can/cc770/cc770_platform.c                       |   18 +-
 drivers/net/can/dev.c                                        |    3 +-
 drivers/net/can/flexcan.c                                    |   12 +-
 drivers/net/can/grcan.c                                      | 1756 ++++++++++++++++++++++++++++++++++++
 drivers/net/can/janz-ican3.c                                 |   28 +-
 drivers/net/can/mcp251x.c                                    |    6 +-
 drivers/net/can/mscan/mpc5xxx_can.c                          |   37 +-
 drivers/net/can/mscan/mscan.c                                |    8 -
 drivers/net/can/mscan/mscan.h                                |    1 -
 drivers/net/can/pch_can.c                                    |    6 +-
 drivers/net/can/sja1000/Kconfig                              |    3 +-
 drivers/net/can/sja1000/ems_pci.c                            |    4 +-
 drivers/net/can/sja1000/ems_pcmcia.c                         |    5 +-
 drivers/net/can/sja1000/kvaser_pci.c                         |    8 +-
 drivers/net/can/sja1000/peak_pci.c                           |    7 +-
 drivers/net/can/sja1000/peak_pcmcia.c                        |    2 +-
 drivers/net/can/sja1000/plx_pci.c                            |   39 +-
 drivers/net/can/sja1000/sja1000.c                            |    8 -
 drivers/net/can/sja1000/sja1000.h                            |    1 -
 drivers/net/can/sja1000/sja1000_isa.c                        |   16 +-
 drivers/net/can/sja1000/sja1000_of_platform.c                |   14 +-
 drivers/net/can/sja1000/sja1000_platform.c                   |    1 +
 drivers/net/can/sja1000/tscan1.c                             |    8 +-
 drivers/net/can/softing/softing_cs.c                         |   11 +-
 drivers/net/can/softing/softing_main.c                       |   14 +-
 drivers/net/can/ti_hecc.c                                    |    5 +-
 drivers/net/can/usb/Kconfig                                  |   29 +
 drivers/net/can/usb/Makefile                                 |    1 +
 drivers/net/can/usb/ems_usb.c                                |    7 -
 drivers/net/can/usb/esd_usb2.c                               |   45 +-
 drivers/net/can/usb/kvaser_usb.c                             | 1627 ++++++++++++++++++++++++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                 |    5 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.h                 |    1 -
 drivers/net/dsa/Kconfig                                      |    5 +-
 drivers/net/ethernet/3com/3c509.c                            |   29 +-
 drivers/net/ethernet/3com/3c59x.c                            |   21 +-
 drivers/net/ethernet/3com/Kconfig                            |    2 +-
 drivers/net/ethernet/3com/typhoon.c                          |   10 +-
 drivers/net/ethernet/8390/ax88796.c                          |   16 +-
 drivers/net/ethernet/8390/etherh.c                           |   14 +-
 drivers/net/ethernet/8390/hydra.c                            |   18 +-
 drivers/net/ethernet/8390/ne2k-pci.c                         |   12 +-
 drivers/net/ethernet/8390/ne3210.c                           |    4 +-
 drivers/net/ethernet/8390/zorro8390.c                        |   17 +-
 drivers/net/ethernet/adaptec/starfire.c                      |   12 +-
 drivers/net/ethernet/adi/Kconfig                             |    2 +-
 drivers/net/ethernet/adi/bfin_mac.c                          |  271 ++++--
 drivers/net/ethernet/adi/bfin_mac.h                          |   13 +-
 drivers/net/ethernet/aeroflex/greth.c                        |    6 +-
 drivers/net/ethernet/alteon/acenic.c                         |   31 +-
 drivers/net/ethernet/amd/a2065.c                             |   16 +-
 drivers/net/ethernet/amd/am79c961a.c                         |    2 +-
 drivers/net/ethernet/amd/amd8111e.c                          |    8 +-
 drivers/net/ethernet/amd/ariadne.c                           |   10 +-
 drivers/net/ethernet/amd/au1000_eth.c                        |    6 +-
 drivers/net/ethernet/amd/declance.c                          |    8 +-
 drivers/net/ethernet/amd/depca.c                             |   10 +-
 drivers/net/ethernet/amd/hplance.c                           |   17 +-
 drivers/net/ethernet/amd/pcnet32.c                           |   10 +-
 drivers/net/ethernet/amd/sunlance.c                          |   12 +-
 drivers/net/ethernet/apple/bmac.c                            |    4 +-
 drivers/net/ethernet/apple/mace.c                            |    4 +-
 drivers/net/ethernet/apple/macmace.c                         |    6 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c              |   15 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c              |   11 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_param.c             |    7 +-
 drivers/net/ethernet/atheros/atlx/atl1.c                     |   17 +-
 drivers/net/ethernet/atheros/atlx/atl2.c                     |   17 +-
 drivers/net/ethernet/broadcom/Kconfig                        |    1 +
 drivers/net/ethernet/broadcom/b44.c                          |   10 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                 |   12 +-
 drivers/net/ethernet/broadcom/bnx2.c                         | 1022 ++++++++++-----------
 drivers/net/ethernet/broadcom/bnx2.h                         |  134 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                  |  141 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c              |  528 +++++++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h              |   91 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c              |   41 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c          |   29 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h          |    5 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h              |   54 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h         |   29 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c             |  991 ++++++++++++++-------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h             |   18 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c             | 1186 +++++++++++++++----------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h              |   59 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c               |   59 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h               |   12 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c            |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h            |    3 +
 drivers/net/ethernet/broadcom/cnic.c                         |  189 ++--
 drivers/net/ethernet/broadcom/cnic.h                         |   30 +-
 drivers/net/ethernet/broadcom/cnic_if.h                      |    7 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c                   |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                          |  726 +++++++++++----
 drivers/net/ethernet/broadcom/tg3.h                          |   68 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c                   |    4 -
 drivers/net/ethernet/brocade/bna/bfi_enet.h                  |    1 +
 drivers/net/ethernet/brocade/bna/bna.h                       |    2 +
 drivers/net/ethernet/brocade/bna/bna_hw_defs.h               |    3 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c                 |  138 ++-
 drivers/net/ethernet/brocade/bna/bna_types.h                 |    9 +-
 drivers/net/ethernet/brocade/bna/bnad.c                      |  943 +++++++++++---------
 drivers/net/ethernet/brocade/bna/bnad.h                      |   66 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c              |    1 +
 drivers/net/ethernet/brocade/bna/cna.h                       |    4 +-
 drivers/net/ethernet/cadence/Kconfig                         |    9 +-
 drivers/net/ethernet/cadence/at91_ether.c                    | 1283 ++++++---------------------
 drivers/net/ethernet/cadence/at91_ether.h                    |  112 ---
 drivers/net/ethernet/cadence/macb.c                          |  564 ++++++++----
 drivers/net/ethernet/cadence/macb.h                          |   67 +-
 drivers/net/ethernet/calxeda/xgmac.c                         |   59 +-
 drivers/net/ethernet/chelsio/Kconfig                         |    2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                    |    7 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c                      |   17 +-
 drivers/net/ethernet/chelsio/cxgb/subr.c                     |   13 +-
 drivers/net/ethernet/chelsio/cxgb/tp.c                       |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/common.h                  |    7 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c              |   14 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c           |    4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c              |   25 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                   |   14 +-
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c          |   22 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h           |    4 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c               |    7 +-
 drivers/net/ethernet/cisco/Kconfig                           |    2 +-
 drivers/net/ethernet/cisco/enic/Kconfig                      |    2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c                  |    7 +-
 drivers/net/ethernet/davicom/dm9000.c                        |   18 +-
 drivers/net/ethernet/dec/ewrk3.c                             |    3 +-
 drivers/net/ethernet/dec/tulip/de2104x.c                     |   16 +-
 drivers/net/ethernet/dec/tulip/de4x5.c                       |   18 +-
 drivers/net/ethernet/dec/tulip/dmfe.c                        |   11 +-
 drivers/net/ethernet/dec/tulip/eeprom.c                      |   10 +-
 drivers/net/ethernet/dec/tulip/media.c                       |    2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c                  |   12 +-
 drivers/net/ethernet/dec/tulip/uli526x.c                     |   12 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c                 |    9 +-
 drivers/net/ethernet/dec/tulip/xircom_cb.c                   |    6 +-
 drivers/net/ethernet/dlink/dl2k.c                            |   24 +-
 drivers/net/ethernet/dlink/sundance.c                        |   95 +-
 drivers/net/ethernet/dnet.c                                  |   11 +-
 drivers/net/ethernet/emulex/Kconfig                          |    2 +-
 drivers/net/ethernet/emulex/benet/Kconfig                    |    2 +-
 drivers/net/ethernet/emulex/benet/be.h                       |   51 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                  |  409 ++++++++-
 drivers/net/ethernet/emulex/benet/be_cmds.h                  |  177 +++-
 drivers/net/ethernet/emulex/benet/be_ethtool.c               |   80 +-
 drivers/net/ethernet/emulex/benet/be_hw.h                    |   20 +-
 drivers/net/ethernet/emulex/benet/be_main.c                  |  849 +++++++++++-------
 drivers/net/ethernet/emulex/benet/be_roce.c                  |    5 +-
 drivers/net/ethernet/ethoc.c                                 |    8 +-
 drivers/net/ethernet/fealnx.c                                |   12 +-
 drivers/net/ethernet/freescale/Kconfig                       |    9 +
 drivers/net/ethernet/freescale/Makefile                      |    1 +
 drivers/net/ethernet/freescale/fec.c                         |  171 ++--
 drivers/net/ethernet/freescale/fec.h                         |  119 +++
 drivers/net/ethernet/freescale/fec_mpc52xx.c                 |    2 +-
 drivers/net/ethernet/freescale/fec_ptp.c                     |  383 ++++++++
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c        |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c         |    5 +-
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c             |    2 +-
 drivers/net/ethernet/freescale/gianfar.c                     |   14 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c                  |    4 +-
 drivers/net/ethernet/hp/hp100.c                              |   18 +-
 drivers/net/ethernet/i825xx/ether1.c                         |   20 +-
 drivers/net/ethernet/i825xx/lasi_82596.c                     |    8 +-
 drivers/net/ethernet/i825xx/lib82596.c                       |    2 +-
 drivers/net/ethernet/i825xx/sni_82596.c                      |    8 +-
 drivers/net/ethernet/ibm/Kconfig                             |    5 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c                    |   16 +-
 drivers/net/ethernet/ibm/emac/core.c                         |   24 +-
 drivers/net/ethernet/ibm/emac/mal.c                          |   13 +-
 drivers/net/ethernet/ibm/emac/rgmii.c                        |    6 +-
 drivers/net/ethernet/ibm/emac/tah.c                          |    6 +-
 drivers/net/ethernet/ibm/emac/zmii.c                         |    6 +-
 drivers/net/ethernet/ibm/ibmveth.c                           |    7 +-
 drivers/net/ethernet/icplus/ipg.c                            |    7 +-
 drivers/net/ethernet/intel/Kconfig                           |   30 +-
 drivers/net/ethernet/intel/e100.c                            |    7 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c                  |   17 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c                |   13 +-
 drivers/net/ethernet/intel/e1000/e1000_param.c               |   14 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c              |   66 +-
 drivers/net/ethernet/intel/e1000e/82571.c                    |  115 +--
 drivers/net/ethernet/intel/e1000e/defines.h                  |   27 +-
 drivers/net/ethernet/intel/e1000e/e1000.h                    |   17 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c                  |   69 +-
 drivers/net/ethernet/intel/e1000e/hw.h                       |    6 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                  |  243 ++---
 drivers/net/ethernet/intel/e1000e/mac.c                      |  135 +--
 drivers/net/ethernet/intel/e1000e/manage.c                   |    9 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                   |  331 +++----
 drivers/net/ethernet/intel/e1000e/nvm.c                      |   15 +-
 drivers/net/ethernet/intel/e1000e/param.c                    |   60 +-
 drivers/net/ethernet/intel/e1000e/phy.c                      |  141 +--
 drivers/net/ethernet/intel/igb/Makefile                      |    4 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                 |   77 +-
 drivers/net/ethernet/intel/igb/e1000_82575.h                 |    3 +
 drivers/net/ethernet/intel/igb/e1000_defines.h               |   22 +
 drivers/net/ethernet/intel/igb/e1000_i210.c                  |  369 +++++---
 drivers/net/ethernet/intel/igb/e1000_i210.h                  |   17 +
 drivers/net/ethernet/intel/igb/e1000_mac.c                   |  128 +++
 drivers/net/ethernet/intel/igb/e1000_mac.h                   |    1 +
 drivers/net/ethernet/intel/igb/e1000_nvm.c                   |   99 ++-
 drivers/net/ethernet/intel/igb/e1000_nvm.h                   |   16 +
 drivers/net/ethernet/intel/igb/e1000_phy.c                   |   49 +-
 drivers/net/ethernet/intel/igb/e1000_phy.h                   |    1 +
 drivers/net/ethernet/intel/igb/igb.h                         |  112 ++-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                 |  406 +++++++--
 drivers/net/ethernet/intel/igb/igb_main.c                    | 1574 +++++++++++++++++++-------------
 drivers/net/ethernet/intel/igb/igb_ptp.c                     |  102 ++-
 drivers/net/ethernet/intel/igbvf/defines.h                   |    1 +
 drivers/net/ethernet/intel/igbvf/igbvf.h                     |    2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c                    |   41 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c                  |   10 +-
 drivers/net/ethernet/intel/ixgb/ixgb_param.c                 |    6 +-
 drivers/net/ethernet/intel/ixgbe/Makefile                    |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                     |   15 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c               |  160 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c              |  100 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h              |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c             |  115 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c             |  109 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c                |    4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                 |   22 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                |  418 +++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h                 |   31 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                 |  164 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c               |  470 +++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                |   12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                |    2 +-
 drivers/net/ethernet/intel/ixgbevf/defines.h                 |    7 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h                 |   16 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c            |  403 ++++++---
 drivers/net/ethernet/intel/ixgbevf/mbx.h                     |   10 +
 drivers/net/ethernet/intel/ixgbevf/vf.c                      |   61 ++
 drivers/net/ethernet/intel/ixgbevf/vf.h                      |    2 +
 drivers/net/ethernet/jme.c                                   |    6 +-
 drivers/net/ethernet/lantiq_etop.c                           |    4 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                    |    7 +-
 drivers/net/ethernet/marvell/skge.c                          |    9 +-
 drivers/net/ethernet/marvell/sky2.c                          |   35 +-
 drivers/net/ethernet/mellanox/Kconfig                        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/Kconfig                   |    3 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c              |  155 +++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c                 |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c               |   28 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                   |    9 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                   |    2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c                    |    7 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                 |   27 +-
 drivers/net/ethernet/micrel/ks8695net.c                      |   13 +-
 drivers/net/ethernet/micrel/ks8842.c                         |    6 +-
 drivers/net/ethernet/micrel/ks8851.c                         |    6 +-
 drivers/net/ethernet/micrel/ks8851_mll.c                     |    6 +-
 drivers/net/ethernet/micrel/ksz884x.c                        |   18 +-
 drivers/net/ethernet/microchip/enc28j60.c                    |    6 +-
 drivers/net/ethernet/myricom/Kconfig                         |    1 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c             |  285 ++----
 drivers/net/ethernet/natsemi/ibmlana.c                       |    4 +-
 drivers/net/ethernet/natsemi/jazzsonic.c                     |    8 +-
 drivers/net/ethernet/natsemi/macsonic.c                      |   21 +-
 drivers/net/ethernet/natsemi/natsemi.c                       |   13 +-
 drivers/net/ethernet/natsemi/ns83820.c                       |    8 +-
 drivers/net/ethernet/natsemi/xtsonic.c                       |    6 +-
 drivers/net/ethernet/neterion/Kconfig                        |    2 +-
 drivers/net/ethernet/neterion/s2io.c                         |   11 +-
 drivers/net/ethernet/neterion/s2io.h                         |    5 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c             |    6 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h             |    6 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c               |   27 +-
 drivers/net/ethernet/nuvoton/w90p910_ether.c                 |    6 +-
 drivers/net/ethernet/nvidia/forcedeth.c                      |    6 +-
 drivers/net/ethernet/nxp/lpc_eth.c                           |    6 +-
 drivers/net/ethernet/octeon/octeon_mgmt.c                    |    6 +-
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig                |   17 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h              |    2 -
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c         |   14 -
 drivers/net/ethernet/packetengines/hamachi.c                 |   12 +-
 drivers/net/ethernet/packetengines/yellowfin.c               |   12 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c                     |    6 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c      |   93 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c         |   10 +-
 drivers/net/ethernet/qlogic/qla3xxx.c                        |   24 +-
 drivers/net/ethernet/qlogic/qlcnic/Makefile                  |    3 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                  |  521 ++++-------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c              |  114 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c          |   73 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hdr.h              |   56 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c               |  749 ++++------------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c             |  852 +++---------------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c               | 1309 +++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c             | 2186 +++++++--------------------------------------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c         |  629 +++++++++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c            |  960 ++++++++++++++++++++
 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c                  |   16 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                 |   12 +-
 drivers/net/ethernet/rdc/r6040.c                             |    9 +-
 drivers/net/ethernet/realtek/8139cp.c                        |   75 +-
 drivers/net/ethernet/realtek/8139too.c                       |   14 +-
 drivers/net/ethernet/realtek/atp.c                           |   58 +-
 drivers/net/ethernet/realtek/atp.h                           |    2 -
 drivers/net/ethernet/realtek/r8169.c                         |  170 ++--
 drivers/net/ethernet/renesas/sh_eth.c                        |    2 +-
 drivers/net/ethernet/s6gmac.c                                |    6 +-
 drivers/net/ethernet/seeq/ether3.c                           |   22 +-
 drivers/net/ethernet/seeq/sgiseeq.c                          |    2 +-
 drivers/net/ethernet/sfc/Kconfig                             |   10 +-
 drivers/net/ethernet/sfc/Makefile                            |    3 +-
 drivers/net/ethernet/sfc/efx.c                               |   16 +-
 drivers/net/ethernet/sfc/efx.h                               |   13 +
 drivers/net/ethernet/sfc/ethtool.c                           |   25 +-
 drivers/net/ethernet/sfc/falcon.c                            |    2 +
 drivers/net/ethernet/sfc/io.h                                |   43 +-
 drivers/net/ethernet/sfc/mcdi.c                              |   23 +-
 drivers/net/ethernet/sfc/net_driver.h                        |    5 +-
 drivers/net/ethernet/sfc/nic.c                               |   81 +-
 drivers/net/ethernet/sfc/nic.h                               |   28 +-
 drivers/net/ethernet/sfc/rx.c                                |    6 +-
 drivers/net/ethernet/sfc/selftest.c                          |    4 +-
 drivers/net/ethernet/sfc/siena.c                             |   17 +-
 drivers/net/ethernet/sfc/siena_sriov.c                       |    8 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                          |   11 +-
 drivers/net/ethernet/sgi/meth.c                              |    2 +-
 drivers/net/ethernet/silan/sc92031.c                         |    7 +-
 drivers/net/ethernet/sis/sis190.c                            |   27 +-
 drivers/net/ethernet/sis/sis900.c                            |   29 +-
 drivers/net/ethernet/smsc/epic100.c                          |   13 +-
 drivers/net/ethernet/smsc/smc911x.c                          |   20 +-
 drivers/net/ethernet/smsc/smc911x.h                          |   16 +-
 drivers/net/ethernet/smsc/smc91x.c                           |   22 +-
 drivers/net/ethernet/smsc/smc91x.h                           |   20 +-
 drivers/net/ethernet/smsc/smsc911x.c                         |   32 +-
 drivers/net/ethernet/smsc/smsc9420.c                         |    6 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig                  |   25 -
 drivers/net/ethernet/stmicro/stmmac/Makefile                 |    1 -
 drivers/net/ethernet/stmicro/stmmac/common.h                 |   39 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h              |    3 -
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c          |    6 +
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h              |    7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c              |   20 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                 |   14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c         |  100 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c            |  261 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c             |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c        |   14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_timer.c           |  134 ---
 drivers/net/ethernet/stmicro/stmmac/stmmac_timer.h           |   46 -
 drivers/net/ethernet/sun/cassini.c                           |   13 +-
 drivers/net/ethernet/sun/niu.c                               |  121 ++-
 drivers/net/ethernet/sun/sunbmac.c                           |   10 +-
 drivers/net/ethernet/sun/sungem.c                            |    7 +-
 drivers/net/ethernet/sun/sunhme.c                            |   20 +-
 drivers/net/ethernet/sun/sunqe.c                             |   12 +-
 drivers/net/ethernet/sun/sunvnet.c                           |   15 +-
 drivers/net/ethernet/tehuti/tehuti.c                         |    6 +-
 drivers/net/ethernet/ti/Kconfig                              |    9 +
 drivers/net/ethernet/ti/Makefile                             |    2 +-
 drivers/net/ethernet/ti/cpmac.c                              |   10 +-
 drivers/net/ethernet/ti/cpsw.c                               |  635 +++++++++----
 drivers/net/ethernet/ti/cpsw_ale.c                           |   31 +-
 drivers/net/ethernet/ti/cpsw_ale.h                           |    1 +
 drivers/net/ethernet/ti/cpts.c                               |  427 +++++++++
 drivers/net/ethernet/ti/cpts.h                               |  146 +++
 drivers/net/ethernet/ti/davinci_emac.c                       |    6 +-
 drivers/net/ethernet/ti/davinci_mdio.c                       |    8 +-
 drivers/net/ethernet/ti/tlan.c                               |   11 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                 |   22 +-
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c            |   10 +-
 drivers/net/ethernet/toshiba/spider_net.c                    |    6 +-
 drivers/net/ethernet/toshiba/tc35815.c                       |   18 +-
 drivers/net/ethernet/via/via-rhine.c                         |   13 +-
 drivers/net/ethernet/via/via-velocity.c                      |   28 +-
 drivers/net/ethernet/wiznet/w5100.c                          |   10 +-
 drivers/net/ethernet/wiznet/w5300.c                          |   10 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c                  |    8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c            |    8 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                |    8 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c                     |    4 +-
 drivers/net/fddi/defxx.c                                     |   46 +-
 drivers/net/fddi/skfp/skfddi.c                               |    4 +-
 drivers/net/hippi/rrunner.c                                  |   11 +-
 drivers/net/hyperv/rndis_filter.c                            |   10 +-
 drivers/net/ieee802154/at86rf230.c                           |    6 +-
 drivers/net/ieee802154/fakehard.c                            |    6 +-
 drivers/net/ieee802154/fakelb.c                              |    6 +-
 drivers/net/ieee802154/mrf24j40.c                            |    6 +-
 drivers/net/irda/au1k_ir.c                                   |    8 +-
 drivers/net/irda/bfin_sir.c                                  |    8 +-
 drivers/net/irda/ep7211-sir.c                                |   73 +-
 drivers/net/irda/sh_irda.c                                   |   10 +-
 drivers/net/irda/sh_sir.c                                    |    6 +-
 drivers/net/irda/smsc-ircc2.c                                |    6 +-
 drivers/net/irda/via-ircc.c                                  |   15 +-
 drivers/net/irda/vlsi_ir.c                                   |    6 +-
 drivers/net/netconsole.c                                     |    6 +
 drivers/net/phy/davicom.c                                    |    6 +
 drivers/net/phy/dp83640.c                                    |   78 +-
 drivers/net/phy/mdio-gpio.c                                  |   14 +-
 drivers/net/phy/mdio-mux-gpio.c                              |    6 +-
 drivers/net/phy/mdio-mux-mmioreg.c                           |    6 +-
 drivers/net/phy/mdio-octeon.c                                |    6 +-
 drivers/net/phy/mdio_bus.c                                   |   14 +
 drivers/net/phy/micrel.c                                     |   44 +
 drivers/net/phy/smsc.c                                       |   95 +-
 drivers/net/phy/spi_ks8995.c                                 |    6 +-
 drivers/net/ppp/ppp_generic.c                                |    2 +-
 drivers/net/tun.c                                            |  875 +++++++++++++-----
 drivers/net/usb/Kconfig                                      |   22 +
 drivers/net/usb/Makefile                                     |    1 +
 drivers/net/usb/asix_common.c                                |  117 +--
 drivers/net/usb/asix_devices.c                               |   19 +-
 drivers/net/usb/cdc_mbim.c                                   |  412 +++++++++
 drivers/net/usb/cdc_ncm.c                                    |  645 ++++++--------
 drivers/net/usb/dm9601.c                                     |  107 +--
 drivers/net/usb/int51x1.c                                    |   52 +-
 drivers/net/usb/mcs7830.c                                    |   85 +-
 drivers/net/usb/net1080.c                                    |  110 +--
 drivers/net/usb/plusb.c                                      |   11 +-
 drivers/net/usb/sierra_net.c                                 |   47 +-
 drivers/net/usb/smsc75xx.c                                   | 1406 ++++++++++++++++++++++-------
 drivers/net/usb/smsc95xx.c                                   | 1088 +++++++++++++++++------
 drivers/net/usb/smsc95xx.h                                   |   25 +
 drivers/net/usb/usbnet.c                                     |  196 ++++
 drivers/net/veth.c                                           |    3 +-
 drivers/net/virtio_net.c                                     |  742 ++++++++++++----
 drivers/net/vmxnet3/vmxnet3_drv.c                            |   42 +-
 drivers/net/vxlan.c                                          |  286 +++++-
 drivers/net/wan/Makefile                                     |    4 +-
 drivers/net/wan/dscc4.c                                      |    7 +-
 drivers/net/wan/farsync.c                                    |   10 +-
 drivers/net/wan/hd64570.c                                    |    5 +-
 drivers/net/wan/hd64572.c                                    |    5 +-
 drivers/net/wan/ixp4xx_hss.c                                 |    4 +-
 drivers/net/wan/lmc/lmc_main.c                               |    7 +-
 drivers/net/wan/pc300too.c                                   |    4 +-
 drivers/net/wan/pci200syn.c                                  |    4 +-
 drivers/net/wan/wanxl.c                                      |    4 +-
 drivers/net/wan/wanxlfw.S                                    |    1 +
 drivers/net/wireless/adm8211.c                               |    6 +-
 drivers/net/wireless/airo.c                                  |    8 +-
 drivers/net/wireless/at76c50x-usb.c                          |   85 +-
 drivers/net/wireless/ath/Kconfig                             |    8 +-
 drivers/net/wireless/ath/Makefile                            |    1 +
 drivers/net/wireless/ath/ar5523/Kconfig                      |    8 +
 drivers/net/wireless/ath/ar5523/Makefile                     |    1 +
 drivers/net/wireless/ath/ar5523/ar5523.c                     | 1798 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ar5523/ar5523.h                     |  152 ++++
 drivers/net/wireless/ath/ar5523/ar5523_hw.h                  |  431 +++++++++
 drivers/net/wireless/ath/ath5k/Kconfig                       |    1 +
 drivers/net/wireless/ath/ath5k/ahb.c                         |   15 +-
 drivers/net/wireless/ath/ath5k/base.c                        |   31 +-
 drivers/net/wireless/ath/ath5k/led.c                         |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                |    7 +-
 drivers/net/wireless/ath/ath5k/pci.c                         |    6 +-
 drivers/net/wireless/ath/ath5k/reset.c                       |    6 +-
 drivers/net/wireless/ath/ath6kl/Kconfig                      |    9 +
 drivers/net/wireless/ath/ath6kl/Makefile                     |    1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c                   |  410 ++++++---
 drivers/net/wireless/ath/ath6kl/cfg80211.h                   |    1 -
 drivers/net/wireless/ath/ath6kl/core.c                       |   21 +
 drivers/net/wireless/ath/ath6kl/core.h                       |   69 +-
 drivers/net/wireless/ath/ath6kl/debug.h                      |    1 +
 drivers/net/wireless/ath/ath6kl/hif.c                        |   12 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c                   |   13 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c                   |   14 +-
 drivers/net/wireless/ath/ath6kl/init.c                       |   92 +-
 drivers/net/wireless/ath/ath6kl/main.c                       |   55 +-
 drivers/net/wireless/ath/ath6kl/recovery.c                   |  160 ++++
 drivers/net/wireless/ath/ath6kl/sdio.c                       |   27 +-
 drivers/net/wireless/ath/ath6kl/txrx.c                       |   47 +-
 drivers/net/wireless/ath/ath6kl/usb.c                        |   32 +-
 drivers/net/wireless/ath/ath6kl/wmi.c                        |  284 ++++--
 drivers/net/wireless/ath/ath6kl/wmi.h                        |   78 +-
 drivers/net/wireless/ath/ath9k/Kconfig                       |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h         |  172 ++--
 drivers/net/wireless/ath/ath9k/ar9003_calib.c                |   81 ++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c               |   86 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h               |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                   |   30 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c                  |   71 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.h                  |    8 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c                |   87 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                  |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                  |   76 +-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h             |    6 +-
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h         |    2 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h             |  338 +++++--
 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h         |    4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                       |   44 +-
 drivers/net/wireless/ath/ath9k/beacon.c                      |    2 +-
 drivers/net/wireless/ath/ath9k/btcoex.c                      |   63 +-
 drivers/net/wireless/ath/ath9k/btcoex.h                      |    8 +
 drivers/net/wireless/ath/ath9k/calib.c                       |    2 +
 drivers/net/wireless/ath/ath9k/calib.h                       |    3 +
 drivers/net/wireless/ath/ath9k/common.h                      |    8 -
 drivers/net/wireless/ath/ath9k/debug.c                       |  439 +++++----
 drivers/net/wireless/ath/ath9k/debug.h                       |   33 +-
 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c        |   12 +-
 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h        |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom.c                      |   29 +-
 drivers/net/wireless/ath/ath9k/eeprom.h                      |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c                   |    8 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c                 |    9 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c                  |   10 +-
 drivers/net/wireless/ath/ath9k/gpio.c                        |  136 ++-
 drivers/net/wireless/ath/ath9k/htc.h                         |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c              |    8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c               |    8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c                |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                |   25 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                |   44 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                |   28 +-
 drivers/net/wireless/ath/ath9k/hw.c                          |   15 +-
 drivers/net/wireless/ath/ath9k/hw.h                          |   13 +-
 drivers/net/wireless/ath/ath9k/init.c                        |   67 +-
 drivers/net/wireless/ath/ath9k/link.c                        |   39 +-
 drivers/net/wireless/ath/ath9k/main.c                        |  203 +----
 drivers/net/wireless/ath/ath9k/mci.c                         |  211 ++++-
 drivers/net/wireless/ath/ath9k/mci.h                         |   36 +
 drivers/net/wireless/ath/ath9k/pci.c                         |   27 +-
 drivers/net/wireless/ath/ath9k/rc.c                          |   53 +-
 drivers/net/wireless/ath/ath9k/rc.h                          |   16 +
 drivers/net/wireless/ath/ath9k/recv.c                        |    7 +-
 drivers/net/wireless/ath/ath9k/reg.h                         |   13 +-
 drivers/net/wireless/ath/ath9k/wow.c                         |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c                        |   21 +-
 drivers/net/wireless/ath/carl9170/Kconfig                    |    1 +
 drivers/net/wireless/ath/carl9170/fw.c                       |    5 -
 drivers/net/wireless/ath/carl9170/mac.c                      |   21 +-
 drivers/net/wireless/ath/carl9170/rx.c                       |   53 +-
 drivers/net/wireless/ath/carl9170/tx.c                       |    7 +
 drivers/net/wireless/ath/carl9170/usb.c                      |    7 +
 drivers/net/wireless/ath/hw.c                                |   20 +-
 drivers/net/wireless/atmel_pci.c                             |    6 +-
 drivers/net/wireless/b43/dma.c                               |    7 +-
 drivers/net/wireless/b43/main.c                              |   14 +-
 drivers/net/wireless/b43/pcmcia.c                            |    6 +-
 drivers/net/wireless/b43/pio.c                               |    4 +-
 drivers/net/wireless/b43/sdio.c                              |    6 +-
 drivers/net/wireless/b43/xmit.c                              |    2 +-
 drivers/net/wireless/b43legacy/b43legacy.h                   |    5 +
 drivers/net/wireless/b43legacy/main.c                        |   37 +-
 drivers/net/wireless/b43legacy/xmit.c                        |    2 +-
 drivers/net/wireless/brcm80211/Kconfig                       |   15 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile             |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c             |   58 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c       |  182 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                |  256 ++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h            |   98 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c            |  126 +--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c         |  893 ++++---------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c            |    9 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h            |   46 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c          |  716 +++++----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h          |   15 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c           |  579 ++++++------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c               |  447 ++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h               |  215 +++++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c               |  344 +++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h               |   39 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c          |   14 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                |  404 ++++-----
 drivers/net/wireless/brcm80211/brcmfmac/usb.h                |   18 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c        | 2952 +++++++++++++++++++++----------------------------------------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h        |  328 +++----
 drivers/net/wireless/brcm80211/brcmsmac/Makefile             |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c            |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c              |  723 +++++++--------
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.h              |   29 +-
 drivers/net/wireless/brcm80211/brcmsmac/antsel.c             |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h |  175 +++-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c            |   10 +-
 drivers/net/wireless/brcm80211/brcmsmac/debug.c              |  156 ++++
 drivers/net/wireless/brcm80211/brcmsmac/debug.h              |   75 ++
 drivers/net/wireless/brcm80211/brcmsmac/dma.c                |  345 +++++---
 drivers/net/wireless/brcm80211/brcmsmac/dma.h                |   11 +-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c        |  157 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c               | 1261 +++++++++-----------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h               |   48 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c        |  471 ++++++----
 drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c     |   64 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h                |   42 +-
 drivers/net/wireless/brcm80211/brcmsmac/stf.c                |    8 +-
 drivers/net/wireless/brcm80211/brcmsmac/types.h              |    3 +-
 drivers/net/wireless/brcm80211/include/defs.h                |   11 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c                |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c                       |    9 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                       |   52 +-
 drivers/net/wireless/ipw2x00/libipw.h                        |    2 +-
 drivers/net/wireless/ipw2x00/libipw_geo.c                    |    3 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c                     |    6 +-
 drivers/net/wireless/iwlegacy/3945-mac.c                     |    4 +-
 drivers/net/wireless/iwlegacy/3945.c                         |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                     |    8 +-
 drivers/net/wireless/iwlegacy/common.h                       |    5 +-
 drivers/net/wireless/iwlwifi/Kconfig                         |    9 -
 drivers/net/wireless/iwlwifi/dvm/agn.h                       |    4 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c                     |   14 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h                  |    7 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c                   |   14 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h                       |    3 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c                   |    8 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c                       |   49 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                  |   28 +-
 drivers/net/wireless/iwlwifi/dvm/main.c                      |   78 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c                        |   44 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c                        |    6 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c                      |   16 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c                      |   13 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c                       |   12 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                        |   76 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c                     |   14 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                    |   10 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h                  |  129 ++-
 drivers/net/wireless/iwlwifi/iwl-drv.c                       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c              |   86 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h              |   45 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h                        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.c                        |   44 +-
 drivers/net/wireless/iwlwifi/iwl-io.h                        |   12 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                      |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans.h                     |   57 +-
 drivers/net/wireless/iwlwifi/pcie/1000.c                     |    8 +-
 drivers/net/wireless/iwlwifi/pcie/2000.c                     |   16 +-
 drivers/net/wireless/iwlwifi/pcie/5000.c                     |   12 +-
 drivers/net/wireless/iwlwifi/pcie/6000.c                     |   28 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c                      |   16 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h                 |  117 +--
 drivers/net/wireless/iwlwifi/pcie/rx.c                       |  413 ++++++---
 drivers/net/wireless/iwlwifi/pcie/trans.c                    | 1064 ++--------------------
 drivers/net/wireless/iwlwifi/pcie/tx.c                       | 1259 ++++++++++++++++++++------
 drivers/net/wireless/libertas/cfg.c                          |   33 +-
 drivers/net/wireless/libertas/if_sdio.c                      |   39 +-
 drivers/net/wireless/libertas/if_spi.c                       |    6 +-
 drivers/net/wireless/libertas/mesh.c                         |    2 +-
 drivers/net/wireless/mac80211_hwsim.c                        |  585 +++++++++---
 drivers/net/wireless/mwifiex/11n_aggr.c                      |    8 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c                 |    8 +-
 drivers/net/wireless/mwifiex/Kconfig                         |    1 -
 drivers/net/wireless/mwifiex/cfg80211.c                      |   89 +-
 drivers/net/wireless/mwifiex/cmdevt.c                        |   24 +-
 drivers/net/wireless/mwifiex/debugfs.c                       |   10 +-
 drivers/net/wireless/mwifiex/fw.h                            |    2 +
 drivers/net/wireless/mwifiex/init.c                          |   39 +-
 drivers/net/wireless/mwifiex/join.c                          |    6 +-
 drivers/net/wireless/mwifiex/main.c                          |   94 +-
 drivers/net/wireless/mwifiex/main.h                          |   19 +-
 drivers/net/wireless/mwifiex/scan.c                          |   55 +-
 drivers/net/wireless/mwifiex/sdio.c                          |   39 +-
 drivers/net/wireless/mwifiex/sdio.h                          |    1 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c                   |    4 -
 drivers/net/wireless/mwifiex/sta_event.c                     |   10 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                     |   49 +-
 drivers/net/wireless/mwifiex/sta_rx.c                        |   26 +-
 drivers/net/wireless/mwifiex/txrx.c                          |   38 +-
 drivers/net/wireless/mwifiex/uap_cmd.c                       |   11 +-
 drivers/net/wireless/mwifiex/uap_event.c                     |    7 +
 drivers/net/wireless/mwifiex/uap_txrx.c                      |   17 +-
 drivers/net/wireless/mwifiex/usb.c                           |    4 +-
 drivers/net/wireless/mwifiex/util.c                          |   19 +-
 drivers/net/wireless/mwifiex/wmm.c                           |   12 +-
 drivers/net/wireless/mwifiex/wmm.h                           |    2 +
 drivers/net/wireless/mwl8k.c                                 |   71 +-
 drivers/net/wireless/orinoco/cfg.c                           |   11 +-
 drivers/net/wireless/orinoco/main.h                          |    2 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c                |    4 +-
 drivers/net/wireless/orinoco/orinoco_pci.c                   |    4 +-
 drivers/net/wireless/orinoco/orinoco_plx.c                   |    4 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c                   |    4 +-
 drivers/net/wireless/orinoco/orinoco_usb.c                   |    9 +-
 drivers/net/wireless/p54/eeprom.c                            |    5 +-
 drivers/net/wireless/p54/p54pci.c                            |   19 +-
 drivers/net/wireless/p54/p54spi.c                            |    6 +-
 drivers/net/wireless/p54/p54usb.c                            |    6 +-
 drivers/net/wireless/p54/txrx.c                              |    6 +-
 drivers/net/wireless/rndis_wlan.c                            |   12 +-
 drivers/net/wireless/rt2x00/rt2400pci.c                      |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                      |    2 +-
 drivers/net/wireless/rt2x00/rt2800.h                         |    6 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                      |  245 +++--
 drivers/net/wireless/rt2x00/rt2800pci.c                      |    4 +-
 drivers/net/wireless/rt2x00/rt2800usb.c                      |    2 +
 drivers/net/wireless/rt2x00/rt2x00dev.c                      |   36 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                      |    6 +-
 drivers/net/wireless/rt2x00/rt61pci.c                        |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c                   |    8 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c                   |    8 +-
 drivers/net/wireless/rtlwifi/Kconfig                         |   11 +
 drivers/net/wireless/rtlwifi/Makefile                        |    4 +-
 drivers/net/wireless/rtlwifi/base.c                          |   24 +
 drivers/net/wireless/rtlwifi/base.h                          |    2 +
 drivers/net/wireless/rtlwifi/cam.c                           |    9 +-
 drivers/net/wireless/rtlwifi/core.c                          |    5 +-
 drivers/net/wireless/rtlwifi/debug.h                         |    2 +
 drivers/net/wireless/rtlwifi/pci.c                           |   24 +-
 drivers/net/wireless/rtlwifi/pci.h                           |    6 +-
 drivers/net/wireless/rtlwifi/rc.c                            |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c            |  227 +++--
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c           |   88 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h                 |    3 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c                  |   30 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                  |   93 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c                 |    2 +
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c                  |   23 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c                  |   15 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c                 |   48 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c                  |   30 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c                  |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c                 |   25 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c                  |   22 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c                 |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c                  |   95 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c                 |   65 +-
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c                  |   18 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c                  |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c                 |   41 +-
 drivers/net/wireless/rtlwifi/rtl8192se/def.h                 |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c                  |   97 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c                  |    9 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h                  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c                 |   64 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c                  |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c                  |   20 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c                 |   23 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile              |   22 +
 drivers/net/wireless/rtlwifi/rtl8723ae/btc.h                 |   41 +
 drivers/net/wireless/rtlwifi/rtl8723ae/def.h                 |  163 ++++
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c                  |  920 +++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.h                  |  149 ++++
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c                  |  745 ++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.h                  |  101 +++
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c      |  542 ++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.h      |  160 ++++
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c             | 1786 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h             |  151 ++++
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c                  | 2380 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h                  |   73 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/led.c                 |  151 ++++
 drivers/net/wireless/rtlwifi/rtl8723ae/led.h                 |   39 +
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c                 | 2044 ++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.h                 |  224 +++++
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.c              |  109 +++
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h              |  322 +++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.c           |  129 +++
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.h           |   98 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h                 | 2097 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/rf.c                  |  505 +++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/rf.h                  |   43 +
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c                  |  380 ++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.h                  |   37 +
 drivers/net/wireless/rtlwifi/rtl8723ae/table.c               |  738 ++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/table.h               |   50 ++
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c                 |  670 ++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h                 |  725 +++++++++++++++
 drivers/net/wireless/rtlwifi/stats.c                         |  268 ++++++
 drivers/net/wireless/rtlwifi/stats.h                         |   46 +
 drivers/net/wireless/rtlwifi/usb.c                           |    2 +-
 drivers/net/wireless/rtlwifi/usb.h                           |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h                          |  161 +++-
 drivers/net/wireless/ti/wl1251/main.c                        |    4 +-
 drivers/net/wireless/ti/wl1251/rx.c                          |    2 +-
 drivers/net/wireless/ti/wl1251/sdio.c                        |    4 +-
 drivers/net/wireless/ti/wl1251/spi.c                         |    6 +-
 drivers/net/wireless/ti/wl12xx/main.c                        |    6 +-
 drivers/net/wireless/ti/wl18xx/main.c                        |    6 +-
 drivers/net/wireless/ti/wlcore/cmd.c                         |    4 +-
 drivers/net/wireless/ti/wlcore/main.c                        |   15 +-
 drivers/net/wireless/ti/wlcore/sdio.c                        |    8 +-
 drivers/net/wireless/ti/wlcore/spi.c                         |    6 +-
 drivers/net/wireless/ti/wlcore/wlcore.h                      |    4 +-
 drivers/net/xen-netfront.c                                   |   10 +-
 drivers/nfc/Makefile                                         |    2 +-
 drivers/nfc/pn533.c                                          |   18 +-
 drivers/nfc/pn544/Makefile                                   |    7 +
 drivers/nfc/pn544/i2c.c                                      |  500 +++++++++++
 drivers/nfc/{pn544_hci.c => pn544/pn544.c}                   |  679 ++++++--------
 drivers/nfc/pn544/pn544.h                                    |   32 +
 drivers/pps/Kconfig                                          |    1 -
 drivers/ptp/Kconfig                                          |   19 +-
 drivers/ptp/ptp_chardev.c                                    |   61 +-
 drivers/s390/net/claw.c                                      |    2 -
 drivers/s390/net/ctcm_main.c                                 |    2 -
 drivers/s390/net/ctcm_mpc.c                                  |    3 -
 drivers/s390/net/qeth_core.h                                 |    1 +
 drivers/s390/net/qeth_core_main.c                            |   49 +-
 drivers/s390/net/qeth_l2_main.c                              |    4 +-
 drivers/s390/net/qeth_l3_main.c                              |    8 +-
 drivers/ssb/b43_pci_bridge.c                                 |    1 +
 drivers/ssb/driver_chipcommon.c                              |  100 ++-
 drivers/ssb/driver_chipcommon_pmu.c                          |   30 +
 drivers/ssb/driver_extif.c                                   |   24 +-
 drivers/ssb/driver_mipscore.c                                |   30 +-
 drivers/ssb/embedded.c                                       |   35 +
 drivers/ssb/main.c                                           |   11 +-
 drivers/ssb/ssb_private.h                                    |   31 +
 drivers/vhost/net.c                                          |  147 ++-
 drivers/vhost/tcm_vhost.c                                    |    9 +-
 drivers/vhost/vhost.c                                        |   59 +-
 drivers/vhost/vhost.h                                        |   14 +-
 fs/proc/proc_sysctl.c                                        |    9 +-
 include/linux/ath9k_platform.h                               |    2 +
 include/linux/atmdev.h                                       |    2 +
 include/linux/bcm47xx_wdt.h                                  |   19 +
 include/linux/bcma/bcma.h                                    |    7 +-
 include/linux/bcma/bcma_driver_chipcommon.h                  |   12 +-
 include/linux/bcma/bcma_driver_mips.h                        |    3 +
 include/linux/bcma/bcma_regs.h                               |    5 +-
 include/linux/etherdevice.h                                  |   20 +
 include/linux/filter.h                                       |    3 +
 include/linux/hdlc/Kbuild                                    |    1 -
 include/linux/ieee80211.h                                    |  188 +++-
 include/linux/if_tunnel.h                                    |   17 +
 include/linux/inetdevice.h                                   |    3 +
 include/linux/ip.h                                           |    5 +
 include/linux/ipv6.h                                         |   38 +-
 include/linux/ktime.h                                        |   19 +
 include/linux/micrel_phy.h                                   |    1 +
 include/linux/netdevice.h                                    |   44 +-
 include/linux/netfilter_ipv6/ip6_tables.h                    |    9 -
 include/linux/nfc/pn544.h                                    |  104 ---
 include/linux/openvswitch.h                                  |    1 +
 include/linux/pci.h                                          |   14 +
 include/linux/platform_data/cpsw.h                           |   23 +-
 include/linux/platform_data/macb.h                           |    1 +
 include/linux/platform_data/pn544.h                          |   44 +
 include/linux/rtnetlink.h                                    |    3 +
 include/linux/skbuff.h                                       |  102 ++-
 include/linux/smscphy.h                                      |    5 +
 include/linux/ssb/ssb.h                                      |    2 +
 include/linux/ssb/ssb_driver_chipcommon.h                    |    5 +-
 include/linux/ssb/ssb_driver_extif.h                         |   52 +-
 include/linux/ssb/ssb_driver_mips.h                          |   10 +-
 include/linux/ssb/ssb_regs.h                                 |    2 +-
 include/linux/stmmac.h                                       |    1 +
 include/linux/sysctl.h                                       |    3 +-
 include/linux/tcp.h                                          |   10 +
 include/linux/timecompare.h                                  |  125 ---
 include/linux/udp.h                                          |    5 +
 include/linux/usb/cdc_ncm.h                                  |  134 +++
 include/linux/usb/usbnet.h                                   |   10 +
 include/net/addrconf.h                                       |    3 +
 include/net/af_unix.h                                        |    1 -
 include/net/bluetooth/a2mp.h                                 |   24 +-
 include/net/bluetooth/amp.h                                  |   54 ++
 include/net/bluetooth/bluetooth.h                            |    1 -
 include/net/bluetooth/hci.h                                  |   69 +-
 include/net/bluetooth/hci_core.h                             |  123 ++-
 include/net/bluetooth/l2cap.h                                |   50 +-
 include/net/cfg80211.h                                       |  306 +++++--
 include/net/cls_cgroup.h                                     |    6 +-
 include/net/gro_cells.h                                      |   14 +-
 include/net/ieee80211_radiotap.h                             |   24 +
 include/net/inet_hashtables.h                                |   50 +-
 include/net/inet_sock.h                                      |    8 +-
 include/net/inet_timewait_sock.h                             |    7 +-
 include/net/ip6_checksum.h                                   |   35 +
 include/net/ip6_fib.h                                        |   20 +-
 include/net/ip6_route.h                                      |    3 -
 include/net/ip_vs.h                                          |  195 ++--
 include/net/ipip.h                                           |   40 +-
 include/net/ipv6.h                                           |   19 +
 include/net/mac80211.h                                       |  275 +++++-
 include/net/ndisc.h                                          |   15 -
 include/net/net_namespace.h                                  |   24 +-
 include/net/netfilter/nf_conntrack.h                         |    2 +-
 include/net/netfilter/nf_nat.h                               |   15 +
 include/net/netfilter/nf_queue.h                             |    8 +-
 include/net/netns/sctp.h                                     |    3 +
 include/net/nfc/hci.h                                        |   21 +-
 include/net/nfc/nfc.h                                        |    2 +-
 include/net/protocol.h                                       |   31 +-
 include/net/request_sock.h                                   |   12 +-
 include/net/route.h                                          |    9 +-
 include/net/rtnetlink.h                                      |    2 +-
 include/net/sch_generic.h                                    |    7 +
 include/net/sctp/command.h                                   |   38 +-
 include/net/sctp/constants.h                                 |    8 -
 include/net/sctp/sctp.h                                      |   12 +
 include/net/sctp/sm.h                                        |    2 +
 include/net/sctp/structs.h                                   |   39 +
 include/net/sctp/ulpqueue.h                                  |    2 +-
 include/net/sctp/user.h                                      |   27 +
 include/net/sock.h                                           |   28 +-
 include/net/tcp.h                                            |    1 -
 include/uapi/asm-generic/socket.h                            |    1 +
 include/uapi/linux/Kbuild                                    |    1 +
 include/uapi/linux/ethtool.h                                 |   11 +-
 include/uapi/linux/filter.h                                  |    4 +-
 include/uapi/linux/hdlc/Kbuild                               |    1 +
 include/{ => uapi}/linux/hdlc/ioctl.h                        |    7 +-
 include/uapi/linux/if_bridge.h                               |   81 ++
 include/uapi/linux/if_ether.h                                |    1 +
 include/uapi/linux/if_link.h                                 |   22 +
 include/uapi/linux/if_packet.h                               |    1 +
 include/uapi/linux/if_tun.h                                  |    7 +
 include/uapi/linux/if_tunnel.h                               |   20 +
 include/uapi/linux/in6.h                                     |    1 +
 include/uapi/linux/inet_diag.h                               |    3 +-
 include/uapi/linux/ipv6.h                                    |    1 +
 include/uapi/linux/ipv6_route.h                              |    3 +
 include/uapi/linux/netconf.h                                 |   24 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h           |    2 +
 include/uapi/linux/netfilter_ipv6/ip6_tables.h               |    3 +
 include/uapi/linux/nfc.h                                     |   15 +
 include/uapi/linux/nl80211.h                                 |  177 +++-
 include/uapi/linux/ptp_clock.h                               |   14 +
 include/uapi/linux/rtnetlink.h                               |   26 +
 include/uapi/linux/unix_diag.h                               |    1 +
 include/uapi/linux/usb/cdc.h                                 |   23 +
 include/uapi/linux/virtio_net.h                              |   27 +
 kernel/nsproxy.c                                             |    2 +-
 kernel/time/Makefile                                         |    2 +-
 kernel/time/timecompare.c                                    |  193 ----
 net/8021q/vlan.c                                             |   15 +-
 net/8021q/vlan_dev.c                                         |   12 +-
 net/atm/br2684.c                                             |   91 +-
 net/atm/common.c                                             |   12 +
 net/atm/pppoatm.c                                            |   68 +-
 net/batman-adv/Kconfig                                       |   11 +
 net/batman-adv/Makefile                                      |    1 +
 net/batman-adv/bat_iv_ogm.c                                  |   51 +-
 net/batman-adv/bitarray.c                                    |   23 +-
 net/batman-adv/bridge_loop_avoidance.c                       |  131 +--
 net/batman-adv/bridge_loop_avoidance.h                       |    6 +-
 net/batman-adv/debugfs.c                                     |   60 +-
 net/batman-adv/distributed-arp-table.c                       | 1066 ++++++++++++++++++++++
 net/batman-adv/distributed-arp-table.h                       |  167 ++++
 net/batman-adv/gateway_client.c                              |   19 +-
 net/batman-adv/hard-interface.c                              |   51 +-
 net/batman-adv/hash.h                                        |   22 +
 net/batman-adv/icmp_socket.c                                 |   16 +-
 net/batman-adv/main.c                                        |   89 +-
 net/batman-adv/main.h                                        |   36 +-
 net/batman-adv/originator.c                                  |   22 +-
 net/batman-adv/packet.h                                      |   86 +-
 net/batman-adv/routing.c                                     |  315 ++++---
 net/batman-adv/send.c                                        |   43 +-
 net/batman-adv/send.h                                        |    3 +
 net/batman-adv/soft-interface.c                              |   94 +-
 net/batman-adv/sysfs.c                                       |   58 +-
 net/batman-adv/translation-table.c                           |  526 ++++++-----
 net/batman-adv/translation-table.h                           |    8 +-
 net/batman-adv/types.h                                       |  102 ++-
 net/batman-adv/unicast.c                                     |  143 ++-
 net/batman-adv/unicast.h                                     |   36 +-
 net/batman-adv/vis.c                                         |   44 +-
 net/bluetooth/Kconfig                                        |    2 +-
 net/bluetooth/Makefile                                       |    2 +-
 net/bluetooth/a2mp.c                                         |  459 +++++++++-
 net/bluetooth/af_bluetooth.c                                 |   10 +-
 net/bluetooth/amp.c                                          |  471 ++++++++++
 net/bluetooth/bnep/core.c                                    |    3 +-
 net/bluetooth/bnep/netdev.c                                  |    1 -
 net/bluetooth/cmtp/capi.c                                    |    2 +-
 net/bluetooth/cmtp/core.c                                    |    2 +-
 net/bluetooth/cmtp/sock.c                                    |    2 +-
 net/bluetooth/hci_conn.c                                     |   76 +-
 net/bluetooth/hci_core.c                                     |  233 +++--
 net/bluetooth/hci_event.c                                    |  562 +++++++++++-
 net/bluetooth/hci_sysfs.c                                    |   10 +-
 net/bluetooth/hidp/core.c                                    |    8 +-
 net/bluetooth/l2cap_core.c                                   | 1611 ++++++++++++++++++++++++++-------
 net/bluetooth/l2cap_sock.c                                   |   94 +-
 net/bluetooth/lib.c                                          |   14 -
 net/bluetooth/mgmt.c                                         |  105 ++-
 net/bluetooth/rfcomm/core.c                                  |   19 +-
 net/bluetooth/rfcomm/sock.c                                  |   13 +-
 net/bluetooth/rfcomm/tty.c                                   |    6 +-
 net/bluetooth/sco.c                                          |   98 +-
 net/bluetooth/smp.c                                          |    2 +-
 net/bridge/Makefile                                          |    2 +-
 net/bridge/br_device.c                                       |    4 +-
 net/bridge/br_input.c                                        |   17 +-
 net/bridge/br_ioctl.c                                        |   25 +-
 net/bridge/br_mdb.c                                          |  481 ++++++++++
 net/bridge/br_multicast.c                                    |   81 +-
 net/bridge/br_netlink.c                                      |  249 ++++--
 net/bridge/br_private.h                                      |   46 +-
 net/bridge/br_stp.c                                          |   22 +-
 net/bridge/br_stp_bpdu.c                                     |    7 +
 net/bridge/br_sysfs_br.c                                     |   22 +-
 net/bridge/br_sysfs_if.c                                     |   47 +-
 net/caif/caif_usb.c                                          |   18 +-
 net/caif/cfctrl.c                                            |    3 +-
 net/can/gw.c                                                 |    6 +
 net/core/dev.c                                               |  236 +++--
 net/core/ethtool.c                                           |    2 +-
 net/core/filter.c                                            |  139 +++
 net/core/flow.c                                              |    4 +-
 net/core/neighbour.c                                         |   20 +-
 net/core/net-sysfs.c                                         |   17 +-
 net/core/net_namespace.c                                     |   23 +-
 net/core/netpoll.c                                           |    6 +-
 net/core/netprio_cgroup.c                                    |    2 +-
 net/core/pktgen.c                                            |   47 +-
 net/core/rtnetlink.c                                         |  230 ++++-
 net/core/scm.c                                               |    6 +-
 net/core/skbuff.c                                            |   34 +-
 net/core/sock.c                                              |   84 +-
 net/core/sysctl_net_core.c                                   |    5 +
 net/dcb/dcbnl.c                                              |    8 +-
 net/dccp/minisocks.c                                         |    3 +-
 net/decnet/dn_dev.c                                          |    6 +
 net/decnet/dn_fib.c                                          |    6 +
 net/dsa/Kconfig                                              |   18 +-
 net/ieee802154/6lowpan.c                                     |    3 +-
 net/ipv4/af_inet.c                                           |   93 +-
 net/ipv4/arp.c                                               |    2 +-
 net/ipv4/devinet.c                                           |  198 ++++-
 net/ipv4/fib_frontend.c                                      |    2 +-
 net/ipv4/fib_semantics.c                                     |    2 +-
 net/ipv4/inet_connection_sock.c                              |   25 +-
 net/ipv4/inet_diag.c                                         |    5 +-
 net/ipv4/inet_hashtables.c                                   |   36 +-
 net/ipv4/ip_fragment.c                                       |    4 +
 net/ipv4/ip_gre.c                                            |   32 +-
 net/ipv4/ip_options.c                                        |    6 +-
 net/ipv4/ip_output.c                                         |    4 +
 net/ipv4/ip_sockglue.c                                       |    5 +-
 net/ipv4/ip_vti.c                                            |   26 +-
 net/ipv4/ipconfig.c                                          |    6 +-
 net/ipv4/ipip.c                                              |  271 ++++--
 net/ipv4/ipmr.c                                              |  137 ++-
 net/ipv4/netfilter/arp_tables.c                              |    8 +-
 net/ipv4/netfilter/ip_tables.c                               |    8 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                           |    9 +-
 net/ipv4/netfilter/iptable_nat.c                             |    8 +-
 net/ipv4/protocol.c                                          |   21 +
 net/ipv4/route.c                                             |   27 +-
 net/ipv4/syncookies.c                                        |    2 +-
 net/ipv4/sysctl_net_ipv4.c                                   |    3 +
 net/ipv4/tcp.c                                               |   25 +-
 net/ipv4/tcp_cong.c                                          |    3 +-
 net/ipv4/tcp_input.c                                         |   45 +-
 net/ipv4/tcp_ipv4.c                                          |   38 +-
 net/ipv4/tcp_minisocks.c                                     |    8 +-
 net/ipv4/tcp_output.c                                        |    5 +
 net/ipv4/tcp_timer.c                                         |    8 +-
 net/ipv6/Makefile                                            |    5 +-
 net/ipv6/addrconf.c                                          |  203 ++++-
 net/ipv6/af_inet6.c                                          |  245 +----
 net/ipv6/ah6.c                                               |   10 +-
 net/ipv6/anycast.c                                           |    7 +-
 net/ipv6/datagram.c                                          |    8 +-
 net/ipv6/exthdrs.c                                           |   70 +-
 net/ipv6/exthdrs_core.c                                      |  168 ++++
 net/ipv6/exthdrs_offload.c                                   |   41 +
 net/ipv6/fib6_rules.c                                        |    2 +-
 net/ipv6/icmp.c                                              |    2 +-
 net/ipv6/inet6_hashtables.c                                  |   27 +-
 net/ipv6/ip6_fib.c                                           |   57 ++
 net/ipv6/ip6_flowlabel.c                                     |    3 +-
 net/ipv6/ip6_gre.c                                           |   29 +-
 net/ipv6/ip6_offload.c                                       |  282 ++++++
 net/ipv6/ip6_offload.h                                       |   18 +
 net/ipv6/ip6_output.c                                        |   72 +-
 net/ipv6/ip6_tunnel.c                                        |  288 +++++-
 net/ipv6/ip6mr.c                                             |  157 +++-
 net/ipv6/ipv6_sockglue.c                                     |    9 +-
 net/ipv6/mcast.c                                             |    7 +-
 net/ipv6/ndisc.c                                             |   62 +-
 net/ipv6/netfilter/ip6_tables.c                              |  117 +--
 net/ipv6/netfilter/ip6t_rpfilter.c                           |    2 +-
 net/ipv6/netfilter/ip6table_nat.c                            |    8 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c               |   70 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c               |    4 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c                    |    6 +-
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c                     |    2 +-
 net/ipv6/output_core.c                                       |   76 ++
 net/ipv6/protocol.c                                          |   25 +
 net/ipv6/raw.c                                               |    6 +-
 net/ipv6/reassembly.c                                        |    4 +
 net/ipv6/route.c                                             |  210 ++++-
 net/ipv6/sit.c                                               |  459 ++++++++--
 net/ipv6/syncookies.c                                        |    2 +-
 net/ipv6/tcp_ipv6.c                                          |  124 +--
 net/ipv6/tcpv6_offload.c                                     |   95 ++
 net/ipv6/udp.c                                               |   94 --
 net/ipv6/udp_offload.c                                       |  120 +++
 net/ipv6/xfrm6_policy.c                                      |   21 +-
 net/ipv6/xfrm6_state.c                                       |    4 +-
 net/key/af_key.c                                             |    2 +-
 net/l2tp/l2tp_netlink.c                                      |    2 +-
 net/llc/af_llc.c                                             |    2 +-
 net/mac80211/Kconfig                                         |    2 +-
 net/mac80211/Makefile                                        |    1 +
 net/mac80211/aes_cmac.c                                      |   18 +
 net/mac80211/agg-rx.c                                        |    2 +-
 net/mac80211/agg-tx.c                                        |   14 +-
 net/mac80211/cfg.c                                           |  499 +++++++----
 net/mac80211/chan.c                                          |  411 ++++++---
 net/mac80211/debugfs.h                                       |    6 +-
 net/mac80211/debugfs_key.c                                   |   23 +-
 net/mac80211/debugfs_netdev.c                                |   78 +-
 net/mac80211/debugfs_sta.c                                   |   59 +-
 net/mac80211/driver-ops.h                                    |  140 ++-
 net/mac80211/ht.c                                            |    4 +-
 net/mac80211/ibss.c                                          |  171 ++--
 net/mac80211/ieee80211_i.h                                   |  214 ++++-
 net/mac80211/iface.c                                         |  143 ++-
 net/mac80211/key.c                                           |   15 +-
 net/mac80211/key.h                                           |   11 +-
 net/mac80211/main.c                                          |  150 +++-
 net/mac80211/mesh.c                                          |   82 +-
 net/mac80211/mesh.h                                          |   18 +-
 net/mac80211/mesh_plink.c                                    |   64 +-
 net/mac80211/mesh_sync.c                                     |  105 +--
 net/mac80211/mlme.c                                          |  735 +++++++++++----
 net/mac80211/offchannel.c                                    |   24 +-
 net/mac80211/pm.c                                            |   46 +-
 net/mac80211/rate.c                                          |    5 +-
 net/mac80211/rate.h                                          |   12 +-
 net/mac80211/rc80211_minstrel.c                              |    9 +-
 net/mac80211/rc80211_minstrel_ht.c                           |    8 +-
 net/mac80211/rx.c                                            |  250 ++++--
 net/mac80211/scan.c                                          |   61 +-
 net/mac80211/sta_info.c                                      |   69 +-
 net/mac80211/sta_info.h                                      |   31 +-
 net/mac80211/status.c                                        |  169 ++--
 net/mac80211/trace.h                                         |  246 +++++-
 net/mac80211/tx.c                                            |  291 +++---
 net/mac80211/util.c                                          |  363 +++++---
 net/mac80211/vht.c                                           |   35 +
 net/mac80211/wme.c                                           |   40 +-
 net/mac80211/wpa.c                                           |    5 +-
 net/mac802154/tx.c                                           |    7 +-
 net/mac802154/wpan.c                                         |    4 +-
 net/netfilter/core.c                                         |    2 -
 net/netfilter/ipset/ip_set_core.c                            |  245 +++--
 net/netfilter/ipvs/Kconfig                                   |    7 +-
 net/netfilter/ipvs/ip_vs_conn.c                              |   15 +-
 net/netfilter/ipvs/ip_vs_core.c                              |  404 +++++----
 net/netfilter/ipvs/ip_vs_ctl.c                               |    8 +-
 net/netfilter/ipvs/ip_vs_dh.c                                |    2 +-
 net/netfilter/ipvs/ip_vs_lblc.c                              |    7 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                             |    6 +-
 net/netfilter/ipvs/ip_vs_nfct.c                              |    2 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c                            |   18 +-
 net/netfilter/ipvs/ip_vs_proto.c                             |    6 +-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c                      |    9 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c                        |   42 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c                         |   40 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c                         |   41 +-
 net/netfilter/ipvs/ip_vs_sched.c                             |    2 +-
 net/netfilter/ipvs/ip_vs_sh.c                                |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                              |   81 +-
 net/netfilter/nf_conntrack_acct.c                            |    4 +
 net/netfilter/nf_conntrack_core.c                            |   31 +-
 net/netfilter/nf_conntrack_ecache.c                          |    4 +
 net/netfilter/nf_conntrack_helper.c                          |    4 +
 net/netfilter/nf_conntrack_netlink.c                         |  118 ++-
 net/netfilter/nf_conntrack_proto_dccp.c                      |    8 +-
 net/netfilter/nf_conntrack_proto_tcp.c                       |    2 +
 net/netfilter/nf_conntrack_standalone.c                      |    4 +
 net/netfilter/nf_conntrack_timestamp.c                       |    4 +
 net/netfilter/nf_queue.c                                     |  152 +---
 net/netfilter/nfnetlink.c                                    |    2 +-
 net/netfilter/nfnetlink_queue_core.c                         |   14 +-
 net/netfilter/xt_HMARK.c                                     |    8 +-
 net/netfilter/xt_ipvs.c                                      |    4 +-
 net/netlink/af_netlink.c                                     |    2 +-
 net/nfc/Kconfig                                              |    4 +-
 net/nfc/core.c                                               |   33 +-
 net/nfc/hci/command.c                                        |   28 +-
 net/nfc/hci/core.c                                           |   90 +-
 net/nfc/hci/llc.c                                            |    2 +-
 net/nfc/hci/llc_shdlc.c                                      |    7 +-
 net/nfc/llcp/Kconfig                                         |    4 +-
 net/nfc/llcp/commands.c                                      |  148 +++-
 net/nfc/llcp/llcp.c                                          |  248 +++++-
 net/nfc/llcp/llcp.h                                          |   13 +
 net/nfc/llcp/sock.c                                          |   42 +-
 net/nfc/nci/Kconfig                                          |    4 +-
 net/nfc/nci/core.c                                           |   29 +-
 net/nfc/netlink.c                                            |  157 +++-
 net/nfc/nfc.h                                                |    6 +
 net/nfc/rawsock.c                                            |    1 -
 net/openvswitch/actions.c                                    |   97 ++
 net/openvswitch/datapath.c                                   |   27 +-
 net/openvswitch/flow.c                                       |   28 +-
 net/openvswitch/flow.h                                       |    8 +-
 net/openvswitch/vport-netdev.c                               |   14 +-
 net/openvswitch/vport-netdev.h                               |    3 +
 net/openvswitch/vport.c                                      |    5 +-
 net/packet/af_packet.c                                       |   50 +-
 net/packet/internal.h                                        |    1 +
 net/phonet/pn_netlink.c                                      |    6 +
 net/rds/ib.h                                                 |    2 +-
 net/rds/ib_recv.c                                            |   24 +-
 net/rfkill/rfkill-gpio.c                                     |    2 +-
 net/rfkill/rfkill-regulator.c                                |    6 +-
 net/sched/Kconfig                                            |    2 +-
 net/sched/act_api.c                                          |    3 +
 net/sched/cls_api.c                                          |    2 +
 net/sched/cls_cgroup.c                                       |   24 +
 net/sched/sch_api.c                                          |   20 +-
 net/sched/sch_cbq.c                                          |    3 +-
 net/sched/sch_generic.c                                      |   11 +-
 net/sched/sch_htb.c                                          |  139 ++-
 net/sched/sch_mq.c                                           |    4 +-
 net/sched/sch_mqprio.c                                       |    4 +
 net/sched/sch_qfq.c                                          |  830 +++++++++++------
 net/sctp/Kconfig                                             |   39 +-
 net/sctp/associola.c                                         |   16 +-
 net/sctp/endpointola.c                                       |    5 +-
 net/sctp/inqueue.c                                           |    2 +
 net/sctp/ipv6.c                                              |    2 +-
 net/sctp/output.c                                            |   14 +-
 net/sctp/outqueue.c                                          |   12 +-
 net/sctp/proc.c                                              |   21 +-
 net/sctp/protocol.c                                          |   15 +-
 net/sctp/sm_make_chunk.c                                     |   24 +-
 net/sctp/sm_sideeffect.c                                     |   55 +-
 net/sctp/sm_statefuns.c                                      |   20 +-
 net/sctp/socket.c                                            |   88 +-
 net/sctp/sysctl.c                                            |   59 ++
 net/sctp/transport.c                                         |   20 +-
 net/sctp/tsnmap.c                                            |    8 +-
 net/sctp/ulpqueue.c                                          |    3 +-
 net/socket.c                                                 |    8 -
 net/sysctl_net.c                                             |   15 +-
 net/tipc/Kconfig                                             |   13 +-
 net/tipc/bcast.c                                             |   27 +-
 net/tipc/bearer.c                                            |  110 +--
 net/tipc/bearer.h                                            |   24 +-
 net/tipc/core.c                                              |    5 -
 net/tipc/discover.c                                          |    2 +-
 net/tipc/link.c                                              |  232 +++--
 net/tipc/link.h                                              |    4 -
 net/tipc/name_distr.c                                        |    2 +-
 net/tipc/node.c                                              |   15 +-
 net/tipc/node.h                                              |    6 +-
 net/tipc/port.c                                              |   32 +-
 net/tipc/port.h                                              |    6 +-
 net/tipc/socket.c                                            |  411 +++++----
 net/tipc/subscr.c                                            |    2 +-
 net/unix/diag.c                                              |    3 +
 net/unix/sysctl_net_unix.c                                   |    4 +
 net/wireless/Kconfig                                         |    5 +-
 net/wireless/Makefile                                        |    4 +-
 net/wireless/ap.c                                            |    4 +-
 net/wireless/chan.c                                          |  313 +++++--
 net/wireless/core.c                                          |   23 +-
 net/wireless/core.h                                          |   32 +-
 net/wireless/ethtool.c                                       |   15 +-
 net/wireless/ibss.c                                          |   36 +-
 net/wireless/mesh.c                                          |   59 +-
 net/wireless/mlme.c                                          |  116 ++-
 net/wireless/nl80211.c                                       |  868 ++++++++++++------
 net/wireless/nl80211.h                                       |    8 +-
 net/wireless/rdev-ops.h                                      |  878 ++++++++++++++++++
 net/wireless/reg.c                                           |    2 +-
 net/wireless/reg.h                                           |    2 +-
 net/wireless/scan.c                                          |  615 +++++++------
 net/wireless/sme.c                                           |   25 +-
 net/wireless/sysfs.c                                         |    5 +-
 net/wireless/trace.c                                         |    7 +
 net/wireless/trace.h                                         | 2324 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/util.c                                          |  197 ++++-
 net/wireless/wext-compat.c                                   |   76 +-
 net/wireless/wext-sme.c                                      |   19 +-
 net/xfrm/xfrm_ipcomp.c                                       |    8 +-
 net/xfrm/xfrm_replay.c                                       |   13 +-
 net/xfrm/xfrm_sysctl.c                                       |    4 +
 net/xfrm/xfrm_user.c                                         |    2 +-
 security/selinux/nlmsgtab.c                                  |    3 +
 tools/virtio/virtio_test.c                                   |    2 +-
 1353 files changed, 82947 insertions(+), 34593 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-mdio
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-grcan
 create mode 100644 Documentation/devicetree/bindings/net/can/grcan.txt
 create mode 100644 Documentation/devicetree/bindings/net/cdns-emac.txt
 delete mode 100644 arch/arm/mach-at91/include/mach/at91rm9200_emac.h
 create mode 100644 drivers/net/can/grcan.c
 create mode 100644 drivers/net/can/usb/kvaser_usb.c
 delete mode 100644 drivers/net/ethernet/cadence/at91_ether.h
 create mode 100644 drivers/net/ethernet/freescale/fec_ptp.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_timer.c
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_timer.h
 create mode 100644 drivers/net/ethernet/ti/cpts.c
 create mode 100644 drivers/net/ethernet/ti/cpts.h
 create mode 100644 drivers/net/usb/cdc_mbim.c
 create mode 100644 drivers/net/wireless/ath/ar5523/Kconfig
 create mode 100644 drivers/net/wireless/ath/ar5523/Makefile
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523.c
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523.h
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523_hw.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/recovery.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fweh.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fweh.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/btc.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h
 create mode 100644 drivers/net/wireless/rtlwifi/stats.c
 create mode 100644 drivers/net/wireless/rtlwifi/stats.h
 create mode 100644 drivers/nfc/pn544/Makefile
 create mode 100644 drivers/nfc/pn544/i2c.c
 rename drivers/nfc/{pn544_hci.c => pn544/pn544.c} (58%)
 create mode 100644 drivers/nfc/pn544/pn544.h
 create mode 100644 include/linux/bcm47xx_wdt.h
 delete mode 100644 include/linux/nfc/pn544.h
 create mode 100644 include/linux/platform_data/pn544.h
 delete mode 100644 include/linux/timecompare.h
 create mode 100644 include/linux/usb/cdc_ncm.h
 create mode 100644 include/net/bluetooth/amp.h
 rename include/{ => uapi}/linux/hdlc/ioctl.h (96%)
 create mode 100644 include/uapi/linux/netconf.h
 delete mode 100644 kernel/time/timecompare.c
 create mode 100644 net/batman-adv/distributed-arp-table.c
 create mode 100644 net/batman-adv/distributed-arp-table.h
 create mode 100644 net/bluetooth/amp.c
 create mode 100644 net/bridge/br_mdb.c
 create mode 100644 net/ipv6/exthdrs_offload.c
 create mode 100644 net/ipv6/ip6_offload.c
 create mode 100644 net/ipv6/ip6_offload.h
 create mode 100644 net/ipv6/output_core.c
 create mode 100644 net/ipv6/tcpv6_offload.c
 create mode 100644 net/ipv6/udp_offload.c
 create mode 100644 net/mac80211/vht.c
 create mode 100644 net/wireless/rdev-ops.h
 create mode 100644 net/wireless/trace.c
 create mode 100644 net/wireless/trace.h
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
