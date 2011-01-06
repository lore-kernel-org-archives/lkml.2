Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1AFUTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:19:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35205
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab1AFUTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:19:34 -0500
Date: Thu, 06 Jan 2011 12:20:03 -0800 (PST)
Message-Id: <20110106.122003.233698077.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p06KKBlA027789


Things of note:

1) Lots of cleanups and unused code removal in TIPC from Allan Stephens
   and Paul Gortmaker.

2) DCBX data center bridging support from Shmulik Ravid.

3) Addition of batman-adv meshing protocol, from Sven Eckelmann.

4) Several optimizations to the socket filter code from Eric Dumazet
   and Tetsuo Handa:
   a) remove redundancies in revalidation code
   b) implement skb ancillary data accesses more directly
   c) validate memory accesses at filter install time instead
      of at run-time
   d) use reciprocal divide

5) Use keyed wakeups in AF_UNIX, this was just an oversight when
   the initial keyed wakeup changes went in.  From Eric Dumazet.

6) Several netdevice access RCU conversions and elimination of
   dev_base_lock usage, from Eric Dumazet.

7) VLAN and macvlan TX paths are now lockless, from Eric Dumazet.

8) New SKF_AD_RXHASH and SKF_AD_CPU socket filter opcodes, also from Eric.

9) AF_PACKET no longer uses high-order memory allocations, which many
   people have complained about in the past, from Neil Horman.

10) Fix keying of GRE tunnels for IPSEC, from Timo Ter√§s.

11) Add Transmit Packet Steering, from Tom Herbert with several follow-up
    improvements wrt. NUMA memory allocation et al. from Eric Dumazet.

12) BLK removals in X25 protocol, from Andrew Hendry.

13) The inetpeer cache and TCP time-wait recycling now both work with
    ipv6.

14) Infrastructure changes to allow the eventual COW'ing of route
    metrics.

Plus the usual spattering of wireless, bluetooth, and wired driver
updates.

Please pull, thanks a lot!

The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Adam Edvardsson (1):
      ethoc: enable interrupts after napi_complete

Akinobu Mita (1):
      airo: use simple_write_to_buffer

Alan Cox (1):
      hso: Fix unused variable warning

Alexander Duyck (30):
      ixgbe: remove unnecessary re-init of adapter on Rx-csum change
      ixgbe: move GSO segments and byte count processing into ixgbe_tx_map
      ixgbe: cleanup ixgbe_alloc_rx_buffers
      ixgbe: drop ring->head, make ring->tail a pointer instead of offset
      ixgbe: move device pointer into the ring structure
      ixgbe: combine some stats into a union to allow for Tx/Rx stats overlap
      ixgbe: add a netdev pointer to the ring structure
      ixgbe: move ixgbe_clear_interrupt_scheme to before pci_save_state
      ixgbe: remove residual code left over from earlier combining of TXDCTL
      ixgbe: move adapter into pci_dev driver data instead of netdev
      ixgbe: move CPU variable from ring into q_vector, add ring->q_vector
      ixgbe: add a state flags to ring
      ixgbe: cleanup race conditions in link setup
      ixgbe: Disable RSC when ITR setting is too high to allow RSC
      ixgbe: reorder Tx cleanup so that if adapter will reset we don't rearm
      ixgbe: change vector numbering so that queues end up on correct CPUs
      ixgbe: cleanup ixgbe_clean_rx_irq
      ixgbe: cleanup ATR filter setup function
      ixgbe: cleanup use of ixgbe_rsc_count and RSC_CB
      ixgbe: change mac_type if statements to switch statements
      ixgbe: cleanup ixgbe_set_tx_csum ethtool flags configuration
      ixgbe: add WOL support for backplane adapters
      ixgbe: Cleanup DCB logic, whitespace, and comments in ixgbe_ethtool.c
      ixgbe: cleanup unnecessary return value in ixgbe_cache_ring_rss
      ixgbe: cleanup unclear references to reg_idx
      ixgbe: simplify math and improve stack use of ixgbe_set_itr functions
      ixgbe: cleanup ixgbe_map_rings_to_vectors
      ixgbe: populate the ring->q_vector pointer during ring mapping
      ixgbe: Resolve null function pointer accesses on 82598 w/ multi-speed fiber
      igbvf: force link checking when mailbox timeout has occurred

Alexey Orishko (2):
      usbnet: changes for upcoming cdc_ncm driver
      USB CDC NCM host driver

Allan Stephens (30):
      tipc: Remove obsolete native API files and exports
      tipc: Remove obsolete inclusions of header files
      tipc: Delete unused configuration service structure definition
      tipc: Eliminate useless return value when disabling a bearer
      tipc: Delete useless function prototypes
      tipc: Remove support for TIPC mode change callback
      tipc: Remove unused domain argument from multicast send routine
      tipc: Eliminate useless initialization when creating subscriber
      tipc: Eliminate an unused symbolic constant in link code
      tipc: Eliminate obsolete native API forwarding routines
      tipc: Delete tipc_ownidentity()
      tipc: Remove prototype code for supporting multiple zones
      tipc: Remove prototype code for supporting slave nodes
      tipc: Remove prototype code for supporting inter-cluster routing
      tipc: Remove prototype code for supporting multiple clusters
      tipc: Eliminate use of user registry by configuration service
      tipc: Eliminate use of user registry by topology service
      tipc: Remove user registry subsystem
      tipc: Remove internal linked list of node objects
      tipc: rename dbg.[ch] to log.[ch]
      tipc: remove calls to dbg() and msg_dbg()
      tipc: remove dump() and tipc_dump_dbg()
      tipc: Prune down link-specific debugging code
      tipc: Finish streamlining of debugging code
      tipc: remove redundant #includes
      tipc: remove pointless check for NULL prior to kfree
      tipc: cleanup various cosmetic whitespace issues
      tipc: split variable assignments out of conditional expressions
      tipc: remove zeroing assignments to static global variables
      tipc: remove extraneous braces from single statements

Amit Kumar Salecha (2):
      qlcnic: validate eswitch config values for PF
      netxen: update module description

Amitkumar Karwar (1):
      cfg80211: add some element IDs in enum ieee80211_eid

Anderson Lizardo (1):
      Bluetooth: Fix error handling for l2cap_init()

Andreas Herrmann (1):
      bitops: Provide generic sign_extend32 function

Andrei Emeltchenko (8):
      Bluetooth: Check sk is not owned before freeing l2cap_conn
      Bluetooth: timer check sk is not owned before freeing
      Bluetooth: do not use assignment in if condition
      Bluetooth: clean up sco code
      Bluetooth: clean up rfcomm code
      Bluetooth: clean up l2cap code
      Bluetooth: clean up hci code
      Bluetooth: clean up legal text

Andy Shevchenko (2):
      wireless: ray_cs: use '%pm' format option to print MAC
      atm: lanai: use kernel's '%pM' format option to print MAC

Anirban Chakraborty (2):
      qlcnic: Bumped up driver version to 5.0.12
      qlcnic: Updated driver version to 5.0.13

Anisse Astier (1):
      rtl8192ce: Fix typo in Kconfig description

Arce, Abraham (1):
      ks8851: suspend resume support

Arik Nemtsov (2):
      mac80211: support hardware TX fragmentation offload
      wl1271: add support for HW TX fragmentation

Axel Lin (2):
      net: ixp4xx_eth: Return proper error for eth_init_one
      net: r6040: Return proper error for r6040_init_one

Ben Greear (6):
      ath5k: Print stats as unsigned ints.
      ath5k: Cleanup opmode setting logic.
      ath9k: Move debugfs under ieee80211/[phyname]/ath9k/
      ath9k: Make DMA warning in ath_stoprecv WARN_ON_ONCE.
      ath9k: Check for NULL sta in ath_tx_start
      mac80211: Show max number of probe tries in debug message.

Ben Hutchings (29):
      sfc: Reduce log level for MCDI error response in efx_mcdi_rpc()
      sfc: Fix condition for no-op in set_phy_flash_cfg()
      sfc: Distinguish critical and non-critical over-temperature conditions
      sfc: Read-to-clear LM87 alarm/interrupt status at start of day
      sfc: Clear RXIN_SEL when soft-resetting QT2025C
      sfc: Remove broken automatic fallback for invalid Falcon chip/board config
      sfc: Expose Falcon BootROM config through MTD, not ethtool
      sfc: Remove unnecessary inclusion of various private header files
      sfc: Move SPI state to struct falcon_nic_data
      sfc: Move mdio_lock to struct falcon_nic_data
      sfc: Move Falcon global event handling to falcon.c
      sfc: Move xmac_poll_required into struct falcon_nic_data
      sfc: Update kernel-doc to match earlier move of Toeplitz hash key
      sfc: Use current MAC address, not NVRAM MAC address, for WoL filter
      sfc: Store MAC address from NVRAM in net_device::perm_addr
      sfc: Reorder struct efx_nic to separate fields by volatility
      sfc: Use ACCESS_ONCE when copying efx_tx_queue::read_count
      sfc: Expand/correct comments on collector behaviour and function usage
      sfc: Remove redundant memory barriers between MMIOs
      sfc: Add compile-time checks for correctness of paged register writes
      sfc: Remove locking from implementation of efx_writeo_paged()
      sfc: Use TX push whenever adding descriptors to an empty queue
      sfc: Log start and end of ethtool self-test at INFO level
      sfc: Remove filter table IDs from filter functions
      sfc: Generalise filter spec initialisation
      sfc: Remove unused field and comment on a previously removed field
      sfc: Remove ancient support for nesting of TX stop
      ethtool: Report link-down while interface is down
      netdev: Use default implementation of ethtool_ops::get_link where possible

Bing Zhao (1):
      ieee80211: add Parameter Set Count bitmask

Blaise Gassend (1):
      mac80211_hwsim: Incorporate txpower into rssi

Bob Copeland (2):
      ath5k: fix cycle counter inconsistent locking
      cfg80211: fix transposition of words in printk

Breno Leitao (2):
      cxgb3: Removing unused return variable
      ehea: Fixing some message level

Brian Cavagnolo (6):
      mwl8k: revert unnecessary modification of tx descriptor
      mwl8k: factor out firmware loading and hw init code
      mwl8k: choose proper firmware image as directed by user
      mwl8k: add API version checking for AP firmware
      mwl8k: make initial firmware load asynchronous
      mwl8k: use const struct fw pointers throughout

Brian Prodoehl (1):
      ath9k: fix spur mitigation no-spur case for AR9002

Bruce Allan (17):
      e1000e: 82571 SerDes link handle null code word from partner
      e1000e: 82574 intermittently fails to initialize with manageability f/w
      e1000e: 82571-based mezzanine card can fail ethtool link test
      e1000e: 82574/82583 performance improvement
      e1000e: 82577/8 must acquire h/w semaphore before workaround
      e1000e: 82571 Serdes can fail to get link
      e1000e: 82577/8/9 mis-configured OEM bits during S0->Sx
      e1000e: 82579 PHY incorrectly identified during init
      e1000e: support new PBA format from EEPROM
      e1000e: prevent null ptr dereference in e1000_tx_queue()
      e1000e: minor error message corrections
      e1000e: static analysis tools complain of a possible null ptr p dereference
      e1000e: increment the driver version
      e1000e: checkpatch error - macro panethesis
      e1000e: checkpatch error - trailing statements
      e1000e: checkpatch error - open braces
      e1000e: checkpatch warnings - braces

Bruno Randolf (25):
      ath5k: Optimize descriptor alignment
      ath5k: Add channel time to survey data
      cfg80211: Add nl80211 antenna configuration
      mac80211: Add antenna configuration
      ath5k: Add support for antenna configuration
      lib: Add generic exponentially weighted moving average (EWMA) function
      ath5k: Use generic EWMA library
      nl80211/mac80211: Report signal average
      cfg80211: Add documentation for antenna ops
      cfg80211: Add documentation for antenna ops
      ath5k: Use EWMA factor of 1024 instead of 1000
      lib: Improve EWMA efficiency by using bitshifts
      nl80211/mac80211: Report signal average
      ath5k: Use capabilities information for the number of TX queues
      cfg80211: Add antenna availability information
      ath5k: Fix survey
      cfg80211: Separate available antennas for RX and TX
      nl80211: Export available antennas
      ath5k: Set available antenna information for cfg80211
      ath5k: Simplify powertable recalculation
      ath5k: Separate powertable setup and writing
      ath5k: Track current TX power separately from max TX power
      ath5k: Remove ATH5K_INI_RFGAIN defines, use band instead
      ath5k: Use helper function to get eeprom mode from channel
      ath5k: Move mac80211 functions into new file

Carolyn Wyborny (1):
      igb: Add new function to read part number from EEPROM in string format

Casey Leedom (4):
      cxgb4vf: minor comment/symbolic name cleanup.
      cxgb4vf: add ethtool statistics for GRO.
      cxgb4vf: fix up "Section Mismatch" compiler warning.
      cxgb4vf: Advertise NETIF_F_TSO_ECN.

Changli Gao (18):
      net: use the macros defined for the members of flowi
      net: move definitions of BPF_S_* to net/core/filter.c
      net: don't reallocate skb->head unless the current one hasn't the needed extra size or is shared
      af_packet: use vmalloc_to_page() instead for the addresss returned by vmalloc()
      af_packet: remove pgv.flags
      net: arp: use assignment
      net: init ingress queue
      af_packet: eliminate pgv_to_page on some arches
      af_packet: fix freeing pg_vec twice on error path
      ifb: remove the useless debug stats
      ifb: remove unused macro TX_TIMEOUT
      ifb: use the lockless variants of skb_queue
      af_packet: use swap() instead of the open coded macro XC()
      net: use NUMA_NO_NODE instead of the magic number -1
      net: increase skb->users instead of skb_clone()
      netfilter: fix the race when initializing nf_ct_expect_hash_rnd
      net: bridge: check the length of skb after nf_bridge_maybe_copy_header()
      net: remove the duplicate #ifdef __KERNEL__

Chaoming Li (1):
      rtlwifi: Fix large packet issue

Christian Lamparter (14):
      carl9170: import hw/fw header updates
      carl9170: initialize HW aMPDU parameters properly
      carl9170: fix spurious restart due to high latency
      carl9170: stop stale uplink BA sessions
      carl9170: configurable beacon rates
      carl9170: tx path review
      carl9170: use generic sign_extend32
      carl9170: fix init-self regression
      carl9170: add missing return-value check
      carl9170: reduce channel change delay
      carl9170: fix usb pm suspend->resume woes
      mac80211: ignore PSM bit of reordered frames
      mac80211: serialize rx path workers
      Revert "mac80211: temporarily disable reorder release timer"

Dan Carpenter (11):
      isdn: return -EFAULT if copy_from_user() fails
      vmxnet3: locking problems in xmit
      wl1251: wl12xx_get_platform_data() returns an ERR_PTR
      bnx2x: remove bogus check
      stmmac: unwind properly in stmmac_dvr_probe()
      ath9k: unlock on error path in ath9k_change_interface()
      vxge: remove duplicated part of check
      USB: cdc_ether: remove unneeded check
      ath5k: ath5k_eeprom_mode_from_channel() returns signed
      dcb: unlock on error in dcbnl_ieee_get()
      dcb: use after free in dcb_flushapp()

Daniel Drake (1):
      libertas: don't block usb8388 suspend if no wakeup conditions are set

David Kilroy (1):
      orinoco: allow IW_AUTH_MFP to pass through

David S. Miller (57):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      ipv4: Make rt->fl.iif tests lest obscure.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipv4: Fix build with multicast disabled.
      vlan: Fix build warning in vlandev_seq_show()
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      net: Export netif_get_vlan_features().
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      atm: fore200e: Fix build warning.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      inetpeer: Abstract out the tree root accesses.
      inetpeer: Introduce inet_peer_address_t.
      inetpeer: Make inet_getpeer() take an inet_peer_adress_t pointer.
      inetpeer: Abstract address comparisons.
      inetpeer: Add v6 peers tree, abstract root properly.
      inetpeer: Add inet_getpeer_v6()
      ipv6: Add infrastructure to bind inet_peer objects to routes.
      inet: Turn ->remember_stamp into ->get_peer in connection AF ops.
      inetpeer: Kill use of inet_peer_address_t typedef.
      inetpeer: Fix incorrect comment about inetpeer struct size.
      timewait_sock: Create and use getpeer op.
      ipv6: Add rt6_get_peer() helper.
      ipv6: Create inet6_csk_route_req().
      tcp: Add timewait recycling bits to ipv6 connect code.
      tcp: Implement ipv6 ->get_peer() and ->tw_get_peer().
      Revert "ehea: Use the standard logging functions"
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      can: slcan: Add missing linux/sched.h include.
      net: Abstract away all dst_entry metrics accesses.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next-2.6
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      ipv6: Fix 'release_it' logic in tcp_v6_get_peer()
      isdn: Fix printed out copy_from_user() return value after previous change.
      ipv6: Use ip6_dst_hoplimit() instead of direct dst_metric() calls.
      net: Abstract RTAX_HOPLIMIT metric accesses behind helper.
      ipv6: Demark default hoplimit as zero.
      ipv4: Don't pre-seed hoplimit metric.
      net: Abstract default ADVMSS behind an accessor.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      net: Abstract default MTU metric calculation behind an accessor.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipv4: Flush per-ns routing cache more sanely.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next-2.6
      Merge branch '20101221_static_const' of git://repo.or.cz/linux-2.6/trivial-mods
      Merge branch 'for-davem' of ssh://master.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      af_unix: Avoid socket->sk NULL OOPS in stream connect security hooks.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6

David Shwatrz (1):
      Fix a typo in datagram.c and sctp/socket.c.

Dean Nelson (1):
      e1000: fix return value not set on error

Deepak Saxena (1):
      libertas: EHS_REMOVE_WAKEUP is not always supported

Denis Kirjanov (2):
      sundance: Wrap up acceess to ASICCtrl high word with a macro
      sundance: Program station address into HW

Dimitris Michailidis (11):
      cxgb4: enable PCIe relaxed ordering
      cxgb4: do not read the clock frequency from VPD
      cxgb4: set the number of queues before device registration
      cxgb4: distinguish between 1-lane KR/KX and 4-lane KR/KX/KX4 ports
      cxgb4: print port information after registering each netdev
      cxgb4: allocate more space for MSI-X interrupt names
      cxgb4: correct formatting of MSI-X interrupt names
      cxgb4: remove the name field from the adapter structure
      cxgb4: remove a bitmap
      cxgb4: extend VPD parsing
      cxgb4: NUMA-aware Tx queue allocations

Dmitry Kravkov (1):
      bnx2x: Add Nic partitioning mode (57712 devices)

Don Skidmore (13):
      ixgbe: make silicon specific functions generic
      ixgbe: add MAC and PHY support for x540
      ixgbe: add support for x540 MAC
      ixgbe: update version number for ixgbe
      ixgbe: fix link behavior for SFP+ when driver is brought down
      ixgbe: add WOL support for SFP+ subdevice
      ixgbe: add support for 82599 FCoE SKU
      ixgbe: add support for new format of PBA numbers
      ixgbe: fix for link failure on SFP+ DA cables
      ixgbe: fix enum type mismatch on disable laser
      ixgbe: fix X540 phy id to correct value
      ixgbe: fix X540 to use it's own info struct
      ixgbe: cleanup string function calls to use bound checking versions.

Dongdong Deng (1):
      e1000e: add netpoll support for MSI/MSI-X IRQ modes

Eddie Wai (2):
      bnx2: Fix reset bug on 5709
      cnic: Call cm_connect_complete() immediately on error

Einar Lueck (2):
      qeth: support ipv6 query arp cache for HiperSockets
      qeth: support VIPA add/del in offline mode

