Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2JBTnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:43:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50339 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2JBTmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:42:53 -0400
Date: Tue, 02 Oct 2012 15:42:47 -0400 (EDT)
Message-Id: <20121002.154247.1892546933595516451.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q92JhHpc001412


There are a small number of minor conflicts to resolve in this pull:

1) An earlier point of Eric Biederman's userns tree was pulled into
   net-next to decrease the amount of conflict resolution we have
   to do now and it mostly worked out.

   There are some small, minor, merge hassles still to address though.

   For all of them you should basically take the hunk in your tree
   rather than the hunk in net-next.

2) The ath9k driver has a merge conflict with ASPM PCI changes.

   Retain the part from your tree the uses the new pci_*() interface
   instead of poking around directly in PCI space.

   Take the if() conditional from the net-next side, since that
   adds a chipset variant to the test.

3) feature-removal-schedule.txt removed from your tree, edited
   in net-next, retain the removal.

Notable changes this time around:

1) GRE now works over ipv6, from Dmitry Kozlov.

2) Make SCTP more network namespace aware, from Eric Biederman.

3) TEAM driver now works with non-ethernet devices, from Jiri Pirko.

4) Make openvswitch network namespace aware, from Pravin B. Shelar.

5) IPV6 NAT implementation, from Patrick McHardy.

6) Server side support for TCP Fast Open, from Jerry Chu and others.

7) Packet BPF filter supports MOD and XOR, from Eric Dumazet and
   Daniel Borkmann.

8) Increate the loopback default MTU to 64K, from Eric Dumazet.

9) Use a per-task rather than per-socket page fragment allocator
   for outgoing networking traffic.  This benefits processes that
   have very many mostly idle sockets, which is quite common.

   From Eric Dumazet.

10) Use up to 32K for page fragment allocations, with fallbacks
    to smaller sizes when higher order page allocations fail.
    Benefits are a) less segments for driver to process b)
    less calls to page allocator c) less waste of space.

    From Eric Dumazet.

11) Allow GRO to be used on GRE tunnels, from Eric Dumazet.

12) VXLAN device driver, one way to handle VLAN issues such as
    the limitation of 4096 VLAN IDs yet still have some level
    of isolation.  From Stephen Hemminger.

As usual there is a large boatload of driver changes, with the scale
perhaps tilted towards the wireless side this time around.

Please pull, thanks a lot!

The following changes since commit 6672d90fe779dc0dfffe027c3ede12609df091c2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-09-28 10:09:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to a3a6cab5ea10cca64d036851fe0d932448f2fe4f:

  hyperv: Add buffer for extended info after the RNDIS response message. (2012-10-02 14:39:31 -0400)

----------------------------------------------------------------
AceLan Kao (1):
      Revert "rfkill: remove dead code"

Akeem G. Abodunrin (2):
      igb: Supported and Advertised Pause Frame
      igb: Support to enable EEE on all eee_supported devices

Alan Cox (3):
      af_unix: old_cred is surplus
      wireless: remove unreachable code
      tcp: Document use of undefined variable.

Alan Ott (3):
      6lowpan: Make a copy of skb's delivered to 6lowpan
      6lowpan: handle NETDEV_UNREGISTER event
      ieee802154: MRF24J40 driver

Alex Bergmann (1):
      tcp: Increase timeout for SYN segments

Alexander Duyck (24):
      ixgbe: Remove code that was initializing Rx page offset
      ixgbe: combine ixgbe_add_rx_frag and ixgbe_can_reuse_page
      ixgbe: Only use double buffering if page size is less than 8K
      ixgbe: Have the CPU take ownership of the buffers sooner
      ixgbe: Make pull tail function separate from rest of cleanup_headers
      ixgbe: Copybreak sooner to avoid get_page/put_page and offset change overhead
      ixgbe: Make allocating skb and placing data in it a separate function
      ixgbe: Roll RSC code into non-EOP code
      ixgbe: Rewrite code related to configuring IFCS bit in Tx descriptor
      ixgbevf: Add suspend and resume support to the VF
      ixgbevf: Cleanup handling of configuration for jumbo frames
      ipv4: Minor logic clean-up in ipv4_mtu
      ixgbe: Fix ordering of things so that PF correctly configures its VLANs
      ixgbe: Fix VF rate limiting to correctly account for more queues per VF
      igb: Remove artificial restriction on RQDPC stat reading
      ixgbevf: Add support for VF API negotiation
      igb: Remove logic that was doing NUMA pseudo-aware allocations
      igb: Change Tx cleanup loop to do/while instead of for
      igb: Change how we populate the RSS indirection table
      igb: Simplify how we populate the RSS key
      igb: Use dma_unmap_addr and dma_unmap_len defines
      ixgbevf: Fix code for handling timeout
      ixgbevf: Add fix to VF to handle multi-descriptor buffers
      ixgbevf: Return error on failure to enable VLAN

Allan, Bruce W (1):
      mdio: translation of MMD EEE registers to/from ethtool settings

Amerigo Wang (9):
      net: move and rename netif_notify_peers()
      net: remove netdev_bonding_change()
      ipv6: remove some useless RCU read lock
      netpoll: call ->ndo_select_queue() in tx path
      ipv6: add a new namespace for nf_conntrack_reasm
      ipv6: unify conntrack reassembly expire code with standard one
      ipv6: make ip6_frag_nqueues() and ip6_frag_mem() static inline
      ipv6: unify fragment thresh handling code
      l2tp: fix compile error when CONFIG_IPV6=m and CONFIG_L2TP=y

Amit Beka (1):
      iwlwifi: fix FW restart on init FW

Amitkumar Karwar (16):
      mwifiex: do le_to_cpu conversion for Rx packet header elements
      mwifiex: update max_chan_per_scan correctly for SSID scan
      mwifiex: improve scan delay logic during Tx traffic
      mwifiex: notify cfg80211 about MIC failures
      mwifiex: release semaphore acquired for internal scan operation
      mwifiex: don't disable wait_q_enabled flag
      mwifiex: remove get operation code for SUBSCRIBE EVENT command
      mwifiex: remove 11N_CFG command response handler
      mwifiex: remove AMSDU_AGGR_CTRL command response handler
      mwifiex: have same priority for AP and station traffic
      mwifiex: update adapter->bss_prio_tbl[j].bss_prio_cur correctly
      mwifiex: use country ie of requested AP while associating
      mwifiex: support custom world regulatory domain
      mwifiex: fix issue in resumed scan operation
      mwifiex: disconnect the device before entering suspend state
      mwifiex: block scan request during heavy Tx traffic

Andi Kleen (1):
      brcm80211: Remove bogus memcpy in ai_detach

Andre Guedes (17):
      Bluetooth: Remove missing code
      Bluetooth: Use lmp_bredr_capable where applicable
      Bluetooth: Use lmp_le_capable where applicable
      Bluetooth: Use lmp_ssp_capable where applicable
      Bluetooth: Use lmp_esco_capable where applicable
      Bluetooth: Use lmp_rswitch_capable where applicable
      Bluetooth: Use lmp_sniff_capable where applicable
      Bluetooth: Use lmp_sniffsubr_capable where applicable
      Bluetooth: Use lmp_no_flush_capable where applicable
      Bluetooth: Remove locking in hci_user_passkey_request_evt
      Bluetooth: Trivial refactoring
      Bluetooth: Fix hci_le_conn_complete_evt
      Bluetooth: Remove unneeded code
      Bluetooth: Refactor hci_cs_le_create_conn
      Bluetooth: Find hci_conn by BT_CONNECT state
      Bluetooth: Lookup hci_conn in hci_le_conn_complete_evt
      Bluetooth: Refactor in hci_le_conn_complete_evt

Andreas Larsson (1):
      can: sja1000: Add support for listen-only mode and one-shot mode

Andrei Emeltchenko (15):
      Bluetooth: mgmt: Managing only BR/EDR HCI controllers
      Bluetooth: debug: Fix printing A2MP cmd code format
      Bluetooth: debug: Fix printing refcnt for hci_conn
      Bluetooth: trivial: Fix mixing spaces and tabs in smp
      Bluetooth: Define AMP controller statuses
      Bluetooth: Do not shadow hdr variable
      Bluetooth: Fix processing A2MP chan in security_cfm
      Bluetooth: Make connect / disconnect cfm functions return void
      Bluetooth: trivial: Shorten variable scope
      Bluetooth: trivial: Use preferred method for NULL check
      Bluetooth: Remove unneeded zero init
      Bluetooth: trivial: Make hci_chan_del return void
      Bluetooth: trivial: Remove empty line
      Bluetooth: debug: Print refcnt for hci_dev
      Bluetooth: AMP: Add Read Data Block Size to amp_init

Andy Shevchenko (2):
      wireless: at76c50x: eliminate hex2str()
      ipconfig: fix trivial build error

AnilKumar Ch (6):
      can: c_can: Modify c_can device names
      can: c_can: Add device tree support to Bosch C_CAN/D_CAN controller
      can: c_can: Add runtime PM support to Bosch C_CAN/D_CAN controller
      can: c_can: Add d_can suspend resume support
      can: c_can: Adopt pinctrl support
      can: c_can: fix segfault during rmmod

Antonio Quartulli (9):
      mac80211: add supported rates change notification in IBSS
      ath9k_htc: implement sta_rc_update() mac80211 callback
      batman-adv: move function arguments on one line
      batman-adv: add reference counting for type batadv_tt_orig_list_entry
      batman-adv: fix typos in comments
      batman-adv: detect not yet announced clients
      batman-adv: change interface_rx to get orig node
      mac80211: move ieee80211_send_deauth_disassoc outside mlme code
      mac80211: reply to AUTH with DEAUTH if sta allocation fails in IBSS

Arend van Spriel (16):
      wext: include wireless event id when it has a size problem
      brcmfmac: add callback for nl80211 testmode command
      cfg80211: remove obsolete comment for .sched_scan_stop() callback
      brcmfmac: add parameter check in brcmf_c_mkiovar()
      brcmfmac: simplify handling e-scan result firmware event
      brcmfmac: fix sparse warnings in e-scan related code
      brcmfmac: extend brcmf_term_iscan() to abort e-scan
      brcmfmac: introduce scheduled scan support
      brcmfmac: change struct brcmf_cfg80211_priv comments to kernel-doc
      brcmfmac: get rid of void pointer in struct brcmf_cfg80211_priv
      brcmfmac: get rid of extern keyword in wl_cfg80211.h
      brcmfmac: use brcmf_cfg80211_priv to interface with wl_cfg80211 code
      brcmfmac: remove two obsolete structure definitions
      brcmfmac: rename structure brcmf_cfg80211_priv
      brcmfmac: remove brcmf_read_prof() function
      brcmfmac: remove brcmf_update_prof() function

Arik Nemtsov (11):
      wlcore: don't get the hlid from a queued skb
      wlcore: op_tx: pass sta explicitly when inferring frame hlid
      wlcore: AP mode - send non-data packets with basic rates
      wlcore: allow only the lowest OFDM rate for p2p setup frames
      wlcore: make Tx flush timings more verbose
      wlcore: tx_flush - optimize flow and force Tx during the flush
      wlcore/wl18xx/wl12xx: allow up to 3 mac addresses
      wlcore: make debug prints work without dynamic debug
      wlcore: allow up to 3 running STA interfaces in combinations
      wlcore: spi: use private max-buf-size limit
      wl18xx: default to siso40 in 2.4ghz with a single antenna

Avinash Patil (10):
      mwifiex: update 11n status as per start_ap IE
      mwifiex: separate file for handling AP events
      mwifiex: create list for associated stations in AP mode
      mwifiex: improve uAP RX handling
      mwifiex: support RX AMSDU aggregation for uAP
      mwifiex: add 11n Block Ack support for uAP
      mwifiex: cleanup TX/RX BA tables for uAP
      mwifiex: parse rate info for AP
      mwifiex: separate TxPD processing routine for AP
      mwifiex: enhance RX reordering to avoid packet drop during host sleep

Bala Shanmugam (1):
      ath9k: Enable MCI for AR9565

Ben Hutchings (36):
      net: Set device operstate at registration time
      sfc: Refactor struct efx_tx_buffer to use a flags field
      sfc: Stop TX queues before they fill up
      sfc: Simplify TSO header buffer allocation
      sfc: Replace tso_state::full_packet_space with ip_base_len
      sfc: Stash header offsets for TSO in struct tso_state
      sfc: Change state names to be clearer, and comment them
      sfc: Hold the RTNL lock for more of the suspend/resume cycle
      sfc: Keep disabled NICs quiescent during suspend/resume
      sfc: Hold RTNL lock (only) when calling efx_stop_interrupts()
      sfc: Never try to stop and start a NIC that is disabled
      sfc: Improve log messages in case we abort probe due to a pending reset
      sfc: Fix reset vs probe/remove/PM races involving efx_nic::state
      sfc: Remove overly paranoid locking assertions from netdev operations
      sfc: Remove bogus comment about MTU change and RX buffer overrun
      sfc: Assign efx and efx->type as early as possible in efx_pci_probe()
      sfc: Fix the initial device operstate
      pps/ptp: Allow PHC devices to adjust PPS events for known delay
      llc2: Remove pointless indirection through llc_stat_state_trans_end
      llc2: Remove dead code for state machine
      llc2: Collapse the station event receive path
      llc2: Remove the station send queue
      llc2: Remove explicit indexing of state action arrays
      llc2: Collapse remainder of state machine into simple if-else if-statement
      sfc: Fix maximum array sizes for various MCDI commands
      sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
      sfc: Support variable-length response to MCDI GET_BOARD_CFG
      sfc: Expose FPGA bitfile partition through MTD
      sfc: Bump version to 3.2
      sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
      sfc: Fix null function pointer in efx_sriov_channel_type
      sfc: Add parentheses around use of bitfield macro arguments
      sfc: Fix MCDI structure field lookup
      sfc: Fix loopback self-test with separate_tx_channels=1
      sfc: Remove EFX_FILTER_FLAG_RX_OVERRIDE_IP
      sfc: Fix the reported priorities of different filter types

Bing Zhao (5):
      mwifiex: fix powerpc64-linux- compilation warnings
      mwifiex: fix 'smatch' warning in preparing key_material cmd
      mwifiex: make use of is_zero_ether_addr()
      mwifiex: do not hint regulatory domain with f/w country code
      mwifiex: disable WOW by default

Bj√∏rn Mork (6):
      net: cx82310_eth: use common match macro
      net: sierra_net: make private symbols static
      net: sierra_net: rx_urb_size is constant
      net: qmi_wwan: increase max QMI message size to 4096
      net: qmi_wwan: use a single bind function for all device types
      net: qmi_wwan: adding Huawei E367, ZTE MF683 and Pantech P4200

Bruce Allan (6):
      e1000e: use correct type for read of 32-bit register
      e1000e: cleanup strict checkpatch MEMORY_BARRIER checks
      e1000e: cleanup strict checkpatch check
      e1000e: cleanup - remove inapplicable comment
      e1000e: cleanup - remove unnecessary variable
      e1000e: update driver version number

Bruce W Allan (1):
      e1000e: implement 82577/579 MDI setting support

Carolyn Wyborny (2):
      igb: Add loopback test support for i210
      igb: Fix stats output on i210/i211 parts.

Catherine Sullivan (3):
      ixgbe: add debugfs support
      ixgbe: added netdev_ops file to debugfs
      ixgbe: added reg_ops file to debugfs

Christian Lamparter (6):
      p54: parse output power table
      p54: fix powerpc gcc warnings
      carl9170: report A-MPDU status
      p54: fix off-by-one null pointer bug in p54_tx_80211
      p54: connect to 11w protected networks
      carl9170: connect to 11w protected networks

Christoph Fritz (1):
      ipconfig: add nameserver IPs to kernel-parameter ip=

Christoph Paasch (2):
      ipv4: Don't add TCP-code in inet_sock_destruct
      tcp: Remove unused parameter from tcp_v4_save_options

Chun-Yeow Yeoh (3):
      mac80211: don't re-init rate control when receiving mesh beacon
      mac80211: allow re-open the blocked peer link in mesh
      ath5k: disable HW crypto in management frame

Claudiu Ghioc (1):
      ipvs: fixed sparse warning

Claudiu Manoil (1):
      gianfar: Change default HW Tx queue scheduling mode

Cong Wang (3):
      sctp: fix a compile error in sctp.h
      netfilter: remove xt_NOTRACK
      NFC: Remove the pn544 raw driver

Dan Carpenter (7):
      mwifiex: use GFP_ATOMIC under spin lock
      sctp: fix bogus if statement in sctp_auth_recv_cid()
      ipv6: move dereference after check in fl_free()
      gre: information leak in ip6_tnl_ioctl()
      mwifiex: potential corruption in mwifiex_update_uap_custom_ie()
      brcmfmac: use kcalloc() to prevent integer overflow
      net/key/af_key.c: add range checks on ->sadb_x_policy_len

Daniel Borkmann (3):
      filter: add XOR instruction for use with X/K
      x86: bpf_jit_comp: add XOR instruction for BPF JIT
      sparc: bpf_jit_comp: add XOR instruction for BPF JIT JIT

Daniel Drake (1):
      libertas: set mac control synchronously during init

Daniel Golle (1):
      rt2x00: add MediaTek/RaLink Rt3352 WiSoC

Daniel Mack (2):
      net: ti cpsw ethernet: set IFCTL_A bit in MACCONTROL
      net: ti cpsw ethernet: allow reading phy interface mode from DT

David S. Miller (38):
      Merge branch 'master' of git://kernel.ubuntu.com/rtg/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://git.kernel.org/.../ppwaskie/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://1984.lsi.us.es/nf-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'for-next' of git://git.kernel.org/.../ebiederm/user-namespace
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'tcp_fastopen_server'
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      net: Add INET dependency on aes crypto for the sake of TCP fastopen.
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      llc: Remove stray reference to sysctl_llc_station_ack_timeout.
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      sunbmac: Remove unused local variable.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      net: Make ZNET driver config depend on X86.
      netlink: Rearrange netlink_kernel_cfg to save space on 64-bit.
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      net: Remove unnecessary NULL check in scm_destroy().
      bna: Fix warning false positive.
      pkt_sched: Fix warning false positives.
      Revert "be2net: fix vfs enumeration"
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Revert "net: ti cpsw ethernet: allow reading phy interface mode from DT"
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      vxlan: Depend on CONFIG_INET

David Spinadel (3):
      iwlwifi: remove radio_config from eeprom_data
      iwlwifi: don't reset interupts after disabling
      iwlwifi: stop interrupts before stopping device

Devendra Naga (1):
      wl18xx: use module_platform_driver

Duan Jiong (1):
      etherdevice: introduce help function eth_zero_addr()

Eliad Peller (12):
      mac80211: add PS flag to bss_conf
      mac80211: use synchronize_net() on key destroying
      mac80211: use call_rcu() on sta deletion
      wlcore: consider single fw case
      wlcore: cancel recovery_work on stop() instead of remove_interface()
      wlcore: resume() only if sta is associated
      wlcore: always use wlvif->role_id for scans
      wlcore: lazy-enable device roles
      wlcore: invalidate keep-alive template on disconnection
      wlcore: use dynamic keep-alive template ids
      wlcore: decrease elp timeout
      wlcore: protect wlcore_op_set_key with mutex

Eliezer Tamir (1):
      ixgbe: remove old init remnant

Emil Tantilov (1):
      ixgbe: fix reporting of spoofed packets

Emmanuel Grumbach (6):
      iwlwifi: s/iwl_ucode_callback/iwl_req_fw_callback
      iwlwifi: get the correct HCMD in the response handler
      mac80211: don't call mgd_prepare_tx when associated
      iwlwifi: fix the preparation of the card
      iwlwifi: some clean up in transport layer
      iwlwifi: don't access the HW when it is not available

Eric Dumazet (37):
      net: skb_share_check() should use consume_skb()
      ipv4: change inet_addr_hash()
      ipv4: Introduce IN_DEV_NET_ROUTE_LOCALNET
      net: avoid reloads in SNMP_UPD_PO_STATS
      net: reorganize IP MIB values
      net: tcp: GRO should be ECN friendly
      tcp: ecn: dont delay ACKS after CE
      net: output path optimizations
      fib: use __fls() on non null argument
      time: jiffies_delta_to_clock_t() helper to the rescue
      net: remove delay at device dismantle
      xfrm: fix RCU bugs
      ipv6: gre: fix ip6gre_err()
      net: reinstate rtnl in call_netdevice_notifiers()
      netpoll: provide an IP ident in UDP frames
      igb: reduce Rx header size
      net: qdisc busylock needs lockdep annotations
      tcp: fix TFO regression
      igmp: avoid drop_monitor false positives
      net: rt_cache_flush() cleanup
      filter: add MOD operation
      x86 bpf_jit: support MOD operation
      ipv6: route templates can be const
      net: more accurate network taps in transmit path
      net: provide a default dev->ethtool_ops
      gre: add GSO support
      net: loopback: set default mtu to 64K
      net: use a per task frag allocator
      net: raw: revert unrelated change
      net: remove sk_init() helper
      ipv6: gre: remove ip6gre_header_parse()
      net: use bigger pages in __netdev_alloc_frag
      net: struct napi_struct fields reordering
      tcp: gro: add checksuming helpers
      net: add gro_cells infrastructure
      ipv4: gre: add GRO capability
      mlx4: dont orphan skbs in mlx4_en_xmit()

Eric Lapuyade (9):
      NFC: Changed the HCI cmd execution callback prototype
      NFC: Add a public nfc_hci_send_cmd_async method
      NFC: Modified hci_transceive to become an asynchronous operation
      NFC: Add an LLC Core layer to HCI
      NFC: Add a nop (passthrough) llc module to llc core
      NFC: Add an shdlc llc module to llc core
      NFC: Changed HCI and PN544 HCI driver to use the new HCI LLC Core
      NFC: Fix LLC registration definitions for ANSI compliance
      NFC: Add HCI module description

Eric W. Biederman (43):
      userns: Allow the usernamespace support to build after the removal of usbfs
      userns:  Fix link restrictions to use uid_eq
      userns: Convert net/core/scm.c to use kuids and kgids
      userns: Convert __dev_set_promiscuity to use kuids in audit logs
      userns: Convert sock_i_uid to return a kuid_t
      userns: Allow USER_NS and NET simultaneously in Kconfig
      userns: Make seq_file's user namespace accessible
      userns: Print out socket uids in a user namespace aware fashion.
      userns: Use kgids for sysctl_ping_group_range
      net ip6 flowlabel: Make owner a union of struct pid * and kuid_t
      pidns: Export free_pid_ns
      userns: Convert net/ax25 to use kuid_t where appropriate
      netlink: Make the sending netlink socket availabe in NETLINK_CB
      userns: Implement sk_user_ns
      userns: Teach inet_diag to work with user namespaces
      userns: nfnetlink_log: Report socket uids in the log sockets user namespace
      net sched: Pass the skb into change so it can access NETLINK_CB
      userns: Convert cls_flow to work with user namespaces enabled
      userns: Convert xt_LOG to print socket kuids and kgids as uids and gids
      userns xt_recent: Specify the owner/group of ip_list_perms in the initial user namespace
      userns: xt_owner: Add basic user namespace support.
      userns: Make the airo wireless driver use kuids for proc uids and gids
      userns: Convert tun/tap to use kuid and kgid where appropriate
      sctp: Make the port hash table use struct net in it's key.
      sctp: Make the endpoint hashtable handle multiple network namespaces
      sctp: Make the association hashtable handle multiple network namespaces
      sctp: Make the address lists per network namespace
      sctp: Make the ctl_sock per network namespace
      sctp: Move the percpu sockets counter out of sctp_proc_init
      sctp: Make the proc files per network namespace.
      sctp: Enable sctp in all network namespaces
      sctp: Make the mib per network namespace
      sctp: Add infrastructure for per net sysctls
      sctp: Push struct net down to sctp_chunk_event_lookup
      sctp: Push struct net down into sctp_transport_init
      sctp: Push struct net down into sctp_in_scope
      sctp: Push struct net down into all of the state machine functions
      sctp: Push struct net down into sctp_verify_ext_param
      sctp: Make sysctl tunables per net
      scm: Don't use struct ucred in NETLINK_CB and struct scm_cookie.
      netlink: Rename pid to portid to avoid confusion
      xfrm: Report user triggered expirations against the users socket
      scsi_netlink: Remove dead and buggy code

Eyal Shapira (2):
      mac80211: avoid using synchronize_rcu in ieee80211_set_probe_resp
      wlcore: configure wowlan regardless of wakeup conditions

Fan Du (2):
      xfrm: remove redundant parameter "int dir" in struct xfrm_mgr.acquire
      xfrm: Use rcu_dereference_bh to deference pointer protected by rcu_read_lock_bh

Felix Fietkau (1):
      mac80211: validate skb->dev in the tx status path

Fengguang Wu (1):
      mwifiex: fix code mis-alignment after the if statement

Florian Westphal (2):
      netfilter: nf_nat: fix out-of-bounds access in address selection
      netfilter: xt_time: add support to ignore day transition

Francois Romieu (1):
      r8169: add D-Link DGE-560T identifiers.

Franky Lin (9):
      brcmfmac: add BCM43241 sdio interface driver support
      brcmfmac: absorb brcmf_sendpkt into brcmf_netdev_start_xmit
      brcmfmac: remove obsolete sdio bus sleep mechanism
      brcmfmac: use atomic variable for interrupt pending flag
      brcmfmac: convert SDIO dpc implementation to workqueue
      brcmfmac: streamline SDIO dpc
      brcmfmac: raise SDIO host lock to higher level
      brcmfmac: clear status for in-band interrupt in brcmf_sdbrcm_isr
      brcmfmac: streamline SDIO read frame routine

Gabor Juhos (2):
      ath9k: optimize power level initialization for CTL_[25]GHT20
      ath9k: fix indentation in ar9003_hw_set_power_per_rate_table

Gao feng (2):
      net: dev: fix the incorrect hold of net namespace's lo device
      net: dev: fix incorrect getting net device's name

Gertjan van Wingerde (10):
      rt2x00: Align GPIO register definitions with the datasheets.
      rt2x00: Unify GPIO register field namings
      rt2x00: rt2800 - Make probe_hw function common between PCI and USB.
      rt2x00: Code clean up in rt2800lib.
      rt2x00: rt2800 - Fix default vgc values for RT3572
      rt2x00: rt2800lib - code cleanup.
      rt2x00: Code style cleanup in rt2800lib.c
      rt2x00: Clean up RFCSR1 programming in rt2800_config_channel_rf3xxx.
      rt2x00: Deprecate max_sta_intf field of struct rt2x00_ops.
      rt2x00: Replace open coded interface checking with interface combinations.

Greg Kroah-Hartman (1):
      USB: remove dbg() usage in USB networking drivers

Greg Rose (2):
      ixgbe: Do not read the spoofed packets counter when not in IOV mode
      ixgbevf: Fix AIM (Adaptive Interrupt Moderation)

Gustavo Padovan (1):
      Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn

Haiyang Zhang (7):
      hyperv: Add comments for the extended buffer after RNDIS message
      hyperv: Fix the max_xfer_size in RNDIS initialization
      hyperv: Fix the missing return value in rndis_filter_set_packet_filter()
      hyperv: Fix page buffer handling in rndis_filter_send_request()
      hyperv: Remove extra allocated space for recv_pkt_list elements
      hyperv: Report actual status in receive completion packet
      hyperv: Add buffer for extended info after the RNDIS response message.

Hante Meuleman (22):
      brcmfmac: prevent possible race condition on usb rx control.
      brcmfmac: Add 43242 USB support.
      brcmfmac: Add 43143 USB support.
      brcmfmac: Stop all net if queues on tx flow halt.
      brcmfmac: Add extra data support to firmware event queueing.
      brcmfmac: Add tx flow control on net if queue for USB.
      brcmfmac: Clean up scan related code.
      brcmfmac: refill buffers on rx protocol error.
      brcmfmac: avoid using local usb data.
      brcmfmac: add e-scan support.
      brcmfmac: fix bug causing errorneous free on exception.
      brcmfmac: fix debug printout of event data.
      brcmfmac: store usb fw images in local linked list.
      brcmfmac: remove unused function.
      brcmfmac: fix bug in determining phy bands.
      brcmfmac: remove unused usb bmac model code.
      brcmfmac: clear control lock on usb error.
      brcmfmac: use wait_event_timeout for fw control packets over usb.
      brcmfmac: use different fw api for encryption,auth. config
      brcmfmac: use define instead of hardcoded values.
      brcmfmac: notify common driver about usb tx completion.
      brcmfmac: add hostap supoort.

Hauke Mehrtens (1):
      bcma: make some functions static

Hila Gonen (1):
      cfg80211: fix indentation

Ido Reis (2):
      wl18xx: update default phy configuration for pg2
      wl18xx: increase rx_ba_win_size to 32

Ido Yariv (6):
      wlcore: Prevent interaction with HW after recovery is queued
      wlcore: Don't recover during boot
      wlcore: Fix unbalanced interrupts enablement
      wlcore: Allow memory access when the FW crashes
      wlcore: Refactor probe
      wlcore: Load the NVS file asynchronously

Igal Chernobelsky (2):
      wl18xx/wl12xx: defines for Tx/Rx descriptors num
      wlcore/wl18xx/wl12xx: aggregation buffer size set

Igor Maravic (1):
      net: ipv4: fib_trie: Don't unnecessarily search for already found fib leaf

Ilan Elias (3):
      NFC: Set local general bytes in nci_start_poll
      NFC: Parse NCI NFC-DEP activation params
      NFC: Implement NCI dep_link_up and dep_link_down

Ilan Peer (1):
      mac80211: Do not check for valid hw_queues for P2P_DEVICE

Ivan Vecera (2):
      be2net: fix vfs enumeration
      be2net: fix vfs enumeration

Jaganath Kanakkassery (2):
      Bluetooth: Move l2cap_chan_hold/put to l2cap_core.c
      Bluetooth: Free the l2cap channel list only when refcount is zero

Jan Beulich (1):
      netfilter: properly annotate ipv4_netfilter_{init,fini}()

Jan Engelhardt (2):
      netfilter: combine ipt_NETMAP and ip6t_NETMAP
      netfilter: combine ipt_REDIRECT and ip6t_REDIRECT

Jaroslav Resler (1):
      Bluetooth: Add support for BCM20702A0 [04ca, 2003]

Javier Lopez (1):
      carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces

Jean Sacren (1):
      netfilter: remove unnecessary goto statement for error recovery

Jeff Disher (1):
      mwifiex: store mwifiex_ds_misc_subsc_evt in mwifiex_private

Jeff Mahoney (1):
      brcmsmac: document firmware dependencies

Jerry Chu (3):
      tcp: TCP Fast Open Server - header & support functions
      tcp: TCP Fast Open Server - support TFO listeners
      tcp: TCP Fast Open Server - main code path

Jesper Dangaard Brouer (1):
      ipvs: IPv6 MTU checking cleanup and bugfix

Jesse Brandeburg (5):
      ethtool.h: MDI setting support
      igb: implement 580 MDI setting support
      e1000: configure and read MDI settings
      e1000e: implement MDI/MDI-X control
      igb: update to allow reading/setting MDI state

Jiri Bohac (1):
      bonding: add some slack to arp monitoring time limits

Jiri Pirko (9):
      netlink: add signed types
      team: add signed 32-bit team option type
      team: add per port priority option
      team: add support for queue override by setting queue_id for port
      team: add support for non-ethernet devices
      team: don't print warn message on -ESRCH during event send
      vlan: add helper which can be called to see if device is used by vlan
      team: do not allow to add VLAN challenged port when vlan is used
      team: send port changed when added

Joe Perches (1):
      net1080: Neaten netdev_dbg use

Johan Hedberg (2):
      Bluetooth: mgmt: Implement support for passkey notification
      Bluetooth: Update management interface revision