Eliad Peller (10):
      mac80211: refactor debugfs function generation code
      wl1271: set wl->vif only if add_interface succeeded.
      wl1271: refactor debugfs function generation code
      wl1271: handle HW watchdog interrupt
      wl1271: add recover testmode command
      wl1271: use debugfs_remove_recursive
      wl1271: move wl12xx debugfs directory to under wiphy's debugfs
      mac80211: fix dynamic-ps/pm_qos magic numbers
      wl12xx: add auto-arp support
      wl12xx: allow runtime changing of debug_level

Emil Tantilov (2):
      ixgb: Don't check for vlan group on transmit
      ixgbe: fix ntuple support

Eric Dumazet (65):
      aoe: remove dev_base_lock use from aoecmd_cfg_pkts()
      bonding: remove dev_base_lock use
      decnet: RCU conversion and get rid of dev_base_lock
      af_unix: use keyed wakeups
      af_unix: fix unix_dgram_poll() behavior for EPOLLOUT event
      af_unix: optimize unix_dgram_poll()
      drivers/net: normalize TX_TIMEOUT
      neigh: reorder struct neighbour
      net: get rid of rtable->idev
      igmp: RCU conversion of in_dev->mc_list
      net: net_families __rcu annotations
      bridge: add RCU annotation to bridge multicast table
      bridge: add proper RCU annotation to should_route_hook
      bridge: add RCU annotations to bridge port lookup
      macvlan: lockless tx path
      vlan: lockless transmit path
      vlan: remove ndo_select_queue() logic
      udp: use atomic_inc_not_zero_hint
      net: reorder struct sock fields
      mpc52xx: cleanup locking
      ixgbe: delay rx_ring freeing
      ixgbe: refactor ixgbe_alloc_queues()
      bonding: IGMP handling cleanup
      igmp: refine skb allocations
      filter: optimize sk_run_filter
      filter: cleanup codes[] init
      filter: use reciprocal divide
      packet: use vzalloc()
      pktgen: allow faster module unload
      bnx2x: Disable local BHes to prevent a dead-lock situation
      ipv6: mcast: RCU conversion
      scm: lower SCM_MAX_FD
      infiniband: remove dev_base_lock use
      drivers/net: use vzalloc()
      net: add netif_tx_queue_frozen_or_stopped
      xps: NUMA allocations for per cpu data
      xps: add __rcu annotations
      net sched: use xps information for qdisc NUMA affinity
      filter: add SKF_AD_RXHASH and SKF_AD_CPU
      __in_dev_get_rtnl() can use rtnl_dereference()
      net: kill an RCU warning in inet_fill_link_af()
      filter: add a security check at install time
      net: RCU conversion of dev_getbyhwaddr() and arp_ioctl()
      filter: constify sk_run_filter()
      net: call dev_queue_xmit_nit() after skb_dst_drop()
      net: optimize INET input path further
      filter: use size of fetched data in __load_pointer()
      net: add limits to ip_default_ttl
      net: change ip_default_ttl documentation
      tcp: relax tcp_paws_check()
      ifb: fix a lockdep splat
      ifb: use netif_receive_skb() instead of netif_rx()
      net_sched: sch_sfq: add backlog info in sfq_dump_class_stats()
      net_sched: sch_sfq: better struct layouts
      net: timestamp cloned packet in dev_queue_xmit_nit
      filter: optimize accesses to ancillary data
      sfq: fix sfq class stats handling
      sch_sfq: allow big packets and be fair
      sfq: fix slot_dequeue_head()
      tg3: fix warnings
      sch_red: report backlog information
      ifb: add performance flags
      net_sched: pfifo_head_drop problem
      net: add POLLPRI to sock_def_readable()
      ipv4: IP defragmentation must be ECN aware

Eric Paris (5):
      netfilter: allow hooks to pass error code back up the stack
      network: tcp_connect should return certain errors up the stack
      SELinux: return -ECONNREFUSED from ip_postroute to signal fatal error
      SELinux: Only return netlink error when we know the return is fatal
      SELinux: indicate fatal error in compat netfilter code

Felix Fietkau (85):
      ath9k_hw: optimize interrupt mask changes
      ath9k_hw: small optimization in ar9002_hw_get_isr
      ath9k_hw: optimize tx status descriptor processing
      ath9k: optimize/fix ANI RSSI processing
      ath9k: remove a redundant call to ath9k_hw_gettsf32
      ath9k_hw: make ath9k_hw_gettsf32 static
      ath9k_hw: optimize all descriptor access functions
      ath9k_hw: initialize regulatory->max_power_level in set_txpower for AR9003
      ath9k_hw: extend ath9k_hw_set_txpowerlimit to test channel txpower
      ath9k: initialize per-channel tx power limits instead of hardcoding them
      ath9k_hw: fix potential spurious tx error bit interpretation
      mac80211: minstrel_ht - reduce the overhead of rate sampling
      ath9k: rework tx queue selection and fix queue stopping/waking
      ath9k: remove the unnecessary private xretry tx flag
      ath9k: handle tx underrun in the driver instead of rate control
      ath9k: remove the tx info padding byte abuse
      ath9k: clean up tx buffer setup
      ath9k_hw: add a private op for configuring radar pulse detection
      cfg80211: add support for setting the ad-hoc multicast rate
      mac80211: add support for setting the ad-hoc multicast rate
      ath9k_hw: set default values for radar pulse detection
      ath9k: fix PA predistortion training frame setup
      ath9k: remove bfs_seqno from struct ath_buf_state
      ath9k: remove bfs_tidno from struct ath_buf_state
      ath9k: remove bfs_keytype from struct ath_buf_state
      ath9k: remove bfs_paprd_timestamp from struct ath_buf_state
      ath9k: remove bfs_keyix from struct ath_buf_state
      ath9k: remove bfs_al from struct ath_buf_state
      ath9k: remove bfs_nframes from struct ath_buf_state
      ath9k: remove bfs_frmlen from struct ath_buf_state
      ath9k: remove bf_tx_aborted from struct ath_buf
      ath9k: clean up code duplication around ath_tx_start
      ath9k: block new AMPDU sessions if SC_OP_TXAGGR is not set
      ath9k: more tx setup cleanups
      ath9k: store frame information used by aggregation inside the skb tx info
      ath9k_hw: add support for reading EEPROM data from the internal OTP ROM
      ath9k: add support for reading eeprom from platform data on PCI devices
      ath9k_hw: support reading calibration data from flash on AR9003
      ath9k: fix recursive locking in the tx flush path
      ath9k_hw: fix A-MPDU key search issues on AR9003
      ath9k_htc: fix eeprom access
      mac80211: restart beacon miss timer on system resume from suspend
      mac80211: calculate beacon loss time accurately
      mac80211: probe the AP when resuming
      cfg80211/mac80211: improve ad-hoc multicast rate handling
      mac80211: use nullfunc instead of probe request for connection monitoring
      mac80211: reduce the number of retries for nullfunc probing
      ath9k_hw: remove ath9k_hw_stoppcurecv
      ath9k: fix software retry counter tracking
      ath5k: Use Generic DMA for later support of AHB bus.
      ath5k: Introduce ath5k_init_softc function as in ath9k
      ath5k: Move PCI bus functions to separate file.
      ath5k: Use generic eeprom read from common ath_bus_opts struct.
      ath5k: Check if pci pdev struct is initialized in common functions.
      ath5k: Add a function to read chipset's MAC revision
      ath5k: Add initial registers values for radio RF2317 chip.
      ath5k: Add AHB bus support.
      ath5k: Fix reset and interrupts for AHB type of devices.
      mac80211: remove a redundant check
      mac80211: speed up AP probing using nullfunc frames
      mac80211: fix a compiler warning
      ath9k: fix sequence number assigment for non-AMPDU QoS data frames
      ath9k_hw: only use the PCIe disable register write sequence for AR5416
      ath9k_hw: clean up duplicate and unnused eeprom related defines
      ath9k_hw: merge ath9k_hw_get_gain_boundaries_pdadcs between eeprom_def.c and eeprom_4k.c
      ath9k_hw: merge the ar9287 version of ath9k_hw_get_gain_boundaries_pdadcs
      ath9k_hw: remove antenna configuration eeprom ops and variables
      ath9k_hw: clean up SREV version checks
      ath9k_hw: remove ah->beacon_interval
      ath9k_hw: remove ah->txpower_indexoffset
      ath9k_hw: initialize ah->slottime
      ath9k_hw: fix the slot time setting for long distance links
      ath9k: fix PA predistortion thermal measurement handling
      ath9k_hw: fix the PA predistortion rate mask
      ath9k_hw: fix PA predistortion training power selection
      ath9k_hw: update AR9003 initvals for improved radar detection
      ath9k_hw: update AR9003 initvals to improve carrier leak calibration/correction
      ath9k: fix queue depth check for forming new aggregates
      ath9k_hw: remove baseband rfsilent support
      mac80211: fix initialization of skb->cb in ieee80211_subif_start_xmit
      mac80211: skip unnecessary pskb_expand_head calls
      mac80211: fix potentially redundant skb data copying
      ath9k_hw: fix PA predistortion HT40 mask
      ath9k: do not limit the chainmask to 1 for legacy mode
      ath9k_hw: fix dma descriptor rx error bit parsing

Ferenc Wagner (2):
      netconsole: don't announce stopping if nothing happened
      netconsole: clarify stopping message

Francois-Xavier Le Bail (1):
      net: typos in comments in include/linux/igmp.h

Frank Blaschka (2):
      qeth: l3 fix len in tso hdr
      qeth: l3 add vlan hdr in passthru frames

Gasparakis, Joseph (1):
      igb: Some fine tuning

Gerrit Renker (10):
      dccp ccid-2: Ack Vector interface clean-up
      dccp ccid-2: Separate internals of Ack Vectors from option-parsing code
      dccp ccid-2: Implementation of circular Ack Vector buffer with overflow handling
      dccp ccid-2: Algorithm to update buffer state
      dccp ccid-2: Update code for the Ack Vector input/registration routine
      dccp ccid-2: Consolidate Ack-Vector processing within main DCCP module
      dccp ccid-2: Schedule Sync as out-of-band mechanism
      dccp ccid-2: Remove old infrastructure
      dccp ccid-2: Separate option parsing from CCID processing
      dccp ccid-2: whitespace fix-up

Gertjan van Wingerde (9):
      rt2x00: Add initial support for RT3370/RT3390 devices.
      rt2x00: Clean up Kconfig for RT2800 devices.
      rt2x00: Remove RT30XX Kconfig variables.
      rt2x00: Remove unneccessary internal Kconfig symbols.
      rt2x00: Use ioremap for SoC devices instead of KSEG1ADDR.
      rt2x00: Ensure TX-ed frames are returned in the original state.
      rt2x00: Remove intf->bssid field.
      rt2x00: remove intf->mac field.
      rt2x00: Fix pointer errors.

Gery Kahn (2):
      wl1271: ref_clock cosmetic changes
      wl1271: cleanup unused code of calibration structures

Giuseppe CAVALLARO (4):
      stmmac: tidy-up stmmac_priv structure
      stmmac: add init/exit callback in plat_stmmacenet_data struct
      stmmac: convert to dev_pm_ops.
      stmmac: update the driver version

Giuseppe Cavallaro (2):
      stmmac: update the driver documentation
      stmmac: fix stmmac_resume removing not yet used shutdown flag

Grazvydas Ignotas (3):
      wl1251: add power callback to wl1251_if_operations
      wl1251: add runtime PM support for SDIO
      wl1251: use wl12xx_platform_data to pass data

Greg Rose (11):
      ixgbevf: Update Version String and Copyright Notice
      ixgbevf: Fix Oops
      igbvf: Update version and Copyright
      Remove extra struct page member from the buffer info structure
      igb: Fix overwrite of the VF's flags
      igb: Warn on attempt to override administratively set MAC/VLAN
      igb: Add Anti-spoofing feature support
      ixgbe: Warn on VF attempt to override Administratively set MAC/VLAN
      ixgbe: Add SR-IOV feature support to X540
      ixgbe: Add anti-spoofing feature support
      ixgbevf: Add X540 VF device support to the ixgbevf driver

Grumbach, Emmanuel (1):
      iwlagn: Enable PCI L1 ACTIVE state after uCode has been loaded

Gustavo F. Padovan (5):
      Merge git://git.kernel.org/.../padovan/bluetooth-2.6 into test
      Bluetooth: Get rid of __l2cap_get_sock_by_psm()
      Bluetooth: Get rid of __rfcomm_get_sock_by_channel()
      Bluetooth: Don't accept ConfigReq if we aren't in the BT_CONFIG state
      Bluetooth: Improve handling of HCI control channel in bind

Guy Eilam (1):
      wl1271: fixed problem with WPS IEs in probe requests

Hauke Mehrtens (9):
      carl9170: fix typos
      ssb: Add sysfs attributes to ssb devices
      wl1251: remove unnecessary import
      wl12xx: remove unnecessary import
      ssb: Use pci_is_pcie()
      rt2x00: Use pci_is_pcie()
      ath5k: Use pci_is_pcie()
      ath9k: Use pci_is_pcie()
      rtlwifi: Use pci_pcie_cap()

Helmut Schaa (17):
      rt2x00: Add TXOP_CTRL_CFG register definition
      rt2x00: Sync Tx and RX ring sizes with legacy drivers
      rt2x00: Wait up to one second on rt2800 for WPDMA to be ready
      rt2x00: Reduce tx descriptor size
      rt2x00: Optimize rt2x00debug_dump_frame when frame dumping is not active
      rt2x00: Fix hw crypto in AP mode for some devices
      mac80211: Disable hw crypto for GTKs on AP VLAN interfaces
      mac80211: Minor optimization in ieee80211_rx_h_data
      mac80211: Update last_tx_rate only for data frames
      cfg80211: Add new BSS attribute ht_opmode
      mac80211: Apply ht_opmode changes in ieee80211_change_bss
      rt2x00: Implement get_survey callback for rt2800
      rt2x00: Don't frequently reset beacon interval in AdHoc mode
      rt2x00: Remove superfluous assignment of mpdu_density
      rt2x00: Simplify intf->delayed_flags locking
      rt2x00: Remove unused interface spinlock
      rt2x00: Fix comment about removed spinlock

Henry Ptasinski (1):
      include/linux/if_ether.h: Add #define ETH_P_LINK_CTL for HPNA and wlan local tunnel

Herbert Xu (1):
      bridge: Use consistent NF_DROP returns in nf_pre_routing

Herton Ronaldo Krzesinski (9):
      rtl8187: remove redundant initialization of ARFR
      rtl8187: remove setting of beacon/atim registers from initialization
      rtl8187: fix wrong register initialization in 8187B
      rtl8187: avoid redundant write to register FF72 (RFSW_CTRL)
      rtl8187: move pll reset at start out of ANAPARAM write
      rtl8187: don't set RTL818X_CONFIG3_GNT_SELECT flag on 8187B
      rtl8187: consolidate anaparam on/off write sequences
      rtl8187: remove uneeded setting of anaparam write
      rtl8187: restore anaparam registers after reset with 8187B

Holger Eitzenberger (1):
      e1000e: fix double initialization in blink path

Huang Weiyi (1):
      libertas: remove duplicated #include

Ido Yariv (4):
      wl1271: TX aggregation optimization
      wl1271: Fix TX starvation
      wl1271: Allocate TX descriptors more efficiently
      wl1271: Fix TX queue low watermark handling

Ismael Luceno (1):
      rt2x00: Fix panic on frame padding for rt2800 usb devices

Ivo van Doorn (17):
      rt2x00: Rename rt2x00queue_timeout
      rt2x00: Remove failsave from rt2x00usb_watchdog_tx_dma
      rt2x00: Implement flush callback
      rt2x00: Fix MCU_SLEEP arguments
      rt2x00: Fix crash on USB unplug
      rt2x00: Rename queue->lock to queue->index_lock
      rt2x00: Fix rt2x00queue_kick_tx_queue arguments
      rt2x00: Remove rt2x00lib_toggle_rx
      rt2x00: Add watchdog functions for HW queue
      rt2x00: Increase REGISTER_BUSY_COUNT
      rt2x00: Introduce 3 queue commands in drivers (start, kick, stop).
      rt2x00: Reorganize queue callback functions
      rt2x00: Protect queue control with mutex
      rt2x00: Add "flush" queue command
      rt2x00: Cleanup RX index counting
      rt2x00: Introduce extra queue entry sanity flag
      rt2x00: Fix WMM Queue naming

Jan Engelhardt (2):
      netlink: let nlmsg and nla functions take pointer-to-const args
      netns: let net_generic take pointer-to-const args

Jan Glauber (1):
      qeth: buffer count imbalance

Jason Wang (1):
      vhost: fix typos in comment

Javier Cardona (6):
      nl80211/mac80211: define and allow configuring mesh element TTL
      mac80211: Fix compilation error when mesh is disabled
      mac80211: Rename mesh_params to mesh_config to prepare for mesh_setup
      mac80211: Let userspace enable and configure vendor specific path selection.
      mac80211: Send mesh non-HWMP path selection frames to userspace
      mac80211: Remove unused third address from mesh address extension header.

Jeff Kirsher (9):
      Documentation/networking/e1000.txt: Update documentation
      Documentation/networking/e1000e.txt: Update documentation
      Documentation/networking/igb.txt: update documentation
      Documentation/networking/igbvf.txt: Update documentation
      Documentation/networking/ixgbe.txt: Update ixgbe documentation
      Documentation/networking/ixgbevf.txt: Update documentation
      MAINTAINERS: Update Intel Wired LAN info
      Intel Wired LAN drivers: Use static const
      Documentation/networking: Update Intel Wired LAN docs

Jeremy Eder (1):
      clarify documentation for net.ipv4.igmp_max_memberships

Jesper Juhl (1):
      mac80211: Remove redundant checks for NULL before calls to crypto_free_cipher()

Jesse Gross (3):
      offloading: Make scatter/gather more tolerant of vlans.
      offloading: Support multiple vlan tags in GSO.
      offloading: Force software GSO for multiple vlan tags.

Jiri Kosina (1):
      tcp: cleanup of cwnd initialization in tcp_init_metrics()

Jiri Pirko (1):
      net/ipv6/udp.c: fix typo in flush_stack()