Johannes Berg (67):
      iwlwifi: fix aggregation check indentation
      iwlwifi: reduce max remain-on-channel duration
      mac80211: don't react to beacon loss if HW monitoring
      mac80211: supress HT/VHT disable if not supported
      mac80211: rename sta to new_sta
      mac80211: set channel only once during auth/assoc
      mac80211: use oper_channel in mesh
      mac80211: use oper_channel in ibss
      mac80211: use oper_channel in managed mlme
      mac80211: use oper_channel in utils and config
      mac80211: fix current vs. operating channel in preq/beacon
      mac80211: use correct channel in TX
      mac80211: manage carrier state in mesh
      mac80211: enable WDS carrier only after adding station
      mac80211: use eth_broadcast_addr
      mac80211: reset station MLME flags upon new association
      brcmsmac: use ieee80211_channel_to_frequency
      iwlegacy: clean up suspend/resume
      wireless: add radiotap A-MPDU status field
      mac80211: support A-MPDU status reporting
      mac80211: remove unneeded 'bssid' variable
      mac80211: clean up CSA handling code
      mac80211: fix CSA handling timer
      mac80211: check size of channel switch IE when parsing
      mac80211: make ieee80211_beacon_connection_loss_work static
      cfg80211: add P2P Device abstraction
      mac80211: support P2P Device abstraction
      mac80211: add IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF
      mac80211_hwsim: add support for P2P Device
      mac80211: simplify buffers in aes_128_cmac_vector
      mac80211: mesh: don't use global channel type
      mac80211: remove almost unused local variable
      mac80211: remove freq/chantype from debugfs
      mac80211: use oper_channel in rate init
      mac80211: don't assume channel is set in tracing
      mac80211: use RX status band instead of current band
      mac80211: check operating channel in scan
      mac80211: convert ops checks to WARN_ON
      mac80211: pass channel to ieee80211_send_probe_req
      mac80211: clean up ieee80211_subif_start_xmit
      iwlwifi: fix antenna bitmask
      mac80211: don't use kerneldoc for ieee80211_add_rx_radiotap_header
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: report A-MPDU status
      iwlwifi: reduce overhead if tracing disabled
      iwlwifi: remove unused IDI code stubs
      Merge remote-tracking branch 'mac80211/master' into mac80211-next
      mac80211: don't hang on to sched_scan_ies
      mac80211: disconnect if channel switch fails
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      wireless: remove obsolete chan no/center freq conversion functions
      mac80211_hwsim: move module_init/exit
      mac80211: check power constraint IE size when parsing
      mac80211: add key flag for management keys
      iwlwifi: fix indentation in iwl_load_given_ucode
      iwlwifi: load firmware in chunks
      mac80211: remove unneeded CONFIG_PM ifdef
      mac80211: handle power constraint/country IE better
      mac80211: change locking around ieee80211_recalc_smps
      mac80211: make reset debugfs depend on CONFIG_PM
      cfg80211: constify name parameter to add_virtual_intf
      iwlwifi: use eth_broadcast_addr
      iwlwifi: fix async station command crash
      mac80211: don't send delBA before disassoc
      mac80211: don't send delBA when removing stations
      mac80211: don't send delBA on addBA failure
      iwlegacy: use eth_broadcast_addr

John Eaglesham (1):
      bonding: support for IPv6 transmit hashing

John Fastabend (1):
      ixgbevf: scheduling while atomic in reset hw path

John W. Linville (23):
      Merge branch 'master' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge tag 'nfc-next-3.7-1' of git://git.kernel.org/.../sameo/nfc-3.0
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      ath5k: add missing breaks in ath5k_hw_set_spur_mitigation_filter
      nfc: add dummy nfc_llc_shdlc_register definition
      NFC: Add dummy nfc_llc_shdlc_register definition
      Merge tag 'nfc-next-3.7-2' of git://git.kernel.org/.../sameo/nfc-3.0
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jonathan Corbet (1):
      batman-adv: remove a misleading comment

Jozsef Kadlecsik (7):
      netfilter: ipset: Fix sparse warnings "incorrect type in assignment"
      netfilter: ipset: Check and reject crazy /0 input parameters
      netfilter: ipset: Rewrite cidr book keeping to handle /0
      netfilter: ipset: Add /0 network support to hash:net,iface type
      netfilter: ipset: Include supported revisions in module description
      netfilter: ipset: Coding style fixes
      netfilter: ipset: Support to match elements marked with "nomatch"

Julia Lawall (1):
      drivers/net/ethernet/tundra/tsi108_eth.c: delete double assignment

Julian Anastasov (6):
      ipvs: ip_vs_ftp depends on nf_conntrack_ftp helper
      ipvs: generalize app registration in netns
      ipvs: implement passive PMTUD for IPIP packets
      ipvs: add pmtu_disc option to disable IP DF for TUN packets
      netlink: add minlen validation for the new signed types
      tcp: add generic netlink support for tcp_metrics

Jussi Kivilinna (1):
      zd1211rw: enable support for MFP

Kevin Gan (1):
      mwifiex: add inactivity deauth support for ap

Kevin Groeneveld (1):
      ppp: add 64 bit stats

Konstantin Khlebnikov (1):
      nf_defrag_ipv6: fix oops on module unloading

LEROY Christophe (1):
      lxt PHY: Support for the buggy LXT973 rev A2

Larry Finger (6):
      p54pci: convert driver to use asynchronous firmware loading
      rtlwifi: rtl8192c: rtl8192de: Fix typo in cursta_connectctate
      rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192se: Remove sparse warnings
      rtlwifi: Update header file
      rtlwifi: Remove EXPERIMENTAL as pre-requisite for the drivers
      b43legacy: Fix crash on unload when firmware not available

Li RongQing (2):
      ipv6: replace write lock with read lock when get route info
      ipv6: recursive check rt->dst.from when call rt6_check_expired

Lin Ming (1):
      ipv6: return errno pointers consistently for fib6_add_1()

Luciano Coelho (1):
      wl12xx: use module_platform_driver

Mahesh Palivela (1):
      mac80211: VHT (11ac) association

Marco Porsch (1):
      mac80211: fix unnecessary beacon update after peering status change

Marek Lindner (1):
      batman-adv: convert remaining packet counters to per_cpu_ptr() infrastructure

Mark Rustad (1):
      ixgbe: Improve statistics accuracy for DDP traffic

Martin Hundeb√∏ll (2):
      batman-adv: Move batadv_check_unicast_packet()
      batman-adv: Drop tt queries with foreign dest

Masatake YAMATO (9):
      Bluetooth: /proc/net/ entries for bluetooth protocols
      Bluetooth: Added /proc/net/bnep via bt_procfs_init()
      Bluetooth: Added /proc/net/cmtp via bt_procfs_init()
      Bluetooth: Added /proc/net/hci via bt_procfs_init()
      Bluetooth: Added /proc/net/hidp via bt_procfs_init()
      Bluetooth: Added /proc/net/l2cap via bt_procfs_init()
      Bluetooth: Added /proc/net/rfcomm via bt_procfs_init()
      Bluetooth: Added /proc/net/sco via bt_procfs_init()
      net: Providing protocol type via system.sockprotoname xattr of /proc/PID/fd entries

Matthew Vick (6):
      igb: Tidy up wrapping for CONFIG_IGB_PTP.
      igb: Update PTP function names/variables and locations.
      igb: Correct PTP support query from ethtool.
      igb: Store the MAC address in the name in the PTP struct.
      igb: Prevent dropped Tx timestamps via work items and interrupts.
      igb: Add 1588 support to I210/I211.

Meenakshi Venkataraman (2):
      iwlwifi: clean up properly when registration with mac80211 fails
      iwlwifi: rework the iwlwifi debugfs structure

Merav Sicron (1):
      bnx2x: Improve code around bnx2x_tests_str_arr

Michael Chan (12):
      cnic: Add functions to allocate and free UIO rings
      cnic: Free UIO rings when the device is closed.
      cnic: Add function pointers to arm IRQ for different devices.
      cnic: Allocate kcq resource only on devices that support FCoE.
      cnic: Allocate UIO resources only on devices that support iSCSI.
      tg3: Introduce separate functions to allocate/free RX/TX rings.
      tg3: Allow number of rx and tx rings to be set independently.
      tg3: Separate coalescing setup for rx and tx
      tg3: Refactor tg3_open()
      tg3: Refactor tg3_close()
      tg3: Add support for ethtool -L|-l to get/set the number of rings.
      tg3: Disable multiple TX rings by default due to hardware flaw

Michael Wang (3):
      netfilter: replace list_for_each_continue_rcu with new interface
      netfilter: pass 'nf_hook_ops' instead of 'list_head' to nf_iterate()
      netfilter: pass 'nf_hook_ops' instead of 'list_head' to nf_queue()

Michal Kazior (1):
      mac80211: refactor set_channel_type

Michal Schmidt (1):
      r8169: use unlimited DMA burst for TX

Mika Westerberg (1):
      i825xx: znet: fix compiler warnings when building a 64-bit kernel

Mikel Astiz (3):
      Bluetooth: Add more HCI error codes
      Bluetooth: Fix minor coding style in hci_event.c
      Bluetooth: mgmt: Add device disconnect reason

Ming Lei (2):
      wireless: ath9k-htc: only load firmware in need
      wireless: ath9k-htc: fix possible use after free

Mohammed Shafi Shajakhan (11):
      ath9k_hw: small optimization
      ath9k_hw: Fix invalid MCI GPM index access/caching
      ath9k: Fix BTCOEX timer triggering comparision
      ath9k: Make use of ath_stop_ani wrapper
      ath9k: Remove an obselete function declaration
      ath9k: Cleanup add/change_interface callbacks
      ath9k_htc: minor cleanup in ath9k_htc_add_station
      ath9k_htc: Add a modparam to enable BTCOEX rather than default
      ath9k_htc: Cancel BTCOEX related work before disabling BTCOEX
      ath9k: Add Generic hardware timer interrupt in debugfs
      ath9k: update hw_timer_enabled to false when we stop generic timers

Mugunthan V N (4):
      drivers: net: ethernet: cpsw: Add SOC dependency support for cpsw dependent modules
      drivers: net: ethernet: cpsw: Add device tree support to CPSW
      drivers: net: ethernet: davince_mdio: device tree implementation
      documentation: dt: bindings: cpsw: fixing the examples for directly using it in dts file

Narendra K (1):
      ixgbevf - Remove unused parameter in ixgbevf_receive_skb

Neal Cardwell (5):
      tcp: extract code to compute SYNACK RTT
      tcp: TCP Fast Open Server - take SYNACK RTT after completing 3WHS
      tcp: TCP Fast Open Server - note timestamps and retransmits for SYNACK RTT
      tcp: TCP Fast Open Server - call tcp_validate_incoming() for all packets
      tcp: TCP Fast Open Server - record retransmits after 3WHS

Neil Horman (1):
      cls_cgroup: Allow classifier cgroups to have their classid reset to 0

Nick Kossifidis (4):
      ath5k: Use correct value for min_pwr and cur_pwr
      ath5k: Fix range scaling when setting rate power table
      ath5k: Preserve tx power level requested from above on phy_init
      ath5k: Put power_level where it belongs and rename it

Nicolas Dichtel (4):
      ipv6: fix handling of blackhole and prohibit routes
      ipv6: fix handling of throw routes
      ipv4/route: arg delay is useless in rt_cache_flush()
      ipv6: del unreachable route when an addr is deleted on lo

Nikolay Aleksandrov (1):
      net: add unknown state to sysfs NIC duplex export

Oliver Neukum (2):
      usbnet: drop unneeded check for NULL
      Revert "usbnet: drop unneeded check for NULL"

Or Gerlitz (2):
      IB/ipoib: Add rtnl_link_ops support
      IB/ipoib: Add more rtnl_link_ops callbacks

Otto Estuardo Solares Cabrera (1):
      e1000: add byte queue limits

Pablo Neira Ayuso (15):
      netfilter: nf_nat: support IPv6 in IRC NAT helper
      netfilter: nf_nat: support IPv6 in TFTP NAT helper
      netfilter: xt_socket: fix compilation warnings with gcc 4.7
      netfilter: xt_CT: refactorize xt_ct_tg_check
      netfilter: nf_conntrack: add nf_ct_timeout_lookup
      Merge git://git.kernel.org/.../davem/net-next
      netfilter: fix crash during boot if NAT has been compiled built-in
      netlink: kill netlink_set_nonroot
      netlink: hide struct module parameter in netlink_kernel_create
      netfilter: ctnetlink: fix module auto-load in ctnetlink_parse_nat
      netfilter: fix IPv6 NAT dependencies in Kconfig
      netlink: use <linux/export.h> instead of <linux/module.h>
      netfilter: nf_ct_ftp: add sequence tracking pickup facility for injected entries
      netfilter: nfnetlink_queue: fix maximum packet length to userspace
      netfilter: nfnetlink_queue: add NFQA_CAP_LEN attribute

Pandiyarajan Pitchaimuthu (1):
      cfg80211/nl80211: Notify connection request failure in AP mode

Patrick McHardy (19):
      netfilter: sparse endian fixes
      netfilter: nf_conntrack: remove unnecessary RTNL locking
      ipv4: fix path MTU discovery with connection tracking
      netfilter: nf_conntrack_ipv6: improve fragmentation handling
      netfilter: nf_conntrack_ipv6: fix tracking of ICMPv6 error messages containing fragments
      netfilter: nf_conntrack: restrict NAT helper invocation to IPv4
      netfilter: nf_nat: add protoff argument to packet mangling functions
      netfilter: add protocol independent NAT core
      netfilter: ipv6: expand skb head in ip6_route_me_harder after oif change
      net: core: add function for incremental IPv6 pseudo header checksum updates
      netfilter: ipv6: add IPv6 NAT support
      netfilter: ip6tables: add MASQUERADE target
      netfilter: ip6tables: add REDIRECT target
      netfilter: ip6tables: add NETMAP target
      netfilter: nf_nat: support IPv6 in FTP NAT helper
      netfilter: nf_nat: support IPv6 in amanda NAT helper
      netfilter: nf_nat: support IPv6 in SIP NAT helper
      netfilter: ip6tables: add stateless IPv6-to-IPv6 Network Prefix Translation target
      netfilter: nf_nat: fix oops when unloading protocol modules

Paul Bolle (1):
      ipw2x00: silence GCC warning for unused variable 'dev'

Paul Gortmaker (1):
      tg3: unconditionally select HWMON support when tg3 is enabled.

Pavel Emelyanov (12):
      net: Dont use ifindices in hash fns
      net: Allow to create links with given ifindex
      veth: Allow to create peer link with given ifindex
      net: Make ifindex generation per-net namespace
      net: Loopback ifindex is constant now
      packet: Introduce net/packet/internal.h header
      packet: Diag core and basic socket info dumping
      packet: Report more packet sk info via diag module
      packet: Report socket mclist info via diag module
      packet: Report rings cfg via diag engine
      packet: Report fanout status via diag engine
      packet: Protect packet sk list with mutex (v2)

Peter Senna Tschudin (15):
      net/mac80211/scan.c: removes unnecessary semicolon
      drivers/net/usb/sierra_net.c: removes unnecessary semicolon
      drivers/net/wireless/rtlwifi/rtl8192de/phy.c: removes unnecessary semicolon
      drivers/net/wireless/ath/ath9k/ar9003_mac.c: removes unnecessary semicolon
      drivers/isdn/gigaset/common.c: Remove useless kfree
      net/ieee802154/6lowpan.c: Remove unecessary semicolon
      net/openvswitch/vport.c: Remove unecessary semicolon
      net/tipc/name_table.c: Remove unecessary semicolon
      Bluetooth: bluecard_cs.c: removes unnecessary semicolon
      Bluetooth: hci_ldisc.c: removes unnecessary semicolon
      Bluetooth: hci_ll.c: removes unnecessary semicolon
      Bluetooth: hci_vhci.c: removes unnecessary semicolon
      Bluetooth: btuart_cs.c: removes unnecessary semicolon
      drivers/s390/net: removes unnecessary semicolon
      ctcm: fix error return code

Piotr Haber (1):
      brcmsmac: don't start device when RfKill is engaged

Pravin B Shelar (2):
      openvswitch: Add support for network namespaces.
      openvswitch: Increase maximum number of datapath ports.

Priyanka Jain (1):
      Replace rwlock on xfrm_policy_afinfo with rcu

Quinlan Pfiffer (1):
      asix: Adds support for Lenovo 10/100 USB dongle.