Joe Perches (74):
      drivers/net/can: Update WARN uses
      drivers/net/usb: Update WARN uses
      net/core/dev.c: Update WARN uses
      net/ipv4/tcp.c: Update WARN uses
      drivers/isdn: Remove unnecessary semicolons
      drivers/net/bnx2x: Remove unnecessary semicolons
      drivers/net/e1000e: Remove unnecessary semicolons
      drivers/net/ixgbe: Remove unnecessary semicolons
      drivers/net/cnic.c: Remove unnecessary semicolons
      include/linux/if_macvlan.h: Remove unnecessary semicolons
      include/net/caif/cfctrl.h: Remove unnecessary semicolons
      net/ipv6/mcast.c: Remove unnecessary semicolons
      drivers/isdn/mISDN: Use printf extension %pV
      drivers/net/wireless/ath/debug.c: Use printf extension %pV
      drivers/net/wireless/b43/main.c: Use printf extension %pV
      drivers/net/wireless/b43legacy/main.c: Use printf extension %pV
      drivers/isdn/i4l: Remove unnecessary casts of netdev_priv
      drivers/net/bonding: Remove unnecessary casts of netdev_priv
      drivers/net/pcmcia: Remove unnecessary casts of netdev_priv
      drivers/net/qla3xxx.c: Remove unnecessary casts of netdev_priv
      drivers/net/qlge: Remove unnecessary casts of netdev_priv
      drivers/net/usb: Remove unnecessary casts of netdev_priv
      drivers/net/vxge: Remove unnecessary casts of netdev_priv
      drivers/net: Remove unnecessary casts of netdev_priv
      net/atm: Remove unnecessary casts of netdev_priv
      drivers/isdn/hisax: Add printf format/argument verification and fix fallout
      drivers/net/s2io.c: Remove unnecessary casts of pci_get_drvdata
      drivers/net/vxge/vxge-main.c: Remove unnecessary casts of pci_get_drvdata
      drivers/net/can/sja1000: Use printf extension %pR for struct resource
      ar9170: Use const
      ath5k: Use static const
      ath9k: Use static const
      carl9170: Use static const
      atmel: Use static const
      b43: Use static const
      iwlwifi: Use static const
      libertas: Use static const
      ray_cs: Use static const
      rndis_wlan: Use static const
      rt2x00: Use static const
      zd1211rw: Use const
      net/wireless: Use pr_<level> and netdev_<level>
      netxen: remove unnecessary [kv][mcz]alloc casts
      qlcnic: remove unnecessary [kv][mcz]alloc casts
      vxge: remove unnecessary [kv][mcz]alloc casts
      zd1211rw: document need for kmalloc cast
      drivers/s390/net: Remove unnecessary semicolons
      forcedeth: Change reg_delay arguments and use
      forcedeth: convert dprintk(KERN_DEBUG to netdev_dbg
      forcedeth: Use print_hex_dump
      forcedeth: Convert remaining dprintk to netdev_dbg
      forcedeth: Use pr_fmt and pr_<level>
      forcedeth: Convert pr_<level> to netdev_<level>
      forcedeth: Add function init_realtek_8211b
      forcedeth: Separate vendor specific initializations into functions
      forcedeth: Convert dev_printk(<level> to dev_<level>(
      forcedeth: Remove netdev_dbg uses
      forcedeth: Use netdev_dbg for printk(KERN_DEBUG
      ath9k: hif_usb: Reduce indent 1 column
      wireless: Remove unnecessary casts of usb_get_intfdata
      MAINTAINERS: Add ATH GENERIC UTILITIES
      ehea: Use the standard logging functions
      ath: Add and use ath_printk and ath_<level>
      ath: Convert ath_print(.., ATH_DBG_FATAL to ath_err
      ath: Convert ath_print to ath_dbg
      ath: Fix ath_dbg access beyond array bound
      ehea: Use the standard logging functions
      cxgb4: add const to static arrays
      pktgen: Remove unnecessary prefix from pr_<level>
      tg3: Use DEFINE_PCI_DEVICE_TABLE
      drivers/net/*.c: Use static const
      usb: Use static const, consolidate code
      tulip: Use DEFINE_PCI_DEVICE_TABLE and static const
      drivers/net/*/: Use static const

Joel A Fernandes (1):
      mac80211: Fix mesh portal communication with other mesh nodes.

Johan Hedberg (12):
      Bluetooth: Simplify remote features callback function logic
      Bluetooth: Create a unified authentication request function
      Bluetooth: Automate remote name requests
      Bluetooth: Add Bluetooth Management interface definitions
      Bluetooth: Add initial Bluetooth Management interface callbacks
      Bluetooth: Make hci_send_to_sock usable for management control sockets
      Bluetooth: Add error handling for managment command handlers
      Bluetooth: Add read_version management command
      Bluetooth: Add read_index_list management command
      Bluetooth: Add read_info management command
      Bluetooth: Add management events for controller addition & removal
      Bluetooth: Fix __hci_request synchronization for hci_open_dev

Johannes Berg (63):
      iwlwifi: make mac80211 ops a device config
      iwlagn: don't resend RXON timing
      iwlagn: new RXON processing for modern devices
      iwlwifi: fix IBSS beaconing
      iwlwifi: implement switching iftype while up
      iwlagn: fix non-5000+ build
      iwlagn: fix needed chains calculation
      iwlagn: fix RXON issues
      iwlagn: re-enable calibration
      iwlagn: fix RXON HT
      iwlagn: fix some naming regarding FIFOs
      iwlagn: remove unused variable swq_id
      iwlagn: remove a bogus AGG_OFF check
      iwlwifi: pass txq to wake/stop queue
      iwlwifi: always build swq_id as virtual queue ID
      iwlagn: fix PAN queues
      iwlagn: avoid crash if vif is not assigned
      iwlagn: reprogram AP STA after assoc
      iwlagn: fix PAN slot timing wrt. DTIM
      mac80211: defines for AC numbers
      mac80211: fix powersaving clients races
      iwlwifi: fix modular 3945 only build
      cfg80211: allow using CQM event to notify packet loss
      mac80211: implement packet loss notification
      iwlagn: remove powersave warning
      iwlagn: fix station powersave accounting for aggregation
      iwlagn: advertise reliable TX status
      iwlwifi: use mac80211 AC defines
      nl80211/cfg80211: extend mgmt-tx API for off-channel
      mac80211: implement off-channel mgmt TX
      mac80211: fix RX aggregation locking
      cfg80211: include CQM packet loss docs
      mac80211: document workqueue
      mac80211: publish docs for _ni functions
      mac80211: publish some misc docs
      mac80211: publish some rate control docs
      mac80211: document aggregation
      mac80211: publish interface iteration docs
      mac80211: document station handling
      mac80211: publish SMPS docs
      mac80211: move mesh filter adjusting
      cfg80211: require add_virtual_intf to return new dev
      nl80211: refactor mesh parameter parsing
      cfg80211/mac80211: add mesh join/leave commands
      mac80211: clean up RX key checks
      cfg80211/nl80211: separate unicast/multicast default TX keys
      mac80211: support separate default keys
      mac80211: support IBSS RSN with SW crypto
      iwlagn: fix debug variable access
      iwlagn: rename enhanced txpower fields
      iwlagn: implement layout-agnostic EEPROM reading
      iwlagn: remove old EEPROM TX power reading
      nl80211: advertise maximum remain-on-channel duration
      mac80211: make LED trigger names available early
      mac80211: add throughput based LED blink trigger
      mac80211: selective throughput LED trigger active
      mac80211: cleanup select_queue
      iwlagn: fix FH error
      mac80211: add missing synchronize_rcu
      mac80211: fix some key comments and code
      mac80211: implement hardware offload for remain-on-channel
      mac80211: implement off-channel TX using hw r-o-c offload
      mac80211: remove stray extern

Johannes Stezenbach (6):
      mac80211/rt2x00: add ieee80211_tx_status_ni()
      rt2x00: fix hang when unplugging USB device in use
      rt2x00: trivial: add missing \n on warnings
      rt2x00: remove stray semicolon
      rt2x00: simplify txstatus_fifo handling
      rt2x00: allow txstatus_fifo w/o txstatus_tasklet

John Fastabend (13):
      8021q: set hard_header_len when VLAN offload features are toggled
      net: remove check for headroom in vlan_dev_create
      net: consolidate 8021q tagging
      ipv6: fix missing in6_ifa_put in addrconf
      ixgbe: DCB set PFC high and low water marks per data sheet specs
      ixgbe: DCB: credit max only needs to be gt TSO size for 82598
      ixgbe: rework Tx hang detection to fix reoccurring false Tx hangs
      net: zero kobject in rx_queue_release
      net: add priority field to pktgen
      8021q: vlan device is lockless do not transfer real_num_{tx|rx}_queues
      dcbnl: add support for ieee8021Qaz attributes
      dcbnl: add appliction tlv handlers
      net_dcb: add application notifiers

John W. Linville (32):
      b43: remove extraneous code in free_ringmemory
      rt2x00pci: do not use GFP_DMA
      iwlwifi: Convert to new PCI PM framework
      iwmc3200wifi: clarify potentially undefined operation in iwm_scan_ssids
      rndis_wlan: avoid uninitialized var warning in rndis_wlan_craft_connected_bss
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Revert "nl80211/mac80211: Report signal average"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      ath5k: remove MODULE_VERSION
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      ath: fix build break with ATH_DBG_WARN_ON_ONCE
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      rtlwifi: convert to __packed notation
      Merge branch 'wl12xx-next' of git://git.kernel.org/.../luca/wl12xx
      rtl8192ce: drop 'rtl8192c-' prefix from files
      rtlwifi: use alloc_workqueue
      rtl818x: move rtl8180 and rtl8187 to separate subdirectories
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'master' of master.kernel.org:/.../padovan/bluetooth-next-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      ath9k: qualify global modparam_nohwcrypt variable
      ath5k: qualify global modparam_nohwcrypt variable
      ath9k: correct MODULE_PARM_DESC parameters for force_new_ani
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Jon Mason (26):
      vxge: enable rxhash
      vxge: Wait for Rx to become idle before reseting or closing
      vxge: cleanup debug printing and asserts
      vxge: serialize access to steering control register
      vxge: add support for ethtool firmware flashing
      vxge: add receive hardware timestamping
      vxge: Handle errors in vxge_hw_vpath_fw_api
      vxge: Titan1A detection
      vxge: correct multi-function detection
      vxge: update Kconfig
      vxge: sparse and other clean-ups
      vxge: update driver version
      vxge: remove unnecessary printks
      vxge: use strcpy for strings
      vxge: update driver version
      vxge: code cleanup and reorganization
      vxge: fix crash of VF when unloading PF
      vxge: use pci_request_region()
      vxge: transmit timeout deadlock
      vxge: hotplug stall
      vxge: independent interrupt moderation
      vxge: update driver version
      s2io: rx_ring_sz bounds checking
      s2io: make strings at tables const
      s2io: Update Driver Version
      s2io: Using static const generally increases object text and decreases data size. It also generally decreases overall object size.

Jonas Bonn (7):
      ethoc: Add device tree configuration
      ethoc: remove unused spinlock
      ethoc: Double check pending RX packet
      ethoc: rework interrupt handling
      ethoc: rework mdio read/write
      ethoc: fix function return type
      ethoc: remove division from loops

Jouni Malinen (1):
      nl80211: Add notification for dropped Deauth/Disassoc

Jozsef Kadlecsik (2):
      ipv6: Prepare the tree for un-inlined jhash.
      The new jhash implementation

Julia Lawall (1):
      drivers/vhost/vhost.c: delete double assignment

Julian Stecklina (1):
      igbvf: Remove some dead code in igbvf

Junchang Wang (1):
      pktgen: adding prefetchw() call

Jussi Kivilinna (9):
      rndis_wlan: workaround device not returning bss for currently connected AP
      rndis_wlan: workaround poor scanning with BCM4320a
      rndis_wlan: scanning, workaround device returning incorrect bssid-list item count.
      rndis_wlan: do not set default_key if not WEP key
      rndis_wlan: turn radio off before interface is bring up
      rndis_wlan: constify rndis_config_ops
      rndis_wlan: remove unused variable from priv structure
      rndis_wlan: add support for set_cqm_rssi_config
      rndis_wlan: add support for set_power_mgmt

Juuso Oikarinen (11):
      wl1271: Fix RX path stall
      wl1271: Fix scan failure detection
      wl1271: Check interface state in op_* functions
      mac80211: Add function to get probe request template for current AP
      wl1271: Prevent ad-hoc and active scanning on 11a DFS frequencies
      Revert "wl1271: Change supported channel order for a more optimal scan"
      wl12xx: Unset bssid filter, ssid and bssid from firmware on disassoc
      wl12xx: Fix kernel crash related to hw recovery and interface shutdown
      wl1271: Fix setting of the hardware connection monitoring probe-req template
      wl12xx: Remove 11j channels from the supported channels list.
      wl12xx: Change TX queue to be per AC

Lalith Suresh (1):
      rt2x00: Fix comments in rt73usb.h and rt61pci.h

Larry Finger (8):
      ssb: Clear RETRY_TIMEOUT in PCI Configuration for normal devices
      rtl8192ce: Add new driver
      rtl8192ce: Fix build on powerpc
      rtl8192ce: Update MAINTAINERS
      rtlwifi: Switch locking from semaphores to mutexes
      MAINTAINERS: Fix typo in rtl8192ce entry
      rtlwifi: Fix use of mutex in interrupt code
      rtlwifi: rtl8192ce: Fix driver problem when radio switch off at module load

Luciano Coelho (6):
      wl1271: exit ELP mode when setting enabled rates in tx
      wl12xx: disable 11a channels when regulatory changes if 11a is not supported
      wl12xx: fix illegal memset if debugfs is not enabled
      wl12xx: disable 11a channels when wl->enable_11a is known
      wl12xx_sdio_test: rename files to match current style
      mac80211: check for CONFIG_MAC80211_LEDS in the tpt_led_trigger declaration

Luis R. Rodriguez (29):
      ath9k: fix sparse complaint on aphy for debugfs
      ath: make ath_hw_keysetmac() static
      ath: make ath_hw_set_keycache_entry() static
      ath5k: make ath5k_update_bssid_mask_and_opmode() static
      cfg80211: pass the reg hint initiator to helpers
      cfg80211: fix allowing country IEs for WIPHY_FLAG_STRICT_REGULATORY
      cfg80211: fix disabling channels based on hints
      cfg80211: add debug prints for when we ignore regulatory hints
      cfg80211: add debug print when disabling a channel on a custom regd
      cfg80211: add debug print when processing a channel
      cfg80211: prefix REG_DBG_PRINT() with cfg80211
      ath: add a ATH_DBG_WARN()
      ath9k: add a debug warning when we cannot stop RX
      ath9k: simplify hw reset locking
      ath9k: move the PCU lock to the sc structure
      ath9k: content DMA start / stop through the PCU lock
      cfg80211: put core regulatory request into queue
      cfg80211: move reg_work and reg_todo above
      cfg80211: move mutex locking to reg_process_pending_hints()
      cfg80211: Fix regulatory bug with multiple cards and delays
      ath9k: avoid aggregation for VO traffic
      mac80211: avoid aggregation for VO traffic
      ath9k: skip ATH9K_INT_TIM_TIMER when we are idle
      ath9k_hw: warn if we cannot change the power to the chip
      ath9k: Fix power save count imbalance on ath_radio_enable()
      ath9k: fix assumptions for idle calls on suspend/resume
      cfg80211: fix null pointer dereference with a custom regulatory request
      ath: fix NULL pointer dereference on reg_notifier()
      ath9k: fix aphy / wiphy idle mismatch

Manuel Lauss (1):
      net: au1000_eth: remove unused global variable.

Mark Einon (14):
      rt2x00: checkpatch.pl error fixes for rt2400pci.h
      rt2x00: checkpatch.pl error fixes for rt2500pci.h
      rt2x00: checkpatch.pl error fixes for rt2500usb.c
      rt2x00: checkpatch.pl error fixes for rt2800.h
      rt2x00: checkpatch.pl error fixes for rt2800lib.c
      rt2x00: checkpatch.pl error fixes for rt2800pci.h
      rt2x00: checkpatch.pl error fixes for rt2800usb.c
      rt2x00: checkpatch.pl error fixes for rt2800usb.h
      rt2x00: checkpatch.pl error fixes for rt2x00config.c
      rt2x00: checkpatch.pl error fixes for rt2x00dev.c
      rt2x00: checkpatch.pl error fixes for rt2x00lib.h
      rt2x00: checkpatch.pl error fixes for rt2x00link.c
      rt2x00: checkpatch.pl error fixes for rt2x00queue.c
      rt2x00: checkpatch.pl error fixes for rt73usb.c

Martin Willi (3):
      xfrm: Add Traffic Flow Confidentiality padding XFRM attribute
      xfrm: Traffic Flow Confidentiality for IPv4 ESP
      xfrm: Traffic Flow Confidentiality for IPv6 ESP

Matt Carlson (16):
      tg3: Apply 10Mbps fix to all 57765 revisions
      tg3: Assign correct tx margin for 5719
      tg3: Always turn on APE features in mac_mode reg
      tg3: Fix 5719 internal FIFO overflow problem
      tg3: Reorg tg3_napi members
      tg3: Enable mult rd DMA engine on 5719
      tg3: Reenable TSS for 5719
      tg3: use dma_alloc_coherent() instead of pci_alloc_consistent()
      tg3: Enable phy APD for 5717 and later asic revs
      tg3: Remove tg3_config_info definition
      tg3: Raise the jumbo frame BD flag threshold
      tg3: Move EEE definitions into mdio.h
      tg3: Fix 57765 EEE support
      tg3: Minor EEE code tweaks
      tg3: Relax EEE thresholds
      tg3: Update version to 3.116

Michael Chan (14):
      bnx2: Remove config access to non-standard registers
      cnic: Fix iSCSI TCP port endian order.
      cnic: Prevent "scheduling while atomic" when calling ->cnic_init()
      cnic: Improve ->iscsi_nl_msg_send()
      cnic: Use proper client and connection IDs on iSCSI ring
      cnic: Support NIC Partition mode
      cnic: Check device state before reading the kcq pointer in IRQ
      cnic: Add kcq2 support on 57712
      cnic: Add FCoE support on 57712
      bnx2: Free IRQ before freeing status block memory
      bnx2: Update firmware and version
      cnic: Do not allow iSCSI and FCoE on bnx2x multi-function mode
      cnic: Do not call bnx2i when bnx2i is calling cnic_unregister_driver()
      cnic: Fix the type field in SPQ messages

Michael S. Tsirkin (9):
      vhost: put mm after thread stop
      vhost-net: batch use/unuse mm
      vhost: copy_to_user -> __copy_to_user
      vhost: get/put_user -> __get/__put_user
      vhost: remove unused include
      vhost: correctly set bits of dirty pages
      vhost: better variable name in logging
      vhost test module
      tools/virtio: virtio_test tool

Michal Simek (2):
      trivial: Fix typo fault in netdevice.h
      ll_temac: Fix section mismatch from the temac_of_probe

Micha≈Ç Miros≈Çaw (4):
      net: Fix too optimistic NETIF_F_HW_CSUM features
      net: Introduce skb_checksum_start_offset()
      net: Use skb_checksum_start_offset()
      net: Fix drivers advertising HW_CSUM feature to use csum_start

Milton Miller (1):
      mac80211: fix mesh forwarding when ratelimited too

Mohammed Shafi Shajakhan (15):
      ath9k: Remove the median function in rate control
      ath9k: Properly assign boolean types
      ath9k_htc: Use macro for caldata array size
      ath9k: Add support for Adaptive Power Management
      ath9k: Properly use unlikely check macro
      ath9k: Parse DTIM period from mac80211
      ath9k: Remove dead code in recv.c
      ath9k: clean up hardware code for beacon handling
      ath9k: Make PM-QOS value as user configurable
      ath9k: Add comments for making pm-qos as modparam
      ath9k: Properly initialize channel table for 2GHz
      ath9k: Reset keycache on resume
      ath9k: Few clean ups in beacon config parameters
      Revert "ath9k: Parse DTIM period from mac80211"
      ath9k : few rate control clean ups

Namhyung Kim (1):
      isdn/hisax: fix compiler warning on hisax_pci_tbl

Nandita Dukkipati (1):
      TCP: increase default initial receive window.

Neil Horman (1):
      packet: Enhance AF_PACKET implementation to not require high order contiguous memory allocation (v4)     MIME-Version: 1.0     Content-Type: text/plain; charset=UTF-8     Content-Transfer-Encoding: 8bit

Nick Kossifidis (35):
      ath5k: Reset cleanup and generic cleanup
      ath5k: Add new function to stop rx/tx DMA
      ath5k: Stop PCU on reset
      ath5k: Use new dma_stop function on base.c
      ath5k: Debug DMA timeouts
      ath5k: Use DCU early termination correctly
      ath5k: Check RXE when setting RXDP
      ath5k: Use new function to stop beacon queue
      ath5k: Add new field on ath5k_hw to track bandwidth modes
      ath5k: Put core clock initialization on a new function
      ath5k: Small cleanup on tweak_initvals
      ath5k: Increase PHY settling parameters for turo mode
      ath5k: Move tx retries setting outside reset_tx_queue
      ath5k: Extend get_default_sifs/slot_time
      ath5k: Extend rate_duration
      ath5k: Set all IFS intervals, not just slot time
      ath5k: Use turbo flag on DCU
      ath5k: Always set IFS intervals on reset
      ath5k: Tweak power detector delays on RF5111/RF5112
      ath5k: Update spur mitigation filter for turbo/half/quarter
      ath5k: Update PLL programming for turbo/half/quarter
      ath5k: Skip powertable setting when we are on the same channel
      ath5k: Support synth-only channel change for AR2413/AR5413
      ath5k: No need to save/restore staid flags on reset
      ath5k: Tweak phy activate to rx start delay based on bwmode
      ath5k: Skip tx power setting on AR5210 for now
      ath5k: Use correct clock when setting ofdm timings
      ath5k: Cleanup turbo channel flags
      ath5k: Clean up turbo mode initvals/rfregs
      ath5k: Set turbo bit on rf bank 2
      ath5k: Always write tx powertable on hw
      ath5k: Always free tx buffers before reset
      ath5k: Disable ANI during reset
      ath5k: Fix reporting of RX dma stop failure
      ath5k: Include tx ack reporting on hw flags

Nicolas Kaiser (1):
      wireless/wl1271: remove redundant if-statement v2

Nishant Sarmukadam (2):
      mwl8k: force AP mode to use non-AMPDU frames
      mwl8k: rf_tx_power cmd not supported by AP firmware APIv1

Octavian Purdila (1):
      net: factorize sync-rcu call in unregister_netdevice_many

Oliver Hartkopp (1):
      can: add slcan driver for serial/USB-serial CAN adapters

Pablo Neira Ayuso (1):
      netfilter: fix export secctx error handling

Paul Gortmaker (4):
      tipc: recode getsockopt error handling for better readability
      tipc: update log.h re-include protection to reflect new name
      net/Space: delete orphaned externs from deleted drivers
      netdev: Update status of 8390 based drivers in MAINTAINERS

Paul Mundt (1):
      net: sh_eth: Move off of deprecated I/O routines.

Philippe De Muyter (2):
      net: Kconfig whitespace cleanup
      net: more Kconfig whitespace cleanup

RA-Jay Hung (5):
      rt2x00: Fix rt2800 USB TX Path DMA issue
      rt2x00: Fix header_length in rt2x00lib_txdone
      rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data two-byte alignment
      rt2x00: Add rt2800 EEPROM definition
      rt2x00: Add RF chip definition

Rafael J. Wysocki (3):
      ath9k: Convert to new PCI PM framework
      tg3: Do not use legacy PCI power management
      sky2: Do not use legacy PCI power management

Rafa≈Ç Mi≈Çecki (47):
      b43: N-PHY: define channel table struct for rev3+ devices
      b43: N-PHY: define registers names for 2056 radio
      b43: N-PHY: define registers names for 2056 radio
      b43: N-PHY: fix 2055 radio init
      b43: define known SPROM boardflags2 bits
      b43: N-PHY: determine usage of radio regulatory workaround correctly
      b43: N-PHY: improve 2055 radio initialization
      b43legacy: rfkill: use status register based on core revision (not PHY's)
      ssb: workarounds: be verbose about hacking SPROM revision, don't duplicate code
      ssb: return -ENOMEM on alloc fail (instead of CRC check's result)
      ssb: drop BCM4328 hack for SPROM revision
      b43: N-PHY: add 2056 radio channels tables
      b43: rfkill: use HI enabled bit for all devices
      b43: N-PHY: fix values for PHY regs in channel tables of 2055 radio
      b43: N-PHY: minor fixes to match specs
      b43: N-PHY: fix some typos, conditions, set gain_boost
      b43: N-PHY: init BPHY when needed
      b43: N-PHY: fix BPHY init
      b43: N-PHY: rev2: save and restore PHY regs on RSSI poll
      b43: N-PHY: little cleanups
      ssb: extract indexes for power tables
      b43: N-PHY: swap values for radio registers 0x3b and 0x3c
      b43: N-PHY: implement very basic TX power control management
      b43: N-PHY: initialize perical variable, add missing call to CCA reset
      b43: N-PHY: fix RSSI calibration
      b43: N-PHY: fix RSSI selection
      b43: N-PHY: use defines for RSSI types
      b43: N-PHY: fix code path on PHY init
      b43: N-PHY: update init tables
      b43: N-PHY: reorder and optimize tables initialization
      b43: N-PHY: implement own maskset
      b43: flush PHY writes when needed
      b43: N-PHY: silence warnings
      b43: set TMS to work with current band width for N-PHY
      b43: fix split of N-PHY devices into supported and not (based on PHY rev)
      b43: rename config option for N-PHY, drop BROKEN
      b43: N-PHY: use correct bit for controlling MAC and PHY
      b43: N-PHY: one more fix for order of tables initialization
      b43: N-PHY: use designed function and macro for writing tables
      b43: rename TMS defines, drop useless condition from core reset
      b43: use correct firmware for newer cores
      b43: N-PHY: implement radio 2056 init steps
      b43: N-PHY: add init tables for 2056 radio
      b43: N-PHY: avoid PHY hangs for rev 3 and 4
      b43: N-PHY: use correct channel tables for rev4+
      b43: N-PHY: update 2056 radio on channel switch on rev3+
      b43: N-PHY: enable support for PHYs rev 3 and higher

Rajesh Borundia (5):
      qlcnic: Fix for kdump
      qlcnic: avoid using reset_devices as it may become obsolete.
      netxen: avoid using reset_devices as it may become obsolete
      qlcnic: fix ocm window register offset calculation
      qlcnic: reset pci function unconditionally during probe

Rajkumar Manoharan (10):
      ath9k_htc: Handle monitor mode properly for HTC devices
      ath: Add a driver_info bitmask field
      ath9k_htc: Add driver_info in usb device list
      ath9k_hw: Fix eeprom offset for AR9287 devices (PCI/USB)
      ath9k_htc: Identify devices using driver_info
      Revert "ath9k_htc: Handle monitor mode properly for HTC devices"
      ath9k: Add change_interface callback
      ath: Missed to clear key4 of micentry
      ath9k: Fix warnings on card removal
      ath9k: fix beacon restart on channel change

Rasesh Mody (10):
      bna: TxRx and datapath fix
      bna: Port enable disable sync and txq priority fix
      bna: Fix ethtool register dump and reordered an API
      bna: Enable pure priority tagged packet reception and rxf uninit cleanup fix
      bna: Fix for TX queue
      bna: IOC uninit check and misc cleanup
      bna: Removed unused code
      bna: Restore VLAN filter table
      bna: IOC failure auto recovery fix
      bna: Update the driver version to 2.3.2.3

Richard Mortimer (1):
      cassini: Use local-mac-address prom property for Cassini MAC address

Roger Luethi (1):
      via-rhine: hardware VLAN support

Roger Quadros (2):
      wl1271: Add wl1271_load_firmware() and export some functions
      wl1271_sdio_test: Add module for sdio RX/TX testing

Ron Mercer (2):
      qlge: Add firmware info to ethtool get regs.
      qlge: Version change to v1.00.00.27

Roopa Prabhu (4):
      enic: Add ndo_set_rx_mode support for enic vnics
      enic: Add ndo_set_vf_mac support for enic dynamic devices
      enic: Use VF mac set by IFLA_VF_MAC in port profile provisioning data
      enic: Move enic port profile handling code to a new 802.1Qbh provisioning info type

Sachin Sant (1):
      qeth lcs: convert mc rwlock to RCU

Sathya Perla (4):
      be2net: adding support for Lancer family of CNAs
      be2net: Fix be_dev_family_check() return value check
      be2net: FW init cmd fix for lancer
      be2net: Handle out of buffer completions for lancer

Scott J. Goldman (1):
      vmxnet3: fix compilation when RSS is disabled

Sedat Dilek (5):
      ath5k: Fix modinfo does not list alias -> pci-id lines
      iwlwifi: Fix error: struct iwl_lq_sta has no member named dbg_fixed_rate
      ksz884x: Fix section mismatch derived from pcidev_init()
      smsc-ircc2: Fix section mismatch derived from smsc_ircc_pnp_probe()
      depca: Fix section mismatch derived from depca_isa_probe()

Senthil Balasubramanian (7):
      ath9k_hw: Fix a reset failure on AR9382 (2x2).
      ath9k_hw: Add new member into the eeprom structure.
      ath9k_hw: Initialize 2GHz CTL properly.
      ath9k_hw: Fix paprd training frame failure.
      ath9k_hw: add eeprom templates for ar9003 family chipsets
      ath9k_hw: Fix low throughput issue with AR93xx
      ath9k: spin_lock_bh is not required within tasklet context.

Shahar Levi (4):
      wl1271: 11n Support, Add Definitions
      wl1271: 11n Support, ACX Commands
      wl1271: 11n Support, functionality and configuration ability
      wl1271: Change wl12xx Files Names

Shan Wei (10):
      sctp: kill unused macro definition
      ipv6: kill two unused macro definition
      sctp: kill unused macros in head file
      net: snmp: fix the wrong ICMP_MIB_MAX value
      tcp: use TCP_BASE_MSS to set basic mss value
      ipv6: use ND_REACHABLE_TIME and ND_RETRANS_TIMER instead of magic number
      net: kill unused macros from head file
      dccp: remove unused macros
      wireless:mac80211: kill unuse macro MESH_CFG_CMP_LEN in mesh.h
      net: kill unused macros

Shanyu Zhao (6):
      iwlwifi: seperate disconnected antenna function
      iwlwifi: disable disconnected antenna for advanced bt coex
      iwlagn: update QoS before commit associated RXON
      iwlagn: check change before commit RXON cmd
      iwlwifi: clear dbg_fixed_rate during init
      iwlagn: check ready in iwlagn_bss_info_changed()

Shmulik Ravid (5):
      dcbnl: adding DCBX engine capability
      dcbnl: adding DCBX feature flags get-set
      bnx2x: adding dcbnl support
      dcbnl: cleanup
      dcbnl: more informed return values for new dcbnl routines

Shreyas Bhatewara (1):
      net-next: Add multiqueue support to vmxnet3 driver

Sony Chacko (1):
      qlcnic: lro off message log from set rx checsum

Sridhar Samudrala (1):
      macvlan: Introduce 'passthru' mode to takeover the underlying device

Sritej Velaga (2):
      qlcnic: Add description for CN1000Q adapter
      qlcnic: LICENSE file for qlcnic

Stanislaw Gruszka (15):
      iwlwifi: warn when send tx power settings during scan
      iwlwifi: send tx_power_cmd synchronously
      iwlwifi: fix set_tx_power vs scan
      iwlwifi: avoid commit rxon during scan in iwlagn_configure_filter
      iwlwifi: avoid commit rxon during scan in iwlagn_bt_traffic_change_work
      iwlwifi: defer update power mode while scan
      iwlwifi: avoid commit rxon during scan in iwl_set_no_assoc
      iwl3945: remove unused len_org variable
      iwlagn: simplify iwlagn_tx_skb
      iwlwifi: kill elapsed_jiffies
      iwlagn: fix microcode error on 4965
      iwl3945: prevent too frequent firmware resets
      iwlwifi: jiffies based tx queues watchdog
      iwlagn: enable only rfkill interrupt when device is down
      iwlagn: fix scan tx antenna setting on 5Ghz band

Stephen Hemminger (1):
      rfkill: remove dead code

Steve Hodgson (2):
      sfc: Fix event based MCDI completion and MC REBOOT/CMDDONE ordering issue
      sfc: When waking a stopped tx_queue, only lock that tx_queue

Sucheta Chakraborty (4):
      qlcnic: Allow minimum bandwidth of zero
      qlcnic: Disable loopback support
      qlcnic: fix LED test when interface is down.
      netxen: enable LRO based on NETIF_F_LRO

Sujith Manoharan (15):
      ath9k_htc: Remove unused structures
      ath9k_htc: Cleanup device identification
      ath9k_htc: Add support for handling TX power configuration
      ath9k_htc: Fix panic on FW download failure
      ath9k: Use power save wrappers for TSF get/set
      ath9k_htc: Add Ubiquiti wifistation ext to supported devices
      mac80211: Add timeout to BA session start API
      ath9k_htc: Remove PCI specific configuration
      ath9k_htc: Fix warning on device removal
      ath9k_htc: Handle pending URBs properly
      ath9k_htc: Move work cancellation outside of mutex
      ath9k_htc: Handle FATAL events
      ath9k_htc: Fix fast channel change
      ath9k_htc: Move LED/RFKILL code to htc_drv_gpio.c
      ath9k_htc: Fix packet injection

Sven Eckelmann (2):
      net: Add batman-adv meshing protocol
      batman-adv: Return hna count on local buffer fill

Sven Neumann (1):
      cfg80211: update information elements in cached BSS struct

Szymon Janc (5):
      forcedeth: fix multiple code style issues
      forcedeth: remove unnecessary checks before kfree
      forcedeth: include <linux/io.h> and <linux/uaccess.h> instead of <asm/io.h> and <asm/uaccess.h> as suggested by checkpatch
      forcedeth: do not use assignment in if conditions
      forcedeth: use usleep_range not msleep for small sleeps

Taku Izumi (3):
      bonding: add the debugfs facility to the bonding driver
      bonding: migrate some macros from bond_alb.c to bond_alb.h
      bonding: add the debugfs interface to see RLB hash table

Teemu Paasikivi (1):
      wl1271: Fix warning about unsupported RX rate

Tejun Heo (11):
      drivers/net: remove unnecessary flush_scheduled_work() calls
      drivers/net: don't use flush_scheduled_work()
      ehea: kill unused ehea_rereg_mr_task
      ehea: don't use flush_scheduled_work()
      iseries_veth: don't use flush_scheduled_work()
      igb[v],ixgbe: don't use flush_scheduled_work()
      sungem: update gp->reset_task flushing
      i2400m: drop i2400m_schedule_work()
      hostap: don't use flush_scheduled_work()
      vxge: add missing flush of reset_task
      bnx2: remove cancel_work_sync() from remove_one

Tetsuo Handa (1):
      filter: Optimize instruction revalidation code.

Thadeu Lima de Souza Cascardo (1):
      rtl8187b: do not do per packet TX AGC

Thiago Farina (1):
      net/9p/protocol.c: Remove duplicated macros.

Thomas Graf (5):
      rtnetlink: Link address family API
      inet: Define IPV4_DEVCONF_MAX
      ipv4: AF_INET link address family
      ipv6: AF_INET6 link address family
      rtnl: make link af-specific updates atomic

Tim Harvey (1):
      mac80211 default tx_last_beacon false (congestion)

Timo Ter√§s (2):
      xfrm: use gre key as flow upper protocol info
      xfrm: fix gre key endianess

Tobias Klauser (6):
      net: am79c961a: Omit private ndo_get_stats function
      net: emaclite: Omit private ndo_get_stats function
      net: cris/eth_v10: Use net_device_stats from struct net_device_stats
      bridge: Fix return values of br_multicast_add_group/br_multicast_new_group
      stmmac: Remove redundant unlikely()
      inet6: Remove redundant unlikely()

Tom Herbert (5):
      net: Move TX queue allocation to alloc_netdev_mq
      net: Simplify RX queue allocation
      xps: Improvements in TX queue selection
      xps: Transmit Packet Steering
      xps: Add CONFIG_XPS

Tomas Winkler (1):
      net/bridge: fix trivial sparse errors

Tomasz Grobelny (2):
      dccp: Policy-based packet dequeueing infrastructure
      dccp qpolicy: Parameter checking of cmsg qpolicy parameters

Tomoya (27):
      can: EG20T PCH: add prefix to macro
      can: EG20T PCH: use BIT(X)
      can: EG20T PCH: Separate Interface Register(IF1/IF2)
      can: EG20T PCH: Change Message Object Index
      can: EG20T PCH: Enumerate LEC macros
      can: EG20T PCH: Delete unnecessary spin_lock
      pch_can: Add flow control processing
      pch_can: Divide poll function
      pch_can: Fix endianness issue
      pch_can: Improve rx processing
      pch_can: Fix warnings
      pch_can: Rename function/macro name
      pch_can: Change functions type
      pch_can: Reduce register access
      pch_can: Change Copyright and module description
      pch_can: Replace netdev_dbg instead of dev_dbg partly
      pch_can: Fix coding rule violation
      pch_can: Delete unnecessary/redundant code
      pch_can: Fix bit timing calculation issue
      pch_can: Fix miss-setting status issue
      pch_can: Comment optimization
      pch_can: Move MSI processing to probe/remove processing
      pch_can: Fix incorrect return processing
      pch_can: Optimize "if" condition in rx/tx processing
      pch_can: Add setting TEC/REC statistics processing
      pch_can: Replace netif_rx to netif_receive_skb
      pch_can: Fix array miss-pointing issue

Tracey Dent (18):
      Net: bluetooth: Makefile: Remove deprecated kbuild goal definitions
      Net: caif: Makefile: Remove deprecated items
      Net: can: Makefile: Remove deprecated kbuild goal definitions
      Net: ceph: Makefile: remove deprecated kbuild goal definitions
      Net: dns_resolver: Makefile: Remove deprecated kbuild goal definitions
      Net: econet: Makefile: Remove deprecated kbuild goal definitions
      Net: ipv4: netfilter: Makefile: Remove deprecated kbuild goal definitions
      Net: ipv6: netfiliter: Makefile: Remove deprecated kbuild goal definitions
      Net: irda: ircomm: Makefile: Remove deprecated kbuild goal defintions
      Net: irda: irlan: Makefile: Remove deprecated kbuild goal definitions
      Net: irda: irnet: Makefile: Remove deprecated kbuild goal definitions
      Net: lapb: Makefile: Remove deprecated kbuild goal definitions
      Net: phonet: Makefile: Remove deprecated kbuild goal definitions
      Net: rds: Makefile: Remove deprecated items
      Net: rxrpc: Makefile: Remove deprecated kbuild goal definitions
      Net: sunrpc: auth_gss: Makefile: Remove deprecated kbuild goal definitions
      Net: wanrouter: Makefile: Remove deprecated kbuild goal definitions
      Net: bluetooth: Makefile: Remove deprecated kbuild goal definitions

Ursula Braun (1):
      qeth: enable interface setup if LAN is offline

Uwe Kleine-K√∂nig (1):
      net: add some KERN_CONT markers to continuation lines

Vasanthakumar Thiagarajan (41):
      ath9k_hw: Fix XPABIAS level configuration for AR9003
      ath9k_hw: Enable strong signal detection for AR9003
      ath9k_hw: Improve power control accuracy for AR9003
      ath9k_hw: Add helper function for interpolation
      ath9k: Fix bug in delimiter padding computation
      ath9k: Reintroduce modparam to enable btcoex
      ath9k: Remove code which enables btcoex based on subsys id
      ath9k_hw: Define hw version macros for AR9485
      ath9k_hw: Add initvals.h for AR9485
      ath9k_hw: Enable hw initialization for AR9485
      ath9k_hw: Initialize mode registers for AR9485
      ath9k_hw: Initialize tx/rx gain table from initvals.h for AR9485
      ath9k_hw: Eeeprom changes for AR9485
      ath9k_hw: Disable LDPC for AR9485
      ath9k: Disable TX STBC for AR9485
      ath9k: Enable extended synch for AR9485 to fix L0s recovery issue
      ath9k_hw: Find the maximum number of chains that hw supports
      ath9k: Configure pll control for AR9485
      ath9k_hw: Find chansel of AR_PHY_65NM_CH0_SYNTH7 for AR9485
      ath9k_hw: Add a helper function to get spur channel pointer from cal data for AR9003 family
      ath9k: Read spur channel information from eeprom for AR9485
      ath9k_hw: Configure xpa bias level for AR9485
      ath9k_hw: Read and configure antenna diversity control for AR9485
      ath9k_hw: Configure internal regulator for AR9485
      ath9k_hw: Read and configure turnning caps to regulate freq accuracy
      ath9k_hw: Configure power control only for the supported chains
      ath9k_hw: Program appropriate chianmask for AR9485 before starting AGC/IQ cal
      ath9k_hw: Define IQcal correction coefficient registers using index
      ath9k_hw: Add IQ cal changes for AR9485
      ath9k_hw: Program appropriate register for temperature compensation cal for AR9485
      ath9k_hw: Setup paprd only for supported chains
      ath9k_hw: Disable MRC CCK for AR9485
      ath9k: Add device id of AR9485 to pci table
      ath9k_hw: Remove delay during regwrite of analog shift registers
      ath9k_hw: Remove unnecessary Rx IQ cal register configuration in ar9003_hw_tx_iq_cal()
      ath9k_hw: Move get_streams() to hw.h
      ath9k_hw: Tx IQ cal changes for AR9003
      ath9k_hw: Add a helper to get paprd scale factor
      ath9k_hw: Disable PAPRD for rates with low Tx power
      ath9k_hw: Configure appropriate Tx power when PAPRD fails
      ath9k_hw: Fix bug in eeprom data length validation for AR9485

Vasanthy Kolluri (1):
      enic: Fix build warnings

Vasiliy Kulikov (4):
      net: ipv4: tcp_probe: cleanup snprintf() use
      Bluetooth: bnep: fix information leak to userland
      Bluetooth: cmtp: fix information leak to userland
      Bluetooth: hidp: fix information leak to userland

Vladislav Zolotarov (15):
      bnx2x: Do interrupt mode initialization and NAPIs adding before register_netdev()
      bnx2x: Use helpers instead of direct access to the shinfo(skb) fields
      bnx2x: LSO code was broken on BE platforms
      bnx2x: Use dma_alloc_coherent() semantics for ILT memory allocation
      bnx2x: Fixed a compilation warning
      bnx2x: Update version number and a date.
      bnx2x: Take the distribution range definition out of skb_tx_hash()
      bnx2x: add FCoE ring
      bnx2x: add a select queue callback
      bnx2x: add DCB support
      bnx2x: Add DCB/PFC support - link layer
      bnx2x: add FW 6.2.5 files
      bnx2x: replace FW to 6.2.5
      bnx2x: remove old FW files
      bnx2x: update version to 1.62.00-2

Wey-Yi Guy (46):
      iwlagn: turn dynamic smps on while BT is on
      iwlwifi: add new devices to Kconfig
      iwlagn: use 6000g2b uCode for 130 series devices
      iwlagn: update PCI ID for 6000g2b series devices
      iwlagn: update PCI ID for 6000g2a series devices
      iwlagn: update PCI ID for 100 series devices
      iwlwifi: Legacy isr only used by legacy devices
      iwlwifi: put all the isr related function under ops
      iwlwifi: legacy tx_cmd_protection function
      iwlwifi: resending QoS command when HT changes
      iwlagn: enable shadow register
      iwlagn: used frame count info in compressed ba packet
      iwlagn: set dynamic aggregation threshold for BT
      iwlagn: support dynamic aggregation for BT coex
      iwlagn: change default ACK/CTS MASK setting for WiFi/BT coex
      iwlwifi: change default led mode for different devices
      iwlagn: use SKU information in the EEPROM
      iwlwifi: set STATUS_READY before commit_rxon
      iwlagn: name change for BT config flag
      iwlwifi: add more power management flags
      iwlwifi: consider BT for power management
      iwlwifi: power management checking for shadow register
      iwlwifi: advance power management support
      iwlwifi: remove unused define
      iwlwifi: use antenna information in EEPROM
      iwlagn: Offical name for 6050g2 device
      iwlagn: Offical name for 6000g2a device
      iwlagn: Offical name for 6000g2b device
      iwlagn: Offical name for 100/130 device
      iwlagn: use different kill mask when SCO active
      iwlagn: minor change in bt coex normal LUT
      iwlagn: fix race condition when reprogram sta
      iwlagn: remove structure name reference to gen2
      iwlwifi: check for STATUS_EXIT_PENDING when send RXON command
      iwlagn: name change for bt_ch_announce module parameter
      iwlagn: change led compensation for 6005 and 6030 devices
      iwlagn: rx antenna diversity
      iwlwifi: add new EEPROM debug log type
      iwlwifi: use IWL_DEBUG_EEPROM for EEPROM related info
      iwlagn: More detail tx power logging
      iwlwifi: do not reload fw if WiMAX own the RF
      iwlwifi: keep track of bt coex enable/disable stage
      iwlagn: code clean up to remove duplicate code
      iwlagn: fix witespace damage
      iwlwifi: remove extra string
      iwlwifi: remove reference to Gen2

Williams, Mitch A (1):
      igbvf: add support for i350 VF device

Winkler, Tomas (1):
      iwlwlifi: update rx write pointer w/o request mac access in the CAM mode

Wolfgang Kufner (2):
      rt2x00: Pad beacon to multiple of 32 bits.
      rt2x00: Fix firmware loading regression on x86_64.

Yi Zou (3):
      ixgbe: avoid doing FCoE DDP when adapter is DOWN or RESETTING
      ixgbe: invalidate FCoE DDP context when no error status is available
      ixgbe: make sure FCoE DDP user buffers are really released by the HW

amit salecha (1):
      netxen: update driver version 4.0.75

andrew hendry (9):
      X25: pushdown bkl in ioctls
      X25: remove bkl in timestamp ioctls
      X25: remove bkl in inq and outq ioctls
      X25: remove bkl in routing ioctls
      X25 remove bkl in subscription ioctls
      X25 remove bkl in facility ioctls
      X25 remove bkl from calluserdata ioctls
      X25 remove bkl from causediag ioctls
      X25 remove bkl in call user data length ioctl

fran√ßois romieu (8):
      r8169: remove the firmware of RTL8111D.
      r8169: identify different registers.
      r8169: use device dependent methods to access the MII registers.
      r8169: 8168DP specific MII registers access methods.
      r8169: phy power ops
      r8169: magic.
      r8169: rtl_csi_access_enable rename.
      r8169: more 8168dp support.

maximilian attems (2):
      zd1211rw: add 2 missing usb id's
      zd1201: Add missing id

roel kluin (1):
      libertas: down_interruptible() can return -EINTR, not EINTR

stephen hemminger (10):
      netdev: add rcu annotations to receive handler hook
      bridge: fix RCU races with bridge port
      gre: minor cleanups
      gre: add module alias for gre0 tunnel device
      ipip: add module alias for tunl0 tunnel device
      sfc: convert references to LRO to GRO
      ipv6: fib6_ifdown cleanup
      ipv6: remove duplicate neigh_ifdown
      skge: Do not use legacy PCI power management
      sky2: implement 64 bit stats

 .../ABI/testing/sysfs-class-net-batman-adv         |   14 +
 Documentation/ABI/testing/sysfs-class-net-mesh     |   69 +
 Documentation/DocBook/80211.tmpl                   |   70 +-
 Documentation/networking/LICENSE.qlcnic            |  327 +
 Documentation/networking/batman-adv.txt            |  240 +
 Documentation/networking/dccp.txt                  |   20 +
 Documentation/networking/e100.txt                  |   19 +-
 Documentation/networking/e1000.txt                 |   16 +-
 Documentation/networking/e1000e.txt                |   52 +-
 Documentation/networking/igb.txt                   |   35 +-
 Documentation/networking/igbvf.txt                 |    6 +-
 Documentation/networking/ip-sysctl.txt             |   28 +-
 Documentation/networking/ixgb.txt                  |   10 +-
 Documentation/networking/ixgbe.txt                 |  213 +-
 Documentation/networking/ixgbevf.txt               |    4 -
 Documentation/networking/stmmac.txt                |   48 +-
 MAINTAINERS                                        |   34 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   32 +-
 arch/s390/include/asm/qeth.h                       |   51 +-
 drivers/atm/fore200e.c                             |    2 +-
 drivers/atm/lanai.c                                |    7 +-
 drivers/block/aoe/aoecmd.c                         |    6 +-
 drivers/infiniband/core/addr.c                     |   14 +-
 drivers/infiniband/hw/mlx4/main.c                  |    6 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |    4 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    2 +-
 drivers/isdn/hisax/avm_pci.c                       |    2 +-
 drivers/isdn/hisax/callc.c                         |    4 +-
 drivers/isdn/hisax/config.c                        |    2 +-
 drivers/isdn/hisax/hfc_2bds0.c                     |    4 +-
 drivers/isdn/hisax/hfc_2bs0.c                      |    2 +-
 drivers/isdn/hisax/hfc_pci.c                       |    4 +-
 drivers/isdn/hisax/hfc_sx.c                        |    6 +-
 drivers/isdn/hisax/hisax.h                         |    2 +
 drivers/isdn/hisax/ipacx.c                         |    2 +-
 drivers/isdn/hisax/isar.c                          |   15 +-
 drivers/isdn/hisax/isdnl1.h                        |    1 +
 drivers/isdn/hisax/isdnl3.c                        |    2 +-
 drivers/isdn/hisax/netjet.c                        |   10 +-
 drivers/isdn/hisax/st5481_d.c                      |    6 +-
 drivers/isdn/i4l/isdn_concap.c                     |    2 +-
 drivers/isdn/i4l/isdn_net.c                        |   20 +-
 drivers/isdn/i4l/isdn_ppp.c                        |   26 +-
 drivers/isdn/mISDN/layer1.c                        |   10 +-
 drivers/isdn/mISDN/layer2.c                        |   12 +-
 drivers/isdn/mISDN/tei.c                           |   23 +-
 drivers/net/3c501.c                                |    4 +-
 drivers/net/3c503.c                                |    4 +-
 drivers/net/3c507.c                                |    6 +-
 drivers/net/3c515.c                                |    2 +-
 drivers/net/3c527.c                                |    6 +-
 drivers/net/8139too.c                              |    3 +-
 drivers/net/82596.c                                |    2 +-
 drivers/net/Kconfig                                |  256 +-
 drivers/net/Space.c                                |    5 -
 drivers/net/arm/am79c961a.c                        |    9 -
 drivers/net/arm/ixp4xx_eth.c                       |    4 +-
 drivers/net/arm/w90p910_ether.c                    |    2 +-
 drivers/net/at1700.c                               |    8 +-
 drivers/net/atarilance.c                           |    2 +-
 drivers/net/atl1c/atl1c_main.c                     |    2 +-
 drivers/net/atl1e/atl1e_main.c                     |    2 +-
 drivers/net/atlx/atl1.c                            |    2 +-
 drivers/net/atlx/atl2.c                            |    4 +-
 drivers/net/au1000_eth.c                           |    2 -
 drivers/net/ax88796.c                              |    8 +-
 drivers/net/bcm63xx_enet.c                         |    2 +-
 drivers/net/benet/be.h                             |   39 +-
 drivers/net/benet/be_cmds.c                        |   69 +-
 drivers/net/benet/be_cmds.h                        |   42 +-
 drivers/net/benet/be_ethtool.c                     |    4 +-
 drivers/net/benet/be_hw.h                          |   39 +-
 drivers/net/benet/be_main.c                        |  252 +-
 drivers/net/bna/bfa_defs.h                         |   22 +-
 drivers/net/bna/bfa_defs_mfg_comm.h                |   22 -
 drivers/net/bna/bfa_ioc.c                          | 1237 ++-
 drivers/net/bna/bfa_ioc.h                          |   49 +-
 drivers/net/bna/bfa_ioc_ct.c                       |  102 +-
 drivers/net/bna/bfi_ctreg.h                        |   41 +-
 drivers/net/bna/bna.h                              |    6 +-
 drivers/net/bna/bna_ctrl.c                         |  377 +-
 drivers/net/bna/bna_txrx.c                         |   44 +-
 drivers/net/bna/bna_types.h                        |   11 +-
 drivers/net/bna/bnad.c                             |  427 +-
 drivers/net/bna/bnad.h                             |   31 +-
 drivers/net/bna/bnad_ethtool.c                     |    8 +-
 drivers/net/bnx2.c                                 |  121 +-
 drivers/net/bnx2.h                                 |    2 +
 drivers/net/bnx2x/Makefile                         |    2 +-
 drivers/net/bnx2x/bnx2x.h                          |  165 +-
 drivers/net/bnx2x/bnx2x_cmn.c                      |  155 +-
 drivers/net/bnx2x/bnx2x_cmn.h                      |   73 +-
 drivers/net/bnx2x/bnx2x_dcb.c                      | 2118 +++
 drivers/net/bnx2x/bnx2x_dcb.h                      |  196 +
 drivers/net/bnx2x/bnx2x_ethtool.c                  |  357 +-
 drivers/net/bnx2x/bnx2x_hsi.h                      |  327 +-
 drivers/net/bnx2x/bnx2x_link.c                     |  666 +-
 drivers/net/bnx2x/bnx2x_link.h                     |   56 +
 drivers/net/bnx2x/bnx2x_main.c                     |  700 +-
 drivers/net/bnx2x/bnx2x_reg.h                      |   52 +
 drivers/net/bnx2x/bnx2x_stats.c                    |   13 +-
 drivers/net/bnx2x/bnx2x_stats.h                    |    2 -
 drivers/net/bonding/Makefile                       |    2 +-
 drivers/net/bonding/bond_3ad.c                     |    3 +-
 drivers/net/bonding/bond_alb.c                     |   36 -
 drivers/net/bonding/bond_alb.h                     |   38 +
 drivers/net/bonding/bond_debugfs.c                 |  146 +
 drivers/net/bonding/bond_main.c                    |   28 +-
 drivers/net/bonding/bonding.h                      |   11 +-
 drivers/net/can/Kconfig                            |   21 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/janz-ican3.c                       |    9 -
 drivers/net/can/mscan/mscan.c                      |    2 +-
 drivers/net/can/pch_can.c                          | 1350 +-
 drivers/net/can/sja1000/plx_pci.c                  |    2 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      |    8 +-
 drivers/net/can/slcan.c                            |  756 +
 drivers/net/cassini.c                              |   22 +-
 drivers/net/cassini.h                              |    3 +
 drivers/net/chelsio/sge.c                          |   10 +-
 drivers/net/cnic.c                                 |  772 +-
 drivers/net/cnic.h                                 |   27 +-
 drivers/net/cnic_defs.h                            | 2103 +++-
 drivers/net/cnic_if.h                              |   26 +-
 drivers/net/cris/eth_v10.c                         |   34 +-
 drivers/net/cxgb3/ael1002.c                        |   24 +-
 drivers/net/cxgb3/cxgb3_main.c                     |    6 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |    6 +-
 drivers/net/cxgb3/t3_hw.c                          |    2 +-
 drivers/net/cxgb4/cxgb4.h                          |    4 +-
 drivers/net/cxgb4/cxgb4_main.c                     |  140 +-
 drivers/net/cxgb4/sge.c                            |   22 +-
 drivers/net/cxgb4/t4_hw.c                          |   93 +-
 drivers/net/cxgb4/t4fw_api.h                       |    1 +
 drivers/net/cxgb4vf/adapter.h                      |    2 +-
 drivers/net/cxgb4vf/cxgb4vf_main.c                 |   32 +-
 drivers/net/cxgb4vf/sge.c                          |    9 +-
 drivers/net/cxgb4vf/t4vf_hw.c                      |    7 +-
 drivers/net/depca.c                                |    2 +-
 drivers/net/dm9000.c                               |    2 +-
 drivers/net/e1000/e1000_hw.c                       |   20 +-
 drivers/net/e1000/e1000_main.c                     |   18 +-
 drivers/net/e1000/e1000_param.c                    |   13 +-
 drivers/net/e1000e/82571.c                         |  189 +-
 drivers/net/e1000e/defines.h                       |    9 +-
 drivers/net/e1000e/e1000.h                         |    4 +-
 drivers/net/e1000e/es2lan.c                        |    8 +-
 drivers/net/e1000e/ethtool.c                       |  147 +-
 drivers/net/e1000e/ich8lan.c                       |   23 +-
 drivers/net/e1000e/lib.c                           |  141 +-
 drivers/net/e1000e/netdev.c                        |  107 +-
 drivers/net/e1000e/param.c                         |    2 +-
 drivers/net/e1000e/phy.c                           |   50 +-
 drivers/net/e2100.c                                |    2 +-
 drivers/net/eepro.c                                |   11 +-
 drivers/net/eexpress.c                             |    2 +-
 drivers/net/ehea/ehea.h                            |   15 -
 drivers/net/ehea/ehea_ethtool.c                    |   18 +-
 drivers/net/ehea/ehea_main.c                       |  433 +-
 drivers/net/ehea/ehea_phyp.c                       |   40 +-
 drivers/net/ehea/ehea_qmr.c                        |   89 +-
 drivers/net/enic/enic.h                            |    6 +-
 drivers/net/enic/enic_main.c                       |  247 +-
 drivers/net/enic/enic_res.h                        |    1 +
 drivers/net/enic/vnic_vic.h                        |   31 +-
 drivers/net/ethoc.c                                |  160 +-
 drivers/net/fec_mpc52xx.c                          |   19 +-
 drivers/net/forcedeth.c                            | 1134 +-
 drivers/net/gianfar.c                              |   10 +-
 drivers/net/hp.c                                   |    6 +-
 drivers/net/ibm_newemac/core.c                     |    2 +-
 drivers/net/ibmveth.c                              |    7 +-
 drivers/net/ifb.c                                  |   46 +-
 drivers/net/igb/e1000_82575.c                      |   37 +-
 drivers/net/igb/e1000_82575.h                      |    5 +
 drivers/net/igb/e1000_defines.h                    |    7 +
 drivers/net/igb/e1000_hw.h                         |    6 +-
 drivers/net/igb/e1000_nvm.c                        |   93 +-
 drivers/net/igb/e1000_nvm.h                        |    2 +
 drivers/net/igb/e1000_phy.c                        |   11 +-
 drivers/net/igb/e1000_regs.h                       |    1 +
 drivers/net/igb/igb.h                              |    1 +
 drivers/net/igb/igb_main.c                         |  100 +-
 drivers/net/igbvf/Makefile                         |    2 +-
 drivers/net/igbvf/defines.h                        |    2 +-
 drivers/net/igbvf/ethtool.c                        |    9 +-
 drivers/net/igbvf/igbvf.h                          |    4 +-
 drivers/net/igbvf/mbx.c                            |    2 +-
 drivers/net/igbvf/mbx.h                            |    2 +-
 drivers/net/igbvf/netdev.c                         |   33 +-
 drivers/net/igbvf/regs.h                           |    2 +-
 drivers/net/igbvf/vf.c                             |    6 +-
 drivers/net/igbvf/vf.h                             |    4 +-
 drivers/net/irda/act200l-sir.c                     |    2 +-
 drivers/net/irda/donauboe.c                        |    4 +-
 drivers/net/irda/mcs7780.c                         |    2 +-
 drivers/net/irda/smsc-ircc2.c                      |    2 +-
 drivers/net/iseries_veth.c                         |   27 +-
 drivers/net/ixgb/ixgb_main.c                       |   61 +-
 drivers/net/ixgb/ixgb_param.c                      |   21 +-
 drivers/net/ixgbe/Makefile                         |    2 +-
 drivers/net/ixgbe/ixgbe.h                          |  122 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |   58 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |  138 +-
 drivers/net/ixgbe/ixgbe_common.c                   |  256 +-
 drivers/net/ixgbe/ixgbe_common.h                   |   10 +-
 drivers/net/ixgbe/ixgbe_dcb.c                      |   17 +-
 drivers/net/ixgbe/ixgbe_dcb.h                      |    3 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |   12 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |   12 +-
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |   55 +-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  297 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |   15 +-
 drivers/net/ixgbe/ixgbe_main.c                     | 2085 ++--
 drivers/net/ixgbe/ixgbe_mbx.c                      |   42 +-
 drivers/net/ixgbe/ixgbe_mbx.h                      |    2 +-
 drivers/net/ixgbe/ixgbe_phy.c                      |   52 +
 drivers/net/ixgbe/ixgbe_phy.h                      |    5 +
 drivers/net/ixgbe/ixgbe_sriov.c                    |   57 +-
 drivers/net/ixgbe/ixgbe_type.h                     |   45 +-
 drivers/net/ixgbe/ixgbe_x540.c                     |  724 +
 drivers/net/ixgbevf/Makefile                       |    2 +-
 drivers/net/ixgbevf/defines.h                      |    3 +-
 drivers/net/ixgbevf/ethtool.c                      |   18 +-
 drivers/net/ixgbevf/ixgbevf.h                      |    6 +-
 drivers/net/ixgbevf/ixgbevf_main.c                 |   27 +-
 drivers/net/ixgbevf/mbx.c                          |    2 +-
 drivers/net/ixgbevf/mbx.h                          |    2 +-
 drivers/net/ixgbevf/regs.h                         |    2 +-
 drivers/net/ixgbevf/vf.c                           |    8 +-
 drivers/net/ixgbevf/vf.h                           |    3 +-
 drivers/net/jme.c                                  |   20 +-
 drivers/net/ks8851.c                               |   33 +
 drivers/net/ksz884x.c                              |   22 +-
 drivers/net/lance.c                                |    2 +-
 drivers/net/lib82596.c                             |    2 +-
 drivers/net/lib8390.c                              |   24 +-
 drivers/net/ll_temac_main.c                        |    4 +-
 drivers/net/macvlan.c                              |  113 +-
 drivers/net/macvtap.c                              |    3 +-
 drivers/net/mv643xx_eth.c                          |    9 +-
 drivers/net/myri10ge/myri10ge.c                    |    4 +-
 drivers/net/ne-h8300.c                             |   12 +-
 drivers/net/netconsole.c                           |    8 +-
 drivers/net/netxen/netxen_nic.h                    |    5 +-
 drivers/net/netxen/netxen_nic_ethtool.c            |   26 +-
 drivers/net/netxen/netxen_nic_hw.c                 |   21 +-
 drivers/net/netxen/netxen_nic_init.c               |    7 +-
 drivers/net/netxen/netxen_nic_main.c               |   12 +-
 drivers/net/ni52.c                                 |    4 +-
 drivers/net/ni65.c                                 |    4 +-
 drivers/net/niu.c                                  |    4 +-
 drivers/net/pch_gbe/pch_gbe_ethtool.c              |   19 +-
 drivers/net/pch_gbe/pch_gbe_main.c                 |   12 +-
 drivers/net/pcmcia/axnet_cs.c                      |   18 +-
 drivers/net/pcmcia/nmclan_cs.c                     |    2 +-
 drivers/net/phy/phy.c                              |    4 +-
 drivers/net/ppp_generic.c                          |   12 +-
 drivers/net/pptp.c                                 |    5 +-
 drivers/net/pxa168_eth.c                           |    9 +-
 drivers/net/qla3xxx.c                              |    8 +-
 drivers/net/qlcnic/qlcnic.h                        |   43 +-
 drivers/net/qlcnic/qlcnic_ctx.c                    |   28 +-
 drivers/net/qlcnic/qlcnic_ethtool.c                |  157 +-
 drivers/net/qlcnic/qlcnic_hdr.h                    |   27 +-
 drivers/net/qlcnic/qlcnic_hw.c                     |   91 +-
 drivers/net/qlcnic/qlcnic_init.c                   |  123 +-
 drivers/net/qlcnic/qlcnic_main.c                   |   89 +-
 drivers/net/qlge/qlge.h                            |    4 +-
 drivers/net/qlge/qlge_dbg.c                        |   21 +-
 drivers/net/qlge/qlge_ethtool.c                    |   19 +-
 drivers/net/qlge/qlge_main.c                       |   21 +-
 drivers/net/qlge/qlge_mpi.c                        |    2 +-
 drivers/net/r6040.c                                |    2 +
 drivers/net/r8169.c                                | 1636 +--
 drivers/net/s2io.c                                 |   79 +-
 drivers/net/s2io.h                                 |    9 +-
 drivers/net/sc92031.c                              |    3 +-
 drivers/net/sfc/efx.c                              |   38 +-
 drivers/net/sfc/efx.h                              |    7 +-
 drivers/net/sfc/ethtool.c                          |  168 +-
 drivers/net/sfc/falcon.c                           |  183 +-
 drivers/net/sfc/falcon_boards.c                    |  120 +-
 drivers/net/sfc/falcon_xmac.c                      |   14 +-
 drivers/net/sfc/filter.c                           |  255 +-
 drivers/net/sfc/filter.h                           |  149 +-
 drivers/net/sfc/io.h                               |  153 +-
 drivers/net/sfc/mcdi.c                             |    3 +-
 drivers/net/sfc/mcdi_phy.c                         |    1 -
 drivers/net/sfc/mdio_10g.c                         |    1 -
 drivers/net/sfc/mtd.c                              |   98 +-
 drivers/net/sfc/net_driver.h                       |   87 +-
 drivers/net/sfc/nic.c                              |   90 +-
 drivers/net/sfc/nic.h                              |   12 +-
 drivers/net/sfc/qt202x_phy.c                       |    6 +
 drivers/net/sfc/rx.c                               |   30 +-
 drivers/net/sfc/siena.c                            |   10 +-
 drivers/net/sfc/spi.h                              |    5 +
 drivers/net/sfc/tenxpress.c                        |    2 -
 drivers/net/sfc/tx.c                               |  122 +-
 drivers/net/sh_eth.c                               |  245 +-
 drivers/net/sh_eth.h                               |    1 -
 drivers/net/sis190.c                               |    3 +-
 drivers/net/skfp/smt.c                             |    4 +-
 drivers/net/skge.c                                 |   54 +-
 drivers/net/sky2.c                                 |  157 +-
 drivers/net/sky2.h                                 |   42 +
 drivers/net/smc-ultra.c                            |    8 +-
 drivers/net/stmmac/stmmac.h                        |   40 +-
 drivers/net/stmmac/stmmac_ethtool.c                |   16 +-
 drivers/net/stmmac/stmmac_main.c                   |  267 +-
 drivers/net/stmmac/stmmac_mdio.c                   |    8 +-
 drivers/net/sundance.c                             |   23 +-
 drivers/net/sungem.c                               |   14 +-
 drivers/net/sunhme.c                               |    2 +-
 drivers/net/sunlance.c                             |   10 +-
 drivers/net/tg3.c                                  |  422 +-
 drivers/net/tg3.h                                  |   42 +-
 drivers/net/tokenring/ibmtr.c                      |    5 +-
 drivers/net/tulip/de2104x.c                        |   18 +-
 drivers/net/tulip/tulip_core.c                     |   15 +-
 drivers/net/tun.c                                  |    2 +-
 drivers/net/usb/Kconfig                            |   19 +
 drivers/net/usb/Makefile                           |    1 +
 drivers/net/usb/cdc_ether.c                        |    4 +-
 drivers/net/usb/cdc_ncm.c                          | 1213 ++
 drivers/net/usb/hso.c                              |   40 +-
 drivers/net/usb/ipheth.c                           |    2 +-
 drivers/net/usb/pegasus.c                          |    4 +-
 drivers/net/usb/sierra_net.c                       |    5 +-
 drivers/net/usb/smsc95xx.c                         |    7 +-
 drivers/net/usb/usbnet.c                           |   48 +-
 drivers/net/via-rhine.c                            |  326 +-
 drivers/net/virtio_net.c                           |    2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  965 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |  174 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |   73 +-
 drivers/net/vxge/vxge-config.c                     | 4360 +++---
 drivers/net/vxge/vxge-config.h                     |  169 +-
 drivers/net/vxge/vxge-ethtool.c                    |  112 +-
 drivers/net/vxge/vxge-main.c                       | 1172 +-
 drivers/net/vxge/vxge-main.h                       |   86 +-
 drivers/net/vxge/vxge-reg.h                        |   33 +-
 drivers/net/vxge/vxge-traffic.c                    | 1453 +-
 drivers/net/vxge/vxge-traffic.h                    |   49 +-
 drivers/net/vxge/vxge-version.h                    |   33 +-
 drivers/net/wan/dscc4.c                            |    6 +-
 drivers/net/wd.c                                   |    2 +-
 drivers/net/wimax/i2400m/driver.c                  |   96 +-
 drivers/net/wimax/i2400m/i2400m.h                  |   19 +-
 drivers/net/wimax/i2400m/sdio.c                    |    1 -
 drivers/net/wimax/i2400m/usb.c                     |    1 -
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/airo.c                        |   20 +-
 drivers/net/wireless/ath/ar9170/cmd.c              |    2 +-
 drivers/net/wireless/ath/ar9170/usb.c              |    6 +-
 drivers/net/wireless/ath/ath.h                     |  111 +
 drivers/net/wireless/ath/ath5k/Kconfig             |   18 +-
 drivers/net/wireless/ath/ath5k/Makefile            |    3 +
 drivers/net/wireless/ath/ath5k/ahb.c               |  219 +
 drivers/net/wireless/ath/ath5k/ani.c               |   40 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |  292 +-
 drivers/net/wireless/ath/ath5k/attach.c            |   28 +-
 drivers/net/wireless/ath/ath5k/base.c              | 1569 +--
 drivers/net/wireless/ath/ath5k/base.h              |    7 +-
 drivers/net/wireless/ath/ath5k/caps.c              |    6 -
 drivers/net/wireless/ath/ath5k/debug.c             |   34 +-
 drivers/net/wireless/ath/ath5k/debug.h             |    2 +
 drivers/net/wireless/ath/ath5k/desc.c              |   24 +-
 drivers/net/wireless/ath/ath5k/desc.h              |   18 +-
 drivers/net/wireless/ath/ath5k/dma.c               |  180 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |  139 +-
 drivers/net/wireless/ath/ath5k/eeprom.h            |    4 +-
 drivers/net/wireless/ath/ath5k/initvals.c          |  409 +-
 drivers/net/wireless/ath/ath5k/led.c               |   11 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |  774 +
 drivers/net/wireless/ath/ath5k/pci.c               |  327 +
 drivers/net/wireless/ath/ath5k/pcu.c               |  571 +-
 drivers/net/wireless/ath/ath5k/phy.c               |  754 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |  696 +-
 drivers/net/wireless/ath/ath5k/reg.h               |   31 +-
 drivers/net/wireless/ath/ath5k/reset.c             | 1221 +-
 drivers/net/wireless/ath/ath5k/rfbuffer.h          | 1169 +-
 drivers/net/wireless/ath/ath5k/sysfs.c             |    4 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |    7 +-
 drivers/net/wireless/ath/ath9k/ani.c               |  107 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |  305 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |  220 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   27 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |  144 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   25 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  104 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  605 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     | 3252 ++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   73 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  289 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |  123 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |  166 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  344 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   78 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   |  943 ++
 drivers/net/wireless/ath/ath9k/ath9k.h             |   68 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |  132 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |   23 -
 drivers/net/wireless/ath/ath9k/btcoex.h            |    1 -
 drivers/net/wireless/ath/ath9k/calib.c             |   59 +-
 drivers/net/wireless/ath/ath9k/common.c            |   19 +-
 drivers/net/wireless/ath/ath9k/common.h            |   15 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   83 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   21 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |  219 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |   63 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |  302 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |  295 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |  353 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |   30 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  229 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |    3 +
 drivers/net/wireless/ath/ath9k/htc.h               |   35 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   24 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |  342 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  114 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  652 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   44 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    5 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h           |   22 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |    5 -
 drivers/net/wireless/ath/ath9k/hw.c                |  298 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   81 +-
 drivers/net/wireless/ath/ath9k/init.c              |  169 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  210 +-
 drivers/net/wireless/ath/ath9k/mac.h               |   14 +-
 drivers/net/wireless/ath/ath9k/main.c              |  597 +-
 drivers/net/wireless/ath/ath9k/pci.c               |  110 +-
 drivers/net/wireless/ath/ath9k/phy.h               |    1 +
 drivers/net/wireless/ath/ath9k/rc.c                |   96 +-
 drivers/net/wireless/ath/ath9k/rc.h                |    9 -
 drivers/net/wireless/ath/ath9k/recv.c              |  111 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   30 +-
 drivers/net/wireless/ath/ath9k/virtual.c           |   16 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   32 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |    3 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  836 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    5 +-
 drivers/net/wireless/ath/carl9170/cmd.c            |    2 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h          |   13 +-
 drivers/net/wireless/ath/carl9170/hw.h             |    7 +-
 drivers/net/wireless/ath/carl9170/mac.c            |   56 +-
 drivers/net/wireless/ath/carl9170/main.c           |   19 +-
 drivers/net/wireless/ath/carl9170/phy.c            |   27 +-
 drivers/net/wireless/ath/carl9170/phy.h            |   24 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   80 +-
 drivers/net/wireless/ath/carl9170/usb.c            |   58 +-
 drivers/net/wireless/ath/carl9170/version.h        |    6 +-
 drivers/net/wireless/ath/debug.c                   |   15 -
 drivers/net/wireless/ath/debug.h                   |   90 -
 drivers/net/wireless/ath/key.c                     |   39 +-
 drivers/net/wireless/ath/main.c                    |   20 +
 drivers/net/wireless/ath/regd.c                    |    8 +
 drivers/net/wireless/atmel.c                       |    6 +-
 drivers/net/wireless/b43/Kconfig                   |   13 +-
 drivers/net/wireless/b43/Makefile                  |    8 +-
 drivers/net/wireless/b43/b43.h                     |   21 +-
 drivers/net/wireless/b43/dma.c                     |    5 -
 drivers/net/wireless/b43/main.c                    |   68 +-
 drivers/net/wireless/b43/phy_common.c              |   22 +-
 drivers/net/wireless/b43/phy_common.h              |    8 +
 drivers/net/wireless/b43/phy_n.c                   |  594 +-
 drivers/net/wireless/b43/phy_n.h                   |    2 +-
 drivers/net/wireless/b43/radio_2055.c              |  502 +-
 drivers/net/wireless/b43/radio_2056.c              | 9062 ++++++++++++-
 drivers/net/wireless/b43/radio_2056.h              | 1084 ++-
 drivers/net/wireless/b43/rfkill.c                  |   19 +-
 drivers/net/wireless/b43/tables_nphy.c             |  228 +-
 drivers/net/wireless/b43legacy/main.c              |   47 +-
 drivers/net/wireless/b43legacy/rfkill.c            |    2 +-
 drivers/net/wireless/hostap/hostap_ap.c            |    3 +
 drivers/net/wireless/hostap/hostap_hw.c            |    8 +-
 drivers/net/wireless/iwlwifi/Kconfig               |    3 +
 drivers/net/wireless/iwlwifi/Makefile              |   11 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   99 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |   35 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h            |    8 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |  369 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  140 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  477 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |  230 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c     |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c      |  345 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  130 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   38 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |  642 +
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |   32 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  160 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |   69 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  614 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h             |   61 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |   26 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  971 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |   97 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    2 +
 drivers/net/wireless/iwlwifi/iwl-debug.h           |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |   40 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |   23 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |   25 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   66 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |   51 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |   12 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |    6 +-
 drivers/net/wireless/iwlwifi/iwl-legacy.c          |  662 +
 drivers/net/wireless/iwlwifi/iwl-legacy.h          |   79 +
 drivers/net/wireless/iwlwifi/iwl-power.c           |  190 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |    3 +
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |   47 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |   14 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |   64 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c              |   64 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |   88 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    3 +-
 drivers/net/wireless/iwmc3200wifi/commands.c       |    2 +-
 drivers/net/wireless/libertas/cfg.c                |    7 +-
 drivers/net/wireless/libertas/cmd.c                |    8 +
 drivers/net/wireless/libertas/dev.h                |    1 +
 drivers/net/wireless/libertas/if_spi.c             |    2 +-
 drivers/net/wireless/libertas/if_usb.c             |   13 +-
 drivers/net/wireless/libertas/main.c               |    3 +-
 drivers/net/wireless/libertas/rx.c                 |    4 +-
 drivers/net/wireless/mac80211_hwsim.c              |    5 +-
 drivers/net/wireless/mwl8k.c                       |  670 +-
 drivers/net/wireless/orinoco/wext.c                |    8 +
 drivers/net/wireless/p54/p54usb.c                  |    2 +-
 drivers/net/wireless/ray_cs.c                      |   18 +-
 drivers/net/wireless/rndis_wlan.c                  |  402 +-
 drivers/net/wireless/rt2x00/Kconfig                |   72 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |  144 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    6 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |  150 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   98 +-
 drivers/net/wireless/rt2x00/rt2800.h               |  218 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  223 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    2 +
 drivers/net/wireless/rt2x00/rt2800pci.c            |  214 +-
 drivers/net/wireless/rt2x00/rt2800pci.h            |   12 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  363 +-
 drivers/net/wireless/rt2x00/rt2800usb.h            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |  113 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |   14 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |   15 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   95 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c             |    2 -
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   12 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   61 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |   11 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  270 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   74 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h            |    4 -
 drivers/net/wireless/rt2x00/rt2x00soc.c            |    6 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |  305 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h            |   12 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |  185 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |   64 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |  107 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |   38 +-
 drivers/net/wireless/rtl818x/Makefile              |    9 +-
 drivers/net/wireless/rtl818x/rtl8180/Makefile      |    5 +
 .../rtl818x/{rtl8180_dev.c => rtl8180/dev.c}       |    8 +-
 .../{rtl8180_grf5101.c => rtl8180/grf5101.c}       |    2 +-
 .../{rtl8180_grf5101.h => rtl8180/grf5101.h}       |    0
 .../{rtl8180_max2820.c => rtl8180/max2820.c}       |    2 +-
 .../{rtl8180_max2820.h => rtl8180/max2820.h}       |    0
 .../net/wireless/rtl818x/{ => rtl8180}/rtl8180.h   |    0
 .../{rtl8180_rtl8225.c => rtl8180/rtl8225.c}       |    2 +-
 .../{rtl8180_rtl8225.h => rtl8180/rtl8225.h}       |    0
 .../rtl818x/{rtl8180_sa2400.c => rtl8180/sa2400.c} |    2 +-
 .../rtl818x/{rtl8180_sa2400.h => rtl8180/sa2400.h} |    0
 drivers/net/wireless/rtl818x/rtl8187/Makefile      |    5 +
 .../rtl818x/{rtl8187_dev.c => rtl8187/dev.c}       |  146 +-
 .../rtl818x/{rtl8187_leds.c => rtl8187/leds.c}     |    2 +-
 .../rtl818x/{rtl8187_leds.h => rtl8187/leds.h}     |    0
 .../rtl818x/{rtl8187_rfkill.c => rtl8187/rfkill.c} |    2 +-
 .../rtl818x/{rtl8187_rfkill.h => rtl8187/rfkill.h} |    0
 .../net/wireless/rtl818x/{ => rtl8187}/rtl8187.h   |    2 +-
 .../{rtl8187_rtl8225.c => rtl8187/rtl8225.c}       |   24 +-
 .../{rtl8187_rtl8225.h => rtl8187/rtl8225.h}       |    0
 drivers/net/wireless/rtlwifi/Kconfig               |   15 +
 drivers/net/wireless/rtlwifi/Makefile              |   13 +
 drivers/net/wireless/rtlwifi/base.c                |  956 ++
 drivers/net/wireless/rtlwifi/base.h                |  120 +
 drivers/net/wireless/rtlwifi/cam.c                 |  291 +
 drivers/net/wireless/rtlwifi/cam.h                 |   53 +
 drivers/net/wireless/rtlwifi/core.c                | 1029 ++
 drivers/net/wireless/rtlwifi/core.h                |   42 +
 drivers/net/wireless/rtlwifi/debug.c               |   50 +
 drivers/net/wireless/rtlwifi/debug.h               |  212 +
 drivers/net/wireless/rtlwifi/efuse.c               | 1189 ++
 drivers/net/wireless/rtlwifi/efuse.h               |  124 +
 drivers/net/wireless/rtlwifi/pci.c                 | 1945 +++
 drivers/net/wireless/rtlwifi/pci.h                 |  302 +
 drivers/net/wireless/rtlwifi/ps.c                  |  493 +
 drivers/net/wireless/rtlwifi/ps.h                  |   43 +
 drivers/net/wireless/rtlwifi/rc.c                  |  329 +
 drivers/net/wireless/rtlwifi/rc.h                  |   40 +
 drivers/net/wireless/rtlwifi/regd.c                |  400 +
 drivers/net/wireless/rtlwifi/regd.h                |   61 +
 drivers/net/wireless/rtlwifi/rtl8192ce/Makefile    |   12 +
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |  257 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c        | 1473 ++
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |  196 +
 drivers/net/wireless/rtlwifi/rtl8192ce/fw.c        |  804 +
 drivers/net/wireless/rtlwifi/rtl8192ce/fw.h        |   98 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        | 2162 +++
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h        |   57 +
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c       |  144 +
 drivers/net/wireless/rtlwifi/rtl8192ce/led.h       |   41 +
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       | 2676 ++++
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h       |  237 +
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       | 2065 +++
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |  523 +
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h        |   44 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |  282 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h        |   37 +
 drivers/net/wireless/rtlwifi/rtl8192ce/table.c     | 1224 ++
 drivers/net/wireless/rtlwifi/rtl8192ce/table.h     |   58 +
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       | 1031 ++
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |  714 +
 drivers/net/wireless/rtlwifi/wifi.h                | 1532 ++
 drivers/net/wireless/wl1251/boot.c                 |    1 -
 drivers/net/wireless/wl1251/main.c                 |   15 +-
 drivers/net/wireless/wl1251/sdio.c                 |  103 +-
 drivers/net/wireless/wl1251/spi.c                  |    9 +
 drivers/net/wireless/wl1251/wl1251.h               |    1 +
 drivers/net/wireless/wl12xx/Kconfig                |   64 +-
 drivers/net/wireless/wl12xx/Makefile               |   22 +-
 .../net/wireless/wl12xx/{wl1271_acx.c => acx.c}    |   99 +-
 .../net/wireless/wl12xx/{wl1271_acx.h => acx.h}    |  108 +-
 .../net/wireless/wl12xx/{wl1271_boot.c => boot.c}  |   38 +-
 .../net/wireless/wl12xx/{wl1271_boot.h => boot.h}  |    3 +-
 .../net/wireless/wl12xx/{wl1271_cmd.c => cmd.c}    |   81 +-
 .../net/wireless/wl12xx/{wl1271_cmd.h => cmd.h}    |   58 +-
 .../net/wireless/wl12xx/{wl1271_conf.h => conf.h}  |    4 +-
 drivers/net/wireless/wl12xx/debugfs.c              |  480 +
 .../wl12xx/{wl1271_debugfs.h => debugfs.h}         |    6 +-
 .../wireless/wl12xx/{wl1271_event.c => event.c}    |   14 +-
 .../wireless/wl12xx/{wl1271_event.h => event.h}    |    4 +-
 .../net/wireless/wl12xx/{wl1271_ini.h => ini.h}    |    4 +-
 .../net/wireless/wl12xx/{wl1271_init.c => init.c}  |   23 +-
 .../net/wireless/wl12xx/{wl1271_init.h => init.h}  |    6 +-
 drivers/net/wireless/wl12xx/{wl1271_io.c => io.c}  |    5 +-
 drivers/net/wireless/wl12xx/{wl1271_io.h => io.h}  |    6 +-
 .../net/wireless/wl12xx/{wl1271_main.c => main.c}  |  494 +-
 drivers/net/wireless/wl12xx/{wl1271_ps.c => ps.c}  |    6 +-
 drivers/net/wireless/wl12xx/{wl1271_ps.h => ps.h}  |    8 +-
 .../net/wireless/wl12xx/{wl1271_reg.h => reg.h}    |    0
 drivers/net/wireless/wl12xx/{wl1271_rx.c => rx.c}  |   38 +-
 drivers/net/wireless/wl12xx/{wl1271_rx.h => rx.h}  |    6 +-
 .../net/wireless/wl12xx/{wl1271_scan.c => scan.c}  |   17 +-
 .../net/wireless/wl12xx/{wl1271_scan.h => scan.h}  |    6 +-
 .../net/wireless/wl12xx/{wl1271_sdio.c => sdio.c}  |    4 +-
 drivers/net/wireless/wl12xx/sdio_test.c            |  520 +
 .../net/wireless/wl12xx/{wl1271_spi.c => spi.c}    |    6 +-
 .../wl12xx/{wl1271_testmode.c => testmode.c}       |   18 +-
 .../wl12xx/{wl1271_testmode.h => testmode.h}       |    4 +-
 drivers/net/wireless/wl12xx/{wl1271_tx.c => tx.c}  |  196 +-
 drivers/net/wireless/wl12xx/{wl1271_tx.h => tx.h}  |    7 +-
 drivers/net/wireless/wl12xx/wl1271_debugfs.c       |  583 -
 drivers/net/wireless/wl12xx/{wl1271.h => wl12xx.h} |  150 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |   17 +-
 drivers/net/wireless/zd1201.c                      |    3 +-
 drivers/net/wireless/zd1211rw/zd_chip.c            |    5 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |    2 +
 drivers/net/xilinx_emaclite.c                      |   36 +-
 drivers/net/znet.c                                 |    2 +-
 drivers/s390/net/lcs.c                             |   10 +-
 drivers/s390/net/qeth_core_main.c                  |    2 +-
 drivers/s390/net/qeth_core_mpc.h                   |    2 +-
 drivers/s390/net/qeth_core_sys.c                   |    2 +-
 drivers/s390/net/qeth_l2_main.c                    |   11 +-
 drivers/s390/net/qeth_l3_main.c                    |  245 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |   14 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |    2 +-
 drivers/ssb/main.c                                 |   30 +
 drivers/ssb/pci.c                                  |   96 +-
 drivers/ssb/pcihost_wrapper.c                      |    7 +
 drivers/ssb/scan.c                                 |    4 +-
 drivers/vhost/net.c                                |    9 +-
 drivers/vhost/test.c                               |  320 +
 drivers/vhost/test.h                               |    7 +
 drivers/vhost/vhost.c                              |   43 +-
 drivers/vhost/vhost.h                              |    2 +-
 firmware/Makefile                                  |   10 +-
 firmware/WHENCE                                    |    4 +-
 ...6-6.0.15.fw.ihex => bnx2-mips-06-6.2.1.fw.ihex} | 5429 ++++----
 ...9-6.0.17.fw.ihex => bnx2-mips-09-6.2.1.fw.ihex} | 5412 ++++----
 firmware/bnx2x/bnx2x-e1-6.0.34.0.fw.ihex           | 9476 ------------
 firmware/bnx2x/bnx2x-e1-6.2.5.0.fw.ihex            | 9483 ++++++++++++
 firmware/bnx2x/bnx2x-e1h-6.0.34.0.fw.ihex          |13178 -----------------
 firmware/bnx2x/bnx2x-e1h-6.2.5.0.fw.ihex           |13181 +++++++++++++++++
 firmware/bnx2x/bnx2x-e2-6.0.34.0.fw.ihex           |15442 -------------------
 firmware/bnx2x/bnx2x-e2-6.2.5.0.fw.ihex            |15456 ++++++++++++++++++++
 include/linux/average.h                            |   30 +
 include/linux/bitops.h                             |   11 +
 include/linux/dcbnl.h                              |  184 +
 include/linux/dccp.h                               |   23 +
 include/linux/ethtool.h                            |    4 +-
 include/linux/filter.h                             |   56 +-
 include/linux/ieee80211.h                          |   30 +-
 include/linux/if_bridge.h                          |    4 +-
 include/linux/if_ether.h                           |    1 +
 include/linux/if_link.h                            |   28 +
 include/linux/if_macvlan.h                         |   34 +-
 include/linux/igmp.h                               |   18 +-
 include/linux/inetdevice.h                         |   15 +-
 include/linux/ipv6.h                               |    2 +-
 include/linux/jhash.h                              |  183 +-
 include/linux/mdio.h                               |    5 +
 include/linux/netdevice.h                          |   89 +-
 include/linux/netfilter.h                          |    2 +
 include/linux/nl80211.h                            |  188 +-
 include/linux/rfkill.h                             |   31 -
 include/linux/security.h                           |   15 +-
 include/linux/skbuff.h                             |   13 +-
 include/linux/socket.h                             |    8 +-
 include/linux/ssb/ssb.h                            |    4 +
 include/linux/ssb/ssb_regs.h                       |   40 +
 include/linux/stmmac.h                             |    6 +-
 include/linux/tipc.h                               |   18 +-
 include/linux/tipc_config.h                        |   76 +-
 include/linux/usb/usbnet.h                         |    6 +
 include/linux/wl12xx.h                             |    8 +
 include/linux/xfrm.h                               |    1 +
 include/net/addrconf.h                             |    2 -
 include/net/bluetooth/bluetooth.h                  |    1 +
 include/net/bluetooth/hci.h                        |   20 +-
 include/net/bluetooth/hci_core.h                   |   23 +-
 include/net/bluetooth/l2cap.h                      |   22 +-
 include/net/bluetooth/mgmt.h                       |   87 +
 include/net/bluetooth/rfcomm.h                     |   18 +-
 include/net/bluetooth/sco.h                        |   20 +-
 include/net/caif/cfctrl.h                          |    2 +-
 include/net/cfg80211.h                             |  171 +-
 include/net/dcbevent.h                             |   31 +
 include/net/dcbnl.h                                |   28 +
 include/net/dn_dev.h                               |   27 +-
 include/net/dn_route.h                             |   10 +
 include/net/dst.h                                  |   68 +-
 include/net/dst_ops.h                              |    2 +
 include/net/flow.h                                 |    2 +
 include/net/if_inet6.h                             |    3 +-
 include/net/inet6_connection_sock.h                |    3 +
 include/net/inet_connection_sock.h                 |    3 +-
 include/net/inet_sock.h                            |    7 +-
 include/net/inet_timewait_sock.h                   |   20 +-
 include/net/inetpeer.h                             |   32 +-
 include/net/ip.h                                   |   10 -
 include/net/ip6_fib.h                              |    2 +
 include/net/ip6_route.h                            |   13 +-
 include/net/mac80211.h                             |  125 +-
 include/net/ndisc.h                                |    3 -
 include/net/neighbour.h                            |   10 +-
 include/net/netfilter/nf_conntrack.h               |    2 +
 include/net/netlink.h                              |   21 +-
 include/net/netns/generic.h                        |    2 +-
 include/net/regulatory.h                           |    7 +
 include/net/route.h                                |   37 +-
 include/net/rtnetlink.h                            |   35 +
 include/net/sch_generic.h                          |    1 +
 include/net/scm.h                                  |    5 +-
 include/net/sctp/command.h                         |    3 -
 include/net/sctp/constants.h                       |   14 -
 include/net/sctp/structs.h                         |    2 -
 include/net/snmp.h                                 |    4 +-
 include/net/sock.h                                 |   97 +-
 include/net/tcp.h                                  |   22 +-
 include/net/timewait_sock.h                        |    8 +
 include/net/tipc/tipc.h                            |  186 -
 include/net/tipc/tipc_bearer.h                     |  138 -
 include/net/tipc/tipc_msg.h                        |  207 -
 include/net/tipc/tipc_port.h                       |  101 -
 include/net/x25.h                                  |    2 +
 include/net/xfrm.h                                 |    7 +
 lib/Kconfig                                        |    3 +
 lib/Makefile                                       |    2 +
 lib/average.c                                      |   61 +
 lib/nlattr.c                                       |   22 +-
 net/8021q/vlan.c                                   |   13 +-
 net/8021q/vlan.h                                   |   22 +-
 net/8021q/vlan_core.c                              |    4 +-
 net/8021q/vlan_dev.c                               |  197 +-
 net/8021q/vlan_netlink.c                           |   20 -
 net/8021q/vlanproc.c                               |    5 -
 net/9p/protocol.c                                  |   33 +-
 net/Kconfig                                        |    6 +
 net/Makefile                                       |    1 +
 net/atm/br2684.c                                   |    2 +-
 net/atm/clip.c                                     |    3 +-
 net/atm/lec.c                                      |    3 +-
 net/atm/mpc.c                                      |    2 -
 net/batman-adv/Kconfig                             |   25 +
 net/batman-adv/Makefile                            |   39 +
 net/batman-adv/aggregation.c                       |  273 +
 net/batman-adv/aggregation.h                       |   43 +
 net/batman-adv/bat_debugfs.c                       |  360 +
 net/batman-adv/bat_debugfs.h                       |   33 +
 net/batman-adv/bat_sysfs.c                         |  593 +
 net/batman-adv/bat_sysfs.h                         |   42 +
 net/batman-adv/bitarray.c                          |  201 +
 net/batman-adv/bitarray.h                          |   44 +
 net/batman-adv/gateway_client.c                    |  477 +
 net/batman-adv/gateway_client.h                    |   36 +
 net/batman-adv/gateway_common.c                    |  177 +
 net/batman-adv/gateway_common.h                    |   38 +
 net/batman-adv/hard-interface.c                    |  651 +
 net/batman-adv/hard-interface.h                    |   53 +
 net/batman-adv/hash.c                              |   62 +
 net/batman-adv/hash.h                              |  176 +
 net/batman-adv/icmp_socket.c                       |  356 +
 net/batman-adv/icmp_socket.h                       |   34 +
 net/batman-adv/main.c                              |  187 +
 net/batman-adv/main.h                              |  183 +
 net/batman-adv/originator.c                        |  564 +
 net/batman-adv/originator.h                        |   64 +
 net/batman-adv/packet.h                            |  136 +
 net/batman-adv/ring_buffer.c                       |   52 +
 net/batman-adv/ring_buffer.h                       |   28 +
 net/batman-adv/routing.c                           | 1397 ++
 net/batman-adv/routing.h                           |   48 +
 net/batman-adv/send.c                              |  585 +
 net/batman-adv/send.h                              |   41 +
 net/batman-adv/soft-interface.c                    |  697 +
 net/batman-adv/soft-interface.h                    |   35 +
 net/batman-adv/translation-table.c                 |  534 +
 net/batman-adv/translation-table.h                 |   45 +
 net/batman-adv/types.h                             |  271 +
 net/batman-adv/unicast.c                           |  343 +
 net/batman-adv/unicast.h                           |   35 +
 net/batman-adv/vis.c                               |  949 ++
 net/batman-adv/vis.h                               |   37 +
 net/bluetooth/Makefile                             |    2 +-
 net/bluetooth/bnep/core.c                          |    1 +
 net/bluetooth/cmtp/core.c                          |    1 +
 net/bluetooth/hci_conn.c                           |   23 +-
 net/bluetooth/hci_core.c                           |   83 +-
 net/bluetooth/hci_event.c                          |  210 +-
 net/bluetooth/hci_sock.c                           |   67 +-
 net/bluetooth/hidp/core.c                          |    2 +-
 net/bluetooth/l2cap.c                              |  102 +-
 net/bluetooth/mgmt.c                               |  308 +
 net/bluetooth/rfcomm/core.c                        |    8 +-
 net/bluetooth/rfcomm/sock.c                        |   24 +-
 net/bluetooth/rfcomm/tty.c                         |   28 +-
 net/bluetooth/sco.c                                |   22 +-
 net/bridge/br.c                                    |    4 -
 net/bridge/br_device.c                             |    2 +-
 net/bridge/br_fdb.c                                |   15 +-
 net/bridge/br_forward.c                            |   20 +-
 net/bridge/br_if.c                                 |    7 +-
 net/bridge/br_input.c                              |   10 +-
 net/bridge/br_multicast.c                          |   88 +-
 net/bridge/br_netfilter.c                          |   49 +-
 net/bridge/br_netlink.c                            |   10 +-
 net/bridge/br_notify.c                             |    6 +-
 net/bridge/br_private.h                            |   21 +-
 net/bridge/br_stp_bpdu.c                           |    8 +-
 net/bridge/br_stp_if.c                             |    2 +-
 net/bridge/netfilter/ebtable_broute.c              |    3 +-
 net/bridge/netfilter/ebtables.c                    |   13 +-
 net/caif/Makefile                                  |    8 +-
 net/can/Makefile                                   |    6 +-
 net/ceph/Makefile                                  |    2 +-
 net/core/datagram.c                                |    2 +-
 net/core/dev.c                                     |  383 +-
 net/core/ethtool.c                                 |   21 +-
 net/core/filter.c                                  |  514 +-
 net/core/neighbour.c                               |    1 -
 net/core/net-sysfs.c                               |  430 +-
 net/core/net-sysfs.h                               |    4 +-
 net/core/netpoll.c                                 |    4 +-
 net/core/pktgen.c                                  |   44 +-
 net/core/request_sock.c                            |    1 +
 net/core/rtnetlink.c                               |  166 +-
 net/core/scm.c                                     |   10 +-
 net/core/skbuff.c                                  |   36 +-
 net/core/sock.c                                    |   13 +-
 net/core/timestamping.c                            |    4 +-
 net/dcb/Makefile                                   |    2 +-
 net/dcb/dcbevent.c                                 |   40 +
 net/dcb/dcbnl.c                                    |  435 +-
 net/dccp/Makefile                                  |    4 +-
 net/dccp/ackvec.c                                  |  616 +-
 net/dccp/ackvec.h                                  |  151 +-
 net/dccp/ccids/ccid2.c                             |  143 +-
 net/dccp/ccids/ccid2.h                             |    2 +
 net/dccp/dccp.h                                    |   32 +-
 net/dccp/input.c                                   |   33 +-
 net/dccp/ipv4.c                                    |   13 +-
 net/dccp/options.c                                 |  100 +-
 net/dccp/output.c                                  |   22 +-
 net/dccp/proto.c                                   |   71 +-
 net/dccp/qpolicy.c                                 |  137 +
 net/decnet/af_decnet.c                             |    6 +-
 net/decnet/dn_dev.c                                |  100 +-
 net/decnet/dn_fib.c                                |    6 +-
 net/decnet/dn_neigh.c                              |    2 +-
 net/decnet/dn_route.c                              |  137 +-
 net/decnet/dn_rules.c                              |    2 +-
 net/dns_resolver/Makefile                          |    2 +-
 net/econet/Makefile                                |    2 +-
 net/ieee802154/af_ieee802154.c                     |    6 +-
 net/ipv4/af_inet.c                                 |   18 +-
 net/ipv4/arp.c                                     |   31 +-
 net/ipv4/devinet.c                                 |   97 +-
 net/ipv4/esp4.c                                    |   32 +-
 net/ipv4/fib_frontend.c                            |   34 +-
 net/ipv4/fib_semantics.c                           |    8 +-
 net/ipv4/icmp.c                                    |   32 +-
 net/ipv4/igmp.c                                    |  282 +-
 net/ipv4/inet_connection_sock.c                    |   22 +-
 net/ipv4/inetpeer.c                                |  167 +-
 net/ipv4/ip_fragment.c                             |   36 +-
 net/ipv4/ip_gre.c                                  |   52 +-
 net/ipv4/ip_output.c                               |   28 +-
 net/ipv4/ipconfig.c                                |   32 +-
 net/ipv4/ipip.c                                    |   21 +-
 net/ipv4/ipmr.c                                    |   20 +-
 net/ipv4/netfilter.c                               |    8 +-
 net/ipv4/netfilter/Makefile                        |    6 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |    2 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/ipv4/raw.c                                     |    7 +-
 net/ipv4/route.c                                   |  252 +-
 net/ipv4/syncookies.c                              |   15 +-
 net/ipv4/sysctl_net_ipv4.c                         |    7 +-
 net/ipv4/tcp.c                                     |   16 +-
 net/ipv4/tcp_input.c                               |   51 +-
 net/ipv4/tcp_ipv4.c                                |   74 +-
 net/ipv4/tcp_minisocks.c                           |   63 +-
 net/ipv4/tcp_output.c                              |   37 +-
 net/ipv4/tcp_probe.c                               |    4 +-
 net/ipv4/udp.c                                     |   18 +-
 net/ipv4/xfrm4_mode_tunnel.c                       |    2 +-
 net/ipv4/xfrm4_policy.c                            |   47 +-
 net/ipv6/addrconf.c                                |  115 +-
 net/ipv6/af_inet6.c                                |    2 +-
 net/ipv6/esp6.c                                    |   32 +-
 net/ipv6/inet6_connection_sock.c                   |   54 +-
 net/ipv6/ip6_tunnel.c                              |    2 -
 net/ipv6/ip6mr.c                                   |    4 +-
 net/ipv6/mcast.c                                   |   77 +-
 net/ipv6/ndisc.c                                   |   29 +-
 net/ipv6/netfilter.c                               |    6 +-
 net/ipv6/netfilter/Makefile                        |    4 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    2 +-
 net/ipv6/reassembly.c                              |   36 +-
 net/ipv6/route.c                                   |  156 +-
 net/ipv6/sit.c                                     |   14 +-
 net/ipv6/tcp_ipv6.c                                |  151 +-
 net/ipv6/udp.c                                     |   10 +-
 net/ipv6/xfrm6_mode_tunnel.c                       |    3 +-
 net/irda/ircomm/Makefile                           |    4 +-
 net/irda/irlan/Makefile                            |    2 +-
 net/irda/irnet/Makefile                            |    2 +-
 net/l2tp/l2tp_ip.c                                 |   12 +-
 net/lapb/Makefile                                  |    2 +-
 net/llc/af_llc.c                                   |    6 +-
 net/mac80211/Kconfig                               |    1 +
 net/mac80211/aes_ccm.c                             |    3 +-
 net/mac80211/aes_cmac.c                            |    3 +-
 net/mac80211/agg-rx.c                              |    8 +-
 net/mac80211/agg-tx.c                              |    7 +-
 net/mac80211/cfg.c                                 |  373 +-
 net/mac80211/debugfs.c                             |   60 +-
 net/mac80211/debugfs.h                             |    2 +
 net/mac80211/debugfs_key.c                         |   56 +-
 net/mac80211/debugfs_key.h                         |    8 +-
 net/mac80211/debugfs_netdev.c                      |    2 +
 net/mac80211/debugfs_sta.c                         |   57 +-
 net/mac80211/driver-ops.h                          |   69 +-
 net/mac80211/driver-trace.h                        |  151 +
 net/mac80211/ibss.c                                |    2 +
 net/mac80211/ieee80211_i.h                         |   75 +-
 net/mac80211/iface.c                               |   52 +-
 net/mac80211/key.c                                 |   98 +-
 net/mac80211/key.h                                 |    3 +-
 net/mac80211/led.c                                 |  186 +-
 net/mac80211/led.h                                 |   45 +-
 net/mac80211/main.c                                |   28 +-
 net/mac80211/mesh.c                                |   88 +-
 net/mac80211/mesh.h                                |   45 +-
 net/mac80211/mesh_hwmp.c                           |    9 +-
 net/mac80211/mesh_pathtbl.c                        |    7 +-
 net/mac80211/mesh_plink.c                          |    3 +-
 net/mac80211/mlme.c                                |  227 +-
 net/mac80211/offchannel.c                          |   85 +
 net/mac80211/rate.c                                |   18 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   21 +-
 net/mac80211/rx.c                                  |  190 +-
 net/mac80211/sta_info.c                            |   19 +-
 net/mac80211/sta_info.h                            |   37 +-
 net/mac80211/status.c                              |   51 +-
 net/mac80211/tx.c                                  |   62 +-
 net/mac80211/util.c                                |   43 +-
 net/mac80211/wme.c                                 |   31 +-
 net/mac80211/work.c                                |   27 +-
 net/netfilter/core.c                               |    6 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    6 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   42 +-
 net/netfilter/nf_conntrack_core.c                  |   30 +-
 net/netfilter/nf_conntrack_expect.c                |   10 +-
 net/netfilter/nf_conntrack_netlink.c               |   25 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 net/netfilter/xt_TEE.c                             |   12 +-
 net/netlabel/netlabel_cipso_v4.h                   |    1 -
 net/netlabel/netlabel_mgmt.h                       |    1 -
 net/netlabel/netlabel_unlabeled.h                  |    1 -
 net/packet/af_packet.c                             |  156 +-
 net/phonet/Makefile                                |    4 +-
 net/rds/Makefile                                   |    8 +-
 net/rfkill/core.c                                  |   14 -
 net/rxrpc/Makefile                                 |    4 +-
 net/rxrpc/ar-peer.c                                |   10 +-
 net/sched/sch_fifo.c                               |    2 -
 net/sched/sch_generic.c                            |   41 +-
 net/sched/sch_red.c                                |    1 +
 net/sched/sch_sfq.c                                |  283 +-
 net/sched/sch_teql.c                               |    3 +-
 net/sctp/socket.c                                  |    2 +-
 net/socket.c                                       |   11 +-
 net/sunrpc/auth_gss/Makefile                       |    4 +-
 net/tipc/Kconfig                                   |   35 +-
 net/tipc/Makefile                                  |    4 +-
 net/tipc/addr.c                                    |   10 -
 net/tipc/addr.h                                    |   25 -
 net/tipc/bcast.c                                   |   50 +-
 net/tipc/bcast.h                                   |    1 +
 net/tipc/bearer.c                                  |   22 +-
 net/tipc/bearer.h                                  |   71 +-
 net/tipc/cluster.c                                 |  557 -
 net/tipc/cluster.h                                 |   92 -
 net/tipc/config.c                                  |  118 +-
 net/tipc/config.h                                  |    1 -
 net/tipc/core.c                                    |  101 +-
 net/tipc/core.h                                    |   76 +-
 net/tipc/discover.c                                |   14 +-
 net/tipc/discover.h                                |    2 -
 net/tipc/eth_media.c                               |   15 +-
 net/tipc/handler.c                                 |    2 +-
 net/tipc/link.c                                    |  383 +-
 net/tipc/link.h                                    |   10 +-
 net/tipc/{dbg.c => log.c}                          |  111 +-
 net/tipc/{dbg.h => log.h}                          |    6 +-
 net/tipc/msg.c                                     |   75 +-
 net/tipc/msg.h                                     |  185 +-
 net/tipc/name_distr.c                              |   47 +-
 net/tipc/name_table.c                              |   60 +-
 net/tipc/name_table.h                              |    2 +-
 net/tipc/net.c                                     |   72 +-
 net/tipc/net.h                                     |   14 +-
 net/tipc/node.c                                    |  301 +-
 net/tipc/node.h                                    |   27 +-
 net/tipc/node_subscr.c                             |    2 -
 net/tipc/port.c                                    |  170 +-
 net/tipc/port.h                                    |  137 +-
 net/tipc/ref.c                                     |    8 +-
 net/tipc/socket.c                                  |  155 +-
 net/tipc/subscr.c                                  |   38 +-
 net/tipc/user_reg.c                                |  264 -
 net/tipc/user_reg.h                                |   48 -
 net/tipc/zone.c                                    |  162 -
 net/tipc/zone.h                                    |   70 -
 net/unix/af_unix.c                                 |   36 +-
 net/wanrouter/Makefile                             |    2 +-
 net/wireless/Makefile                              |    2 +-
 net/wireless/core.c                                |   33 +-
 net/wireless/core.h                                |   18 +-
 net/wireless/lib80211.c                            |    8 +-
 net/wireless/lib80211_crypt_tkip.c                 |   16 +-
 net/wireless/mesh.c                                |  142 +
 net/wireless/mlme.c                                |   43 +-
 net/wireless/nl80211.c                             |  612 +-
 net/wireless/nl80211.h                             |   10 +
 net/wireless/reg.c                                 |  262 +-
 net/wireless/scan.c                                |   11 +
 net/wireless/util.c                                |   15 +-
 net/wireless/wext-compat.c                         |    8 +-
 net/wireless/wext-core.c                           |   10 +-
 net/x25/af_x25.c                                   |   95 +-
 net/x25/x25_link.c                                 |    8 +-
 net/xfrm/xfrm_policy.c                             |   20 +-
 net/xfrm/xfrm_user.c                               |   19 +-
 security/capability.c                              |    2 +-
 security/security.c                                |    3 +-
 security/selinux/hooks.c                           |   22 +-
 security/smack/smack_lsm.c                         |   14 +-
 tools/virtio/Makefile                              |   12 +
 tools/virtio/linux/device.h                        |    2 +
 tools/virtio/linux/slab.h                          |    2 +
 tools/virtio/linux/virtio.h                        |  223 +
 tools/virtio/vhost_test/Makefile                   |    2 +
 tools/virtio/vhost_test/vhost_test.c               |    1 +
 tools/virtio/virtio_test.c                         |  248 +
 1108 files changed, 147630 insertions(+), 78395 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-batman-adv
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-mesh
 create mode 100644 Documentation/networking/LICENSE.qlcnic
 create mode 100644 Documentation/networking/batman-adv.txt
 create mode 100644 drivers/net/bnx2x/bnx2x_dcb.c
 create mode 100644 drivers/net/bnx2x/bnx2x_dcb.h
 create mode 100644 drivers/net/bonding/bond_debugfs.c
 create mode 100644 drivers/net/can/slcan.c
 create mode 100644 drivers/net/ixgbe/ixgbe_x540.c
 create mode 100644 drivers/net/usb/cdc_ncm.c
 create mode 100644 drivers/net/wireless/ath/ath5k/ahb.c
 create mode 100644 drivers/net/wireless/ath/ath5k/mac80211-ops.c
 create mode 100644 drivers/net/wireless/ath/ath5k/pci.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9485_initvals.h
 delete mode 100644 drivers/net/wireless/ath/debug.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.h
 create mode 100644 drivers/net/wireless/rtl818x/rtl8180/Makefile
 rename drivers/net/wireless/rtl818x/{rtl8180_dev.c => rtl8180/dev.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_grf5101.c => rtl8180/grf5101.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_grf5101.h => rtl8180/grf5101.h} (100%)
 rename drivers/net/wireless/rtl818x/{rtl8180_max2820.c => rtl8180/max2820.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_max2820.h => rtl8180/max2820.h} (100%)
 rename drivers/net/wireless/rtl818x/{ => rtl8180}/rtl8180.h (100%)
 rename drivers/net/wireless/rtl818x/{rtl8180_rtl8225.c => rtl8180/rtl8225.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_rtl8225.h => rtl8180/rtl8225.h} (100%)
 rename drivers/net/wireless/rtl818x/{rtl8180_sa2400.c => rtl8180/sa2400.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_sa2400.h => rtl8180/sa2400.h} (100%)
 create mode 100644 drivers/net/wireless/rtl818x/rtl8187/Makefile
 rename drivers/net/wireless/rtl818x/{rtl8187_dev.c => rtl8187/dev.c} (94%)
 rename drivers/net/wireless/rtl818x/{rtl8187_leds.c => rtl8187/leds.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8187_leds.h => rtl8187/leds.h} (100%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rfkill.c => rtl8187/rfkill.c} (98%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rfkill.h => rtl8187/rfkill.h} (100%)
 rename drivers/net/wireless/rtl818x/{ => rtl8187}/rtl8187.h (99%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rtl8225.c => rtl8187/rtl8225.c} (97%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rtl8225.h => rtl8187/rtl8225.h} (100%)
 create mode 100644 drivers/net/wireless/rtlwifi/Kconfig
 create mode 100644 drivers/net/wireless/rtlwifi/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/base.c
 create mode 100644 drivers/net/wireless/rtlwifi/base.h
 create mode 100644 drivers/net/wireless/rtlwifi/cam.c
 create mode 100644 drivers/net/wireless/rtlwifi/cam.h
 create mode 100644 drivers/net/wireless/rtlwifi/core.c
 create mode 100644 drivers/net/wireless/rtlwifi/core.h
 create mode 100644 drivers/net/wireless/rtlwifi/debug.c
 create mode 100644 drivers/net/wireless/rtlwifi/debug.h
 create mode 100644 drivers/net/wireless/rtlwifi/efuse.c
 create mode 100644 drivers/net/wireless/rtlwifi/efuse.h
 create mode 100644 drivers/net/wireless/rtlwifi/pci.c
 create mode 100644 drivers/net/wireless/rtlwifi/pci.h
 create mode 100644 drivers/net/wireless/rtlwifi/ps.c
 create mode 100644 drivers/net/wireless/rtlwifi/ps.h
 create mode 100644 drivers/net/wireless/rtlwifi/rc.c
 create mode 100644 drivers/net/wireless/rtlwifi/rc.h
 create mode 100644 drivers/net/wireless/rtlwifi/regd.c
 create mode 100644 drivers/net/wireless/rtlwifi/regd.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
 create mode 100644 drivers/net/wireless/rtlwifi/wifi.h
 rename drivers/net/wireless/wl12xx/{wl1271_acx.c => acx.c} (91%)
 rename drivers/net/wireless/wl12xx/{wl1271_acx.h => acx.h} (89%)
 rename drivers/net/wireless/wl12xx/{wl1271_boot.c => boot.c} (96%)
 rename drivers/net/wireless/wl12xx/{wl1271_boot.h => boot.h} (96%)
 rename drivers/net/wireless/wl12xx/{wl1271_cmd.c => cmd.c} (90%)
 rename drivers/net/wireless/wl12xx/{wl1271_cmd.h => cmd.h} (91%)
 rename drivers/net/wireless/wl12xx/{wl1271_conf.h => conf.h} (99%)
 create mode 100644 drivers/net/wireless/wl12xx/debugfs.c
 rename drivers/net/wireless/wl12xx/{wl1271_debugfs.h => debugfs.h} (93%)
 rename drivers/net/wireless/wl12xx/{wl1271_event.c => event.c} (97%)
 rename drivers/net/wireless/wl12xx/{wl1271_event.h => event.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_ini.h => ini.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_init.c => init.c} (95%)
 rename drivers/net/wireless/wl12xx/{wl1271_init.h => init.h} (93%)
 rename drivers/net/wireless/wl12xx/{wl1271_io.c => io.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_io.h => io.h} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_main.c => main.c} (87%)
 rename drivers/net/wireless/wl12xx/{wl1271_ps.c => ps.c} (98%)
 rename drivers/net/wireless/wl12xx/{wl1271_ps.h => ps.h} (92%)
 rename drivers/net/wireless/wl12xx/{wl1271_reg.h => reg.h} (100%)
 rename drivers/net/wireless/wl12xx/{wl1271_rx.c => rx.c} (87%)
 rename drivers/net/wireless/wl12xx/{wl1271_rx.h => rx.h} (96%)
 rename drivers/net/wireless/wl12xx/{wl1271_scan.c => scan.c} (96%)
 rename drivers/net/wireless/wl12xx/{wl1271_scan.h => scan.h} (97%)
 rename drivers/net/wireless/wl12xx/{wl1271_sdio.c => sdio.c} (99%)
 create mode 100644 drivers/net/wireless/wl12xx/sdio_test.c
 rename drivers/net/wireless/wl12xx/{wl1271_spi.c => spi.c} (99%)
 rename drivers/net/wireless/wl12xx/{wl1271_testmode.c => testmode.c} (94%)
 rename drivers/net/wireless/wl12xx/{wl1271_testmode.h => testmode.h} (93%)
 rename drivers/net/wireless/wl12xx/{wl1271_tx.c => tx.c} (77%)
 rename drivers/net/wireless/wl12xx/{wl1271_tx.h => tx.h} (97%)
 delete mode 100644 drivers/net/wireless/wl12xx/wl1271_debugfs.c
 rename drivers/net/wireless/wl12xx/{wl1271.h => wl12xx.h} (71%)
 create mode 100644 drivers/vhost/test.c
 create mode 100644 drivers/vhost/test.h
 rename firmware/bnx2/{bnx2-mips-06-6.0.15.fw.ihex => bnx2-mips-06-6.2.1.fw.ihex} (54%)
 rename firmware/bnx2/{bnx2-mips-09-6.0.17.fw.ihex => bnx2-mips-09-6.2.1.fw.ihex} (59%)
 delete mode 100644 firmware/bnx2x/bnx2x-e1-6.0.34.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e1-6.2.5.0.fw.ihex
 delete mode 100644 firmware/bnx2x/bnx2x-e1h-6.0.34.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e1h-6.2.5.0.fw.ihex
 delete mode 100644 firmware/bnx2x/bnx2x-e2-6.0.34.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e2-6.2.5.0.fw.ihex
 create mode 100644 include/linux/average.h
 create mode 100644 include/net/bluetooth/mgmt.h
 create mode 100644 include/net/dcbevent.h
 delete mode 100644 include/net/tipc/tipc.h
 delete mode 100644 include/net/tipc/tipc_bearer.h
 delete mode 100644 include/net/tipc/tipc_msg.h
 delete mode 100644 include/net/tipc/tipc_port.h
 create mode 100644 lib/average.c
 create mode 100644 net/batman-adv/Kconfig
 create mode 100644 net/batman-adv/Makefile
 create mode 100644 net/batman-adv/aggregation.c
 create mode 100644 net/batman-adv/aggregation.h
 create mode 100644 net/batman-adv/bat_debugfs.c
 create mode 100644 net/batman-adv/bat_debugfs.h
 create mode 100644 net/batman-adv/bat_sysfs.c
 create mode 100644 net/batman-adv/bat_sysfs.h
 create mode 100644 net/batman-adv/bitarray.c
 create mode 100644 net/batman-adv/bitarray.h
 create mode 100644 net/batman-adv/gateway_client.c
 create mode 100644 net/batman-adv/gateway_client.h
 create mode 100644 net/batman-adv/gateway_common.c
 create mode 100644 net/batman-adv/gateway_common.h
 create mode 100644 net/batman-adv/hard-interface.c
 create mode 100644 net/batman-adv/hard-interface.h
 create mode 100644 net/batman-adv/hash.c
 create mode 100644 net/batman-adv/hash.h
 create mode 100644 net/batman-adv/icmp_socket.c
 create mode 100644 net/batman-adv/icmp_socket.h
 create mode 100644 net/batman-adv/main.c
 create mode 100644 net/batman-adv/main.h
 create mode 100644 net/batman-adv/originator.c
 create mode 100644 net/batman-adv/originator.h
 create mode 100644 net/batman-adv/packet.h
 create mode 100644 net/batman-adv/ring_buffer.c
 create mode 100644 net/batman-adv/ring_buffer.h
 create mode 100644 net/batman-adv/routing.c
 create mode 100644 net/batman-adv/routing.h
 create mode 100644 net/batman-adv/send.c
 create mode 100644 net/batman-adv/send.h
 create mode 100644 net/batman-adv/soft-interface.c
 create mode 100644 net/batman-adv/soft-interface.h
 create mode 100644 net/batman-adv/translation-table.c
 create mode 100644 net/batman-adv/translation-table.h
 create mode 100644 net/batman-adv/types.h
 create mode 100644 net/batman-adv/unicast.c
 create mode 100644 net/batman-adv/unicast.h
 create mode 100644 net/batman-adv/vis.c
 create mode 100644 net/batman-adv/vis.h
 create mode 100644 net/bluetooth/mgmt.c
 create mode 100644 net/dcb/dcbevent.c
 create mode 100644 net/dccp/qpolicy.c
 delete mode 100644 net/tipc/cluster.c
 delete mode 100644 net/tipc/cluster.h
 rename net/tipc/{dbg.c => log.c} (81%)
 rename net/tipc/{dbg.h => log.h} (96%)
 delete mode 100644 net/tipc/user_reg.c
 delete mode 100644 net/tipc/user_reg.h
 delete mode 100644 net/tipc/zone.c
 delete mode 100644 net/tipc/zone.h
 create mode 100644 net/wireless/mesh.c
 create mode 100644 tools/virtio/Makefile
 create mode 100644 tools/virtio/linux/device.h
 create mode 100644 tools/virtio/linux/slab.h
 create mode 100644 tools/virtio/linux/virtio.h
 create mode 100644 tools/virtio/vhost_test/Makefile
 create mode 100644 tools/virtio/vhost_test/vhost_test.c
 create mode 100644 tools/virtio/virtio_test.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