Rafa≈Ç Mi≈Çecki (16):
      b43: N-PHY: update workarounds
      b43: N-PHY: add PHY rev7+ workarounds
      b43: rename host flags defines
      b43: add helper waiting for given value in radio reg
      b43: N-PHY: finish 0x2056 radio setup
      b43: N-PHY: init 0x2057 radio
      b43: be more user friendly with PHY info
      b43: N-PHY: add overriding RF control for rev7+
      bcma: add (mostly) NAND defines
      b43: N-PHY: fix 0x2057 radio calib copy/paste mistake
      b43legacy: fix logic in GPIO init
      ssb: check for flash presentence
      bcma: detect and register serial flash device
      bcma: detect and register NAND flash device
      bcma: handle BCM43227
      bcma: change delays to follow timers-howto guide

Rajkumar Manoharan (13):
      ath9k: tune rc_stats to display only valid rates
      ath9k_hw: Read and apply thermometer settings from EEPROM
      ath9k_hw: Read and configure thermocal for AR9462
      ath9k_hw: Wait BT calibration to complete
      ath9k_hw: use peak detection for 5GHz
      ath9k_hw: add 8 points for 5G temp slop
      ath9k_hw: move 2g5g switch before nfcal start
      ath9k_hw: fix ar9462 selfgen chainmask
      ath9k: flush bt profile whenever it is requested
      ath9k: move coex param updation within mci work
      ath9k: fill led_pin before drv_start
      ath9k: fix queuing MCI work twice
      ath9k_hw: fix BT sleep state on chip wakeup

Rami Rosen (2):
      packet: fix broken build.
      net: fix documentation of skb_needs_linearize().

Randy Dunlap (1):
      can: usb: peak: rename peak_usb dump_mem function

Razvan Ghitulete (1):
      net: remove wrong initialization for snd_wl1

Richard Cochran (4):
      ptp: remember the adjusted frequency
      ptp: provide the clock's adjusted frequency
      ptp: link the phc device to its parent device
      ptp: clarify the clock_name sysfs attribute

Robert P. J. Day (1):
      cfg80211: add kerneldoc entry for "vht_cap"

Sachin Kamat (12):
      Bluetooth: Use devm_kzalloc in bcm203x.c file.
      Bluetooth: Use devm_kzalloc in bfusb.c file
      Bluetooth: Use devm_kzalloc in bluecard_cs.c file
      Bluetooth: Use devm_kzalloc in bpa10x.c file
      Bluetooth: Use devm_kzalloc in bt3c_cs.c file
      Bluetooth: Use devm_kzalloc in btmrvl_sdio.c file
      Bluetooth: Use devm_kzalloc in btsdio.c file
      Bluetooth: Use devm_kzalloc in btuart_cs.c file
      Bluetooth: Use devm_kzalloc in btusb.c file
      Bluetooth: Use devm_kzalloc in btwilink.c file
      Bluetooth: Use devm_kzalloc in dtl1_cs.c file
      Bluetooth: Use module_platform_driver() in btwilink.c file

Samuel Ortiz (4):
      NFC: Queue pn533 commands
      NFC: Set the IRQF_ONESHOT flag from the pn544_hci IRQ handler request
      NFC: Remove unneeded LLC symbols export
      MAINTAINERS: Add NFC specific mailing list

Sathya Perla (7):
      be2net: create RSS rings even in multi-channel configs
      be2net: fixup malloc/free of adapter->pmac_id
      be2net: use PCIe AER capability
      be2net: remove type argument of be_cmd_mac_addr_query()
      be2net: fix wrong handling of be_setup() failure in be_probe()
      be2net: cleanup code related to be_link_status_query()
      be2net: fixup log messages

Saul St. John (1):
      bcma: don't leak memory for PCIE, MIPS, GBIT cores

Sebastian Ott (2):
      qeth: cleanup channel path descriptor function
      lcs: ensure proper ccw setup

Simon Wunderlich (4):
      batman-adv: Add the backbone gateway list to debugfs
      batman-adv: correct comments in bridge loop avoidance
      batman-adv: rename bridge loop avoidance claim types
      batman-adv: check batadv_orig_hash_add_if() return code

Sorin Dumitru (1):
      ipv6: remove some deadcode

Srinivas Kandagatla (6):
      of/mdio: Add dummy functions in of_mdio.h.
      of/mdio-gpio: Simplify the way device tree support is implemented.
      net:stmmac: Add check if mdiobus is registered in stmmac_mdio_unregister
      net:stmmac: fix broken stmmac_pltfr_remove.
      net:stmmac: Remove bus_id from mdio platform data.
      net:stmmac: convert driver to use devm_request_and_ioremap.

Srivatsa S. Bhat (2):
      netprio_cgroup: Remove update_netdev_tables() since it is unnecessary
      netprio_cgroup: Use memcpy instead of the for-loop to copy priomap

Stefan Assmann (1):
      igb: Change how we check for pre-existing and assigned VFs

Stephen Rothwell (1):
      netfilter: ipv6: using csum_ipv6_magic requires net/ip6_checksum.h

Steve Glendinning (9):
      smsc95xx: sleep before read for lengthy operations
      smsc95xx: remove unnecessary variables
      smsc95xx: check return code from control messages
      smsc95xx: fix resume when usb device is reset
      smsc95xx: enable power saving mode during system suspend
      smsc95xx: add wol magic packet support
      smsc75xx: add explicit test that device is READY
      smsc75xx: enable power saving mode during system suspend
      smsc75xx: add wol magic packet support

Steven J. Hill (1):
      net: mipsnet: Remove the MIPSsim Ethernet driver.

Stone Piao (14):
      mwifiex: fix coding style issue
      mwifiex: implement cfg80211 mgmt_tx handler
      mwifiex: advertise mgmt_stype to cfg80211
      mwifiex: implement cfg80211 mgmt_frame_register handler
      mwifiex: report received management frames to cfg80211
      mwifiex: implement remain_on_channel and cancel_remain_on_channel
      mwifiex: process remain on channel expired event
      mwifiex: append each IE into a seperate IE buffer
      mwifiex: send firmware initialization commands synchronously
      mwifiex: add P2P interface
      mwifiex: add support for P2P client in interface type change
      mwifiex: add support for P2P GO in interface type change
      mwifiex: parse P2P IEs from beacon_data
      mwifiex: set txpd when send a mgmt frame for AP and GO mode

Stuart Hodgson (4):
      sfc: Add explicit RX queue flag to channel
      sfc: Add channel specific receive_skb handler and post_remove callback
      sfc: Allow efx_mcdi_rpc to be called in two parts
      sfc: Add support for IEEE-1588 PTP

Sujith Manoharan (40):
      ath9k: Simplify rate table initialization
      ath9k: Cleanup RC init API
      ath9k: Cleanup ath_rc_setvalid_rates
      ath9k: Cleanup ath_rc_setvalid_htrates
      ath9k: Cleanup index retrieval routines
      ath9k: Change rateset calculation
      ath9k: Remove ath_rc_set_valid_rate_idx
      ath9k: Unify valid rate calculation routines
      ath9k: Do not set IEEE80211_TX_RC_USE_SHORT_PREAMBLE
      ath9k: Fix RTS/CTS rate selection
      ath9k: Bail out properly before calculating rate index
      ath9k: Cleanup TX status API
      ath9k: Remove MIMO-PS specific code
      ath9k: Trim rate table
      mac80211: Fix AP mode regression
      ath9k: Fix TX filter usage
      ath9k_hw: Add version/revision macros for AR9565
      ath9k_hw: Add AR9565 initvals
      ath9k_hw: Add AR9565 HW support
      ath9k: Set correct max streams for AR9565
      ath9k_hw: Fix spur mitigation for AR9565
      ath9k_hw: Program correct PLL value for AR9565
      ath9k: Add PCI ID for AR9565
      ath9k_hw: Handle gentimer termination properly
      ath9k_hw: Rename antenna diversity macros
      ath9k: Choose correct LED pin for AR9565
      ath9k: Enable SGI correctly
      ath9k_hw: Use HW cap ATH9K_HW_CAP_ANT_DIV_COMB
      ath9k: Remove redundant variable assignment
      ath9k: Remove a couple of unused variables
      ath9k_hw: Add antenna diversity group for AR9565
      ath9k_hw: Update AR9565 initvals
      ath9k_hw: Add a HW callback to set diversity
      ath9k: Add a module parameter to enable diversity
      ath9k_hw: Enable WLAN RX diversity for AR9565
      ath9k: Disable ASPM only for AR9285
      ath9k: Handle errors properly in MCI initialization
      ath9k: Add a debugfs file to adjust antenna diversity
      ath9k: Fix chainmask selection for AR9462
      ath9k: Fix BTCOEX weight initialization

Sven Eckelmann (6):
      batman-adv: Split batadv_priv in sub-structures for features
      batman-adv: Use BIT(x) macro to calculate bit positions
      batman-adv: Don't break statements after assignment operator
      batman-adv: Reduce accumulated length of simple statements
      batman-adv: Start new development cycle
      ath9k_hw: Handle AR_INTR_SYNC_HOST1_(FATAL|PERR) on AR9003

Syam Sidhardhan (4):
      Bluetooth: debug: Correct the PSM printing
      Bluetooth: Use kref for l2cap channel reference counting
      NFC: Use module_platform_driver macro for nfcwilink.c
      NFC: Remove repeated code for NULL check

Sylvain Roger Rieunier (1):
      mac80211: fix IBSS auth TX debug message

Szymon Janc (4):
      NFC: Use dynamic initialization for rwlocks
      NFC: Fix missing mutex unlock in pn533_send_cmd_frame_async
      NFC: Fix sleeping in invalid context when netlink socket is closed
      NFC: Fix sleeping in atomic when releasing socket

Tejun Heo (2):
      NFC: Use system_nrt_wq instead of custom ones
      NFC: Don't use WQ_MEM_RECLAIM for pn533

Thierry Escande (1):
      NFC: LLCP raw socket support

Thomas Huehn (1):
      mac80211: move TX station pointer and restructure TX

Thomas Pedersen (6):
      mac80211: improve cleanup when leaving mesh
      mac80211: remove ieee80211_clean_sdata()
      mac80211: don't request ack for peering close
      mac80211: skb leak in mesh_plink_frame_tx()
      mac80211: use skb_queue_walk() in mesh_path_assign_nexthop
      mac80211: clean up mpath_move_to_queue()

Thomas Wagner (1):
      ath9k: Fix rx filtering issue for older chips

Tim Gardner (2):
      firmware: Remove obsolete Chelsio cxgb3 firmware
      wlcore: Declare MODULE_FIRMWARE usage

Timur Tabi (10):
      net/fsl: introduce Freescale 10G MDIO driver
      netdev/phy: add MDIO bus multiplexer driven by a memory-mapped device
      net/freescale: do not export any functions from fsl_pq_mdio.c
      net/fsl_pq_mdio: trim #include statements
      net/fsl_pq_mdio: merge some functions together
      net/fsl_pq_mdio: various small fixes
      net/fsl_pq_mdio: streamline probing of MDIO nodes
      net/fsl-pq-mdio: coalesce multiple memory allocations into one
      net/fsl_pq_mdio: add support for the Fman 1G MDIO controller
      netdev/phy: mdio-mux-mmioreg.c should include of_address.h

Ulrich Weber (2):
      sctp: fix compile issue with disabled CONFIG_NET_NS
      netfilter: nf_nat: remove obsolete rcu_read_unlock call

Vasundhara Volam (3):
      be2net: fix max VFs reported by HW
      be2net: fix FW default for VF tx-rate
      be2net: modify log msg for lack of privilege error

Vinicius Costa Gomes (8):
      Bluetooth: Remove some functions from being exported
      Bluetooth: Rename LE and ACL connection functions
      Bluetooth: Refactor LE connection into its own function
      Bluetooth: Refactor ACL connection into its own function
      Bluetooth: Refactor SCO connection into its own function
      Bluetooth: Simplify a the connection type handling
      Bluetooth: Add type information to the hci_connect() debug statement
      Bluetooth: Fix establishing ESCO links

Vipul Pandya (9):
      RDMA/cxgb4: Update RDMA/cxgb4 due to macro definition removal in cxgb4 driver
      cxgb4: Remove duplicate register definitions
      cxgb4: Fix incorrect values for MEMWIN*_APERTURE and MEMWIN*_BASE
      cxgb4: Add functions to read memory via PCIE memory window
      cxgb4/cxgb4vf: Code cleanup to enable T4 Configuration File support
      cxgb4: Add support for T4 configuration file
      cxgb4: Add support for T4 hardwired driver configuration settings
      cxgb4: Inform caller if driver didn't upgrade firmware
      cxgb4: Don't attempt to upgrade T4 firmware when cxgb4 will end up as a slave

Vitaly Wool (1):
      rfkill: prevent unnecessary event generation

Vladimir Kondratiev (2):
      cfg80211: unify IE search
      cfg80211: Fix regulatory check for 60GHz band frequencies

Waldemar Rymarkiewicz (6):
      NFC: Remove crc generation from shdlc layer
      NFC: Correct outgoing frame before requeueing
      NFC: xmit from hci ops must return 0 or negative
      NFC: Handle RSET in SHDLC_CONNECTING state
      NFC: Don't handle consequent RSET frames after UA
      NFC: Fix typo negociating -> negotiating

Wanlong Gao (1):
      net:atm:fix up ENOIOCTLCMD error handling

Wei Yongjun (33):
      wimax/i2400m: use is_zero_ether_addr() instead of memcmp()
      w5100: using eth_hw_addr_random() for random MAC and set device flag
      w5300: using eth_hw_addr_random() for random MAC and set device flag
      openvswitch: using kfree_rcu() to simplify the code
      sctp: use list_move_tail instead of list_del/list_add_tail
      cfg80211: use list_move_tail instead of list_del/list_add_tail
      bnx2x: use list_move_tail instead of list_del/list_add_tail
      mac80211: use list_move instead of list_del/list_add
      ipw2100: use is_zero_ether_addr() and is_broadcast_ether_addr()
      ipw2200: use is_zero_ether_addr() and is_broadcast_ether_addr()
      orinoco: use is_zero_ether_addr() instead of memcmp()
      drivers/net: use is_zero_ether_addr() instead of memcmp()
      airo: use is_zero_ether_addr() and is_broadcast_ether_addr()
      mwifiex: use is_broadcast_ether_addr() instead of memcmp()
      mwifiex: use is_zero_ether_addr() instead of memcmp()
      wireless: use is_broadcast_ether_addr() instead of memcmp()
      wl3501_cs: use is_broadcast_ether_addr() instead of memcmp()
      wl18xx: remove duplicated include from main.c
      airo: remove duplicated include from airo.c
      rtlwifi: rtl8192de: remove pointless conditional before kfree_skb()
      rtlwifi: rtl8192c: remove pointless conditional before kfree_skb()
      Bluetooth: btmrvl: remove pointless conditional before kfree_skb()
      netfilter: nfnetlink_queue: remove pointless conditional before kfree_skb()
      ipvs: use list_del_init instead of list_del/INIT_LIST_HEAD
      rndis_wlan: remove pointless check from rndis_scan()
      can: mscan-mpc5xxx: fix return value check in mpc512x_can_get_clock()
      qeth: fix possible memory leak in qeth_l3_add_[vipa|rxip]()
      NFC: Remove pointless conditional before HCI kfree_skb()
      NFC: Fix possible LLCP memory leak
      NFC: Move the nfcwilink dereference below the NULL test
      NFC: Move the pn544_hci dereference below the NULL test
      wl12xx: remove duplicated include from main.c
      mwifiex: convert to use le16_add_cpu()

Weiping Pan (1):
      use skb_end_offset() in skb_try_coalesce()

Wolfgang Grandegger (1):
      flexcan: disable bus error interrupts for the i.MX28

Wu Fengguang (1):
      netfilter: PTR_RET can be used

Xi Wang (2):
      decnet: fix shutdown parameter checking
      af_unix: fix shutdown parameter checking

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (2):
      ipv6: Add labels for site-local and 6bone testing addresses (RFC6724)
      ipv6: Compare addresses only bits up to the prefix length (RFC6724).

Yair Shapira (2):
      wl18xx: number_of_assembled_ant5 indicates if A band is enabled
      wlcore/wl18xx: add phy_fw_version_str to debugfs driver_state

Yaniv Rosner (2):
      bnx2x: link code refactoring
      bnx2x: Link Flap Avoidance

Ying Luo (3):
      mwifiex: rename wapi_rxpn to pn
      mwifiex: pass key_params pointer in mwifiex_set_encode
      mwifiex: add AES_CMAC support in key_material cmd

Ying Xue (10):
      tipc: optimize the initialization of network device notifier
      tipc: fix lockdep warning during bearer initialization
      tipc: remove pointless name sanity check and tipc_alphabet array
      tipc: manually inline single use media_name_valid routine
      tipc: change tipc_net_start routine return value type
      tipc: convert tipc_nametbl_size type from variable to macro
      tipc: add __read_mostly annotations to several global variables
      tipc: eliminate configuration for maximum number of name subscriptions
      tipc: eliminate configuration for maximum number of name publications
      rds: Don't disable BH on BH context

Yogesh Ashok Powar (3):
      mwifiex: copy MSDU subframes correctly
      mwifiex: remove extra padding to AMSDU
      mwifiex: correction in MSDU padding logic

Yuchung Cheng (3):
      tcp: move tcp_enter_cwr()
      tcp: move tcp_update_cwnd_in_recovery
      tcp: use PRR to reduce cwin in CWR state

Yuval Mintz (8):
      bnx2x: EEE status is read locally
      bnx2x: add EEE support for 4-port devices
      bnx2x: EEE code refactoring
      bnx2x: correct & clean 10G EEE requirements
      bnx2x: use native EEE instead of auto-greeen
      bnx2x: Utilize Link Flap Avoidance
      bnx2x,cnic: use FW 7.8.2
      bnx2x: update version to 1.78.00-0.

alex.bluesman.smirnov@gmail.com (2):
      drivers/ieee802154/at86rf230: replace the code under _init and _exit by macro
      drivers/ieee802154: move ieee802154 drivers to net folder

danborkmann@iogearbox.net (1):
      af_packet: use define instead of constant

david decotigny (3):
      forcedeth: fix buffer overflow
      forcedeth: fix TX timeout caused by TX pause on down link
      forcedeth: prevent TX timeouts after reboot

stephen hemminger (10):
      netdev: make address const in device address management
      gre: fix handling of key 0
      gre: remove unnecessary rcu_read_lock/unlock
      xfrm: remove extranous rcu_read_lock
      tunnel: drop packet if ECN present with not-ECT
      gre: fix sparse warning
      netlink: add attributes to fdb interface
      igmp: export symbol ip_mc_leave_group
      vxlan: virtual extensible lan
      vxlan: put UDP socket in correct namespace

xeb@mail.ru (1):
      gre: Support GRE over IPv6

 Documentation/ABI/testing/sysfs-ptp                        |    6 +-
 Documentation/devicetree/bindings/net/can/c_can.txt        |   49 +
 Documentation/devicetree/bindings/net/cpsw.txt             |  109 +++
 Documentation/devicetree/bindings/net/davinci-mdio.txt     |   33 +
 Documentation/devicetree/bindings/net/mdio-mux-mmioreg.txt |   75 ++
 Documentation/feature-removal-schedule.txt                 |   20 -
 Documentation/filesystems/nfs/nfsroot.txt                  |   10 +-
 Documentation/infiniband/ipoib.txt                         |    3 +
 Documentation/networking/batman-adv.txt                    |    7 +-
 Documentation/networking/bonding.txt                       |   30 +-
 Documentation/networking/ip-sysctl.txt                     |   37 +-
 Documentation/networking/stmmac.txt                        |    5 -
 Documentation/networking/vxlan.txt                         |   47 +
 MAINTAINERS                                                |    1 +
 arch/m68k/configs/amiga_defconfig                          |    1 -
 arch/m68k/configs/apollo_defconfig                         |    1 -
 arch/m68k/configs/atari_defconfig                          |    1 -
 arch/m68k/configs/bvme6000_defconfig                       |    1 -
 arch/m68k/configs/hp300_defconfig                          |    1 -
 arch/m68k/configs/mac_defconfig                            |    1 -
 arch/m68k/configs/multi_defconfig                          |    1 -
 arch/m68k/configs/mvme147_defconfig                        |    1 -
 arch/m68k/configs/mvme16x_defconfig                        |    1 -
 arch/m68k/configs/q40_defconfig                            |    1 -
 arch/m68k/configs/sun3_defconfig                           |    1 -
 arch/m68k/configs/sun3x_defconfig                          |    1 -
 arch/mips/configs/ar7_defconfig                            |    1 -
 arch/mips/configs/bcm47xx_defconfig                        |    1 -
 arch/mips/configs/ip22_defconfig                           |    1 -
 arch/mips/configs/jazz_defconfig                           |    1 -
 arch/mips/configs/malta_defconfig                          |    1 -
 arch/mips/configs/markeins_defconfig                       |    1 -
 arch/mips/configs/nlm_xlp_defconfig                        |    1 -
 arch/mips/configs/nlm_xlr_defconfig                        |    1 -
 arch/mips/configs/rm200_defconfig                          |    1 -
 arch/powerpc/configs/pmac32_defconfig                      |    1 -
 arch/powerpc/configs/ppc64_defconfig                       |    1 -
 arch/powerpc/configs/ppc64e_defconfig                      |    1 -
 arch/powerpc/configs/ppc6xx_defconfig                      |    1 -
 arch/sparc/net/bpf_jit_comp.c                              |    4 +
 arch/tile/configs/tilegx_defconfig                         |    1 -
 arch/tile/configs/tilepro_defconfig                        |    1 -
 arch/x86/net/bpf_jit_comp.c                                |   34 +
 crypto/crypto_user.c                                       |    7 +-
 drivers/Makefile                                           |    1 -
 drivers/bcma/Kconfig                                       |    4 +-
 drivers/bcma/bcma_private.h                                |    2 +
 drivers/bcma/core.c                                        |    2 +-
 drivers/bcma/driver_chipcommon_nflash.c                    |   28 +-
 drivers/bcma/driver_chipcommon_pmu.c                       |    9 +-
 drivers/bcma/driver_chipcommon_sflash.c                    |  123 ++-
 drivers/bcma/driver_pci.c                                  |    6 +-
 drivers/bcma/driver_pci_host.c                             |    8 +-
 drivers/bcma/host_pci.c                                    |   12 +-
 drivers/bcma/host_soc.c                                    |    2 +-
 drivers/bcma/main.c                                        |   27 +
 drivers/bcma/sprom.c                                       |    2 +
 drivers/bluetooth/bcm203x.c                                |    8 +-
 drivers/bluetooth/bfusb.c                                  |   12 +-
 drivers/bluetooth/bluecard_cs.c                            |    7 +-
 drivers/bluetooth/bpa10x.c                                 |    8 +-
 drivers/bluetooth/bt3c_cs.c                                |    5 +-
 drivers/bluetooth/btmrvl_sdio.c                            |   18 +-
 drivers/bluetooth/btsdio.c                                 |    8 +-
 drivers/bluetooth/btuart_cs.c                              |    7 +-
 drivers/bluetooth/btusb.c                                  |   16 +-
 drivers/bluetooth/btwilink.c                               |   24 +-
 drivers/bluetooth/dtl1_cs.c                                |    3 +-
 drivers/bluetooth/hci_ldisc.c                              |    2 +-
 drivers/bluetooth/hci_ll.c                                 |    2 +-
 drivers/bluetooth/hci_vhci.c                               |    2 +-
 drivers/connector/connector.c                              |    3 +-
 drivers/infiniband/core/netlink.c                          |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c                           |    2 +-
 drivers/infiniband/ulp/ipoib/Makefile                      |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib.h                       |   16 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c                    |   34 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c                  |   41 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c               |  172 ++++
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c                  |  124 +--
 drivers/isdn/gigaset/common.c                              |    1 -
 drivers/net/Kconfig                                        |   17 +-
 drivers/net/Makefile                                       |    2 +
 drivers/net/bonding/bond_main.c                            |  140 ++-
 drivers/net/can/c_can/c_can.c                              |  130 ++-
 drivers/net/can/c_can/c_can.h                              |   14 +-
 drivers/net/can/c_can/c_can_pci.c                          |    6 +-
 drivers/net/can/c_can/c_can_platform.c                     |  123 ++-
 drivers/net/can/flexcan.c                                  |   29 +-
 drivers/net/can/mscan/mpc5xxx_can.c                        |    4 +-
 drivers/net/can/sja1000/sja1000.c                          |   31 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c               |    8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h               |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c                |    8 +-
 drivers/net/ethernet/Kconfig                               |    9 -
 drivers/net/ethernet/Makefile                              |    1 -
 drivers/net/ethernet/broadcom/Kconfig                      |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c            |   24 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h            |   16 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c            |   12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c        |   58 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h        |    3 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h            |  109 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h           |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c           | 1701 ++++++++++++++++----------------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h           |    7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c           |   34 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h            |   14 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c             |    5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c          |   35 +-
 drivers/net/ethernet/broadcom/cnic.c                       |  116 ++-
 drivers/net/ethernet/broadcom/cnic.h                       |    5 +
 drivers/net/ethernet/broadcom/cnic_defs.h                  |    2 +-
 drivers/net/ethernet/broadcom/cnic_if.h                    |    4 +-
 drivers/net/ethernet/broadcom/tg3.c                        |  534 ++++++----
 drivers/net/ethernet/broadcom/tg3.h                        |    9 +-
 drivers/net/ethernet/brocade/bna/bnad.c                    |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                 |   51 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c            |  954 +++++++++++++++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h             |    2 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c                   |  341 +++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                 |  734 +++++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h                 |   80 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h               |  185 +++-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h              |   97 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                 |    5 +-
 drivers/net/ethernet/emulex/benet/be.h                     |    2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                |   55 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h                |    6 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c             |   57 +-
 drivers/net/ethernet/emulex/benet/be_main.c                |   96 +-
 drivers/net/ethernet/freescale/Kconfig                     |    7 +
 drivers/net/ethernet/freescale/Makefile                    |    1 +
 drivers/net/ethernet/freescale/fsl_pq_mdio.c               |  549 ++++++-----
 drivers/net/ethernet/freescale/fsl_pq_mdio.h               |   52 -
 drivers/net/ethernet/freescale/gianfar.c                   |   12 +-
 drivers/net/ethernet/freescale/gianfar.h                   |   11 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c               |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.c                  |    1 -
 drivers/net/ethernet/freescale/xgmac_mdio.c                |  274 ++++++
 drivers/net/ethernet/i825xx/Kconfig                        |    2 +-
 drivers/net/ethernet/i825xx/znet.c                         |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c           |   39 +
 drivers/net/ethernet/intel/e1000/e1000_main.c              |   14 +
 drivers/net/ethernet/intel/e1000e/82571.c                  |    4 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c                |   44 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                 |   19 +-
 drivers/net/ethernet/intel/e1000e/phy.c                    |   31 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c               |   17 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h             |   11 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c                 |   29 +-
 drivers/net/ethernet/intel/igb/e1000_phy.h                 |    5 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h                |    3 +
 drivers/net/ethernet/intel/igb/igb.h                       |   41 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c               |  198 ++--
 drivers/net/ethernet/intel/igb/igb_main.c                  |  711 ++++----------
 drivers/net/ethernet/intel/igb/igb_ptp.c                   |  677 ++++++++++---
 drivers/net/ethernet/intel/ixgbe/Makefile                  |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                   |   35 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c           |  300 ++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c              |  573 ++++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c               |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c             |  105 +-
 drivers/net/ethernet/intel/ixgbevf/defines.h               |    1 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h               |    9 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c          |  272 ++++--
 drivers/net/ethernet/intel/ixgbevf/mbx.c                   |   15 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.h                   |   21 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c                    |  122 ++-
 drivers/net/ethernet/intel/ixgbevf/vf.h                    |    4 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                 |    4 -
 drivers/net/ethernet/mipsnet.c                             |  345 -------
 drivers/net/ethernet/nvidia/forcedeth.c                    |   17 +-
 drivers/net/ethernet/realtek/r8169.c                       |    4 +-
 drivers/net/ethernet/sfc/Kconfig                           |    7 +
 drivers/net/ethernet/sfc/Makefile                          |    1 +
 drivers/net/ethernet/sfc/bitfield.h                        |   22 +-
 drivers/net/ethernet/sfc/efx.c                             |  250 +++--
 drivers/net/ethernet/sfc/efx.h                             |    1 +
 drivers/net/ethernet/sfc/ethtool.c                         |   16 +-
 drivers/net/ethernet/sfc/falcon_boards.c                   |    2 +-
 drivers/net/ethernet/sfc/filter.c                          |  108 +--
 drivers/net/ethernet/sfc/filter.h                          |    7 +-
 drivers/net/ethernet/sfc/mcdi.c                            |   49 +-
 drivers/net/ethernet/sfc/mcdi.h                            |   12 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h                       |   29 +-
 drivers/net/ethernet/sfc/mtd.c                             |    7 +-
 drivers/net/ethernet/sfc/net_driver.h                      |   78 +-
 drivers/net/ethernet/sfc/nic.c                             |    6 +-
 drivers/net/ethernet/sfc/nic.h                             |   36 +
 drivers/net/ethernet/sfc/ptp.c                             | 1484 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/rx.c                              |   20 +-
 drivers/net/ethernet/sfc/selftest.c                        |    3 +-
 drivers/net/ethernet/sfc/siena.c                           |    1 +
 drivers/net/ethernet/sfc/siena_sriov.c                     |    8 +
 drivers/net/ethernet/sfc/tx.c                              |  627 +++++-------
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c          |   11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c           |    1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c      |   39 +-
 drivers/net/ethernet/sun/sunbmac.c                         |    1 -
 drivers/net/ethernet/ti/Kconfig                            |    4 +-
 drivers/net/ethernet/ti/cpsw.c                             |  179 +++-
 drivers/net/ethernet/ti/davinci_mdio.c                     |   41 +-
 drivers/net/ethernet/tundra/tsi108_eth.c                   |    1 -
 drivers/net/ethernet/wiznet/w5100.c                        |    3 +-
 drivers/net/ethernet/wiznet/w5300.c                        |    3 +-
 drivers/net/hyperv/hyperv_net.h                            |    4 +-
 drivers/net/hyperv/netvsc.c                                |   22 +-
 drivers/net/hyperv/netvsc_drv.c                            |    4 +-
 drivers/net/hyperv/rndis_filter.c                          |   60 +-
 drivers/{ => net}/ieee802154/Kconfig                       |   11 +
 drivers/{ => net}/ieee802154/Makefile                      |    1 +
 drivers/{ => net}/ieee802154/at86rf230.c                   |   12 +-
 drivers/{ => net}/ieee802154/fakehard.c                    |    1 -
 drivers/{ => net}/ieee802154/fakelb.c                      |    0
 drivers/net/ieee802154/mrf24j40.c                          |  767 +++++++++++++++
 drivers/net/loopback.c                                     |    3 +-
 drivers/net/macvlan.c                                      |    6 +-
 drivers/net/phy/Kconfig                                    |   13 +
 drivers/net/phy/Makefile                                   |    1 +
 drivers/net/phy/dp83640.c                                  |    2 +-
 drivers/net/phy/lxt.c                                      |  127 +++
 drivers/net/phy/mdio-gpio.c                                |  132 +--
 drivers/net/phy/mdio-mux-mmioreg.c                         |  171 ++++
 drivers/net/phy/phy.c                                      |   74 +-
 drivers/net/ppp/ppp_generic.c                              |   58 +-
 drivers/net/team/Kconfig                                   |    4 +-
 drivers/net/team/team.c                                    |  342 ++++++-
 drivers/net/team/team_mode_broadcast.c                     |    8 +-
 drivers/net/team/team_mode_roundrobin.c                    |    8 +-
 drivers/net/tun.c                                          |   46 +-
 drivers/net/usb/asix_devices.c                             |   40 +-
 drivers/net/usb/catc.c                                     |   55 +-
 drivers/net/usb/cx82310_eth.c                              |   11 +-
 drivers/net/usb/gl620a.c                                   |   10 +-
 drivers/net/usb/kaweth.c                                   |  134 +--
 drivers/net/usb/net1080.c                                  |   51 +-
 drivers/net/usb/qmi_wwan.c                                 |   47 +-
 drivers/net/usb/rtl8150.c                                  |    6 +-
 drivers/net/usb/sierra_net.c                               |   25 +-
 drivers/net/usb/smsc75xx.c                                 |  240 ++++-
 drivers/net/usb/smsc95xx.c                                 |  560 +++++++----
 drivers/net/usb/smsc95xx.h                                 |   12 +-
 drivers/net/veth.c                                         |    3 +
 drivers/net/virtio_net.c                                   |    2 +-
 drivers/net/vxlan.c                                        | 1219 +++++++++++++++++++++++
 drivers/net/wimax/i2400m/driver.c                          |    3 +-
 drivers/net/wireless/adm8211.c                             |    4 +-
 drivers/net/wireless/airo.c                                |   55 +-
 drivers/net/wireless/at76c50x-usb.c                        |   58 +-
 drivers/net/wireless/ath/ath.h                             |    1 +
 drivers/net/wireless/ath/ath5k/ath5k.h                     |    2 +-
 drivers/net/wireless/ath/ath5k/base.c                      |    6 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c              |   12 +-
 drivers/net/wireless/ath/ath5k/phy.c                       |   45 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                 |    4 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.h                 |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c                       |    2 +-
 drivers/net/wireless/ath/ath9k/antenna.c                   |  117 ++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c             |  288 +++---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h             |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                 |   57 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                |   21 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c                |   43 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.h                |   14 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                |  197 +++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                |   95 +-
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h       |    2 +-
 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h       | 1231 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h                     |   12 +-
 drivers/net/wireless/ath/ath9k/btcoex.c                    |   65 +-
 drivers/net/wireless/ath/ath9k/btcoex.h                    |    3 +-
 drivers/net/wireless/ath/ath9k/debug.c                     |   58 +-
 drivers/net/wireless/ath/ath9k/debug.h                     |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom.h                    |    3 +-
 drivers/net/wireless/ath/ath9k/gpio.c                      |   72 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c                   |   38 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h                   |    4 +-
 drivers/net/wireless/ath/ath9k/htc.h                       |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c              |   13 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c              |    5 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c              |   51 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c              |    2 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h                    |    7 +
 drivers/net/wireless/ath/ath9k/hw.c                        |   57 +-
 drivers/net/wireless/ath/ath9k/hw.h                        |    4 +-
 drivers/net/wireless/ath/ath9k/init.c                      |   15 +-
 drivers/net/wireless/ath/ath9k/main.c                      |   66 +-
 drivers/net/wireless/ath/ath9k/mci.c                       |   94 +-
 drivers/net/wireless/ath/ath9k/pci.c                       |    6 +-
 drivers/net/wireless/ath/ath9k/rc.c                        |  819 +++++++---------
 drivers/net/wireless/ath/ath9k/rc.h                        |    4 -
 drivers/net/wireless/ath/ath9k/recv.c                      |    4 +-
 drivers/net/wireless/ath/ath9k/reg.h                       |    9 +
 drivers/net/wireless/ath/ath9k/wow.c                       |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c                      |   15 +-
 drivers/net/wireless/ath/carl9170/carl9170.h               |    5 +-
 drivers/net/wireless/ath/carl9170/fw.c                     |    1 +
 drivers/net/wireless/ath/carl9170/mac.c                    |    5 +-
 drivers/net/wireless/ath/carl9170/main.c                   |    6 +-
 drivers/net/wireless/ath/carl9170/rx.c                     |   16 +-
 drivers/net/wireless/ath/carl9170/tx.c                     |   16 +-
 drivers/net/wireless/b43/Makefile                          |    1 +
 drivers/net/wireless/b43/b43.h                             |   10 +-
 drivers/net/wireless/b43/main.c                            |   54 +-
 drivers/net/wireless/b43/phy_common.c                      |   17 +-
 drivers/net/wireless/b43/phy_common.h                      |    6 +
 drivers/net/wireless/b43/phy_n.c                           |  668 ++++++++++++-
 drivers/net/wireless/b43/phy_n.h                           |    1 +
 drivers/net/wireless/b43/radio_2057.c                      |  141 +++
 drivers/net/wireless/b43/radio_2057.h                      |  430 +++++++++
 drivers/net/wireless/b43/tables_nphy.c                     |   75 ++
 drivers/net/wireless/b43/tables_nphy.h                     |   10 +
 drivers/net/wireless/b43legacy/main.c                      |    5 +-
 drivers/net/wireless/brcm80211/Kconfig                     |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c           |   39 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c     |   27 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h              |   62 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h          |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c       |   73 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h          |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c        |   65 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c         | 1047 ++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c        |   17 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h        |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c              |  353 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c      | 3425 ++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h      |  296 ++++--
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c          |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c      |   15 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c             |   13 +-
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h       |    1 +
 drivers/net/wireless/brcm80211/include/brcmu_wifi.h        |    5 -
 drivers/net/wireless/hostap/hostap_info.c                  |    4 +-
 drivers/net/wireless/hostap/hostap_ioctl.c                 |   15 +-
 drivers/net/wireless/hostap/hostap_main.c                  |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c                     |   11 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                     |   11 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c                   |    2 +-
 drivers/net/wireless/iwlegacy/3945-mac.c                   |   12 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                   |   26 +-
 drivers/net/wireless/iwlegacy/4965.h                       |    8 +-
 drivers/net/wireless/iwlegacy/common.c                     |   19 +-
 drivers/net/wireless/iwlegacy/common.h                     |    2 -
 drivers/net/wireless/iwlwifi/dvm/agn.h                     |   13 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h                |    3 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c                 |   56 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h                     |    1 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                |    8 +-
 drivers/net/wireless/iwlwifi/dvm/main.c                    |   24 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c                      |   11 +
 drivers/net/wireless/iwlwifi/dvm/scan.c                    |    4 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c                     |    9 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                      |   18 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c                   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h                |   34 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                     |  167 +++-
 drivers/net/wireless/iwlwifi/iwl-drv.h                     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h            |    2 -
 drivers/net/wireless/iwlwifi/iwl-fw.h                      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                 |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h                   |   12 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c                    |   19 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h               |    3 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c                     |   91 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                  |  112 ++-
 drivers/net/wireless/iwlwifi/pcie/tx.c                     |   51 +-
 drivers/net/wireless/libertas/cmd.c                        |   16 +
 drivers/net/wireless/libertas/cmd.h                        |    1 +
 drivers/net/wireless/libertas/main.c                       |    4 +-
 drivers/net/wireless/libertas_tf/main.c                    |    4 +-
 drivers/net/wireless/mac80211_hwsim.c                      |   59 +-
 drivers/net/wireless/mwifiex/11n.c                         |   64 +-
 drivers/net/wireless/mwifiex/11n.h                         |   20 +-
 drivers/net/wireless/mwifiex/11n_aggr.c                    |   14 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c               |  115 ++-
 drivers/net/wireless/mwifiex/11n_rxreorder.h               |   10 +
 drivers/net/wireless/mwifiex/Makefile                      |    2 +
 drivers/net/wireless/mwifiex/cfg80211.c                    |  460 ++++++++-
 drivers/net/wireless/mwifiex/cmdevt.c                      |    7 +-
 drivers/net/wireless/mwifiex/decl.h                        |    9 +-
 drivers/net/wireless/mwifiex/fw.h                          |   93 +-
 drivers/net/wireless/mwifiex/ie.c                          |   88 +-
 drivers/net/wireless/mwifiex/init.c                        |  126 ++-
 drivers/net/wireless/mwifiex/ioctl.h                       |   14 +-
 drivers/net/wireless/mwifiex/main.c                        |   39 +-
 drivers/net/wireless/mwifiex/main.h                        |   87 +-
 drivers/net/wireless/mwifiex/scan.c                        |   15 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                     |  150 ++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                 |   77 +-
 drivers/net/wireless/mwifiex/sta_event.c                   |   74 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                   |  124 ++-
 drivers/net/wireless/mwifiex/sta_rx.c                      |   44 +-
 drivers/net/wireless/mwifiex/sta_tx.c                      |   12 +-
 drivers/net/wireless/mwifiex/txrx.c                        |   11 +-
 drivers/net/wireless/mwifiex/uap_cmd.c                     |   62 +-
 drivers/net/wireless/mwifiex/uap_event.c                   |  290 ++++++
 drivers/net/wireless/mwifiex/uap_txrx.c                    |  340 +++++++
 drivers/net/wireless/mwifiex/util.c                        |   40 +
 drivers/net/wireless/mwifiex/wmm.c                         |   77 +-
 drivers/net/wireless/mwl8k.c                               |   17 +-
 drivers/net/wireless/orinoco/wext.c                        |    7 +-
 drivers/net/wireless/p54/eeprom.c                          |  108 ++-
 drivers/net/wireless/p54/eeprom.h                          |   12 +
 drivers/net/wireless/p54/lmac.h                            |    4 +-
 drivers/net/wireless/p54/main.c                            |   15 +-
 drivers/net/wireless/p54/p54pci.c                          |   88 +-
 drivers/net/wireless/p54/p54pci.h                          |    1 +
 drivers/net/wireless/p54/txrx.c                            |   15 +-
 drivers/net/wireless/rndis_wlan.c                          |    3 -
 drivers/net/wireless/rt2x00/rt2400pci.c                    |    5 +-
 drivers/net/wireless/rt2x00/rt2400pci.h                    |   27 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                    |    3 +-
 drivers/net/wireless/rt2x00/rt2500pci.h                    |   18 +-
 drivers/net/wireless/rt2x00/rt2500usb.c                    |    5 +-
 drivers/net/wireless/rt2x00/rt2500usb.h                    |   27 +-
 drivers/net/wireless/rt2x00/rt2800.h                       |   52 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                    |  397 ++++++--
 drivers/net/wireless/rt2x00/rt2800lib.h                    |   22 +-
 drivers/net/wireless/rt2x00/rt2800pci.c                    |   83 +-
 drivers/net/wireless/rt2x00/rt2800usb.c                    |   62 +-
 drivers/net/wireless/rt2x00/rt2x00.h                       |   20 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c                    |   35 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                    |   44 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c                  |   20 +-
 drivers/net/wireless/rt2x00/rt61pci.c                      |   13 +-
 drivers/net/wireless/rt2x00/rt61pci.h                      |   28 +-
 drivers/net/wireless/rt2x00/rt73usb.c                      |    5 +-
 drivers/net/wireless/rt2x00/rt73usb.h                      |   34 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c                 |    6 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c                 |    6 +-
 drivers/net/wireless/rtlwifi/Kconfig                       |    8 +-
 drivers/net/wireless/rtlwifi/base.c                        |    3 +-
 drivers/net/wireless/rtlwifi/core.c                        |    8 +-
 drivers/net/wireless/rtlwifi/pci.c                         |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c          |   41 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c          |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c               |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h               |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c               |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h               |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c                |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c                |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c               |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c               |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h               |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c               |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h               |    1 +
 drivers/net/wireless/rtlwifi/usb.c                         |   17 +-
 drivers/net/wireless/rtlwifi/wifi.h                        |  121 ++-
 drivers/net/wireless/ti/wl1251/main.c                      |    4 +-
 drivers/net/wireless/ti/wl12xx/main.c                      |   79 +-
 drivers/net/wireless/ti/wl12xx/wl12xx.h                    |    7 +
 drivers/net/wireless/ti/wl18xx/debugfs.c                   |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c                      |  129 ++-
 drivers/net/wireless/ti/wl18xx/wl18xx.h                    |    7 +
 drivers/net/wireless/ti/wlcore/cmd.c                       |   21 +-
 drivers/net/wireless/ti/wlcore/cmd.h                       |    5 -
 drivers/net/wireless/ti/wlcore/conf.h                      |    3 +-
 drivers/net/wireless/ti/wlcore/debug.h                     |   16 +-
 drivers/net/wireless/ti/wlcore/debugfs.c                   |   32 +-
 drivers/net/wireless/ti/wlcore/init.c                      |   12 +-
 drivers/net/wireless/ti/wlcore/io.h                        |    4 +-
 drivers/net/wireless/ti/wlcore/main.c                      |  372 ++++---
 drivers/net/wireless/ti/wlcore/ps.c                        |   10 +-
 drivers/net/wireless/ti/wlcore/rx.c                        |    2 +-
 drivers/net/wireless/ti/wlcore/scan.c                      |   20 +-
 drivers/net/wireless/ti/wlcore/spi.c                       |   10 +-
 drivers/net/wireless/ti/wlcore/testmode.c                  |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c                        |  112 ++-
 drivers/net/wireless/ti/wlcore/tx.h                        |    4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h                    |   23 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h                  |   13 +-
 drivers/net/wireless/wl3501_cs.c                           |    3 +-
 drivers/net/wireless/zd1211rw/zd_mac.c                     |    9 +-
 drivers/net/xen-netfront.c                                 |    2 +-
 drivers/nfc/Kconfig                                        |   14 +-
 drivers/nfc/Makefile                                       |    1 -
 drivers/nfc/nfcwilink.c                                    |   20 +-
 drivers/nfc/pn533.c                                        |  107 +-
 drivers/nfc/pn544.c                                        |  893 -----------------
 drivers/nfc/pn544_hci.c                                    |  177 ++--
 drivers/ptp/ptp_clock.c                                    |   16 +-
 drivers/ptp/ptp_ixp46x.c                                   |    2 +-
 drivers/ptp/ptp_pch.c                                      |    2 +-
 drivers/ptp/ptp_private.h                                  |    1 +
 drivers/s390/net/ctcm_fsms.c                               |    2 +-
 drivers/s390/net/ctcm_main.c                               |    2 +-
 drivers/s390/net/lcs.c                                     |    2 +-
 drivers/s390/net/qeth_core_main.c                          |   78 +-
 drivers/s390/net/qeth_l3_main.c                            |    2 +
 drivers/scsi/scsi_netlink.c                                |  557 +----------
 drivers/scsi/scsi_transport_iscsi.c                        |    7 +-
 drivers/ssb/driver_mipscore.c                              |   28 +-
 drivers/staging/gdm72xx/netlink_k.c                        |    4 +-
 drivers/staging/winbond/wbusb.c                            |    4 +-
 firmware/Makefile                                          |    1 -
 firmware/cxgb3/t3fw-7.10.0.bin.ihex                        | 1935 -------------------------------------
 fs/dlm/netlink.c                                           |    8 +-
 fs/namei.c                                                 |    6 +-
 fs/seq_file.c                                              |    4 +
 include/linux/Kbuild                                       |    2 +
 include/linux/bcma/bcma_driver_chipcommon.h                |  111 +++
 include/linux/bcma/bcma_regs.h                             |    4 +
 include/linux/etherdevice.h                                |   11 +
 include/linux/ethtool.h                                    |   17 +-
 include/linux/filter.h                                     |    7 +
 include/linux/hash.h                                       |   10 +
 include/linux/ieee80211.h                                  |   80 --
 include/linux/if_arp.h                                     |    1 +
 include/linux/if_link.h                                    |   34 +
 include/linux/if_team.h                                    |   11 +-
 include/linux/if_tunnel.h                                  |    3 +
 include/linux/if_vlan.h                                    |    9 +-
 include/linux/inet_diag.h                                  |    1 +
 include/linux/inetdevice.h                                 |   11 +-
 include/linux/ip6_tunnel.h                                 |   17 +
 include/linux/ipv6.h                                       |    1 +
 include/linux/jiffies.h                                    |    6 +
 include/linux/mdio.h                                       |   83 ++
 include/linux/netdevice.h                                  |   51 +-
 include/linux/netfilter.h                                  |   14 +-
 include/linux/netfilter/ipset/ip_set.h                     |   15 +-
 include/linux/netfilter/ipset/ip_set_ahash.h               |  106 +-
 include/linux/netfilter/nf_conntrack_amanda.h              |    1 +
 include/linux/netfilter/nf_conntrack_ftp.h                 |    7 +-
 include/linux/netfilter/nf_conntrack_h323.h                |   15 +-
 include/linux/netfilter/nf_conntrack_irc.h                 |    1 +
 include/linux/netfilter/nf_conntrack_pptp.h                |    2 +
 include/linux/netfilter/nf_conntrack_sip.h                 |   21 +-
 include/linux/netfilter/nf_nat.h                           |    8 +
 include/linux/netfilter/nfnetlink_conntrack.h              |    8 +-
 include/linux/netfilter/nfnetlink_queue.h                  |    1 +
 include/linux/netfilter/xt_time.h                          |    5 +
 include/linux/netfilter_ipv4.h                             |    1 -
 include/linux/netfilter_ipv6/Kbuild                        |    1 +
 include/linux/netfilter_ipv6/ip6t_NPT.h                    |   16 +
 include/linux/netlink.h                                    |   40 +-
 include/linux/nfc.h                                        |   11 +
 include/linux/nl80211.h                                    |   54 +-
 include/linux/of_mdio.h                                    |   33 +
 include/linux/packet_diag.h                                |   72 ++
 include/linux/pps_kernel.h                                 |    9 +
 include/linux/ptp_clock_kernel.h                           |   21 +-
 include/linux/rfkill.h                                     |   31 +
 include/linux/sched.h                                      |    3 +
 include/linux/seq_file.h                                   |   14 +
 include/linux/skbuff.h                                     |    9 +-
 include/linux/snmp.h                                       |   16 +-
 include/linux/ssb/ssb_driver_chipcommon.h                  |    4 +-
 include/linux/stmmac.h                                     |    1 -
 include/linux/tcp.h                                        |   49 +-
 include/linux/tcp_metrics.h                                |   54 ++
 include/linux/tipc_config.h                                |    8 +-
 include/net/addrconf.h                                     |    2 +-
 include/net/arp.h                                          |    3 +-
 include/net/ax25.h                                         |    4 +-
 include/net/bluetooth/bluetooth.h                          |   10 +
 include/net/bluetooth/hci.h                                |   32 +
 include/net/bluetooth/hci_core.h                           |   48 +-
 include/net/bluetooth/l2cap.h                              |   20 +-
 include/net/bluetooth/mgmt.h                               |   16 +
 include/net/bluetooth/smp.h                                |    8 +-
 include/net/cfg80211.h                                     |   68 +-
 include/net/checksum.h                                     |    3 +
 include/net/dst.h                                          |   10 +-
 include/net/genetlink.h                                    |   34 +-
 include/net/gro_cells.h                                    |  103 ++
 include/net/ieee80211_radiotap.h                           |   11 +
 include/net/inet_ecn.h                                     |   76 ++
 include/net/inet_frag.h                                    |    4 +-
 include/net/inet_sock.h                                    |    4 +-
 include/net/ip.h                                           |    2 +
 include/net/ip6_fib.h                                      |    1 +
 include/net/ip6_tunnel.h                                   |   41 +-
 include/net/ip_vs.h                                        |   16 +-
 include/net/ipip.h                                         |    3 +
 include/net/ipv6.h                                         |   38 +-
 include/net/llc.h                                          |    1 -
 include/net/mac80211.h                                     |   99 +-
 include/net/ndisc.h                                        |    3 +-
 include/net/neighbour.h                                    |   14 +-
 include/net/net_namespace.h                                |   15 +
 include/net/netfilter/nf_conntrack_ecache.h                |   32 +-
 include/net/netfilter/nf_conntrack_expect.h                |    2 +-
 include/net/netfilter/nf_conntrack_timeout.h               |   20 +
 include/net/netfilter/nf_nat.h                             |    6 +-
 include/net/netfilter/nf_nat_core.h                        |    5 +-
 include/net/netfilter/nf_nat_helper.h                      |   11 +-
 include/net/netfilter/nf_nat_l3proto.h                     |   52 +
 include/net/netfilter/nf_nat_l4proto.h                     |   72 ++
 include/net/netfilter/nf_nat_protocol.h                    |   67 --
 include/net/netfilter/nf_nat_rule.h                        |   15 -
 include/net/netlink.h                                      |  124 ++-
 include/net/netns/conntrack.h                              |    4 +
 include/net/netns/ipv4.h                                   |    5 +-
 include/net/netns/ipv6.h                                   |    9 +
 include/net/netns/packet.h                                 |    4 +-
 include/net/netns/sctp.h                                   |  131 +++
 include/net/nfc/hci.h                                      |   21 +-
 include/net/nfc/llc.h                                      |   54 ++
 include/net/nfc/nci.h                                      |   29 +
 include/net/nfc/nci_core.h                                 |    5 +
 include/net/nfc/nfc.h                                      |    4 +-
 include/net/nfc/shdlc.h                                    |  107 --
 include/net/request_sock.h                                 |   49 +-
 include/net/sch_generic.h                                  |    3 +-
 include/net/scm.h                                          |   25 +-
 include/net/sctp/sctp.h                                    |   69 +-
 include/net/sctp/sm.h                                      |    8 +-
 include/net/sctp/structs.h                                 |  154 +--
 include/net/snmp.h                                         |   10 +-
 include/net/sock.h                                         |   40 +-
 include/net/tcp.h                                          |   93 +-
 include/net/xfrm.h                                         |    8 +-
 include/scsi/scsi_netlink.h                                |   24 -
 init/Kconfig                                               |   19 -
 kernel/audit.c                                             |   23 +-
 kernel/exit.c                                              |    3 +
 kernel/fork.c                                              |    1 +
 kernel/pid.c                                               |    1 +
 kernel/pid_namespace.c                                     |    2 +
 kernel/taskstats.c                                         |    4 +-
 lib/kobject_uevent.c                                       |    5 +-
 lib/nlattr.c                                               |    4 +
 net/8021q/vlan_core.c                                      |    6 +
 net/Kconfig                                                |    2 +
 net/appletalk/atalk_proc.c                                 |    3 +-
 net/atm/resources.c                                        |    2 +-
 net/ax25/ax25_uid.c                                        |   21 +-
 net/batman-adv/bat_iv_ogm.c                                |   86 +-
 net/batman-adv/bridge_loop_avoidance.c                     |  214 ++--
 net/batman-adv/bridge_loop_avoidance.h                     |   11 +-
 net/batman-adv/debugfs.c                                   |   12 +
 net/batman-adv/gateway_client.c                            |   53 +-
 net/batman-adv/hard-interface.c                            |   13 +-
 net/batman-adv/main.c                                      |   27 +-
 net/batman-adv/main.h                                      |   29 +-
 net/batman-adv/packet.h                                    |   35 +-
 net/batman-adv/routing.c                                   |   85 +-
 net/batman-adv/send.c                                      |    8 +-
 net/batman-adv/soft-interface.c                            |   79 +-
 net/batman-adv/soft-interface.h                            |    5 +-
 net/batman-adv/translation-table.c                         |  416 +++++---
 net/batman-adv/translation-table.h                         |    4 +-
 net/batman-adv/types.h                                     |  120 ++-
 net/batman-adv/unicast.c                                   |   16 +-
 net/batman-adv/vis.c                                       |  144 +--
 net/batman-adv/vis.h                                       |    2 +-
 net/bluetooth/a2mp.c                                       |   16 +-
 net/bluetooth/af_bluetooth.c                               |  139 +++
 net/bluetooth/bnep/sock.c                                  |   22 +-
 net/bluetooth/cmtp/sock.c                                  |   23 +-
 net/bluetooth/hci_conn.c                                   |  100 +-
 net/bluetooth/hci_core.c                                   |   12 +-
 net/bluetooth/hci_event.c                                  |  190 ++--
 net/bluetooth/hci_sock.c                                   |   13 +-
 net/bluetooth/hidp/sock.c                                  |   22 +-
 net/bluetooth/l2cap_core.c                                 |   37 +-
 net/bluetooth/l2cap_sock.c                                 |   22 +-
 net/bluetooth/mgmt.c                                       |   62 +-
 net/bluetooth/rfcomm/sock.c                                |   14 +-
 net/bluetooth/sco.c                                        |   16 +-
 net/bridge/br_fdb.c                                        |   17 +-
 net/bridge/br_netlink.c                                    |    2 +-
 net/bridge/br_private.h                                    |    6 +-
 net/bridge/br_stp_timer.c                                  |    2 +-
 net/bridge/netfilter/ebt_ulog.c                            |    3 +-
 net/bridge/netfilter/ebtable_filter.c                      |    4 +-
 net/bridge/netfilter/ebtable_nat.c                         |    4 +-
 net/can/gw.c                                               |    2 +-
 net/core/dev.c                                             |  116 ++-
 net/core/dev_addr_lists.c                                  |   40 +-
 net/core/dst.c                                             |    2 +-
 net/core/ethtool.c                                         |   12 -
 net/core/fib_rules.c                                       |    6 +-
 net/core/filter.c                                          |   27 +-
 net/core/link_watch.c                                      |    8 +
 net/core/neighbour.c                                       |    8 +-
 net/core/net-sysfs.c                                       |   18 +-
 net/core/netpoll.c                                         |    5 +-
 net/core/netprio_cgroup.c                                  |   41 +-
 net/core/request_sock.c                                    |   95 ++
 net/core/rtnetlink.c                                       |   38 +-
 net/core/scm.c                                             |   44 +-
 net/core/secure_seq.c                                      |    1 +
 net/core/skbuff.c                                          |   86 +-
 net/core/sock.c                                            |   74 +-
 net/core/sock_diag.c                                       |    3 +-
 net/core/utils.c                                           |   20 +
 net/dcb/dcbnl.c                                            |   18 +-
 net/decnet/af_decnet.c                                     |    4 +-
 net/decnet/dn_dev.c                                        |    6 +-
 net/decnet/dn_route.c                                      |   16 +-
 net/decnet/dn_table.c                                      |   12 +-
 net/decnet/netfilter/dn_rtmsg.c                            |    3 +-
 net/ieee802154/6lowpan.c                                   |   53 +-
 net/ieee802154/nl-mac.c                                    |    6 +-
 net/ieee802154/nl-phy.c                                    |    6 +-
 net/ipv4/af_inet.c                                         |   27 +-
 net/ipv4/devinet.c                                         |   67 +-
 net/ipv4/fib_frontend.c                                    |   25 +-
 net/ipv4/fib_semantics.c                                   |    8 +-
 net/ipv4/fib_trie.c                                        |   15 +-
 net/ipv4/igmp.c                                            |   38 +-
 net/ipv4/inet_connection_sock.c                            |   57 +-
 net/ipv4/inet_diag.c                                       |   45 +-
 net/ipv4/inet_fragment.c                                   |    9 +-
 net/ipv4/ip_fragment.c                                     |   13 +-
 net/ipv4/ip_gre.c                                          |  128 ++-
 net/ipv4/ip_output.c                                       |   74 +-
 net/ipv4/ip_vti.c                                          |    5 -
 net/ipv4/ipconfig.c                                        |   43 +-
 net/ipv4/ipip.c                                            |   51 +-
 net/ipv4/ipmr.c                                            |   12 +-
 net/ipv4/netfilter.c                                       |   41 +-
 net/ipv4/netfilter/Kconfig                                 |   90 +-
 net/ipv4/netfilter/Makefile                                |   18 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                        |   18 +-
 net/ipv4/netfilter/ipt_NETMAP.c                            |   98 --
 net/ipv4/netfilter/ipt_REDIRECT.c                          |  110 ---
 net/ipv4/netfilter/ipt_ULOG.c                              |    3 +-
 net/ipv4/netfilter/ipt_rpfilter.c                          |    2 +-
 net/ipv4/netfilter/iptable_filter.c                        |   10 +-
 net/ipv4/netfilter/iptable_mangle.c                        |   10 +-
 net/ipv4/netfilter/{nf_nat_standalone.c => iptable_nat.c}  |  264 +++--
 net/ipv4/netfilter/iptable_raw.c                           |   10 +-
 net/ipv4/netfilter/iptable_security.c                      |    5 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c             |    8 +-
 net/ipv4/netfilter/nf_nat_h323.c                           |   71 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c                   |  281 ++++++
 net/ipv4/netfilter/nf_nat_pptp.c                           |   21 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c                      |   30 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c                     |   24 +-
 net/ipv4/netfilter/nf_nat_rule.c                           |  214 ----
 net/ipv4/ping.c                                            |   22 +-
 net/ipv4/proc.c                                            |    4 +
 net/ipv4/raw.c                                             |    4 +-
 net/ipv4/route.c                                           |   30 +-
 net/ipv4/syncookies.c                                      |    1 +
 net/ipv4/sysctl_net_ipv4.c                                 |   87 +-
 net/ipv4/tcp.c                                             |  135 +--
 net/ipv4/tcp_fastopen.c                                    |   83 +-
 net/ipv4/tcp_input.c                                       |  281 +++---
 net/ipv4/tcp_ipv4.c                                        |  332 ++++++-
 net/ipv4/tcp_metrics.c                                     |  354 ++++++-
 net/ipv4/tcp_minisocks.c                                   |   75 +-
 net/ipv4/tcp_output.c                                      |   27 +-
 net/ipv4/tcp_timer.c                                       |   39 +-
 net/ipv4/udp.c                                             |    4 +-
 net/ipv4/udp_diag.c                                        |    9 +-
 net/ipv6/Kconfig                                           |   16 +
 net/ipv6/Makefile                                          |    1 +
 net/ipv6/addrconf.c                                        |   83 +-
 net/ipv6/addrlabel.c                                       |   24 +-
 net/ipv6/ip6_fib.c                                         |   20 +-
 net/ipv6/ip6_flowlabel.c                                   |   47 +-
 net/ipv6/ip6_gre.c                                         | 1770 ++++++++++++++++++++++++++++++++++
 net/ipv6/ip6_output.c                                      |   85 +-
 net/ipv6/ip6_tunnel.c                                      |   91 +-
 net/ipv6/ip6mr.c                                           |   10 +-
 net/ipv6/netfilter.c                                       |    8 +
 net/ipv6/netfilter/Kconfig                                 |   37 +-
 net/ipv6/netfilter/Makefile                                |    6 +
 net/ipv6/netfilter/ip6t_MASQUERADE.c                       |  135 +++
 net/ipv6/netfilter/ip6t_NPT.c                              |  165 ++++
 net/ipv6/netfilter/ip6table_filter.c                       |    4 +-
 net/ipv6/netfilter/ip6table_mangle.c                       |    4 +-
 net/ipv6/netfilter/ip6table_nat.c                          |  321 ++++++
 net/ipv6/netfilter/ip6table_raw.c                          |    4 +-
 net/ipv6/netfilter/ip6table_security.c                     |    5 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c             |  137 +--
 net/ipv6/netfilter/nf_conntrack_reasm.c                    |  218 +++--
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c                   |  288 ++++++
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c                   |   90 ++
 net/ipv6/raw.c                                             |    3 +-
 net/ipv6/reassembly.c                                      |   89 +-
 net/ipv6/route.c                                           |   96 +-
 net/ipv6/sit.c                                             |    6 -
 net/ipv6/syncookies.c                                      |    1 +
 net/ipv6/tcp_ipv6.c                                        |   46 +-
 net/ipv6/udp.c                                             |    3 +-
 net/ipx/ipx_proc.c                                         |    3 +-
 net/irda/irnetlink.c                                       |    2 +-
 net/key/af_key.c                                           |   41 +-
 net/l2tp/Kconfig                                           |    1 +
 net/l2tp/l2tp_eth.c                                        |    3 +-
 net/l2tp/l2tp_netlink.c                                    |   24 +-
 net/llc/llc_proc.c                                         |    2 +-
 net/llc/llc_station.c                                      |  600 +-----------
 net/llc/sysctl_net_llc.c                                   |    7 -
 net/mac80211/aes_cmac.c                                    |    6 +-
 net/mac80211/agg-tx.c                                      |    2 +-
 net/mac80211/cfg.c                                         |  103 +-
 net/mac80211/chan.c                                        |   67 +-
 net/mac80211/debugfs.c                                     |   36 +-
 net/mac80211/driver-ops.h                                  |   11 +-
 net/mac80211/ibss.c                                        |   50 +-
 net/mac80211/ieee80211_i.h                                 |   53 +-
 net/mac80211/iface.c                                       |  316 +++---
 net/mac80211/key.c                                         |    2 +-
 net/mac80211/main.c                                        |   31 +-
 net/mac80211/mesh.c                                        |   49 +-
 net/mac80211/mesh.h                                        |    5 +-
 net/mac80211/mesh_hwmp.c                                   |    2 -
 net/mac80211/mesh_pathtbl.c                                |   44 +-
 net/mac80211/mesh_plink.c                                  |   85 +-
 net/mac80211/mlme.c                                        |  443 +++++----
 net/mac80211/offchannel.c                                  |    9 +-
 net/mac80211/rate.h                                        |    2 +-
 net/mac80211/rx.c                                          |   60 +-
 net/mac80211/scan.c                                        |   53 +-
 net/mac80211/sta_info.c                                    |  123 +--
 net/mac80211/sta_info.h                                    |    2 +
 net/mac80211/status.c                                      |   42 +-
 net/mac80211/trace.h                                       |   11 +-
 net/mac80211/tx.c                                          |   73 +-
 net/mac80211/util.c                                        |  108 ++-
 net/netfilter/Kconfig                                      |   83 +-
 net/netfilter/Makefile                                     |   21 +-
 net/netfilter/core.c                                       |   21 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c                     |   19 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                  |   18 +-
 net/netfilter/ipset/ip_set_bitmap_port.c                   |    9 +-
 net/netfilter/ipset/ip_set_core.c                          |   39 +-
 net/netfilter/ipset/ip_set_hash_ip.c                       |   15 +-
 net/netfilter/ipset/ip_set_hash_ipport.c                   |   24 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c                 |   24 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c                |   47 +-
 net/netfilter/ipset/ip_set_hash_net.c                      |   25 +-
 net/netfilter/ipset/ip_set_hash_netiface.c                 |   66 +-
 net/netfilter/ipset/ip_set_hash_netport.c                  |   36 +-
 net/netfilter/ipset/ip_set_list_set.c                      |    9 +-
 net/netfilter/ipvs/Kconfig                                 |    3 +-
 net/netfilter/ipvs/ip_vs_app.c                             |   58 +-
 net/netfilter/ipvs/ip_vs_core.c                            |   76 +-
 net/netfilter/ipvs/ip_vs_ctl.c                             |   25 +-
 net/netfilter/ipvs/ip_vs_ftp.c                             |   22 +-
 net/netfilter/ipvs/ip_vs_xmit.c                            |  111 ++-
 net/netfilter/nf_conntrack_amanda.c                        |    5 +-
 net/netfilter/nf_conntrack_core.c                          |   15 +-
 net/netfilter/nf_conntrack_ecache.c                        |    2 +-
 net/netfilter/nf_conntrack_ftp.c                           |   24 +-
 net/netfilter/nf_conntrack_h323_main.c                     |  232 +++--
 net/netfilter/nf_conntrack_irc.c                           |    3 +-
 net/netfilter/nf_conntrack_netlink.c                       |  114 ++-
 net/netfilter/nf_conntrack_pptp.c                          |   18 +-
 net/netfilter/nf_conntrack_proto.c                         |    5 -
 net/netfilter/nf_conntrack_proto_tcp.c                     |    8 +-
 net/netfilter/nf_conntrack_sip.c                           |  143 +--
 net/netfilter/nf_internals.h                               |    4 +-
 net/{ipv4 => }/netfilter/nf_nat_amanda.c                   |    4 +-
 net/{ipv4 => }/netfilter/nf_nat_core.c                     |  679 +++++++------
 net/{ipv4 => }/netfilter/nf_nat_ftp.c                      |   34 +-
 net/{ipv4 => }/netfilter/nf_nat_helper.c                   |  109 +--
 net/{ipv4 => }/netfilter/nf_nat_irc.c                      |   10 +-
 net/{ipv4 => }/netfilter/nf_nat_proto_common.c             |   54 +-
 net/{ipv4 => }/netfilter/nf_nat_proto_dccp.c               |   56 +-
 net/{ipv4 => }/netfilter/nf_nat_proto_sctp.c               |   53 +-
 net/{ipv4 => }/netfilter/nf_nat_proto_tcp.c                |   40 +-
 net/{ipv4 => }/netfilter/nf_nat_proto_udp.c                |   42 +-
 net/{ipv4 => }/netfilter/nf_nat_proto_udplite.c            |   58 +-
 net/{ipv4 => }/netfilter/nf_nat_proto_unknown.c            |   16 +-
 net/{ipv4 => }/netfilter/nf_nat_sip.c                      |  270 +++---
 net/{ipv4 => }/netfilter/nf_nat_tftp.c                     |    1 -
 net/netfilter/nf_queue.c                                   |   10 +-
 net/netfilter/nfnetlink.c                                  |    2 +-
 net/netfilter/nfnetlink_acct.c                             |   16 +-
 net/netfilter/nfnetlink_cthelper.c                         |   17 +-
 net/netfilter/nfnetlink_cttimeout.c                        |   12 +-
 net/netfilter/nfnetlink_log.c                              |   27 +-
 net/netfilter/nfnetlink_queue_core.c                       |   50 +-
 net/netfilter/xt_CT.c                                      |  262 +++--
 net/netfilter/xt_LOG.c                                     |    8 +-
 net/netfilter/xt_NETMAP.c                                  |  165 ++++
 net/netfilter/xt_NFQUEUE.c                                 |    8 +-
 net/netfilter/xt_NOTRACK.c                                 |   53 -
 net/netfilter/xt_REDIRECT.c                                |  190 ++++
 net/netfilter/xt_nat.c                                     |  170 ++++
 net/netfilter/xt_osf.c                                     |    2 +-
 net/netfilter/xt_owner.c                                   |   30 +-
 net/netfilter/xt_recent.c                                  |   13 +-
 net/netfilter/xt_set.c                                     |   22 +
 net/netfilter/xt_socket.c                                  |   12 +-
 net/netfilter/xt_time.c                                    |   24 +-
 net/netlabel/netlabel_cipso_v4.c                           |    2 +-
 net/netlabel/netlabel_mgmt.c                               |    4 +-
 net/netlabel/netlabel_unlabeled.c                          |    2 +-
 net/netlink/af_netlink.c                                   |  216 ++---
 net/netlink/genetlink.c                                    |   48 +-
 net/nfc/core.c                                             |   13 +-
 net/nfc/hci/Makefile                                       |    4 +-
 net/nfc/hci/command.c                                      |   45 +-
 net/nfc/hci/core.c                                         |  336 ++++---
 net/nfc/hci/hci.h                                          |   15 +-
 net/nfc/hci/hcp.c                                          |    6 +-
 net/nfc/hci/llc.c                                          |  170 ++++
 net/nfc/hci/llc.h                                          |   69 ++
 net/nfc/hci/llc_nop.c                                      |   99 ++
 net/nfc/hci/{shdlc.c => llc_shdlc.c}                       |  544 +++++------
 net/nfc/llcp/commands.c                                    |    2 +
 net/nfc/llcp/llcp.c                                        |  131 +--
 net/nfc/llcp/llcp.h                                        |    6 +-
 net/nfc/llcp/sock.c                                        |   93 +-
 net/nfc/nci/core.c                                         |   91 +-
 net/nfc/nci/ntf.c                                          |   52 +
 net/nfc/nci/rsp.c                                          |   14 +
 net/nfc/netlink.c                                          |   68 +-
 net/openvswitch/actions.c                                  |    6 +-
 net/openvswitch/datapath.c                                 |  453 +++++----
 net/openvswitch/datapath.h                                 |   52 +-
 net/openvswitch/dp_notify.c                                |    8 +-
 net/openvswitch/flow.c                                     |   21 +-
 net/openvswitch/flow.h                                     |    3 +-
 net/openvswitch/vport-internal_dev.c                       |    7 +-
 net/openvswitch/vport-netdev.c                             |    2 +-
 net/openvswitch/vport.c                                    |   27 +-
 net/openvswitch/vport.h                                    |   13 +-
 net/packet/Kconfig                                         |    8 +
 net/packet/Makefile                                        |    2 +
 net/packet/af_packet.c                                     |  145 +--
 net/packet/diag.c                                          |  242 +++++
 net/packet/internal.h                                      |  121 +++
 net/phonet/pn_netlink.c                                    |   14 +-
 net/phonet/socket.c                                        |    6 +-
 net/rds/tcp_connect.c                                      |    4 +-
 net/rds/tcp_listen.c                                       |    4 +-
 net/rds/tcp_recv.c                                         |    4 +-
 net/rds/tcp_send.c                                         |    4 +-
 net/rfkill/core.c                                          |   22 +-
 net/sched/act_api.c                                        |   52 +-
 net/sched/cls_api.c                                        |   16 +-
 net/sched/cls_basic.c                                      |    3 +-
 net/sched/cls_cgroup.c                                     |    3 +-
 net/sched/cls_flow.c                                       |   19 +-
 net/sched/cls_fw.c                                         |    3 +-
 net/sched/cls_route.c                                      |    3 +-
 net/sched/cls_rsvp.h                                       |    3 +-
 net/sched/cls_tcindex.c                                    |    3 +-
 net/sched/cls_u32.c                                        |    3 +-
 net/sched/em_meta.c                                        |    2 +-
 net/sched/sch_api.c                                        |   44 +-
 net/sched/sch_drr.c                                        |    2 +-
 net/sched/sch_generic.c                                    |   27 +-
 net/sched/sch_qfq.c                                        |    2 +-
 net/sctp/associola.c                                       |   25 +-
 net/sctp/auth.c                                            |   20 +-
 net/sctp/bind_addr.c                                       |   20 +-
 net/sctp/chunk.c                                           |    2 +-
 net/sctp/endpointola.c                                     |   25 +-
 net/sctp/input.c                                           |  115 ++-
 net/sctp/ipv6.c                                            |   36 +-
 net/sctp/objcnt.c                                          |    8 +-
 net/sctp/output.c                                          |    2 +-
 net/sctp/outqueue.c                                        |   28 +-
 net/sctp/primitive.c                                       |    4 +-
 net/sctp/proc.c                                            |   61 +-
 net/sctp/protocol.c                                        |  454 ++++-----
 net/sctp/sm_make_chunk.c                                   |   61 +-
 net/sctp/sm_sideeffect.c                                   |   26 +-
 net/sctp/sm_statefuns.c                                    |  725 ++++++++------
 net/sctp/sm_statetable.c                                   |   17 +-
 net/sctp/socket.c                                          |  119 ++-
 net/sctp/sysctl.c                                          |  198 ++--
 net/sctp/transport.c                                       |   23 +-
 net/sctp/ulpqueue.c                                        |   18 +-
 net/socket.c                                               |   89 +-
 net/tipc/bearer.c                                          |   21 +-
 net/tipc/config.c                                          |   48 +-
 net/tipc/core.c                                            |   22 +-
 net/tipc/core.h                                            |   18 +-
 net/tipc/eth_media.c                                       |   29 +-
 net/tipc/handler.c                                         |    2 +-
 net/tipc/link.c                                            |    4 +-
 net/tipc/name_table.c                                      |   16 +-
 net/tipc/net.c                                             |    3 +-
 net/tipc/net.h                                             |    2 +-
 net/tipc/netlink.c                                         |    2 +-
 net/tipc/subscr.c                                          |    4 +-
 net/unix/af_unix.c                                         |   17 +-
 net/unix/diag.c                                            |   14 +-
 net/wireless/chan.c                                        |    7 +-
 net/wireless/core.c                                        |   53 +-
 net/wireless/core.h                                        |    2 +-
 net/wireless/mlme.c                                        |   37 +-
 net/wireless/nl80211.c                                     |  266 +++--
 net/wireless/nl80211.h                                     |    5 +
 net/wireless/radiotap.c                                    |    2 +
 net/wireless/reg.c                                         |   45 +-
 net/wireless/scan.c                                        |    2 +-
 net/wireless/util.c                                        |   36 +-
 net/wireless/wext-core.c                                   |    8 +-
 net/xfrm/xfrm_policy.c                                     |   83 +-
 net/xfrm/xfrm_state.c                                      |   12 +-
 net/xfrm/xfrm_user.c                                       |   77 +-
 security/selinux/netlink.c                                 |    5 +-
 1000 files changed, 43058 insertions(+), 22065 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/cpsw.txt
 create mode 100644 Documentation/devicetree/bindings/net/davinci-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-mmioreg.txt
 create mode 100644 Documentation/networking/vxlan.txt
 create mode 100644 drivers/infiniband/ulp/ipoib/ipoib_netlink.c
 delete mode 100644 drivers/net/ethernet/freescale/fsl_pq_mdio.h
 create mode 100644 drivers/net/ethernet/freescale/xgmac_mdio.c
 create mode 100644 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
 delete mode 100644 drivers/net/ethernet/mipsnet.c
 create mode 100644 drivers/net/ethernet/sfc/ptp.c
 rename drivers/{ => net}/ieee802154/Kconfig (76%)
 rename drivers/{ => net}/ieee802154/Makefile (74%)
 rename drivers/{ => net}/ieee802154/at86rf230.c (98%)
 rename drivers/{ => net}/ieee802154/fakehard.c (99%)
 rename drivers/{ => net}/ieee802154/fakelb.c (100%)
 create mode 100644 drivers/net/ieee802154/mrf24j40.c
 create mode 100644 drivers/net/phy/mdio-mux-mmioreg.c
 create mode 100644 drivers/net/vxlan.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
 create mode 100644 drivers/net/wireless/b43/radio_2057.c
 create mode 100644 drivers/net/wireless/b43/radio_2057.h
 create mode 100644 drivers/net/wireless/mwifiex/uap_event.c
 create mode 100644 drivers/net/wireless/mwifiex/uap_txrx.c
 delete mode 100644 drivers/nfc/pn544.c
 delete mode 100644 firmware/cxgb3/t3fw-7.10.0.bin.ihex
 create mode 100644 include/linux/netfilter_ipv6/ip6t_NPT.h
 create mode 100644 include/linux/packet_diag.h
 create mode 100644 include/linux/tcp_metrics.h
 create mode 100644 include/net/gro_cells.h
 create mode 100644 include/net/netfilter/nf_nat_l3proto.h
 create mode 100644 include/net/netfilter/nf_nat_l4proto.h
 delete mode 100644 include/net/netfilter/nf_nat_protocol.h
 delete mode 100644 include/net/netfilter/nf_nat_rule.h
 create mode 100644 include/net/netns/sctp.h
 create mode 100644 include/net/nfc/llc.h
 delete mode 100644 include/net/nfc/shdlc.h
 delete mode 100644 net/ipv4/netfilter/ipt_NETMAP.c
 delete mode 100644 net/ipv4/netfilter/ipt_REDIRECT.c
 rename net/ipv4/netfilter/{nf_nat_standalone.c => iptable_nat.c} (52%)
 create mode 100644 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
 delete mode 100644 net/ipv4/netfilter/nf_nat_rule.c
 create mode 100644 net/ipv6/ip6_gre.c
 create mode 100644 net/ipv6/netfilter/ip6t_MASQUERADE.c
 create mode 100644 net/ipv6/netfilter/ip6t_NPT.c
 create mode 100644 net/ipv6/netfilter/ip6table_nat.c
 create mode 100644 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
 create mode 100644 net/ipv6/netfilter/nf_nat_proto_icmpv6.c
 rename net/{ipv4 => }/netfilter/nf_nat_amanda.c (96%)
 rename net/{ipv4 => }/netfilter/nf_nat_core.c (51%)
 rename net/{ipv4 => }/netfilter/nf_nat_ftp.c (79%)
 rename net/{ipv4 => }/netfilter/nf_nat_helper.c (82%)
 rename net/{ipv4 => }/netfilter/nf_nat_irc.c (89%)
 rename net/{ipv4 => }/netfilter/nf_nat_proto_common.c (62%)
 rename net/{ipv4 => }/netfilter/nf_nat_proto_dccp.c (61%)
 rename net/{ipv4 => }/netfilter/nf_nat_proto_sctp.c (61%)
 rename net/{ipv4 => }/netfilter/nf_nat_proto_tcp.c (65%)
 rename net/{ipv4 => }/netfilter/nf_nat_proto_udp.c (60%)
 rename net/{ipv4 => }/netfilter/nf_nat_proto_udplite.c (58%)
 rename net/{ipv4 => }/netfilter/nf_nat_proto_unknown.c (76%)
 rename net/{ipv4 => }/netfilter/nf_nat_sip.c (62%)
 rename net/{ipv4 => }/netfilter/nf_nat_tftp.c (97%)
 create mode 100644 net/netfilter/xt_NETMAP.c
 delete mode 100644 net/netfilter/xt_NOTRACK.c
 create mode 100644 net/netfilter/xt_REDIRECT.c
 create mode 100644 net/netfilter/xt_nat.c
 create mode 100644 net/nfc/hci/llc.c
 create mode 100644 net/nfc/hci/llc.h
 create mode 100644 net/nfc/hci/llc_nop.c
 rename net/nfc/hci/{shdlc.c => llc_shdlc.c} (54%)
 create mode 100644 net/packet/diag.c
 create mode 100644 net/packet/internal.h
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
