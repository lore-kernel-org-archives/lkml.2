Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1JYKc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:32:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55802 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab1JYKcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:32:17 -0400
Date: Tue, 25 Oct 2011 06:32:06 -0400 (EDT)
Message-Id: <20111025.063206.2273357152859701628.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 25 Oct 2011 03:32:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9PAWrlo011672


The most visible thing in here is the reorganization of the drivers
under drivers/net.

Mostly it's moving the various ethernet drivers to paths of the form
drivers/net/ethernet/VENDOR/CHIP/

There is almost nothing left directly under drivers/net/

Thanks to Jeff Kirsher for doing this work.

I have to say I was really impressed with GIT's rename detection.  For
example, when I'd pull bug fixes from the 'net' tree into this
'net-next' tree, GIT would figure it out and cleanly merge in the
fixes even though the file names were completely different.

I'll also note that I had to bump GIT's diff.renamelimit to about 1000
to generate this pull request.

Other highlights:

1) Ian Campbell is going through the networking abstracting away
   accesses to SKB page frags so we can cheaply do interesting things
   with page referencing in the future.

2) Eric Dumazet is increasing the accuracy of skb->truesize's value
   on incoming SKBs from devices so that we can avoid unexpectedly
   running out of memory before we hit the individual socket and the
   global protocol socket memory limits.

I think that, without the driver renames, this is actually a smaller
networking pull request than usual for the merge window.

Please pull, thanks a lot.

The following changes since commit 1bc67188c3843b8e16caaa8624beeb0e2823c1f8:

  Merge branch 'for-linus' of http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm (2011-10-25 10:18:27 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

Akeem G. Abodunrin (4):
      igb: Code to prevent overwriting SFP I2C
      igb: Alternate MAC Address EEPROM Updates
      igb: Alternate MAC Address Updates for Func2&3
      igb: Loopback functionality supports for i350 devices

Alex Hacker (2):
      ath9k_hw: use register name in place of magic value
      ath9k_hw: fix EIFS value to microseconds

Alexander Duyck (58):
      ixgbe: Refactor transmit map and cleanup routines
      ixgbe: replace reference to CONFIG_FCOE with IXGBE_FCOE
      ixgbe: Cleanup FCOE and VLAN handling in xmit_frame_ring
      ixgbe: Simplify transmit cleanup path
      ixgbe: convert rings from q_vector bit indexed array to linked list
      ixgbe: Add support for setting CC bit when SR-IOV is enabled
      ixgbe: Always tag VLAN tagged packets
      ixgbe: Change default Tx work limit size to 256 buffers
      v2 ixgbe: consolidate all MSI-X ring interrupts and poll routines into one
      ixgbe: cleanup allocation and freeing of IRQ affinity hint
      ixgbe: Use ring->dev instead of adapter->pdev->dev when updating DCA
      ixgbe: commonize ixgbe_map_rings_to_vectors to work for all interrupt types
      ixgbe: Drop unnecessary adapter->hw dereference in loopback test setup
      ixgbe: combine PCI_VDEVICE and board declaration to same line
      ixgbe: Update TXDCTL configuration to correctly handle WTHRESH
      ixgbe: cleanup reset paths
      ixgbe: cleanup configuration of EITRSEL and VF reset path
      ixgbe: Correctly name and handle MSI-X other interrupt
      ixgbe: remove redundant configuration of tx_sample_rate
      v2 ixgbe: Update packet buffer reservation to correct fdir headroom size
      ixgbe: make ixgbe_up and ixgbe_up_complete void functions
      ixgbe: Add missing code for enabling overheat sensor interrupt
      ixgbe: Add SFP support for missed 82598 PHY
      ixgbe: drop adapter from ixgbe_fso call documentation
      ixgbe: Make better use of memory allocations in one-buffer mode w/ RSC
      igb: Update RXDCTL/TXDCTL configurations
      igb: Update max_frame_size to account for an optional VLAN tag if present
      igb: drop support for single buffer mode
      igb: streamline Rx buffer allocation and cleanup
      igb: update ring and adapter structure to improve performance
      igb: Refactor clean_rx_irq to reduce overhead and improve performance
      igb: drop the "adv" off function names relating to descriptors
      igb: Replace E1000_XX_DESC_ADV with IGB_XX_DESC
      igb: Remove multi_tx_table and simplify igb_xmit_frame
      igb: Make Tx budget for NAPI user adjustable
      igb: split buffer_info into tx_buffer_info and rx_buffer_info
      igb: Consolidate creation of Tx context descriptors into a single function
      igb: Make first and tx_buffer_info->next_to_watch into pointers
      igb: Create separate functions for generating cmd_type and olinfo
      igb: Cleanup protocol handling in transmit path
      igb: Combine all flag info fields into a single tx_flags structure
      igb: consolidate creation of Tx buffer info and data descriptor
      igb: push data into first igb_tx_buffer sooner to reduce stack usage
      igb: Use node specific allocations for the q_vectors and rings
      igb: avoid unnecessary conversions from u16 to int
      igb: Consolidate all of the ring feature flags into a single value
      igb: Move ITR related data into work container within the q_vector
      igb: cleanup IVAR configuration
      igb: retire the RX_CSUM flag and use the netdev flag instead
      igb: leave staterr in place and instead us a helper function to check bits
      igb: fix recent VLAN changes that would leave VLANs disabled after reset
      igb: move TX hang check flag into ring->flags
      igb: add support for NETIF_F_RXHASH
      igb: avoid unnecessarily creating a local copy of the q_vector
      igb: Make certain one vector is always assigned in igb_request_irq
      igb: Fix features that are currently 82580 only and should also be i350
      igb: Drop unnecessary write of E1000_IMS from igb_msix_other
      igb: Add workaround for byte swapped VLAN on i350 local traffic

Alexander Guller (7):
      mlx4_en: Assigning TX irq per ring
      mlx4_en: Removing reserve vectors
      mlx4_en: Adjusting moderation per each ring
      mlx4_en: Added missing iounmap upon releasing a device
      mlx4_en: Fix QP number calculation according to module param
      mlx4_en: Fix crash upon device initialization error
      mlx4_en: Adding 40gb speed report for ethtool

Alexander Simon (1):
      mac80211: fix indentation

Alexander Smirnov (1):
      IEEE802.15.4: 6LoWPAN basic support

Allan Stephens (23):
      tipc: Remove obsolete manipulation of message re-route count field
      tipc: Eliminate obsolete filter for unexpected unicast messages
      tipc: Display meaningful peer interface name during link creation
      tipc: Initialize peer session field of newly created link endpoint
      tipc: Enhance filtering of out-dated link reset messages
      tipc: Update obsolete references to multicast link
      tipc: Cosmetic changes to broadcast bearer send routine
      tipc: Remove non-executable code to handle broadcast bearer congestion
      tipc: Enhance cleanup of broadcast link when contact with node is lost
      tipc: Prevent broadcast link stalling when another node fails
      tipc: Fix node lock problems during broadcast message reception
      tipc: Remove deferred queue head caching during broadcast message reception
      tipc: Discard incoming broadcast messages that are unexpected
      tipc: Remove obsolete congestion handling when sending a broadcast NACK
      tipc: Eliminate redundant check when sending messages
      tipc: Prevent rounding issues when saving connect timeout option
      tipc: Ensure congested links receive bearer status updates
      tipc: Ensure both nodes recognize loss of contact between them
      tipc: Fix unsafe device list search when enabling bearer
      tipc: Remove redundant search when enabling bearer
      tipc: Lower limits for number of bearers and media types
      tipc: Prevent fragmented messages during initial name table exchange
      tipc: Enhance sending of bulk name table messages

Aloisio Almeida Jr (1):
      MAINTAINERS: Add NFC subsystem entry

Alwin Beukers (9):
      brcm80211: cleanup function prototypes
      brcm80211: removed unused functions
      brcm80211: moved power conversion functions
      brcm80211: moved function brcmu_chipname
      brcm80211: moved function brcmu_parse_tlvs
      brcm80211: moved function brcmu_chspec_malformed
      brcm80211: moved function brcmu_mkiovar
      brcm80211: moved function brcmu_format_flags
      brcm80211: removed file wifi.c

Ameen Rahman (1):
      qlcnic: Added error logging for firmware abort

Amir Hanania (2):
      ixgbe - DDP last user buffer - error to warn
      ixgbe: Add FCoE DDP allocation failure counters to ethtool stats.

Amit Beka (1):
      iwlagn: remove duplicate list init

Amit Kumar Salecha (1):
      MAINTAINERS: change netxen_nic maintainers

Amitkumar Karwar (15):
      mwifiex: print driver version information
      mwifiex: use cfg80211 dynamic scan table and cfg80211_get_bss API
      libertas: update readme file
      mwifiex: fix 5GHz association issue
      mwifiex: update bss band information
      mwifiex: pass correct band parameter to ieee80211_channel_to_frequency()
      mwifiex: reset skb length before inserting to free queue
      mwifiex: remove unnecessary mwifiex_dump_station_info() call
      mwifiex: remove unreachable code
      mwifiex: fix Tx data rate display issue
      mwifiex: correct AMSDU aggregation check
      mwifiex: handle an error path correctly
      mwifiex: add support for Marvell pcie8766 chipset
      mwifiex: use separate wait condition for each command node
      mwifiex: fix make namespacecheck warnings

Anderson Briglia (1):
      Bluetooth: Fix wrong memcpy size on LE start encryption

Anderson Lizardo (1):
      Bluetooth: use recommended LE connection parameters

Andre Guedes (3):
      Bluetooth: Reduce critical region.
      Bluetooth: Check 'dev_class' in mgmt_device_found()
      Bluetooth: hci_le_adv_report_evt code refactoring

Andreas Hofmeister (1):
      ipv6: Do not use routes from locally generated RAs

Andres Salomon (1):
      libertas: prioritize usb8388_olpc.bin firmware on OLPC machines

Andy Fleming (2):
      net: Allow skb_recycle_check to be done in stages
      phylib: Modify Vitesse RGMII skew settings

Andy Shevchenko (1):
      wireless: at76c50x: use native hex_pack_byte() method

Anirban Chakraborty (4):
      qlcnic: Fix enviroment variable for udev event generation during FW dump
      qlcnic: FW dump related changes
      MAINTAINERS: qlcnic
      qlcnic: Change CDRP function

Anton Blanchard (15):
      ehea: Remove NETIF_F_LLTX
      ehea: Update multiqueue support
      ehea: Remove force_irq logic in napi poll routine
      ehea: Remove num_tx_qps module option
      ehea: Dont check NETIF_F_TSO in TX path
      ehea: Add vlan_features
      ehea: Allocate large enough skbs to avoid partial cacheline DMA writes
      ehea: Simplify ehea_xmit2 and ehea_xmit3
      ehea: Merge swqe2 TSO and non TSO paths
      ehea: Simplify type 3 transmit routine
      ehea: Remove some unused definitions
      ehea: Add 64bit statistics
      ehea: Remove LRO support
      ehea: Add GRO support
      ehea: Remove unused tcp_end field in send WQ

Antonio Quartulli (8):
      batman-adv: hash_add() has to discriminate on the return value
      batman-adv: correct several typ0s in the comments
      batman-adv: detect clients connected through a 802.11 device
      batman-adv: implement AP-isolation on the receiver side
      batman-adv: implement AP-isolation on the sender side
      batman-adv: print client flags in the local/global transtables output
      batman-adv: fix tt_local_reset_flags() function
      batman-adv: correctly set the data field in the TT_REPONSE packet

Antti Julku (2):
      Bluetooth: Add mgmt command for fast connectable mode
      Bluetooth: Add mgmt events for blacklisting

Arend van Spriel (11):
      net: wireless: add brcm80211 drivers
      brcm80211: remove sparse warning in fullmac debug function
      brcm80211: fix sparse endianess error in mac80211_if.c
      brcm80211: add endian annotation to packet filter structures
      brcm80211: rename variable in _brcmf_set_multicast_list()
      brcm80211: fix annotations in TOE configuration functions
      brcm80211: use endian annotations in scan related function
      brcm80211: use endian annotation for pmk related structure
      brcm80211: use endian annotations for assoc ie length request
      brcm80211: use endian annotation for roaming related parameters
      brcm80211: use endian annotation for scan time configuration

Arik Nemtsov (38):
      wl12xx: Revert "wl12xx: schedule TX packets according to FW occupancy"
      wl12xx: Use a single fw for both STA and AP roles
      wl12xx: use 1 spare block in all cases
      wl12xx: handle dummy packet event also in ap mode
      wl12xx: fix session counter
      wl12xx: use dynamic hlids for AP-mode
      wl12xx: re-enable block ack session support
      wl12xx: AP-mode - set STA HT capabilities when adding a STA
      wl12xx: AP-mode - configure STA HT rates on join
      wl12xx: AP-mode - configure HT rate support to the FW
      wl12xx: track freed packets in FW by AC
      wl12xx: schedule TX packets according to FW packet occupancy
      wl12xx: handle wrap-around overflow in released Tx blocks FW counter
      wl12xx: enable AP advanced functionality
      wl12xx: set the AP-started flag only after setting keys
      wl12xx: AP-mode - prevent Tx to stale/invalid stations
      wl12xx: fix tx_queue_count spurious increment
      wl12xx: allow 11a AP-mode for wl127x devices
      mac80211: allow action frames with unknown BSSID in GO mode
      mac80211: add flag to indicate HW only Tx-agg setup support
      wl12xx: don't queue a new dummy packet if one is already pending
      wl12xx: don't indicate up PS-filtered dummy packets
      wl12xx: AP mode - don't regulate FW blocks for non-active STAs
      wl12xx: support up to 8 stations in AP-mode
      wl12xx: don't regulate links when a single STA is connected
      wl12xx: AP mode - enable the BA constraint event from the FW
      wl12xx: AP mode - clean BA and queue state in tx_reset
      wl12xx: set mac80211 flags for A-MPDU aggregation support
      mac80211: add ssid config to bss information in AP-mode
      wl12xx: AP mode - support hidden SSID
      wl12xx: correct fw_status structure for 8 sta support in AP-mode
      wl12xx: report the stop_ba event to all STAs in AP-mode
      mac80211: treat the WME sta flag as a bit
      nl80211: support sending TDLS commands/frames
      mac80211: standardize adding supported rates IEs
      mac80211: handle TDLS high-level commands and frames
      nl80211/mac80211: allow adding TDLS peers as stations
      mac80211: data path modification for TDLS peers

Axel Lin (1):
      p54spi: add "spi:" prefix for stlc45xx modalias

Baruch Siach (1):
      mac80211/mesh: make the preq queue lock consistent

Ben Hutchings (24):
      ethtool: Reformat struct ethtool_coalesce comments into kernel-doc format
      ethtool: Specify what kind of coalescing struct ethtool_coalesce covers
      ethtool: Correct description of 'max_coalesced_frames' fields
      ethtool: Explicitly state the exit condition for interrupt coalescing
      ethtool: Note common alternate exit condition for interrupt coalescing
      headers, pppox: Add missing #include to <linux/if_pppox.h>
      headers, ax25: Add missing #include to <linux/netrom.h>, <linux/rose.h>
      headers, pppol2tp: Use __kernel_pid_t in <linux/pppol2tp.h>
      headers, net: Use __kernel_sa_family_t in more definitions shared with userland
      headers, netfilter: Use kernel type names __u8, __u16, __u32
      headers, tipc: Add missing #include to <linux/tipc_config.h> for userland
      headers, netfilter: Add missing #include <limits.h> for userland
      headers, xtables: Add missing #include <linux/netfilter.h>
      headers, can: Add missing #include to <linux/can/bcm.h>
      sfc: Correct error code for unsupported interrupt coalescing parameters
      sfc: Use consistent types for interrupt coalescing parameters
      sfc: Correct reporting and validation of TX interrupt coalescing
      sfc: Validate IRQ moderation parameters in efx_init_irq_moderation()
      sfc: Use correct fields of struct ethtool_coalesce
      ethtool: Make struct ethtool_rxnfc kernel-doc more self-consistent
      ethtool: Explicitly state that RX NFC rule locations are priorities
      ethtool: Clean up definitions of rule location arrays in RX NFC
      ethtool: Update ethtool_rxnfc::rule_cnt on return from ETHTOOL_GRXCLSRLALL
      RPS: Ensure that an expired hardware filter can be re-added later

Bhanu Prakash Gollapudi (1):
      net: Define NETDEV_FCOE_WWNN, NETDEV_FCOE_WWPN only when CONFIG_LIBFCOE is enabled

Bill Jordan (2):
      ath9k: fix MGMT packets when using TKIP
      ath9k: ath9k_hw_set_txpowerlimit sets previous txpower

Bing Zhao (2):
      mwifiex: remove wireless.h inclusion and fix resulting bugs
      mwifiex: remove redundant variable scan_table_idx

Bruce Allan (7):
      e1000e: convert driver to use extended descriptors
      e1000e: bump driver version number
      e1000e: convert to netdev features/hw_features API
      e1000e: WoL can fail on 82578DM
      e1000e: WoL fails on device ID 0x1501
      e1000e: bad short packets received when jumbos enabled on 82579
      e1000e: locking bug introduced by commit 67fd4fcb

Carolyn Wyborny (4):
      igb: Version bump.
      igb: Fix for Alt MAC Address feature on 82580 and later devices
      igb: Move DMA Coalescing init code to separate function.
      igb: VFTA Table Fix for i350 devices

Changli Gao (5):
      net: rps: support 802.1Q
      net: rps: support PPPOE session messages
      net: add the comment for skb->l4_rxhash
      net: Preserve ooo_okay when copying skb header
      net: rps: fix the support for PPPOE

Chaoming Li (4):
      rtlwifi: Update to new Realtek version - Part I
      rtlwifi: rtl8192ce: Add new chip revisions
      rtlwifi: rtl8192se: Updates from latest Realtek driver version - Part II
      rtlwifi: rtl8192de: Updates from latest Reaktek driver - Part III

Christian Lamparter (8):
      carl9170: fix timekeeping for HW_COUNTER firmwares
      carl9170: import updated firmware headers
      carl9170: improve site survey
      carl9170: export HW random number generator
      p54: improve site survey
      carl9170: Use do_div for 64-bit division to fix 32-bit kernels
      p54: Use do_div for 64-bit division to fix 32-bit kernels
      minstrel_ht: fix Open BA session request floods

Clemens Buchacher (1):
      jme: fix irq storm after suspend/resume

Dan Carpenter (23):
      qla3xxx: remove an extra semi-colon
      libertas: remove some dead code in if_spi_prog_helper_firmware()
      libertas: handle mesh networks in lbs_iface_active()
      bcma: signedness bug in bcma_get_next_core()
      bna: unlock on error path in pnad_pci_probe()
      bna: off by one in bfa_msgq_rspq_pi_update()
      mac80211: handle allocation failures in mesh_pathtbl_init()
      iwlwifi: fix double assign in iwl_start_tx_ba_trans_ready()
      iwlwifi: signedness bug in iwl_trans_pcie_tx_agg_alloc()
      6LoWPAN: use kfree_skb() instead of kfree()
      6LoWPAN: use the _safe version of list_for_each
      6LoWPAN: call dev_put() on error in lowpan_newlink()
      mwifiex: add a kfree() to an error path
      mwifiex: remove unneeded NULL check
      NFC: use after free on error
      wl3501_cs: min_t() cast truncates high bits
      caif: add error handling for allocation
      bnx2x: remove some dead code
      ath5k: remove some unneeded error handling code
      ath9k: remove some bogus error handling code
      cipso: remove an unneeded NULL check in cipso_v4_doi_add()
      iwmc3200wifi: add a range check to iwm_cfg80211_get_key()
      filter: use unsigned int to silence static checker warning

Daniel Drake (8):
      libertas: link mesh device to wiphy
      libertas_usb: use USB interface as parent device
      libertas_usb: program OLPC EC wakeup mask for wake-on-WLAN
      libertas: disable functionality when interface is down
      libertas: implement if_sdio runtime power management
      libertas: scan behaviour consistency improvements
      libertas: detect TX lockups and reset hardware
      libertas: fix changing interface type when interface is down

Daniel Halperin (1):
      iwlagn: fix compile warnings when CONFIG_PM_SLEEP is not set

Daniel Martensson (4):
      caif-hsi: Making read and writes asynchronous.
      caif-hsi: HSI-Platform device register and unregisters itself
      caif-hsi: Added sanity check for length of CAIF frames
      caif-hsi: Added recovery check of CA wake status.

Dave Martin (1):
      net/smsc911x: Correctly configure 16-bit register access from DT

David Daney (2):
      netdev/phy: Use mdiobus_read() so that proper locks are taken.
      netdev/phy/icplus: Use mdiobus_write() and mdiobus_read() for proper locking.

David Herrmann (1):
      Bluetooth: hidp: Add support for NO_INIT_REPORTS quirk

David S. Miller (39):
      Merge branch 'master' of master.kernel.org:/.../davem/net
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net
      Merge branch 'master' of master.kernel.org:/.../jkirsher/next-organize
      cxgbi: Fix scsi Kconfig dependencies.
      mlx4: Fix infiniband Kconfig dependencies.
      cnic: Fix select dependencies in bnx2fc/bnx2i Kconfig.
      net: Move sungem_phy.h under include/linux
      net: Fix sungem_phy sharing.
      Merge branch 'can/mscan' of git://git.pengutronix.de/git/mkl/linux-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/linux-merge
      Merge branch 'davem-next.mii' of git://git.kernel.org/.../romieu/netdev-2.6
      Merge branch 'master' of master.kernel.org:/.../jkirsher/next-organize
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      net: Fix duplicate CONFIG_SLIP entry in driver/net/Makefile
      Merge branch 'master' of ../netdev-next/
      Merge branch 'for-davem' of git://git.infradead.org/users/linville/wireless-next
      Merge git://github.com/Jkirsher/net-next
      Revert "Scm: Remove unnecessary pid & credential references in Unix socket's send and receive path"
      Merge git://github.com/Jkirsher/net-next
      Merge branch 'tipc-Sep17-2011' of git://openlinux.windriver.com/people/paulg/net-next
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of github.com:davem330/net-next
      Merge branch 'master' of github.com:davem330/net
      Merge branch 'davem-next.r8169' of git://violet.fr.zoreil.com/romieu/linux
      Merge git://github.com/Jkirsher/net-next
      Merge git://github.com/Jkirsher/net-next
      Merge git://github.com/Jkirsher/net-next
      Merge branch 'master' of github.com:davem330/net
      Merge git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.infradead.org/users/linville/wireless-next
      Merge git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'batman-adv/maint' of git://git.open-mesh.org/linux-merge
      Merge git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of ra.kernel.org:/.../davem/net

Dean Nelson (2):
      e1000: save skb counts in TX to avoid cache misses
      e1000: don't enable dma receives until after dma address has been setup

Deepak Sikri (1):
      stmmac: support wake up irq from external sources (v3)

Dirk Eibach (1):
      net: Fix driver name for mdio-gpio.c

Dmitry Kravkov (1):
      bnx2x: Fix build error

Dmitry Tarnyagin (3):
      caif-hsi: Fixing a race condition in the caif_hsi code
      caif-hsi: Fix for wakeup condition problem
      caif-hsi: Make inactivity timeout configurable.

Don Fry (3):
      iwlagn: replace beacon_time_fsf_bits variable with #define
      iwlagn: rename iwlagn module iwlwifi and alias to iwlagn.
      iwlagn: eliminate bus pointer from iwl_priv structure

Don Skidmore (6):
      ixgbe: cleanup feature flags in ixgbe_probe
      ixgbe: fix ixgbe_fc_autoneg_fiber bug
      ixgbe: cleanup X540 interrupt enablement
      ixgbe: cleanup ixgbe_setup_gpie() for X540
      ixgbe: add ECC warning for legacy interrupts
      ixgbe: bump version number

Edward Lu (4):
      ath6kl: Support channel set request for startscan command
      ath6kl: Fix a typo in ath6k context
      ath6kl: Fix default key installation in AP mode
      ath6kl: Do not clear CONNECT bit setting in AP mode for STA disconnect

Einar Lueck (2):
      qeth: support forced signal adapter indications
      qeth: exploit asynchronous delivery of storage blocks

Eliad Peller (54):
      mac80211: clear sta.drv_priv on reconfiguration
      wl12xx: temporarily disable advanced ap functions
      wl12xx: remove rx filtering stuff
      wl12xx: update fw status struct
      wl12xx: update acx commands
      wl12xx: update commands & events
      wl12xx: enable/disable role on interface add/remove
      wl12xx: add device role commands
      wl12xx: update scan cmd api
      wl12xx: update rx/tx
      wl12xx: change max/default template size
      wl12xx: use wl1271_acx_beacon_filter_opt for both sta and ap
      wl12xx: add set_rate_mgmt_params acx
      wl12xx: add system_hlid
      wl12xx: add ROC/CROC commands
      wl12xx: replace dummy_join with ROC/CROC commands
      wl12xx: update BT coex configuration params
      wl12xx: call wl12xx_cmd_set_peer_state() in AP mode
      wl12xx: don't remove key if hlid was already deleted
      wl12xx: add wl12xx_cmd_role_start_ibss()
      wl12xx: support IBSS vif type
      wl12xx: use ap_bcast_hlid for recorded keys
      wl12xx: don't remove key if hlid was already deleted
      wl12xx: don't wait for disconnection event
      wl12xx: initialize rate_set on band rates initialization
      wl12xx: increase psm_entry_retries
      wl12xx: enter psm only after station role was started
      nl80211/cfg80211: add STA WME parameters
      mac80211: add uapsd_queues and max_sp params fields
      nl80211/cfg80211: add WIPHY_FLAG_AP_UAPSD flag
      wl12xx: print acx id
      wl12xx: print the seq_num of rx packet
      wl12xx: add module_param to trigger BUG() on recovery
      wl12xx: add beacon_filtering debugfs file
      wl12xx: don't disconnect on recovery
      wl12xx: don't use WL1271_SCAN_OPT_PRIORITY_HIGH flag
      wl12xx: check for ROC on scan_complete
      wl12xx: add config_hangover command
      wl12xx: use kstrtoul_from_user
      wl12xx: declare support for WIPHY_FLAG_AP_UAPSD
      wl12xx: support p2p interfaces
      nl80211/cfg80211/mac80211: fix wme docs
      cfg80211: add cfg80211_find_vendor_ie() function
      wl12xx: remove TIM ie from probe response
      wl12xx: remove P2P ie from probe response
      wl12xx: send all pending packets on channel change
      wl12xx: Use dev_hlid for auth and assoc req
      wl12xx: implement set_bitrate_mask callback
      mac80211: add ieee80211_vif param to tsf functions
      cfg80211/mac80211: add netdev param to set_txq_params()
      mac80211: save tx params per sdata
      mac80211: pass vif param to conf_tx() callback
      wl12xx: configure rate policy for p2p operations
      wl12xx: disable AP-mode-specific quirks

Emil Tantilov (20):
      ixgbe: add check for supported modes
      ixgbe: clear RNBC only for 82598
      ixgbe: cleanup some register reads
      ixgbe: fix FCRTL/H register dump for X540
      ixgbe: remove duplicate netif_tx_start_all_queues
      ixgbe: avoid HW lockup when adapter is reset with Tx work pending
      ixgbe: add WOL support for X540
      ixgbe: remove global reset to the MAC
      ixgbe: Cleanup q_vector interrupt throttle rate logic
      ixgbe: prevent link checks while resetting
      ixgbe: clear the data field in ixgbe_read_i2c_byte_generic
      ixgbe: remove return code for functions that always return 0
      ixgbe: add support for new 82599 device
      ixgbe: send MFLCN to ethtool
      ixgbe: do not disable flow control in ixgbe_check_mac_link
      ixgbe: remove instances of ixgbe_phy_aq for 82598 and 82599
      igb: fix static function warnings reported by sparse
      ixgbe: fix endianess when writing driver version to firmware
      ixgbe: allow eeprom writes via ethtool
      ixgbe: change the eeprom version reported by ethtool

Emmanuel Grumbach (82):
      iwlagn: use iwl_get_debug_level instead of iwl_debug_level
      iwlagn: introduce iwl-shared.h
      iwlagn: introduce struct iwl-shared - known by all layers
      iwlagn: debug_level moves to struct iwl_shared
      iwlagn: hw_params moves to iwl_shared
      iwlagn: cmd_queue moves to iwl_shared
      iwlagn: workqueue moves to iwl_shared
      iwlagn: priv->status moves to iwl_shared
      iwlagn: priv->lock moves to iwl_shared
      iwlagn: priv->mutex moves to iwl_shared
      iwlagn: modify the debug macro to be usable by all the layers
      iwlagn: add IWL_DEBUG_FW_ERRORS
      iwlagn: priv->sta_lock moves to iwl_shared
      iwlagn: bus layer chooses its transport layer
      iwlagn: add comments to iwl_bus / iwl_trans
      iwlagn: transport handler can register debugfs entries
      iwlagn: iwl_rx_queue moves to the iwl_trans_pcie
      iwlagn: move iwl_suspend / iwl_resume to the transport layer
      iwlagn: move ISR related data to transport layer
      iwlagn: move the NIC error flow to the transport layer
      iwlagn: move isr_statistics to transport layer
      iwlagn: reclaim the packets in transport layer
      iwlagn: move reclaim related functions
      iwlagn: move scd_bc_tbls and scd_base_addr to iwl_trans_pcie
      iwlagn: fix the check of IWLAGN_FIRST_AMPDU_QUEUE
      iwlagn: move all iwl_is_XXX helpers to iwl-shared.h
      iwlagn: move iwl_free_pages to iwl-shared.h
      iwlagn: transport layer should receive iwl_trans
      iwlagn: move hcmd_lock to transport layer
      iwlagn: move dump_csr and dump_fh to transport layer
      iwlagn: remove references to priv from the transport layer
      iwlagn: remove unused parameters from hw_params
      iwlagn: iwl-dev.h doesn't include iwl-fh.h any more
      iwlagn: move Keep Warm to transport layer
      iwlagn: add missing includes
      iwlagn: all function iwl-io.c receive iwl_bus
      iwlagn: iwl-pci doesn't include iwl-dev any more
      iwlagn: iwl_tid_data moves to iwl-shared
      iwlagn: remove dereferences of priv from transport
      iwlagn: stop the device before freeing it
      iwlagn: upper layer stores iwl_rxon_context in skb's CB
      iwlagn: set tx_fifo for ampdu in transport layer
      iwlagn: upper layer uses slabs to allocate tx cmds
      iwlagn: move the mapping ac to queue / fifo to transport
      iwlagn: allocate resources for TX BA session in transport
      iwlagn: move the check_empty logic to the transport layer
      iwlagn: move the disable agg logic to transport layer
      iwlagn: cosmetics in iwl-trans.h
      iwlagn: move wait_for_tx_queue_empty to transport layer
      iwlagn: move check_stuck_queue to transport layer
      iwlagn: move the stop / wake queue logic to transport layer
      iwlagn: move tx queues to transport layer
      iwlagn: merge iwl_pci_down and iwl_pci_remove
      iwlagn: remove priv dereferences from the transport layer
      iwlagn: clean up of transport layer
      iwlagn: move traffic_log back to upper layer
      iwlagn: iwl-trans.c can't dereference iwl_priv any more
      iwlagn: fix compilation when debug flags is unset
      iwlagn: warn about buggy fw that doesn't set SEQ_RX_FRAME
      iwlagn: unmap cmd queue's tfds as BIDI
      iwlagn: free the Tx cmd when a non empty Tx queue is freed
      iwlagn: move iwl_stop / wake_queue to the upper layer
      iwlagn: use enum iwl_rxon_context_id instead of u8
      iwlagn: document the bus layer API
      iwlagn: add documentation to the transport layer
      iwlagn: provide data after WARN_ON
      iwlagn: remove the callback in host commands
      iwlagn: simplify the iwl_device_cmd layout
      iwlagn: remove uneeded declaration
      iwlagn: pending frames musn't be incremented if agg is on
      iwlagn: remove warning in iwl_rx_handle
      iwlagn: sparse warning priv->temperature is signed
      iwlagn: set the sequence control from the transport layer
      iwlagn: update rate scaling with BA notifications
      iwlagn: use kcalloc when possible for array allocation
      iwlagn: kill hw_params.max_stations
      iwlagn: fix a race in the unmapping of the TFDs
      iwlagn: warn only once if AGG state is wrong
      iwlagn: move iwl_beacon_time_mask_XXX near to usage
      iwlagn: move iwl_enable_rfkill_int and kill iwl-helpers.h
      iwlagn: remove uneeded include to iwl-dev.h
      iwlagn: add missing include to iwl-agn-rs.h

Eric Dumazet (53):
      ipv6: some RCU conversions
      ipv6: use RCU in inet6_csk_xmit()
      ipv6: avoid a dst_entry refcount change in ipv6_destopt_rcv()
      ip6tnl: avoid touching dst refcount in ip6_tnl_xmit2()
      net: fix potential neighbour race in dst_ifdown()
      benet: fix build error on 32bit arch
      neigh: reduce arp latency
      net: cleanup some rcu_dereference_raw
      rps: support IPIP encapsulation
      net_sched: sfb: optimize enqueue on full queue
      ixgbevf: provide 64 bit statistics
      net: linkwatch: allow vlans to get carrier changes faster
      tcp: md5: remove one indirection level in tcp_md5sig_pool
      ip6_tunnel: add optional fwmark inherit
      tcp: ECN blackhole should not force quickack mode
      tcp: unalias tcp_skb_cb flags and ip_dsfield
      tcp: rename tcp_skb_cb flags
      af_unix: dont send SCM_CREDENTIALS by default
      tcp: report ECN_SEEN in tcp_info
      net: more accurate skb truesize
      be2net: fix truesize errors
      bnx2: fix skb truesize underestimation
      e1000: fix skb truesize underestimation
      igb: fix skb truesize underestimation
      ixgbe: fix skb truesize underestimation
      e1000e: fix skb truesize underestimation
      sky2: fix skb truesize underestimation
      ftgmac100: fix skb truesize underestimation
      vmxnet3: fix skb truesize underestimation
      niu: fix skb truesize underestimation
      ftmac100: fix skb truesize underestimation
      macvlan: handle fragmented multicast frames
      l2tp: give proper headroom in pppol2tp_xmit()
      net: add skb frag size accessors
      tcp: use TCP_INIT_CWND in tcp_fixup_sndbuf()
      mlx4_en: fix skb truesize underestimation
      ip_gre: dont increase dev->needed_headroom on a live device
      tcp: use TCP_DEFAULT_INIT_RCVWND in tcp_fixup_rcvbuf()
      pktgen: remove ndelay() call
      igbvf: fix truesize underestimation
      myri10ge: fix truesize underestimation
      tcp: remove unused tcp_fin() parameters
      net: constify skbuff and Qdisc elements
      bnx2x: fix skb truesize underestimation
      virtio_net: fix truesize underestimation
      tcp: add const qualifiers where possible
      inet: add rfc 3168 extract in front of INET_ECN_encapsulate()
      tg3: fix tigon3_dma_hwbug_workaround()
      tcp: md5: dont write skb head in tcp_md5_hash_header()
      tcp: md5: add more const attributes
      ipv4: tcp: fix TOS value in ACK messages sent from TIME_WAIT
      net_sched: cls_flow: use skb_header_pointer()
      |PATCH net-next] tg3: add tx_dropped counter

Eric W. Biederman (13):
      net: Move rcu_barrier from rollback_registered_many to netdev_run_todo.
      sysfs: Implement support for tagged files in sysfs.
      class: Implement support for class attrs in tagged sysfs directories.
      bonding: Use a per netns implementation of /sys/class/net/bonding_masters.
      sysfs: Remove support for tagged directories with untagged members.
      sysfs: Reject with a warning invalid uses of tagged directories.
      macvtap: Close a race between macvtap_open and macvtap_dellink.
      macvtap: Fix macvtap_open races in the zero copy enable code.
      macvtap: Don't leak unreceived packets when we delete a macvtap device.
      macvtap: Rewrite macvtap_newlink so the error handling works.
      macvtap: Fix the minor device number allocation
      bonding: Add a forgetten sysfs_attr_init on class_attr_bonding_masters
      rtnetlink: Add missing manual netlink notification in dev_change_net_namespaces

Felix Fietkau (60):
      ath9k_hw: remove the tx power index offset
      ath9k_hw: fix calculated runtime tx power limit
      ath9k_hw: do not limit initial tx power to 20 dbm
      ath9k_hw: calculate a much better approximation of channel noise
      ath9k: use the new channel noise value for signal strength and survey info
      cfg80211: fix a crash in nl80211_send_station
      ath9k: avoid sending a-mpdu packets to sleeping stations
      b43: reload phy and bss settings after core restarts
      ath9k: remove a bogus WARN_ON
      ath9k: fix regression in sending aggregated packets
      ath9k: use u8 for the tx key index
      ath9k: clean up the aggregation tid queue
      ath9k: move the sequence number from ath_frame_info to ath_buf
      ath9k: move seqno allocation in the tx path to ath_tx_setup_buffer
      ath9k: defer ath_tx_setup_buffer setup to the first tx attempt during aggr
      ath9k_hw: do not apply the 2.4 ghz ack timeout workaround to cts
      mac80211: retry sending failed BAR frames later instead of tearing down aggr
      ath9k_hw: drop an unused column in AR5008-AR9002 initvals
      ath9k_hw: fix the last register write for ar5416 addac
      ath9k: fix checks for first subframe delimiter padding
      mac80211: make ieee80211_send_bar available for drivers
      ath9k: eliminate common->{rx,tx}_chainmask
      ath9k: move a few functions around
      ath9k: always call ath_reset from workqueue context
      ath9k: merge reset related functions
      ath9k: implement .get_antenna and .set_antenna
      ath9k: fix enabling interrupts after a hardware error interrupt
      ath9k: make beacon timer initialization more reliable
      ath9k: ensure that rx is not enabled during a reset
      ath9k: remove ATH_TX_XRETRY and BUF_XRETRY flags
      ath9k: reduce the number of functions that access the tx descriptor
      ath9k: move ath_buf_set_rate to remove a forward declaration
      ath9k: call ath9k_hw_set_desc_link for beacon descriptors
      ath9k_hw: do not recalculate the descriptor checksum in ar9003_hw_fill_txdesc
      ath9k_hw: add a new API for setting tx descriptors
      ath9k: use the new API for setting tx descriptors
      ath9k_hw: remove the old tx descriptor API
      ath9k: optimize ath9k_ps_restore
      ath9k: remove a redundant check in ath_tx_form_aggr
      ath9k: optimize ath_tx_rc_status usage
      ath9k: do not insert padding into tx buffers on AR9380+
      mac80211: fix endian issues and comments for BAR failure handling
      ath9k: fix setting the IEEE80211_TX_CTL_CLEAR_PS_FILT flag
      ath9k: sync the dma buffer after changing the retry flag
      ath9k_hw: clean up hardware revision checks
      ath9k_hw: remove dead code in the eeprom ops
      ath9k_hw: fix setting the hardware diversity flag
      ath9k_hw: remove ar9100_hw_compute_pll_control
      ath9k: fix a regression in ath9k_ps_restore
      ath9k: indicate which queues are blocked when stopping tx fails
      ath9k: keep track of what's triggering hardware resets
      ath9k: improve PS filter clearing and retry counting for A-MPDU
      ath9k: fix retry counting / BAR handling during queue flush
      ath9k: disable unnecessary PHY error reporting
      ath9k_hw: make ath9k_hw_set_interrupts use ah->imask by default
      ath9k_hw: clean up tx power handling
      ath: remove ath_regulatory::current_rd_ext
      ath9k_hw: remove EEP_REG_1
      ath9k_hw: fix a regression in key miss handling
      ath9k: only send FCS-fail packets to mac80211 if requested

Finn Thain (1):
      macmace, macsonic: cleanup

Flavio Leitner (3):
      bonding: fix wrong port enabling in 802.3ad
      route: fix ICMP redirect validation
      TCP: remove TCP_DEBUG

Florian Fainelli (3):
      ath9k: add missing AR9340 in ath_mac_bb_names
      r6040: invoke phy_{start,stop} when appropriate
      r6040: bump version to 0.28 and date to 07Oct2011.

Francois Romieu (4):
      dl2k: use standard #defines from mii.h.
      sunbmac: use standard #defines from mii.h.
      r8169: expand received packet length indication.
      r8169: jumbo fixes.

Frank Blaschka (5):
      qeth: l3 ipv6 vlan not working on shared OSA chpid
      iucv: introduce loadable iucv interface
      af_iucv: use loadable iucv interface
      if_ether: add new Ethernet Protocol ID for af_iucv
      qeth: add support for af_iucv HiperSockets transport

Fry, Donald H (2):
      iwlagn: fix modinfo display for 135 ucode.
      iwlagn: simplify chain_noise_num_beacons indirection

Gao feng (1):
      ipv4: avoid useless call of the function check_peer_pmtu

Gerrit Renker (4):
      dccp: support for the exchange of NN options in established state 1/2
      dccp: support for exchanging of NN options in established state 2/2
      dccp ccid-2: use feature-negotiation to report Ack Ratio changes
      ipv4: compat_ioctl is local to af_inet.c, make it static

Gery Kahn (1):
      wl12xx: fixes for hw_pg_ver and chip id reporting

Giuseppe CAVALLARO (16):
      stmmac: remove the STBus bridge setting from the GMAC code (v3)
      stmmac: remove the mmc code (v3)
      stmmac: add MMC support exported via ethtool (v3)
      stmmac: export DMA TX/RX rings via debugfs (v3)
      stmmac: rework the code to get the Synopsys ID (v3)
      stmmac: add HW DMA feature register (v3)
      stmmac: update the driver version (Aug_2011) (v3)
      stmmac: update the doc with new info about the driver's debug (v3)
      net/phy: add IC+ IP101A and support APS.
      net/phy: extra delay only for RGMII interfaces for IC+ IP 1001
      stmmac: protect tx process with lock (V4)
      stmmac: update the driver version and doc (V4)
      stmmac: allow mtu bigger than 1500 in case of normal desc (V4)
      stmmac: allow mmc usage only if feature actually available (V4)
      stmmac: add CHAINED descriptor mode support (V4)
      stmmac: limit max_mtu in case of 4KiB and use __netdev_alloc_skb (V2)

Grant Grundler (4):
      NET: fix phy init for AX88772 USB ethernet
      NET: fix phy init for Asix AX88178 USB (GigE)
      NET: white space/coding style cleanup of asix driver
      NET: asix: fix ethtool -e for AX88178 USB dongle

Greg Dietsche (2):
      iwlwifi: iwl-agn-rs.c: remove old comment
      iwlagn: iwl-agn-rs: remove unnecessary null check for sta and lq_sta

Greg Rose (9):
      ixgbevf: Check if EOP has changed before using it
      pci: Add flag indicating device has been assigned by KVM
      ixgbe: Reconfigure SR-IOV Init
      ixgbevf: Fix broken trunk vlan
      ixgbe: Add protection from VF invalid target DMA
      if_link: Add additional parameter to IFLA_VF_INFO for spoof checking
      ixgbe: Add new netdev op to turn spoof checking on or off per VF
      igbvf: Fix trunk vlan
      igb: Check if subordinate VFs are assigned to virtual machines

Guy Eilam (3):
      wl12xx: use 2 spare TX blocks for GEM cipher
      mac80211: refactor sta_info_insert_rcu to 3 main stages
      mac80211: fix race condition between assoc_done and first EAP packet

Hauke Mehrtens (12):
      bcma: move parsing of EEPROM into own function.
      bcma: move initializing of struct bcma_bus to own function.
      bcma: add functions to scan cores needed on SoCs
      bcma: add SOC bus
      bcma: add mips driver
      bcma: add serial console support
      bcma: get CPU clock
      bcm47xx: prepare to support different buses
      bcm47xx: make it possible to build bcm47xx without ssb.
      bcm47xx: add support for bcma bus
      bcm47xx: fix irq assignment for new SoCs.
      b43: add core rev 17 used on bcma SoC.

Hayes Wang (2):
      r8169: define the early size for 8111evl
      r8169: support new chips of RTL8111F

Heiko Carstens (1):
      seeq: fix compile breakage on s390

Helmut Schaa (25):
      mac80211: Stop TX BA session if buf_size is zero
      mac80211: Don't use a buf_size=0 in ADDBA requests
      mac80211: Fill in skb->protocol information for injected frames
      mac80211: Don't use EAPOL frames for rate sampling
      rt2x00: Fix PCI interrupt processing race on SMP systems
      wireless: Introduce defines for BAR TID_INFO & MULTI_TID fields
      mac80211: Tear down BA session on BAR tx failure
      rt2x00: Minor optimizazion in txdone path
      rt2x00: Add LED_CFG register description
      rt2x00: Remove incorrect led blink
      rt2x00: Update some TX descriptor
      rt2x00: Avoid unnecessary uncached
      rt2x00: Move bssidx calculation into its own function
      rt2x00: Introduce sta_add/remove callbacks
      rt2x00: Add WCID to crypto struct
      rt2x00: Add WCID to HT TX descriptor
      rt2x00: Make use of sta_add/remove callbacks in rt2800
      rt2x00: Forbid aggregation for STAs not programmed into the hw
      rt2x00: Use the available helper functions to initialize the WCID table
      mac80211: Allow noack flag overwrite for injected frames
      mac80211: Update injection documentation
      mac80211: Build TX radiotap header dynamically
      mac80211: Populate radiotap header with MCS info for TX frames
      nl80211: Add sta_flags to the station info
      mac80211: Provide station flags to cfg80211

Huang Ying (1):
      net, rds, Replace xlist in net/rds/xlist.h with llist

Ian Campbell (75):
      net: add APIs for manipulating skb page fragments.
      net: convert core to skb paged frag APIs
      net: ipv4: convert to SKB frag APIs
      net: ipv6: convert to SKB frag APIs
      net: xfrm: convert to SKB frag APIs
      atm: convert to SKB paged frag API.
      IB: amso1100: convert to SKB paged frag API.
      IB: nes: convert to SKB paged frag API.
      IPoIB: convert to SKB paged frag API.
      tg3: convert to SKB paged frag API.
      bnx2: convert to SKB paged frag API.
      bnx2x: convert to SKB paged frag API.
      bnx2fc: convert to SKB paged frag API.
      fcoe: convert to SKB paged frag API.
      3c59x: convert to SKB paged frag API.
      8139cp: convert to SKB paged frag API.
      acenic: convert to SKB paged frag API.
      atl1c: convert to SKB paged frag API.
      atl1e: convert to SKB paged frag API.
      atlx: convert to SKB paged frag API.
      benet: convert to SKB paged frag API.
      bna: convert to SKB paged frag API.
      cassini: convert to SKB paged frag API.
      intel: convert to SKB paged frag API.
      enic: convert to SKB paged frag API.
      forcedeth: convert to SKB paged frag API.
      gianfar: convert to SKB paged frag API.
      greth: convert to SKB paged frag API.
      ibmveth: convert to SKB paged frag API.
      jme: convert to SKB paged frag API.
      ksz884x: convert to SKB paged frag API.
      macvtap: convert to SKB paged frag API.
      mv643xx: convert to SKB paged frag API.
      netxen: convert to SKB paged frag API.
      niu: convert to SKB paged frag API.
      ns83820: convert to SKB paged frag API.
      pasemi: convert to SKB paged frag API.
      qeth: convert to SKB paged frag API.
      qla3xxx: convert to SKB paged frag API.
      qlcnic: convert to SKB paged frag API.
      qlge: convert to SKB paged frag API.
      r8169: convert to SKB paged frag API.
      s2io: convert to SKB paged frag API.
      sfc: convert to SKB paged frag API.
      skge: convert to SKB paged frag API.
      sky2: convert to SKB paged frag API.
      starfire: convert to SKB paged frag API.
      stmmac: convert to SKB paged frag API.
      sungem: convert to SKB paged frag API.
      sunhme: convert to SKB paged frag API.
      tehuti: convert to SKB paged frag API.
      tsi108: convert to SKB paged frag API.
      typhoon: convert to SKB paged frag API.
      via-velocity: convert to SKB paged frag API.
      virtionet: convert to SKB paged frag API.
      vmxnet3: convert to SKB paged frag API.
      vxge: convert to SKB paged frag API.
      xen: netback: convert to SKB paged frag API.
      xen: netfront: convert to SKB paged frag API.
      et131x: convert to SKB paged frag API.
      hv: netvsc: convert to SKB paged frag API.
      myri10ge: convert to SKB paged frag API.
      cxgb3: convert to SKB paged frag API.
      chelsio: convert to SKB paged frag API.
      net: use DMA_x_DEVICE and dma_mapping_error with skb_frag_dma_map
      ehea: convert to SKB paged frag API
      emac: convert to SKB paged frag API.
      ll_temac: convert to SKB paged frag API.
      net: do not take an additional reference in skb_frag_set_page
      mm: add a "struct page_frag" type containing a page, offset and length
      mlx4: convert to SKB paged frag API.
      cxgb4: convert to SKB paged frag API.
      cxgb4vf: convert to SKB paged frag API.
      cxgbi: convert to SKB paged frag API.
      net: add opaque struct around skb frag page

Ilan Elias (7):
      NFC: Add dev_up and dev_down control operations
      NFC: move nfc.h from include/net to include/net/nfc
      NFC: basic NCI protocol implementation
      NFC: driver for TI shared transport
      NFC: improve readability of an 'if' in nci core.c
      NFC: implicitly deactivate in nci_start_poll
      NFC: protect nci_data_exchange transactions

Jacob Keller (3):
      ixgbe add thermal sensor support for x540 hardware
      ixgbe: fix driver version initialization in firmware
      igb: enable l4 timestamping for v2 event packets

Jason Wang (1):
      macvtap: fix the uninitialized var using in macvtap_alloc_skb()

Javier Cardona (22):
      mac80211: fix erroneous clearing of MESH_PATH_SN_VALID flag
      mac80211: improve mpath debugging
      mac80211: fix mpath timer NULL function
      mac80211: mesh locking fixes
      mac80211: fix mesh path flushing
      mac80211: mesh gate implementation
      {nl,mac}80211: add missing root mode meshconf entries
      {nl,cfg,mac}80211: let userspace set RANN interval
      {nl,cfg,mac}80211: let userspace make meshif mesh gate
      mac80211: Defer tranmission of mesh path errors
      mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
      mac80211: Remove mesh paths when an interface is removed
      mac80211: Improve mpath state locking
      mac80211: Remove redundant mesh path expiration checks
      mac80211: Don't iterate twice over all mpaths when once in sufficient
      mac80211: Consolidate {mesh,mpp}_path_flush into one function
      mac80211: Consolidate mesh path duplicated functions
      mac80211: Stop forwarding mesh traffic when tx queues are full
      mac80211: Start implementing QoS support for mesh interfaces
      mac80211: Mesh data frames must have the QoS header
      mac80211: Mark all mesh stations as QoS capable
      mac80211: Fix regression that allowed mpaths between non-peers.

Jeff Kirsher (86):
      drivers/net/ethernet: Add ethernet dir and config option
      3c*/acenic/typhoon: Move 3Com Ethernet drivers
      amd: Move AMD (Lance) chipset drivers
      8390: Move the 8390 related drivers
      broadcom: Move the Broadcom drivers
      chelsio: Move the Chelsio drivers
      intel: Move the Intel wired LAN drivers
      qlogic: Move the QLogic drivers
      smsc: Move the SMC (SMSC) drivers
      i825xx: Move the Intel 82586/82593/82596 based drivers
      ni5010: Move the Racal-Interlan (Micom) driver
      cassini/niu/sun*: Move the Sun drivers
      sfc: Move the Solarflare drivers
      be2net: Move the Emulex driver
      bna: Move the Brocade driver
      mlx4: Move the Mellanox driver
      myri*: Move the Myricom drivers
      s2io/vxge: Move the Exar drivers
      ehea/ibm*: Move the IBM drivers
      enic: Move the Cisco driver
      pasemic_mac*: Move the PA Semi driver
      tehuti: Move the Tehuti driver
      stmmac: Move the STMicroelectronics driver
      bmac/mace/macmace/mac89x0/cs89x0: Move the Macintosh (Apple) drivers
      *sonic/natsemi/ns83829: Move the National Semi-conductor drivers
      xscale: Move the Intel XScale IXP drivers
      ftgmac100/ftmac100: Move the Faraday drivers
      8139*/atp/r8169/sc92031: Move the Realtek drivers
      de6*/dl2k/sundance: Move the D-Link drivers
      atl*: Move the Atheros drivers
      spider_net: fix compile issue introduced by driver move
      ewrk3/tulip: Move the DEC - Tulip drivers
      ioc3-eth/meth: Move the SGI drivers
      seeq: Move the SEEQ drivers
      pch_gbe: Move the OKI Semiconductor driver
      skge/sky2/mv643xx/pxa168: Move the Marvell Ethernet drivers
      via-*: Move the VIA drivers
      eth16i: Move the Allied Telesis/Fujitsu drivers
      freescale: Move the Freescale drivers
      ks8*/ksz8*: Move the Micrel drivers
      toshiba: Move the Toshiba drivers
      sis*: Move the Silicon Integrated Systems (SiS) drivers
      cirrus: Move the Cirrus network driver
      nuvoton: Move the Nuvoton driver
      tsi108*: Move the Tundra driver
      s6gmac: Move the s6gmac drivers
      davinci*/tlan/cpmac: Move the Texas Instruments (TI) drivers
      hamachi/yellowfin: Move the packet engine drivers
      octeon: Move the Cavium driver
      jme: Move the JME driver
      xilinx/ll_temac: Move the Xilinx drivers
      ipg: Move the IC Plus driver
      korina: Move the IDT driver
      mipsnet: Move the MIPS driver
      lantiq: Move the Lantiq SoC driver
      bfin_mac: Move the Analog Devices Inc driver
      macb: Move the Atmel driver
      r6040: Move the RDC driver
      fealnx: Move the Myson driver
      forcedeth: Move the NVIDIA nForce driver
      starfire: Move the Adaptec driver
      hp100: Move the HP driver
      dnet: Move the Dave Ethernet driver
      ethoc: Move the Avionic driver
      greth: Move the Aeroflex Gaisler driver
      enc28j60: Move the Microchip driver
      dm9000: Move the Davicom driver
      netx: Move the netx driver
      sh_eth: Move the Renesas SuperH driver
      xircom: Move the Xircom driver
      tile: Move the Tilera driver
      acenic: Move the Alteon driver
      drivers/net: Kconfig and Makefile cleanup
      fddi: Move the FDDI drivers
      skfp: Fix SysKonnect FDDI driver compile issues
      ppp: Move the PPP drivers
      hippi: Move the HIPPI driver
      plip: Move the PLIP driver
      slip: Move the SLIP drivers
      ixbmtr_cs: Move the IBM PCMCIA Token Ring driver
      com20020_cs: Move the PCMCIA Arcnet driver
      drivers/net: Kconfig & Makefile cleanup
      drivers/net/ethernet/*: Enabled vendor Kconfig options
      MII: fix Kconfig dependencies for MII
      e1000e: make function tables const
      cs89x0: Move the driver into the Cirrus dir

Jesper Juhl (1):
      net/wan/hdlc_ppp: use break in switch

Jesse Brandeburg (4):
      ixgb: eliminate checkstack warnings
      e1000: convert hardware management from timers to threads
      e1000: convert mdelay to msleep
      e1000: convert to private mutex from rtnl

Jiri Pirko (10):
      bonding: implement get_tx_queues rtnk_link_op
      rtnetlink: remove initialization of dev->real_num_tx_queues
      bonding: use ndo_change_rx_flags callback
      net: introduce IFF_UNICAST_FLT private flag
      net: remove use of ndo_set_multicast_list in drivers
      net: remove ndo_set_multicast_list callback
      net: vlan: goto another_round instead of calling __netif_receive_skb
      benet: remove bogus "unlikely" on vlan check
      br: remove redundant check and init
      net: consolidate and fix ethtool_ops->get_settings calling

Jitendra Kalsaria (1):
      qlge: Adding Maintainer.

Jiří Župka (1):
      Repair wrong named definition aligned_u64

Joakim Tjernlund (1):
      ucc_geth: Add SUPPORTED_MII and SUPPORTED_Autoneg

Joe Perches (14):
      ipg: Use current logging styles
      ipg: Use const
      cfg80211: Update REG_DBG_PRINT macro and uses
      bnx2x: Remove local defines for %pM and mac address
      bnx2x: Coalesce pr_cont uses and fix DP typos
      bnx2x: Use pr_fmt and message logging cleanups
      caif: Remove OOM messages, use kzalloc
      ath: Make ath_dbg void not int
      ath: Make ath_printk void not int and remove unused struct ath_common *
      batman-adv: Remove unnecessary OOM logging messages
      mac80211: Remove unnecessary OOM logging messages
      rfkill: Remove unnecessary OOM logging messages
      wireless: Remove unnecessary OOM logging messages
      iwlagn: Convert kzalloc to kcalloc

Johannes Berg (76):
      cfg80211: split wext compatibility to separate header
      iwlagn: remove wireless extensions inclusions
      iwlegacy: remove wireless extensions inclusions
      ath5k: remove wireless extensions inclusions
      b43: remove wireless extensions inclusions
      b43legacy: remove wireless extensions inclusions
      rndis_wlan: remove wireless extensions inclusions
      wl12xx: remove wext dependencies
      wl1251: remove wext dependencies
      mwifiex: add wext include
      mac80211: remove linux/wireless.h inclusion
      cfg80211: remove unused wext handler exports
      iwlagn: reserve queue 10 for TX during scan dwell
      iwlagn: separate firmware version warning
      iwlagn: bump firmware API for some devices
      iwlagn: move context init after firmware loading
      iwlagn: support new P2P implementation
      mac80211: remove offchannel_tx API
      iwlagn: handle GO powersave
      mac80211: further optimise buffer expiry timer
      cfg80211: verify format of uAPSD information
      iwlagn: move PCI-E transport files
      iwlagn: generically provide iwl_trans_send_cmd_pdu
      iwlagn: Makefile whitespace cleanup
      iwlagn: clean up PM code
      iwlagn: rename iwl-pci.h to iwl-cfg.h
      iwlagn: remove unused function declarations
      iwlagn: move sysfs files to debugfs
      iwlagn: remove drvdata support from bus layer
      iwlagn: do not use interruptible waits
      cfg80211: validate IBSS BSSID
      mac80211: fix AP/VLAN PS buffer race
      iwlagn: move scan code to scan file
      iwlagn: remove common station priv
      iwlagn: split remain-on-channel
      iwlagn: fix dangling scan request
      iwlagn: fix slot programming
      iwlagn: remove Kelvin support
      iwlagn: make iwl_scan_cancel_timeout void
      iwlagn: refactor scan complete
      iwlagn: move iwl_process_scan_complete up
      iwlagn: fix scan complete processing
      cfg80211/mac80211: apply station uAPSD parameters selectively
      mac80211: let drivers inform it about per TID buffered frames
      mac80211: unify TIM bit handling
      mac80211: also expire filtered frames
      mac80211: split PS buffers into ACs
      mac80211: remove return value from add_pending_skbs
      mac80211: clear more-data bit on filtered frames
      mac80211: allow releasing driver-buffered frames
      mac80211: implement uAPSD
      mac80211: send (QoS) Null if no buffered frames
      mac80211: reply only once to each PS-poll
      mac80211: optimise station flags
      mac80211: add missing station flags to debugfs
      mac80211: explicitly notify drivers of frame release
      mac80211: allow out-of-band EOSP notification
      mac80211: document client powersave
      mac80211: dont assign seqno to or aggregate QoS Null frames
      net: use sock_valbool_flag to set/clear SOCK_RXQ_OVFL
      mac80211: pass no-CCK flag through to HW scan
      mac80211: fix offchannel TX cookie matching
      mac80211: optimise monitor xmit
      mac80211: remove tx_data ethertype
      mac80211: move fragment flag to info flag as dont-fragment
      mac80211: parse radiotap header earlier
      mac80211: dont adjust truesize
      mac80211: dont orphan TX skb
      iwlagn: update beacon smarter
      iwlagn: don't assign seqno to QoS Null frames
      iwlagn: send simple LQ command for WoWLAN
      iwlagn: stop interrupts when suspending
      iwlagn: remove 5000 hw header
      iwlagn: remove 6000 hw header
      mac80211: reformat TX unauthorised check
      mac80211: fix TID for null poll response

John Fastabend (13):
      ixgbe: fixup remaining call sites for arbitrary TCs
      ixgbe: remove unneeded fdir pb alloc case
      ixgbe: consolidate, setup for multiple traffic classes
      ixgbe: PFC not cleared on X540 devices
      ixgbe: DCB, do not call set_state() from IEEE mode
      ixgbe: dcb, set priority to traffic class mappings
      ixgbe: update {P}FC thresholds to account for X540 and loopback
      ixgbe: fixup hard dependencies on supporting 8 traffic classes
      ixgbe: DCB X540 devices support max traffic class of 4
      ixgbe: X540 devices RX PFC frames pause traffic even if disabled
      dcb: add DCBX mode to event notifier attributes
      dcb: Add stub routines for !CONFIG_DCB
      net: allow vlan traffic to be received under bond

John W. Linville (25):
      Merge branch 'ath6kl-next' of master.kernel.org:/.../kvalo/ath6kl
      Merge branch 'for-linville' of git://git.kernel.org/.../kvalo/ath6kl
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      ath9k: remove replicated null check in ath_pci_aspm_init
      b43: correct warning for uninitialized variable 'macstat'
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      mac80211: refactor skb copy to failq in mesh_path_move_to_queue
      wl12xx/sdio_test.c: fix build breakage from WL127X_FW_NAME change
      Merge branch 'master' of git://git.infradead.org/users/linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/lucacoelho/wl12xx
      Merge branch 'master' of ssh://infradead/~/public_git/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/lucacoelho/wl12xx
      Revert "ath9k: do not insert padding into tx buffers on AR9380+"
      Merge branch 'master' of git://git.infradead.org/users/linville/wireless
      Merge branch 'master' of git://github.com/padovan/bluetooth-next
      Merge branch 'for-linville' of git://github.com/lucacoelho/wl12xx
      Merge branch 'master' of git://git.infradead.org/users/linville/wireless
      Merge branch 'master' of git://git.infradead.org/users/linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'master' of git://github.com/padovan/bluetooth-next
      ath6kl: fixup merge damage in ath6kl_mgmt_tx
      Merge branch 'master' of git://git.infradead.org/users/linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/lucacoelho/wl12xx
      Merge branch 'master' of git://git.infradead.org/users/linville/wireless-next into for-davem

Jon Mason (1):
      pch_gbe: remove unused variable

Jouni Malinen (47):
      mac80211_hwsim: Fix RX status reporting for HT
      nl80211: Indicate driver-based offchannel TX on mgmt_tx_cancel_wait
      cfg80211/nl80211: Send AssocReq IEs to user space in AP mode
      nl80211/cfg80211: Make addition of new sinfo fields safer
      nl80211/cfg80211: Allow SSID to be specified in new beacon command
      nl80211/cfg80211: Add crypto settings into NEW_BEACON
      nl80211/cfg80211: Add extra IE configuration to AP mode setup
      ath6kl: Use cfg80211_inform_bss instead of cfg80211_inform_bss_frame
      ath6kl: Add functionality for starting AP mode
      ath6kl: Fix AP mode (Re)AssocReq IE processing
      ath6kl: Delay initial group key setup in AP mode
      ath6kl: Use change_station() to authorize/unauthorize STAs
      ath6kl: Add new WMI commands and events for P2P
      ath6kl: Implement remain_on_channel and cancel_remain_on_channel
      ath6kl: Implement mgmt_tx
      ath6kl: Request P2P capabilities during target init
      ath6kl: Add cfg80211 calls for remain-on-channel events
      ath6kl: Use set_appie command to add Probe Request IEs
      ath6kl: Report received Probe Request frames to cfg80211
      ath6kl: Notify cfg80211 of TX status of mgmt_tx frames
      ath6kl: Report received Action frames to cfg80211
      ath6kl: Advertise supported mgmt_stypes
      ath6kl: Add support for new P2P iftypes in mode changes
      ath6kl: Include P2P IE(s) in GO Probe Response depending on request
      ath6kl: Return error from wmi.c instead of -EIO in ath6kl_cfg80211_scan
      ath6kl: Define __CHECK_ENDIAN__ for sparse
      ath6kl: Do not enable Probe Request reporting by default
      athk6l: Fix channel list processing in scan requests
      ath6kl: Fix WMI message structure for AP_SET_PVB
      ath6kl: Fix AP mode connect event parsing and TIM updates
      ath6kl: Allow AP mode to be configured
      ath6kl: Allow enabling of P2P support
      ath6kl: Fix static WEP configuration in AP mode
      cfg80211/nl80211: Add PMKSA caching candidate event
      ath6kl: Fix BSS update on roaming
      ath6kl: Remove deprecated WMI_OPT_RX_FRAME_EVENTID processing
      ath6kl: Remove RSSI update for internal node table
      ath6kl: Remove unnecessary node table update on disconnect event
      ath6kl: Replace internal node table with cfg80211 BSS table
      ath6kl: Remove the unused node table implementation
      ath6kl: Remove unnecessary bssinfo event header conversion
      ath6kl: Update BSS information after connection
      ath6kl: Export beacon interval and DTIM period through STA info
      ath6kl: Report PMKSA candidate events through cfg80211
      ath6kl: fix TCP corruption
      cfg80211: Remove strict validation of AKM suites
      cfg80211: Validate cipher suite against supported ciphers

Julia Lawall (1):
      drivers/net/wireless/mwifiex/scan.c: test the just-initialized value

Kalle Valo (37):
      Add ath6kl cleaned up driver
      ath6kl: don't force foreground scan when connected
      ath6kl: fix atomicity in ath6kl_cfg80211_scan_node()
      ath6kl: fix crash when interface is closed but scan is ongoing
      ath6kl: remove dependency to wireless extensions
      ath6kl: change aggreation timeout message from an error to a debug message
      ath6kl: fix function name conflicts with ath9k
      staging: remove ath6kl
      ath6kl: fix indentation in htc_issued_send()
      ath6kl: implement suspend support
      ath6kl: add testmode support
      ath6kl: fix compilation when NL80211_TESTMODE is disabled
      ath6kl: add firmware log support
      ath6kl: implement support to set firmware log parameters
      ath6kl: cleanup diagnose window read and write functions
      ath6kl: read fwlog from firmware ring buffer
      ath6kl: unify tx function names in htc.c
      ath6kl: unify rx function naming in htc.c
      ath6kl: separate firmware fetch from upload
      ath6kl: fix busy loop in ath6kl_bmi_get_rx_lkahd()
      ath6kl: add support for firmware API 2 format
      ath6kl: refactor firmware load address code
      ath6kl: refactor firmware ext data addr and reserved ram handling size
      ath6kl: read firmware start address from hardware
      ath6kl: read reserved ram size from firmware file
      ath6kl: add firmware capabilities support
      MAINTAINERS: update ath6kl
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: pass only unicast frames for aggregation
      ath6kl: allow firmware to override firmware patch address
      ath6kl: silence "invalid rate" warning
      ath6kl: add prefix parameter to ath6kl_dbg_dump()
      ath6kl: add sdio debug messages
      ath6kl: add debug logs for booting
      ath6kl: improve wmi debug messages
      ath6kl: fix size_t related warnings
      ath6kl: include vmalloc.h in debug.c

Kevin Fang (1):
      ath6kl: Add beginning of AR6004 initialisation support

Kevin Wilson (1):
      cleanup: remove unnecessary include.

Konrad Rzeszutek Wilk (1):
      xen/pciback: Add flag indicating device has been assigned by Xen

Krishna Kumar (1):
      virtio_net: Clean up set_skb_frag()

Kuninori Morimoto (3):
      net/irda: sh_irda: add sh_irda_ prefix to all functions
      net/irda: sh_irda: update author's email address
      net/irda: sh_irda: add PM support

Larry Finger (19):
      rtlwifi: Eliminate raw reads and writes from PCIe portion
      rtlwifi: Remove raw read/write routines from header
      b43: Remove EXPERIMENTAL designation from LP PHY selection
      rtlwifi: Install updated rate-mapping routine
      rtlwifi: rtl8192ce: Convert to use the new rate-mapping routine in rtlwifi
      rtlwifi: rtl8192cu: Convert to use the new rate-mapping routine in rtlwifi
      rtlwifi: rtl8192se: Convert to use the new rate-mapping routine in rtlwifi
      rtlwifi: rtl8192de: Convert to use the new rate-mapping routine in rtlwifi
      b43: Relax requirement for descriptors to be in the DMA zone
      ath9k: Fix a smatch warnings
      b43: Fix swatch warning
      rtlwifi: rtl8192ce: Change modinfo messages
      rtlwifi: rtl8192se: Change modinfo messages
      rtlwifi: rtl8192de: Change modinfo messages
      rtlwifi: Combine instances of RTL_HAL_IS_CCK_RATE macros.
      rtlwifi: Remove unused routine _usb_readN_sync
      rtlwifi: Remove unused _usb_nbytes_read_write and _usb_writeN_sync
      rtlwifi: Change debug parameter to apply to individual drivers
      rtlwifi: Change PCI drivers to use the new PM framework

Lorenzo Bianconi (1):
      mac80211: max_tp_rate2 management of minstrel_ht

Lorenzo Colitti (1):
      ipv6: updates to privacy addresses per RFC 4941.

Luciano Coelho (10):
      wl12xx: add support for multiple SSIDs in sched_scan
      wl12xx: use SCAN_SSID_TYPE_PUBLIC when using the wildcard in sched_scan
      nl80211/cfg80211: add match filtering for sched_scan
      Merge branch 'wl12xx-next' into for-linville
      wl12xx: remove deprecated CONFIG_WL12XX_HT flag
      wl12xx: add support for sched_scan filters
      wl12xx: increase number of allowed SSIDs in sched_scan
      wl12xx: ignore sched scan match sets without SSID
      wl12xx: fix forced passive scans
      wl12xx: set max_sched_scan_ie_len correctly

Luis R. Rodriguez (5):
      wireless: relicense regulatory header to ISC
      MAINTANERS: update Qualcomm Atheros addresses
      ath9k_hw: add AR9580 support
      ath9k: add AR9580 support
      ath9k_htc: add AVM FRITZ!WLAN 11N v2 support

Luiz Augusto von Dentz (2):
      Bluetooth: make use of connection number to optimize the scheduler
      Bluetooth: mark l2cap_create_iframe_pdu as static

Maciej Żenczykowski (2):
      net: allow CAP_NET_RAW to set socket options IP{,V6}_TRANSPARENT
      net: use INET_ECN_MASK instead of hardcoded 3

Manish chopra (1):
      qlcnic: Change debug messages in loopback path

Marc Kleine-Budde (3):
      net/can/mscan: add __iomem annotations
      MAINTAINERS: can: the mailinglist moved to vger.kernel.org
      can: remove references to berlios mailinglist

Marek Lindner (7):
      ath9k: remove eeprom txgain override for minor version < 19
      batman-adv: reuse tt_len() to calculate tt buffer length
      batman-adv: merge update_transtable() into tt related code
      batman-adv: rename all instances of batman_packet to batman_ogm_packet
      batman-adv: agglomerate all batman iv ogm processing functions in a single file
      batman-adv: move routing packet initialization into corresponding file
      batman-adv: agglomerate all batman iv ogm sending functions in the batman iv file

Mark Einon (2):
      mii: Convert spaces to tabs in mii.h
      mii: Remove references to DP83840 PHY in mii.h

Mark Kamichoff (1):
      net/usb: Add IPv6 support to the LG-VL600 LTE USB modem driver

Mark Rustad (3):
      ixgbe: Fix PFC mask generation
      dcb: Use ifindex instead of ifname
      ixgbe: Correct check for change in FCoE priority

Mat Martineau (3):
      Bluetooth: Linearize skbs for use in BNEP, CMTP, HIDP, and RFCOMM
      Bluetooth: Handle fragmented skbs in bt_sock_stream_recvmsg()
      Bluetooth: Perform L2CAP SDU reassembly without copying data

Matt Carlson (14):
      tg3: Remove dead code
      tg3: Consilidate MAC loopback code
      tg3: Pull phy int lpbk setup into separate func
      tg3: Restructure tg3_test_loopback
      tg3: Add external loopback support to selftest
      tg3: Update version to 3.120
      tg3: Check all adv bits when checking config
      tg3: Fix missed MSI workaround
      tg3: Remove tp->rx_offset term when unneeded
      tg3: Add ability to turn off 1shot MSI
      tg3: Eliminate tg3_stop_fw() prototype
      tg3: Eliminate tg3_write_sig_post_reset() prototype
      tg3: Eliminate tg3_halt_cpu() prototype
      tg3: Code movement

Matvejchikov Ilya (1):
      slip: cleanup statistics generation

Michael Buesch (1):
      b43/legacy: Remove firmware IDs

Michael Chan (2):
      cnic, bnx2fc: Increase maximum FCoE sessions.
      cnic: Add timeout for ramrod replies.

Michael Riesch (1):
      usbnet: add timestamping support

Michal Schmidt (2):
      bnx2x: downgrade Max BW error message to debug
      bnx2x: resurrect RX hashing

Michał Mirosław (4):
      ixgbevf: convert to ndo_fix_features
      ixgb: convert to ndo_fix_features
      ixgb: finish conversion to ndo_fix_features
      igbvf: convert to ndo_fix_features

Michio Honda (2):
      sctp: HEARTBEAT negotiation after ASCONF
      sctp: Bundle HEAERTBEAT into ASCONF_ACK

Mihai Maruseac (1):
      dev: use name hash for dev_seq_ops

Mika Lansirinne (1):
      ixgbe: get pauseparam autoneg

Mohammed Shafi Shajakhan (15):
      ath9k_htc: minor clean-up
      ath9k: optimize rate control statistics
      ath9k: remove obselete comments
      ath9k: Add support for get_stats callback
      ath9k_htc: Add get_stats call back
      ath9k: use appropriate debug mask
      ath9k: minor cleanup in ani
      ath9k: enable LED pin for AR946/8x chipsets
      ath9k: Fix PS wrappers and enabling LED
      rfkill: properly assign a boolean type
      ath9k: add Block ACK bitmap in sample debug
      ath9k/ath9k_htc: Fix PS wrappers for RF kill
      ath9k_hw: extend GPIO pin select mask for rfkill
      ath9k_hw: Fix number of GPIO pins for AR9287/9300
      ath9k_hw: set pci_express capability true for AR9480

Murali Raja (1):
      net-netlink: Add a new attribute to expose TOS values via netlink

Nandita Dukkipati (1):
      Proportional Rate Reduction for TCP.

Nishant Sarmukadam (1):
      mwl8k: Traffic to clients gets affected when one client leaves a cyrpto bss

Oliver Hartkopp (3):
      can-gw: add netlink based CAN routing
      can/sja1000: add driver for EMS PCMCIA card
      candev: allow SJW user setting for bittiming calculation

Oliver Neukum (1):
      btusb: add device entry for Broadcom SoftSailing

Paul Gortmaker (1):
      tipc: relocate/coalesce node cast in tipc_named_node_up

Pavel Roskin (14):
      ath9k: remove all references to subsysid, it's never used
      ath5k: remove unused and write-only structures and fields
      ath5k: remove most references to XR
      ath5k: eliminate CHANNEL_* macros, use AR5K_MODE_* in channel->hw_value
      b43legacy: remove 64-bit DMA support
      b43legacy: report core number
      pcmcia: add PCMCIA_DEVICE_MANF_CARD_PROD_ID3
      hostap_cs: support cards with "Version 01.02" as third product ID
      orinoco_cs: be more careful when matching cards with ID 0x0156:0x0002
      ath: fix spelling of Grenada
      ath5k: clean up base.h and its use
      ath5k: remove last references to "softc"
      lib80211: remove exports for functions not called by other modules
      cfg80211: print bandwidth in chan_reg_rule_print_dbg()

Peter Huewe (1):
      net/mac80211/debugfs: Convert to kstrou8_from_user

Peter Hurley (2):
      Bluetooth: Add LE link type for debugfs output
      Bluetooth: Allow ACL packets over USB in HCI_RAW mode

Rafał Miłecki (64):
      ssb: define boardflags
      bcma: use boardflags define from ssb code
      b43: rename TX header formats
      b43: use enum for firmware header format
      b43: support new TX header, noticed to be used by 598.314+ fw
      b43: support new RX header, noticed to be used in 598.314+ fw
      bcma: implement BCM4331 workaround for external PA lines
      b43: include HT-PHY in some common code
      b43: make forcing clock common (HT-PHY also uses that)
      b43: HT-PHY: init: zero EXTG registers
      b43: HT-PHY: init: implement few simple PHY writes
      b43: HT-PHY: init: copy tables and reset CCA
      b43: HT-PHY: init: init BPHY and upload 0x1a table
      b43: HT-PHY: init: add missing PHY mask/set ops
      b43: HT-PHY: init: add some AFE (Analog Frontend) operation
      b43: HT-PHY: init: add missing small-tables writes
      b43: HT-PHY: allow writing longer tables with a single call
      ssb: fix DMA translation for some specific boards
      b43: fix DMA on some bugged hardware
      b43: LCN-PHY: add very basic PHY ops
      b43: LCN-PHY: implement disabling radio
      b43: LCN-PHY: switch analog
      b43: LCN-PHY: add init tables
      b43: LCN-PHY: basic PHY init
      b43: LCN-PHY: init 0x2064 radio
      b43: warn when forcing PIO mode
      b43: drop Kconfig option of forcing PIO mode
      b43: HT-PHY: use separated function for forcing RF sequence
      b43: HT-PHY: read clip state
      b43: use 8K buffers for 64-bit DMA to workaround hardware bug
      b43: make HT-PHY support experimental
      b43: LCN-PHY: add R/W ops for PHY and radio
      b43: LCN-PHY: implement more PHY ops before radio init
      b43: LCN-PHY: prepare functions for channel switching
      ssb: use u16 for storing board rev
      bcma: extract some basic info about board from SPROM
      b43: LCN-PHY: implement saving and restoring PHY & radio configuration
      b43: LCN-PHY: minor fixes
      b43: LCN-PHY: put tables functions in correct file
      b43: LCN-PHY: rewrite 0x7 table at the end of init
      b43: LCN-PHY: upload additional 0x7 table
      b43: LCN-PHY: rename functions, get rid of magic names
      b43: LCN-PHY: add conditions for few operations
      b43: N-PHY: implement enabling TX power control
      b43: drop Copyright for not really copyrightable info
      b43: add my copyrights and myself as the module author
      b43: LCN-PHY: load TX gain table on init
      b43: N-PHY: use helper for checking IPA
      b43: N-PHY: replace some hacks with nice tables ops
      b43: N-PHY: split workarounds into per-PHY-ver functions
      b43: N-PHY: implement few random missing ops
      bcma: cc: export more control functions
      b43: LCN-PHY: tweaks for channel switching
      b43: LCN-PHY: set TX filters
      b43: LCN-PHY: implement SPUR avoidance mode
      b43: LCN-PHY: init TX power control
      b43: LCN-PHY: add more init tweaks
      b43: LCN-PHY: finish sense setup
      b43: add missing MMIO defines
      b43: update dummy transmission
      b43: LCN-PHY: minor clean ups
      b43: trivial: do not report any link quality instead of invalid one
      Revert "b43: trivial: do not report any link quality instead of invalid one"
      b43: N-PHY: report signal to mac80211

Raja Mani (8):
      ath6kl: Print bad trailer data only when htc fails to parse trailer info
      ath6kl: Rearrange the variable and the value position in IF condition
      ath6kl: Avoid two memset to clear src and desr mac addr variable memory in ath6kl_wmi_dot11_hdr_remove()
      ath6kl: Use bit field macros to maintain wlan enabled and disabled status
      ath6kl: Fix crash during the connection process
      ath6kl: Release the memory allocated for the firmware
      ath6kl: Avoid finding bss presence in cfg80211 scan list
      ath6kl: Check sme state before delivering disconnect event to cfg80211

Rajesh Borundia (3):
      netxen: add vlan LRO support
      netxen: Fix vhdr_len in case of non vlan packets.
      netxen: Add pcie workaround

Rajkumar Manoharan (63):
      ath9k_hw: Add dump_eeprom support for AR9003
      ath9k_hw: Add dump_eeprom support for eeprom_4k
      ath9k_hw: Add dump_eeprom support for AR9287
      ath9k_hw: Add dump_eeprom support for eeprom_def
      ath9k: Dump base eeprom header
      ath9k: Dump modal eeprom header
      ath9k: Remove virtual wiphy specific frame type
      ath9k_hw: Optimize rx descriptor processing for AR9003
      ath9k_hw: Update the radio parameters related to high_power
      ath9k_hw: Update AR9003 high_power tx gain table
      ath9k: do not enable interrupt on set interrupt mask
      ath9k_hw: Fix incorrect spur_freq_sd for AR9003
      ath9k: Use atomic reference count for interrupt ops
      ath9k_hw: Fix exceed transmission burst-time of 5GHz
      ath9k: Fix rx overrun interrupt storm
      ath9k: Re-enable RXOEL interrupt after processing rx buffers
      ath9k: Remove unused argument tsf from ath9k_hw_rxprocdesc
      ath9k: qinfo never be NULL in setuptxqueue
      ath9k_hw: Remove unnecessary chainmask configuration
      ath9k: Remove SC_OP_ENABLE_APM
      ath9k: Move ath9k_init_crypto to common
      ath9k: Fix noisefloor history update for extn chains
      ath9k: Fix invalid noisefloor reading due to channel update
      ath9k: Dump modal noisefloor calibration history
      ath9k_hw: Fix descriptor status of TxOpExceeded
      ath9k: Change rate control to use legacy rate as last MRR
      ath9k_hw: Disable Walsh spatial spreading for 2 chains
      ath9k: Send legacy rated frames as unaggregated
      ath9k_hw: Set default slottime as 9us
      ath9k: Fix eifs/usec timeout for AR9287 v1.3+
      ath9k: Add debugfs support for mac/baseband samples
      ath9k_hw: Fix rx latency of 11a mode
      mac80211: stop tx before doing hw config and rate update
      ath9k: Take the samples in unassociated state
      ath9k: Move cycle conters under cc_lock
      ath9k_hw: Fix magnitude/phase average in TxIQ Calibration
      ath9k_hw: Do full chip reset on 11A channels for AR9003
      ath9k_hw: Fix magnitude/phase coeff correction
      ath9k: load noise floor from history after the full chip reset
      ath9k: Reset caldata on radio enable
      mac80211: Fix regression on queue stop during 2040 bss change
      wireless: Do not allow disabled channel in scan request
      ath9k: Store noise immunity values across scanning
      ath6kl: Fix compilation error while compiling w/o debug
      nl80211/cfg80211: Add support to disable CCK rate for management frame
      mac80211: Send the management frame at requested rate
      ath9k: Remove unnecessary AMPDU check at tx status
      ath9k: Remove redundant my beacon check at ath_rx_ps_beacon
      mac80211: Send nullfunc frames at lower rate during connection monitor
      ath9k_hw: Fix ASPM L1 issue for AR9480
      ath9k_hw: Updated ar9003 initval table for AR9380
      ath9k_hw: Update AR9003 initval to improve phase noise
      ath9k_hw: Updated AR9003 tx gain table for 5GHz
      ath9k_hw: Improve fast channel change for AR9003 chips
      ath9k_hw: Add support to reuse TxIQ cal measurements
      ath9k_hw: Add support to reuse Carrier leak calibration
      ath9k_hw: Cleanup Tx calibrations for AR9003 chips
      ath9k_hw: Support fast channel change on 5GHz for AR9003 chips
      ath9k_hw: Update normal/min noise floor value for AR9480
      ath9k_hw: Add radio retention support for AR9480
      ath9k_hw: Do fast channel change based on reusable calibration results
      ath9k_hw: Rename AR9480 -> AR9462 initvals
      ath9k: Rename AR9480 into AR9462

Ralf Baechle (1):
      NET: Korina: Don't include <asm/segment.h>

Randy Dunlap (3):
      net: fix Makefile typos & build errors
      wireless: fix kernel-doc warning in net/cfg80211.h
      nfc: NFC_WILINK depends on NFC_NCI

Rasesh Mody (37):
      bna: Remove Unnecessary CNA Check
      bna: HW Interface Init Update
      bna: Remove get_regs Ethtool Support
      bna: Consolidated HW Registers for Supported HWs
      bna: Remove Obsolete File bfi_ctreg.h
      bna: MSGQ Implementation
      bna: Introduce ENET as New Driver and FW Interface
      bna: Tx and Rx Redesign
      bna: Add New HW Defs
      bna: ENET and Tx Rx Redesign Enablement
      bna: Remove Unused Code
      bna: Remove Obsolete Files
      bna: Driver Version changed to 3.0.2.0
      bna: Naming Change and Minor Macro Fix
      bna: PCI Probe Fix
      bna: Interrupt Polling and NAPI Init Changes
      bna: TX Path and RX Path Changes
      bna: Formatting and Code Cleanup
      bna: Initialization and Locking Fix
      bna: Ethtool Enhancements and Fix
      bna: Async Mode Tx Rx Init Fix
      bna: MBOX IRQ Flag Check after Locking
      bna: TX Queue Depth Fix
      bna: SKB PCI UNMAP Fix
      bna: Driver Version changed to 3.0.2.1
      bna: Semaphore Lock Fix
      bna: Set Ring Param Fix
      bna: Eliminate Small Race Condition Window in RX Path
      bna: PCI Probe Conf Lock Fix
      bna: Brocade 1860 IOC PLL, Reg Defs and ASIC Mode Changes
      bna: Capability Map and MFG Block Changes for New HW
      bna: Implement FW Download for New HW
      bna: Brocade 1860 HW Enablement
      bna: PLL Init Fix and Add Stats Attributes
      bna: Add Callback to Fix RXQ Stop
      bna: Driver Version changed to 3.0.2.2
      bna: Multiple Definition and Interface Setup Fix

Rayagond Kokatanur (1):
      stmmac: use predefined macros for HW cap register fields (V4)

Ricardo (1):
      ll_temac: Add support for ethtool

Richard Cochran (7):
      dp83640: enable six external events and one periodic output
      net: introduce ptp one step time stamp mode for sync packets
      dp83640: add time stamp insertion for sync messages
      net: validate HWTSTAMP ioctl parameters
      net: hold sock reference while processing tx timestamps
      dp83640: use proper function to free transmit time stamping packets
      dp83640: free packet queues on remove

Rick Jones (3):
      Add ethtool -g support to 8139cp
      net: Remove unnecessary driver assignments of ethtool_ringparam fields to zero
      Add ethtool -g support to virtio_net

Roland Vossen (3):
      brcm80211: smac: removed redundant timer function parameters
      brcm80211: smac: decreased timer callback irq level
      brcm80211: fmac: fixed weird indentation

RongQing Li (1):
      igb: fix a compile warning

Roopa Prabhu (3):
      enic: Add SRIOV support
      enic: Helper code for SRIOV proxy commands
      enic: Add support for port profile association on a enic SRIOV VF

Roy.Li (1):
      ipv6: remove a rcu_read_lock in ndisc_constructor

Sam Leffler (1):
      ath6kl: query device tree for firmware board-id

Samuel Jero (4):
      dccp: send Confirm options only once
      dccp ccid-2: prevent cwnd > Sequence Window
      dccp ccid-2: increment cwnd correctly
      dccp ccid-2: check Ack Ratio when reducing cwnd

Samuel Ortiz (1):
      NFC: Reserve tx head and tail room

Sangwook Lee (1):
      net:rfkill: add a gpio setup function into GPIO rfkill

Sasha Levin (1):
      virtio-net: Verify page list size before fitting into skb

Sathya Perla (20):
      be2net: cleanup and refactor stats code
      be2net: use stats-sync to read/write 64-bit stats
      be2net: remove wrong and unnecessary calls to netif_carrier_off()
      be2net: no need to query link status
      be2net: non-member vlan pkts not received in promiscous mode
      be2net: use RX_FILTER cmd to program multicast addresses
      be2net: add support for flashing Teranetics PHY firmware
      be2net: drop pkts that do not belong to the port
      be2net: fix cmd-rx-filter not notifying MCC
      be2net: Fix race in posting rx buffers.
      be2net: get rid of memory mapped pci-cfg space address
      be2net: fix erx->rx_drops_no_frags wrap around
      be2net: increase FW update completion timeout
      be2net: remove unused variable
      be2net: fix multicast filter programming
      be2net: Show newly flashed FW ver in ethtool
      be2net: add vlan/rx-mode/flow-control config to be_setup()
      be2net: refactor VF setup/teardown code into be_vf_setup/clear()
      be2net: don't create multiple TXQs in BE2
      be2net: don't create multiple RX/TX rings in multi channel mode

Senthil Balasubramanian (4):
      ath9k_hw: Add initvals and register definitions for AR946/8x chipsets.
      ath9k_hw: Split tx/rx gain table initval handling
      ath9k_hw: Add support for AR946/8x chipsets.
      ath9k_hw: move register definitions to header files

Sergei Shtylyov (1):
      ath9k: use pci_dev->subsystem_device

Shahar Levi (5):
      wl12xx: Add support to RX packets payload alignment
      mac80211: Update device channel in case of HW channel switch supported
      wl12xx: fix sdio_test module functionality
      wl12xx: Include OFDM rates in IBSS mode
      wl12xx: Add support for HW channel switch

Shawn Guo (4):
      net/smsc911x: add device tree probe support
      net/fec: fec_reset_phy() does not need to always succeed
      net/fec: fix fec1 check in fec_enet_mii_init()
      net/fec: add imx6q enet support

Simon Wunderlich (1):
      batman-adv: update README (date & ap isolation sysfs file)

Somnath Kotur (6):
      be2net: Storing the 'vid' got by the grp5 event instead of storing the vlan_tag
      be2net: Add 60 second delay to allow FAT dump completion on recovery from EEH
      be2net: Change the data type of the 'on die temperature' stat.
      be2net: Fixed Endianness issues in the response read log length field while retrieving FAT data
      be2net: Modified PCI MaxReadReq size to 4096 bytes
      be2net: Making die temperature ioctl call async

Sony Chacko (1):
      qlcnic: detect fan failure

Srinivas Kandagatla (1):
      stmmac: Stop advertising 1000Base capabilties for non GMII iface (V4).

Sritej Velaga (5):
      qlcnic: Fix delay in reset path
      qlcnic: Move get template from probe to start fw
      qlcnic: Added debug info
      qlcnic: Add FLT entry for CO cards FW image region
      qlcnic: fix cdrp race condition

Stanislaw Gruszka (5):
      ath9k: remove ->config_pci_powersave() redundant argument
      ath9k: merge common ->config_pci_powersave() checks
      ath9k: do btcoex ASPM disabling at initialization time
      cfg80211: document wiphy->registered
      iwlagn: fix priv->cfg->ht_params NULL pointer dereference

Stefan Assmann (1):
      rtlwifi: add module parameter to set global debug level

Steffen Klassert (4):
      xfrm: Simplify the replay check and advance functions
      ipv6: Remove superfluous NULL pointer check in ipv6_local_rxpmtu
      ipv6: Fix IPsec slowpath fragmentation problem
      xfrm6: Don't call icmpv6_send on local error

Stephen Hemminger (2):
      rcu: convert uses of rcu_assign_pointer(x, NULL) to RCU_INIT_POINTER
      skge: handle irq better on single port card

Stephen Rothwell (4):
      sungem: sungem_phy.h moved
      wireless/ath6kl: use of module_param requires the inclusion of moduleparam.h
      net: wireless: brcm80211: replace ndo_set_multicast_list  with ndo_set_rx_mode
      net: wireless: brcm80210: include module.h

Sucheta Chakraborty (1):
      qlcnic: add beacon test support.

Sven Eckelmann (1):
      batman-adv: update internal version number

Sven Neumann (2):
      cfg80211: hold reg_mutex when updating regulatory
      cfg80211: reorder code to obsolete forward declaration

Szymon Janc (1):
      Bluetooth: Mark not declared l2cap_core functions as static

Thomas Pedersen (9):
      mac80211: fix mesh beacon format
      ieee80211: introduce Self Protected Action codes
      mac80211: update mesh peering frame codes
      mac80211: update mesh peering frame format
      ieee80211: add mesh action codes
      mac80211: update mesh path selection frame format
      mac80211: mesh gate fixes
      mac80211: check if mesh frame is in RMC after decrypt
      mac80211: notify peer when shutting down peer link

Tim Chen (1):
      Scm: Remove unnecessary pid & credential references in Unix socket's send and receive path

Tom Herbert (4):
      rps: Some minor cleanup in get_rps_cpus
      rps: Add flag to skb to indicate rxhash is based on L4 tuple
      rps: Infrastructure in __skb_get_rxhash for deep inspection
      rps: Inspect GRE encapsulated packets to get flow hash

Tony Breeds (1):
      net: fix IBM EMAC driver after rename.

Tore Anderson (1):
      ipv6: Send ICMPv6 RSes only when RAs are accepted

Ursula Braun (4):
      qeth: do not apply priority queuing to HiperSockets
      iucv: kernel option for z/VM IUCV and HiperSockets
      af_iucv: cleanup - use iucv_sk(sk) early
      af_iucv: add HiperSockets transport

Vasanthakumar Thiagarajan (54):
      ath6kl: cleanup callbacks for different scatter gather method
      ath6kl: Move ath6kl_sdio_async_rw_scatter() down to other hif_ops functions
      ath6kl: Remove struct hif_scatter_req_priv
      ath6kl: Remove useless flags in hif_scatter_req
      ath6kl: Remove endpoint reference from hif_scatter_req
      ath6kl: Refactor refactor ath6kl_sdio_setup_scat_resource()
      ath6kl: Cleanup ath6kl_sdio_enable_scatter()
      ath6kl: Cleanup ath6kl_sdio_cleanup_scatter()
      ath6kl: Move down scatter enable and cleanup functions
      ath6kl: Merge scatter gather setup functions for two method
      ath6kl: Moe virt_scat from hif_dev_scat_sup_info to hif_scatter_req
      ath6kl: Refactor ath6kl_sdio_read_write_sync()
      ath6kl: Merge scatter rw request functions into one
      ath6kl: Remove ath6kldev_setup_msg_bndl()
      ath6kl: Minor cleanup in ath6kldev_submit_scat_req()
      ath6kl: Remove callback msg_pending() and used the function directly
      ath6kl: Move bundle size from ath6kl_device to htc_target
      ath6kl: Move block_sz and block_mask from ath6kl_device to htc_target
      ath6kl: Move scatter information from ath6kl_device to htc_target
      ath6kl: Bypass reading irq status based on chk_irq_status_cnt
      ath6kl: Move chk_irq_status_cnt from ath6kl_device to htc_target
      ath6kl: Remove unused struct ath6kl_async_reg_io_buffer
      ath6kl: Cleanup void *parent_dev in struct wmi
      ath6kl: Move scan table from wmi to ath6kl
      ath6kl: Cleanup parameters for wlan_refresh_inactive_nodes()
      ath6kl: Remove bssid from struct wmi
      ath6kl: Remove ath6kl_wmi_get_current_bssid()
      ath6kl: Cleanup parameters of wlan_node_table_init()
      ath6kl: Move initialization/deinitialization of scan_table to appropriate functions
      ath6kl: Pass only the needed scan_table to ath6kl_wmi_iterate_nodes()
      ath6kl: Remove ath6kl_wmi_iterate_nodes()
      ath6kl: Use ath6kl_cfg80211_scan_node() directly instead of function pointer
      ath6kl: Cleanup void * in ath6kl_cfg80211_scan_node()
      ath6kl: Release ar->lock right afer updating net_stats in ath6kl_rx()
      ath6kl: Minor cleanup in min_hdr_len computation
      ath6kl: Cleanup ath6kl_wmi_data_hdr_remove()
      ath6kl: Fix bug in computing AMSU subframe padding
      ath6kl: Fix buffer alignment for scatter-gather I/O
      ath6kl: Fix system freeze under heavy data load
      ath6kl: Remove unused meta_v2 from ath6kl_data_tx()
      ath6kl: Add wmi meta data information only it is available
      ath6kl: Avoid rolling back of entire scatter setup in case of failure
      ath6kl: Add initial debugfs changes
      ath6kl: Add debugfs entry to dump target stats
      ath6kl: Add debugfs file entry to dump credit distribution stats
      ath6kl: Add debugfs interface to dump diagnostic registers from firmware
      ath6kl: Fix endianness in requesting chip register read
      ath6kl: Make ath6kl_diag_write32() non-static
      ath6kl: Fix endianness in register write
      ath6kl: Add debugfs support to write a chip register
      ath6kl: Remove auth type fall back in auto authentication mode
      ath6kl: Set the sme_state to disconnected in disconnect() callback
      ath6kl: Fix disconnect event reporting
      ath6kl: Remove unnecessary retrieval of first list entry in ath6kl_htc_tx_setup_scat_list()

Vasily Averin (1):
      ipv4: NET_IPV4_ROUTE_GC_INTERVAL removal

Vasu Dev (1):
      ixgbe: disable LLI for FCoE

Vinicius Costa Gomes (15):
      Bluetooth: Reset the security timer when a command is queued
      Bluetooth: Add a flag to indicate that SMP is going on
      Bluetooth: Use the same timeouts for both ACL and LE links
      Bluetooth: Add support for pairing via mgmt over LE
      Bluetooth: Add support for running SMP without a socket
      Bluetooth: Add link_type information to the mgmt Connected event
      Bluetooth: Move SMP fields to a separate structure
      Bluetooth: Move SMP crypto functions to a workqueue
      Bluetooth: Require authentication if MITM protection is requested
      Bluetooth: Use the MEDIUM security level for pairings
      Bluetooth: Fix sending wrong authentication requirements
      Bluetooth: Use the LTK after receiving a LE Security Request
      Revert "Bluetooth: Add support for communicating keys with userspace"
      Bluetooth: Fix not setting a pending security level
      Bluetooth: Remove support for other SMP keys than the LTK

Vivek Natarajan (5):
      ath6kl: Add debugfs entry to modify roaming parameters.
      ath6kl: Process regulatory requests from firmware.
      cfg80211/nl80211: Indicate roaming feature capability to userspace.
      ath6kl: deinitialise wiphy on error
      ath6kl: Indicate the roaming capability of the firmware

Vladimir Zapolskiy (2):
      dm9000: define debug level as a module parameter
      connector: add comm change event report to proc connector

Waldemar Rymarkiewicz (1):
      Bluetooth: Fix possible NULL pointer dereference

Wey-Yi Guy (43):
      iwlagn: default smps mode for 1000 series device
      iwlagn: Remove ht40 support from 5.2GHz for _bgn devices
      iwlagn: change default sensitivity value for 5000 and 6000 series
      iwlagn: support v2 of enhanced sensitivity table
      iwlagn: Rename iwlcore prefix
      iwlagn: remove out-dated comments
      iwlagn: enable 11n aggregation without checking traffic load
      iwlagn: support small form factor SKU of 6205
      iwlagn: more comments for bt channel inhibition
      iwlagn: add comments to module parameters
      iwlagn: adding special "D" SKU for 2000 series
      iwlagn: only perform necessary calibration at init time
      iwlagn: disply queue read/write pointer when stuck
      iwlagn: enable 11n support for "_d" sku
      iwlagn: remove lines from the wrong place
      iwlagn: New SKU for 6005 SFF
      iwlagn: merge eeprom access into single file
      iwlagn: add support for v2 of temperature offset calibration
      iwlagn: use iwl_eeprom_calib_hdr structure
      iwlagn: fix stack corruption for temperature offset v2
      iwlagn: signedness bug
      MAINTAINERS: update iwlwifi
      iwlagn: add debugging to show probe related info in scan notification
      iwlagn: separate init calib and rt calib
      iwlagn: add cmd queue pointer info when timeout
      iwlagn: add REPLY_ECHO host command
      iwlagn: add WARN if tx cmd complete come back late
      iwlagn: add "echo" test when command queue stuck
      iwlagn: check rf kill in queue stuck
      iwlagn: add "echo test" command to debugfs
      iwlagn: remove un-necessary step
      iwlagn: set rts retry limit
      iwlagn: add "_d" sku to 6005 series of devices
      iwlagn: Add "_d" sku to 105 series of devices
      iwlagn: do nothing when disable agg in wrong state
      iwlagn: use low retry limit for WoWLAN
      iwlwifi: update comments on how to enable debug flag
      iwlagn: more info on warning for shutdown agg queue
      iwlagn: don't stop rts/cts until last aggregation queue close
      iwlagn: add debug for mac80211 callback
      iwlagn: rename all the mac80211 callback functions
      iwlagn: merge station management functions
      iwlagn: rename iwl-rx.c to iwl-agn-rx.c

Williams, Mitch A (2):
      igbvf: Update module identification strings
      igbvf: Bump version number

Wolfgang Grandegger (1):
      can/sja1000: driver for PEAK PCAN PCI/PCIe cards

Xiao Jiang (2):
      net/fec: replace hardcoded irq num with macro
      net/fec: add poll controller function for fec nic

Yan, Zheng (1):
      ipv4: fix ipsec forward performance regression

Yaniv Rosner (1):
      bnx2x: Add new PHY BCM54616

Yevgeny Petrilin (6):
      mlx4: Fix vlan table overflow
      mlx4_en: Controlling FCS header removal
      mlx4_en: Checksum counters per ring
      mlx4_en: Recording rx queue for gro packets
      mlx4_en: Adding rxhash support
      mlx4_en: Updating driver version

Ying Xue (4):
      tipc: Add support for SO_SNDTIMEO socket option
      tipc: Simplify prohibition of listen and accept for connectionless sockets
      tipc: Remove callback field from subscription structure
      tipc: Remove unused link event tracking code

Yogesh Ashok Powar (5):
      cfg80211/mac80211: move information element parsing logic to cfg80211
      mwl8k: Set hardware flag IEEE80211_HW_AP_LINK_PS
      mwifiex: replace kmalloc & memcpy sequence with kmemdup
      mwifiex: add cfg80211 handlers add/del_virtual_intf
      mwifiex: fix smatch errors

Yoshihiro Shimoda (4):
      net: sh_eth: use ioremap()
      sh: modify prototype in sh_eth.h
      net: sh_eth: move the asm/sh_eth.h to include/linux/
      net: sh_eth: fix build failure

alex.bluesman.smirnov@gmail.com (1):
      6LoWPAN: fix skb_copy call

brenohl@br.ibm.com (1):
      ehea: Remove sleep at .ndo_get_stats

chetan loke (3):
      af-packet: Added TPACKET_V3 headers.
      af-packet: TPACKET_V3 flexible buffer implementation.
      af_packet: Prefixed tpacket_v3 structs to avoid name space collision

danborkmann@iogearbox.net (1):
      af_packet: remove unnecessary BUG_ON() in tpacket_destruct_skb

frank.blaschka@de.ibm.com (2):
      qdio: support asynchronous delivery of storage blocks
      qdio: support forced signal adapter indications

françois romieu (9):
      via-velocity : update receive packets statistics.
      via-velocity : ethtool statistics support.
      via-velocity : cleanups.
      bnx2: don't request firmware when there's no userspace.
      atm/iphase : removal of PCI space dereferences.
      sc92031: use standard #defines from mii.h.
      rtl8150: removal of forward declarations.
      drivers/net/ethernet: remove unused #define.
      tehuti: shorten PCI device table.

holt@sgi.com (6):
      flexcan: Remove #include <mach/clock.h>
      flexcan: Abstract off read/write for big/little endian.
      flexcan: Fix up fsl-flexcan device tree binding.
      flexcan: Add of_match to platform_device definition.
      flexcan: Prefer device tree clock frequency if available.
      flexcan: Add flexcan device support for p1010rdb.

huajun li (1):
      net/flow: Fix potential memory leak

roy.qing.li@gmail.com (1):
      neigh: fix rcu splat in neigh_update()

sjur.brandeland@stericsson.com (1):
      caif-hsi: HSI Fix uninitialized data in HSI header

stephen hemminger (8):
      wan: make LAPB callbacks const
      pcnet32: constify function table
      bna: make function tables cont
      vxge: make function table const
      sky2: manage irq better on single port card
      bridge: fix ordering of NEWLINK and NEWNEIGH events
      bridge: allow updating existing fdb entries
      bridge: allow forwarding some link local frames

zero.lin (1):
      rt2x00: Add new chipset support

 Documentation/ABI/testing/sysfs-class-net-mesh     |    8 +
 Documentation/DocBook/80211.tmpl                   |   11 +-
 .../devicetree/bindings/net/can/fsl-flexcan.txt    |   63 +-
 Documentation/devicetree/bindings/net/smsc911x.txt |   38 +
 Documentation/feature-removal-schedule.txt         |    9 +
 Documentation/networking/batman-adv.txt            |    8 +-
 Documentation/networking/ip-sysctl.txt             |   17 +-
 Documentation/networking/mac80211-injection.txt    |    4 +
 Documentation/networking/netdevices.txt            |    4 +-
 Documentation/networking/stmmac.txt                |   44 +-
 MAINTAINERS                                        |  218 +-
 arch/cris/arch-v10/drivers/Kconfig                 |    1 +
 arch/cris/arch-v32/drivers/Kconfig                 |    1 +
 arch/ia64/hp/sim/simeth.c                          |    2 +-
 arch/mips/Kconfig                                  |    8 +-
 arch/mips/bcm47xx/Kconfig                          |   31 +
 arch/mips/bcm47xx/Makefile                         |    3 +-
 arch/mips/bcm47xx/gpio.c                           |   82 +-
 arch/mips/bcm47xx/irq.c                            |   12 +
 arch/mips/bcm47xx/nvram.c                          |   29 +-
 arch/mips/bcm47xx/serial.c                         |   46 +-
 arch/mips/bcm47xx/setup.c                          |   90 +-
 arch/mips/bcm47xx/time.c                           |   16 +-
 arch/mips/bcm47xx/wgt634u.c                        |   14 +-
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h       |   26 +-
 arch/mips/include/asm/mach-bcm47xx/gpio.h          |  108 +-
 arch/mips/pci/pci-bcm47xx.c                        |    6 +
 arch/mips/txx9/generic/setup_tx4939.c              |    2 +-
 arch/powerpc/Kconfig                               |    2 +
 arch/powerpc/boot/dts/p1010rdb.dts                 |   10 +-
 arch/powerpc/boot/dts/p1010si.dtsi                 |   10 +-
 arch/powerpc/configs/40x/acadia_defconfig          |   11 +-
 arch/powerpc/configs/40x/ep405_defconfig           |    5 +-
 arch/powerpc/configs/40x/hcu4_defconfig            |    5 +-
 arch/powerpc/configs/40x/kilauea_defconfig         |    9 +-
 arch/powerpc/configs/40x/makalu_defconfig          |    9 +-
 arch/powerpc/configs/40x/walnut_defconfig          |    5 +-
 arch/powerpc/configs/44x/arches_defconfig          |    9 +-
 arch/powerpc/configs/44x/bamboo_defconfig          |    5 +-
 arch/powerpc/configs/44x/bluestone_defconfig       |    9 +-
 arch/powerpc/configs/44x/canyonlands_defconfig     |    9 +-
 arch/powerpc/configs/44x/ebony_defconfig           |    5 +-
 arch/powerpc/configs/44x/eiger_defconfig           |    9 +-
 arch/powerpc/configs/44x/icon_defconfig            |    5 +-
 arch/powerpc/configs/44x/katmai_defconfig          |    5 +-
 arch/powerpc/configs/44x/redwood_defconfig         |   11 +-
 arch/powerpc/configs/44x/sam440ep_defconfig        |    5 +-
 arch/powerpc/configs/44x/sequoia_defconfig         |    5 +-
 arch/powerpc/configs/44x/taishan_defconfig         |    5 +-
 arch/powerpc/configs/44x/warp_defconfig            |    5 +-
 arch/powerpc/configs/ppc40x_defconfig              |    5 +-
 arch/powerpc/configs/ppc44x_defconfig              |    5 +-
 arch/powerpc/platforms/40x/Kconfig                 |   12 +-
 arch/powerpc/platforms/44x/Kconfig                 |   54 +-
 arch/powerpc/platforms/cell/Kconfig                |    8 +-
 arch/s390/include/asm/qdio.h                       |   78 +-
 arch/um/drivers/net_kern.c                         |    2 +-
 arch/xtensa/platforms/iss/network.c                |    2 +-
 drivers/atm/eni.c                                  |    5 +-
 drivers/atm/iphase.c                               |  265 +-
 drivers/atm/iphase.h                               |  391 +-
 drivers/base/class.c                               |   17 +-
 drivers/bcma/Kconfig                               |   13 +
 drivers/bcma/Makefile                              |    2 +
 drivers/bcma/bcma_private.h                        |   16 +
 drivers/bcma/core.c                                |    2 +
 drivers/bcma/driver_chipcommon.c                   |   53 +
 drivers/bcma/driver_chipcommon_pmu.c               |  191 +-
 drivers/bcma/driver_mips.c                         |  256 +
 drivers/bcma/driver_pci.c                          |   16 +-
 drivers/bcma/host_soc.c                            |  183 +
 drivers/bcma/main.c                                |   70 +-
 drivers/bcma/scan.c                                |  348 +-
 drivers/bcma/sprom.c                               |   15 +
 drivers/bluetooth/btusb.c                          |    6 +-
 drivers/connector/cn_proc.c                        |   26 +
 drivers/infiniband/hw/amso1100/c2.c                |   11 +-
 drivers/infiniband/hw/cxgb3/Makefile               |    2 +-
 drivers/infiniband/hw/cxgb4/Makefile               |    2 +-
 drivers/infiniband/hw/mlx4/Kconfig                 |    3 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   29 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   23 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    2 +-
 drivers/net/Kconfig                                | 3448 +---
 drivers/net/Makefile                               |  326 +-
 drivers/net/appletalk/cops.c                       |    2 +-
 drivers/net/appletalk/ltpc.c                       |    2 +-
 drivers/net/arcnet/Kconfig                         |   14 +-
 drivers/net/arcnet/Makefile                        |    1 +
 drivers/net/arcnet/com20020.c                      |    2 +-
 drivers/net/{pcmcia => arcnet}/com20020_cs.c       |    0
 drivers/net/arm/Kconfig                            |   74 -
 drivers/net/arm/Makefile                           |   14 -
 drivers/net/benet/Kconfig                          |    6 -
 drivers/net/bna/bfa_ioc_ct.c                       |  516 -
 drivers/net/bna/bfi_ctreg.h                        |  646 -
 drivers/net/bna/bfi_ll.h                           |  438 -
 drivers/net/bna/bna_ctrl.c                         | 3076 ---
 drivers/net/bna/bna_hw.h                           | 1490 -
 drivers/net/bna/bna_txrx.c                         | 4185 ---
 drivers/net/bonding/bond_3ad.c                     |    7 -
 drivers/net/bonding/bond_main.c                    |   75 +-
 drivers/net/bonding/bond_sysfs.c                   |   46 +-
 drivers/net/bonding/bonding.h                      |    8 +-
 drivers/net/caif/caif_hsi.c                        |  436 +-
 drivers/net/caif/caif_spi.c                        |    4 -
 drivers/net/can/at91_can.c                         |    2 -
 drivers/net/can/dev.c                              |   14 +-
 drivers/net/can/flexcan.c                          |  189 +-
 drivers/net/can/mscan/mscan.c                      |   26 +-
 drivers/net/can/sja1000/Kconfig                    |   14 +
 drivers/net/can/sja1000/Makefile                   |    2 +
 drivers/net/can/sja1000/ems_pcmcia.c               |  331 +
 drivers/net/can/sja1000/peak_pci.c                 |  291 +
 drivers/net/can/sja1000/sja1000.c                  |    2 -
 drivers/net/can/sja1000/sja1000.h                  |    2 -
 drivers/net/can/slcan.c                            |    2 -
 drivers/net/can/vcan.c                             |    2 -
 drivers/net/cris/eth_v10.c                         |    2 +-
 drivers/net/dummy.c                                |    2 +-
 drivers/net/{ => ethernet/3com}/3c501.c            |    2 +-
 drivers/net/{ => ethernet/3com}/3c501.h            |    0
 drivers/net/{ => ethernet/3com}/3c509.c            |    2 +-
 drivers/net/{ => ethernet/3com}/3c515.c            |    2 +-
 drivers/net/{pcmcia => ethernet/3com}/3c574_cs.c   |    2 +-
 drivers/net/{pcmcia => ethernet/3com}/3c589_cs.c   |    2 +-
 drivers/net/{ => ethernet/3com}/3c59x.c            |   15 +-
 drivers/net/ethernet/3com/Kconfig                  |  122 +
 drivers/net/ethernet/3com/Makefile                 |   11 +
 drivers/net/{ => ethernet/3com}/typhoon.c          |   15 +-
 drivers/net/{ => ethernet/3com}/typhoon.h          |    0
 drivers/net/{ => ethernet/8390}/3c503.c            |    2 +-
 drivers/net/{ => ethernet/8390}/3c503.h            |    0
 drivers/net/{ => ethernet/8390}/8390.c             |    2 +-
 drivers/net/{ => ethernet/8390}/8390.h             |    0
 drivers/net/{ => ethernet/8390}/8390p.c            |    2 +-
 drivers/net/ethernet/8390/Kconfig                  |  337 +
 drivers/net/ethernet/8390/Makefile                 |   29 +
 drivers/net/{ => ethernet/8390}/ac3200.c           |    2 +-
 drivers/net/{ => ethernet/8390}/apne.c             |    0
 drivers/net/{ => ethernet/8390}/ax88796.c          |    2 +-
 drivers/net/{pcmcia => ethernet/8390}/axnet_cs.c   |    4 +-
 drivers/net/{ => ethernet/8390}/e2100.c            |    2 +-
 drivers/net/{ => ethernet/8390}/es3210.c           |    0
 drivers/net/{arm => ethernet/8390}/etherh.c        |    4 +-
 drivers/net/{ => ethernet/8390}/hp-plus.c          |    2 +-
 drivers/net/{ => ethernet/8390}/hp.c               |    0
 drivers/net/{ => ethernet/8390}/hydra.c            |    2 +-
 drivers/net/{ => ethernet/8390}/lib8390.c          |    0
 drivers/net/{ => ethernet/8390}/lne390.c           |    0
 drivers/net/{ => ethernet/8390}/mac8390.c          |    2 +-
 drivers/net/{ => ethernet/8390}/ne-h8300.c         |    2 +-
 drivers/net/{ => ethernet/8390}/ne.c               |    0
 drivers/net/{ => ethernet/8390}/ne2.c              |    0
 drivers/net/{ => ethernet/8390}/ne2k-pci.c         |    2 +-
 drivers/net/{ => ethernet/8390}/ne3210.c           |    0
 drivers/net/{pcmcia => ethernet/8390}/pcnet_cs.c   |    4 +-
 drivers/net/{ => ethernet/8390}/smc-mca.c          |    2 +-
 drivers/net/{ => ethernet/8390}/smc-ultra.c        |    2 +-
 drivers/net/{ => ethernet/8390}/smc-ultra32.c      |    2 +-
 drivers/net/{ => ethernet/8390}/stnic.c            |    0
 drivers/net/{ => ethernet/8390}/wd.c               |    2 +-
 drivers/net/{ => ethernet/8390}/zorro8390.c        |    2 +-
 drivers/net/ethernet/Kconfig                       |  177 +
 drivers/net/ethernet/Makefile                      |   74 +
 drivers/net/ethernet/adaptec/Kconfig               |   36 +
 drivers/net/ethernet/adaptec/Makefile              |    5 +
 drivers/net/{ => ethernet/adaptec}/starfire.c      |   13 +-
 drivers/net/ethernet/adi/Kconfig                   |   69 +
 drivers/net/ethernet/adi/Makefile                  |    5 +
 drivers/net/{ => ethernet/adi}/bfin_mac.c          |    2 +-
 drivers/net/{ => ethernet/adi}/bfin_mac.h          |    0
 drivers/net/ethernet/aeroflex/Kconfig              |   11 +
 drivers/net/ethernet/aeroflex/Makefile             |    5 +
 drivers/net/{ => ethernet/aeroflex}/greth.c        |   20 +-
 drivers/net/{ => ethernet/aeroflex}/greth.h        |    0
 drivers/net/ethernet/alteon/Kconfig                |   48 +
 drivers/net/ethernet/alteon/Makefile               |    5 +
 drivers/net/{ => ethernet/alteon}/acenic.c         |   16 +-
 drivers/net/{ => ethernet/alteon}/acenic.h         |    0
 drivers/net/{ => ethernet/amd}/7990.c              |    0
 drivers/net/{ => ethernet/amd}/7990.h              |    0
 drivers/net/ethernet/amd/Kconfig                   |  195 +
 drivers/net/ethernet/amd/Makefile                  |   20 +
 drivers/net/{ => ethernet/amd}/a2065.c             |    2 +-
 drivers/net/{ => ethernet/amd}/a2065.h             |    0
 drivers/net/{arm => ethernet/amd}/am79c961a.c      |    2 +-
 drivers/net/{arm => ethernet/amd}/am79c961a.h      |    0
 drivers/net/{ => ethernet/amd}/amd8111e.c          |    2 +-
 drivers/net/{ => ethernet/amd}/amd8111e.h          |    0
 drivers/net/{ => ethernet/amd}/ariadne.c           |    2 +-
 drivers/net/{ => ethernet/amd}/ariadne.h           |    0
 drivers/net/{ => ethernet/amd}/atarilance.c        |    2 +-
 drivers/net/{ => ethernet/amd}/au1000_eth.c        |    2 +-
 drivers/net/{ => ethernet/amd}/au1000_eth.h        |    0
 drivers/net/{ => ethernet/amd}/declance.c          |    2 +-
 drivers/net/{ => ethernet/amd}/depca.c             |    2 +-
 drivers/net/{ => ethernet/amd}/depca.h             |    2 -
 drivers/net/{ => ethernet/amd}/hplance.c           |    2 +-
 drivers/net/{ => ethernet/amd}/hplance.h           |    0
 drivers/net/{ => ethernet/amd}/lance.c             |    2 +-
 drivers/net/{ => ethernet/amd}/mvme147.c           |    2 +-
 drivers/net/{ => ethernet/amd}/ni65.c              |    2 +-
 drivers/net/{ => ethernet/amd}/ni65.h              |    0
 drivers/net/{pcmcia => ethernet/amd}/nmclan_cs.c   |    2 +-
 drivers/net/{ => ethernet/amd}/pcnet32.c           |  204 +-
 drivers/net/{ => ethernet/amd}/sun3lance.c         |    2 +-
 drivers/net/{ => ethernet/amd}/sunlance.c          |    2 +-
 drivers/net/ethernet/apple/Kconfig                 |   77 +
 drivers/net/ethernet/apple/Makefile                |    8 +
 drivers/net/{ => ethernet/apple}/bmac.c            |    2 +-
 drivers/net/{ => ethernet/apple}/bmac.h            |    0
 drivers/net/{ => ethernet/apple}/mac89x0.c         |    2 +-
 drivers/net/{ => ethernet/apple}/mace.c            |    2 +-
 drivers/net/{ => ethernet/apple}/mace.h            |    0
 drivers/net/{ => ethernet/apple}/macmace.c         |   11 +-
 drivers/net/ethernet/atheros/Kconfig               |   70 +
 drivers/net/ethernet/atheros/Makefile              |    8 +
 drivers/net/{ => ethernet/atheros}/atl1c/Makefile  |    0
 drivers/net/{ => ethernet/atheros}/atl1c/atl1c.h   |    0
 .../{ => ethernet/atheros}/atl1c/atl1c_ethtool.c   |    0
 .../net/{ => ethernet/atheros}/atl1c/atl1c_hw.c    |    0
 .../net/{ => ethernet/atheros}/atl1c/atl1c_hw.h    |    0
 .../net/{ => ethernet/atheros}/atl1c/atl1c_main.c  |   13 +-
 drivers/net/{ => ethernet/atheros}/atl1e/Makefile  |    0
 drivers/net/{ => ethernet/atheros}/atl1e/atl1e.h   |    0
 .../{ => ethernet/atheros}/atl1e/atl1e_ethtool.c   |    0
 .../net/{ => ethernet/atheros}/atl1e/atl1e_hw.c    |    0
 .../net/{ => ethernet/atheros}/atl1e/atl1e_hw.h    |    0
 .../net/{ => ethernet/atheros}/atl1e/atl1e_main.c  |   19 +-
 .../net/{ => ethernet/atheros}/atl1e/atl1e_param.c |    0
 drivers/net/{ => ethernet/atheros}/atlx/Makefile   |    0
 drivers/net/{ => ethernet/atheros}/atlx/atl1.c     |   25 +-
 drivers/net/{ => ethernet/atheros}/atlx/atl1.h     |    0
 drivers/net/{ => ethernet/atheros}/atlx/atl2.c     |    2 +-
 drivers/net/{ => ethernet/atheros}/atlx/atl2.h     |    0
 drivers/net/{ => ethernet/atheros}/atlx/atlx.c     |    0
 drivers/net/{ => ethernet/atheros}/atlx/atlx.h     |    0
 drivers/net/ethernet/broadcom/Kconfig              |  122 +
 drivers/net/ethernet/broadcom/Makefile             |   11 +
 drivers/net/{ => ethernet/broadcom}/b44.c          |    2 +-
 drivers/net/{ => ethernet/broadcom}/b44.h          |    0
 drivers/net/{ => ethernet/broadcom}/bcm63xx_enet.c |    4 +-
 drivers/net/{ => ethernet/broadcom}/bcm63xx_enet.h |    0
 drivers/net/{ => ethernet/broadcom}/bnx2.c         |   94 +-
 drivers/net/{ => ethernet/broadcom}/bnx2.h         |    0
 drivers/net/{ => ethernet/broadcom}/bnx2_fw.h      |    0
 drivers/net/{ => ethernet/broadcom}/bnx2x/Makefile |    0
 drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x.h  |   67 +-
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_cmn.c  |   65 +-
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_cmn.h  |   10 +-
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_dcb.c  |    5 +-
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_dcb.h  |    0
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_dump.h |    0
 .../{ => ethernet/broadcom}/bnx2x/bnx2x_ethtool.c  |   30 +-
 .../{ => ethernet/broadcom}/bnx2x/bnx2x_fw_defs.h  |    0
 .../broadcom}/bnx2x/bnx2x_fw_file_hdr.h            |    0
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_hsi.h  |    2 +
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_init.h |    0
 .../{ => ethernet/broadcom}/bnx2x/bnx2x_init_ops.h |    0
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_link.c |  150 +-
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_link.h |    0
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_main.c |   81 +-
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_reg.h  |    0
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_sp.c   |   67 +-
 .../net/{ => ethernet/broadcom}/bnx2x/bnx2x_sp.h   |    0
 .../{ => ethernet/broadcom}/bnx2x/bnx2x_stats.c    |   46 +-
 .../{ => ethernet/broadcom}/bnx2x/bnx2x_stats.h    |    0
 drivers/net/{ => ethernet/broadcom}/cnic.c         |   35 +-
 drivers/net/{ => ethernet/broadcom}/cnic.h         |    4 +-
 drivers/net/{ => ethernet/broadcom}/cnic_defs.h    |    1 +
 drivers/net/{ => ethernet/broadcom}/cnic_if.h      |    0
 drivers/net/{ => ethernet/broadcom}/sb1250-mac.c   |    2 +-
 drivers/net/{ => ethernet/broadcom}/tg3.c          | 1596 +-
 drivers/net/{ => ethernet/broadcom}/tg3.h          |    4 +
 drivers/net/ethernet/brocade/Kconfig               |   23 +
 drivers/net/ethernet/brocade/Makefile              |    5 +
 drivers/net/ethernet/brocade/bna/Kconfig           |   17 +
 drivers/net/{ => ethernet/brocade}/bna/Makefile    |    5 +-
 drivers/net/{ => ethernet/brocade}/bna/bfa_cee.c   |    5 -
 drivers/net/{ => ethernet/brocade}/bna/bfa_cee.h   |    0
 drivers/net/{ => ethernet/brocade}/bna/bfa_cs.h    |    0
 drivers/net/{ => ethernet/brocade}/bna/bfa_defs.h  |   64 +-
 .../net/{ => ethernet/brocade}/bna/bfa_defs_cna.h  |    8 +-
 .../{ => ethernet/brocade}/bna/bfa_defs_mfg_comm.h |   69 +-
 .../{ => ethernet/brocade}/bna/bfa_defs_status.h   |    0
 drivers/net/{ => ethernet/brocade}/bna/bfa_ioc.c   |  459 +-
 drivers/net/{ => ethernet/brocade}/bna/bfa_ioc.h   |   68 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c      |  878 +
 drivers/net/ethernet/brocade/bna/bfa_msgq.c        |  669 +
 drivers/net/ethernet/brocade/bna/bfa_msgq.h        |  130 +
 drivers/net/{ => ethernet/brocade}/bna/bfi.h       |  257 +-
 drivers/net/{ => ethernet/brocade}/bna/bfi_cna.h   |    0
 drivers/net/ethernet/brocade/bna/bfi_enet.h        |  901 +
 drivers/net/ethernet/brocade/bna/bfi_reg.h         |  452 +
 drivers/net/{ => ethernet/brocade}/bna/bna.h       |  351 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c        | 2144 ++
 drivers/net/ethernet/brocade/bna/bna_hw_defs.h     |  422 +
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c       | 3798 +++
 drivers/net/{ => ethernet/brocade}/bna/bna_types.h |  656 +-
 drivers/net/{ => ethernet/brocade}/bna/bnad.c      | 1178 +-
 drivers/net/{ => ethernet/brocade}/bna/bnad.h      |  101 +-
 .../net/{ => ethernet/brocade}/bna/bnad_ethtool.c  |  490 +-
 drivers/net/{ => ethernet/brocade}/bna/cna.h       |   43 +-
 drivers/net/{ => ethernet/brocade}/bna/cna_fwimg.c |   48 +-
 drivers/net/ethernet/cadence/Kconfig               |   45 +
 drivers/net/ethernet/cadence/Makefile              |    6 +
 drivers/net/{arm => ethernet/cadence}/at91_ether.c |    2 +-
 drivers/net/{arm => ethernet/cadence}/at91_ether.h |    0
 drivers/net/{ => ethernet/cadence}/macb.c          |    2 +-
 drivers/net/{ => ethernet/cadence}/macb.h          |    0
 drivers/net/ethernet/chelsio/Kconfig               |  107 +
 drivers/net/ethernet/chelsio/Makefile              |    8 +
 .../{chelsio => ethernet/chelsio/cxgb}/Makefile    |    0
 .../{chelsio => ethernet/chelsio/cxgb}/common.h    |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/cphy.h  |    0
 .../{chelsio => ethernet/chelsio/cxgb}/cpl5_cmd.h  |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/cxgb2.c |    4 +-
 .../{chelsio => ethernet/chelsio/cxgb}/elmer0.h    |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/espi.c  |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/espi.h  |    0
 .../{chelsio => ethernet/chelsio/cxgb}/fpga_defs.h |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/gmac.h  |    0
 .../{chelsio => ethernet/chelsio/cxgb}/mv88e1xxx.c |    0
 .../{chelsio => ethernet/chelsio/cxgb}/mv88e1xxx.h |    0
 .../{chelsio => ethernet/chelsio/cxgb}/mv88x201x.c |    0
 .../{chelsio => ethernet/chelsio/cxgb}/my3126.c    |    0
 .../{chelsio => ethernet/chelsio/cxgb}/pm3393.c    |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/regs.h  |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/sge.c   |   13 +-
 .../net/{chelsio => ethernet/chelsio/cxgb}/sge.h   |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/subr.c  |    0
 .../chelsio/cxgb}/suni1x10gexp_regs.h              |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/tp.c    |    0
 .../net/{chelsio => ethernet/chelsio/cxgb}/tp.h    |    0
 .../{chelsio => ethernet/chelsio/cxgb}/vsc7326.c   |    0
 .../chelsio/cxgb}/vsc7326_reg.h                    |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/Makefile  |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/adapter.h |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/ael1002.c |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/aq100x.c  |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/common.h  |    0
 .../{ => ethernet/chelsio}/cxgb3/cxgb3_ctl_defs.h  |    0
 .../net/{ => ethernet/chelsio}/cxgb3/cxgb3_defs.h  |    0
 .../net/{ => ethernet/chelsio}/cxgb3/cxgb3_ioctl.h |    0
 .../net/{ => ethernet/chelsio}/cxgb3/cxgb3_main.c  |    3 +-
 .../{ => ethernet/chelsio}/cxgb3/cxgb3_offload.c   |    0
 .../{ => ethernet/chelsio}/cxgb3/cxgb3_offload.h   |    0
 .../chelsio}/cxgb3/firmware_exports.h              |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/l2t.c     |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/l2t.h     |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/mc5.c     |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/regs.h    |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/sge.c     |   16 +-
 .../net/{ => ethernet/chelsio}/cxgb3/sge_defs.h    |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/t3_cpl.h  |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/t3_hw.c   |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/t3cdev.h  |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/version.h |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/vsc8211.c |    0
 drivers/net/{ => ethernet/chelsio}/cxgb3/xgmac.c   |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/Makefile  |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/cxgb4.h   |    2 +-
 .../net/{ => ethernet/chelsio}/cxgb4/cxgb4_main.c  |    5 +-
 .../net/{ => ethernet/chelsio}/cxgb4/cxgb4_uld.h   |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/l2t.c     |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/l2t.h     |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/sge.c     |   49 +-
 drivers/net/{ => ethernet/chelsio}/cxgb4/t4_hw.c   |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/t4_hw.h   |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/t4_msg.h  |    0
 drivers/net/{ => ethernet/chelsio}/cxgb4/t4_regs.h |    0
 .../net/{ => ethernet/chelsio}/cxgb4/t4fw_api.h    |    0
 .../net/{ => ethernet/chelsio}/cxgb4vf/Makefile    |    0
 .../net/{ => ethernet/chelsio}/cxgb4vf/adapter.h   |    2 +-
 .../{ => ethernet/chelsio}/cxgb4vf/cxgb4vf_main.c  |    2 +
 drivers/net/{ => ethernet/chelsio}/cxgb4vf/sge.c   |   94 +-
 .../{ => ethernet/chelsio}/cxgb4vf/t4vf_common.h   |    0
 .../net/{ => ethernet/chelsio}/cxgb4vf/t4vf_defs.h |    0
 .../net/{ => ethernet/chelsio}/cxgb4vf/t4vf_hw.c   |    0
 drivers/net/ethernet/cirrus/Kconfig                |   50 +
 drivers/net/ethernet/cirrus/Makefile               |    6 +
 drivers/net/{ => ethernet/cirrus}/cs89x0.c         |    2 +-
 drivers/net/{ => ethernet/cirrus}/cs89x0.h         |    0
 drivers/net/{arm => ethernet/cirrus}/ep93xx_eth.c  |    0
 drivers/net/ethernet/cisco/Kconfig                 |   23 +
 drivers/net/ethernet/cisco/Makefile                |    5 +
 drivers/net/ethernet/cisco/enic/Kconfig            |    9 +
 drivers/net/{ => ethernet/cisco}/enic/Makefile     |    0
 drivers/net/{ => ethernet/cisco}/enic/cq_desc.h    |    0
 .../net/{ => ethernet/cisco}/enic/cq_enet_desc.h   |    0
 drivers/net/{ => ethernet/cisco}/enic/enic.h       |   15 +-
 drivers/net/{ => ethernet/cisco}/enic/enic_dev.c   |    0
 drivers/net/{ => ethernet/cisco}/enic/enic_dev.h   |   19 +
 drivers/net/{ => ethernet/cisco}/enic/enic_main.c  |  202 +-
 drivers/net/{ => ethernet/cisco}/enic/enic_pp.c    |  192 +-
 drivers/net/{ => ethernet/cisco}/enic/enic_pp.h    |   15 +-
 drivers/net/{ => ethernet/cisco}/enic/enic_res.c   |    0
 drivers/net/{ => ethernet/cisco}/enic/enic_res.h   |    0
 .../net/{ => ethernet/cisco}/enic/rq_enet_desc.h   |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_cq.c    |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_cq.h    |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_dev.c   |   28 +-
 drivers/net/{ => ethernet/cisco}/enic/vnic_dev.h   |    2 +
 .../net/{ => ethernet/cisco}/enic/vnic_devcmd.h    |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_enet.h  |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_intr.c  |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_intr.h  |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_nic.h   |    0
 .../net/{ => ethernet/cisco}/enic/vnic_resource.h  |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_rq.c    |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_rq.h    |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_rss.h   |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_stats.h |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_vic.c   |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_vic.h   |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_wq.c    |    0
 drivers/net/{ => ethernet/cisco}/enic/vnic_wq.h    |    0
 .../net/{ => ethernet/cisco}/enic/wq_enet_desc.h   |    0
 drivers/net/ethernet/davicom/Kconfig               |   24 +
 drivers/net/ethernet/davicom/Makefile              |    5 +
 drivers/net/{ => ethernet/davicom}/dm9000.c        |   13 +-
 drivers/net/{ => ethernet/davicom}/dm9000.h        |    0
 drivers/net/ethernet/dec/Kconfig                   |   37 +
 drivers/net/ethernet/dec/Makefile                  |    6 +
 drivers/net/{ => ethernet/dec}/ewrk3.c             |    2 +-
 drivers/net/{ => ethernet/dec}/ewrk3.h             |    0
 drivers/net/{ => ethernet/dec}/tulip/21142.c       |    0
 drivers/net/{ => ethernet/dec}/tulip/Kconfig       |   21 +-
 drivers/net/{ => ethernet/dec}/tulip/Makefile      |    0
 drivers/net/{ => ethernet/dec}/tulip/de2104x.c     |    2 +-
 drivers/net/{ => ethernet/dec}/tulip/de4x5.c       |    2 +-
 drivers/net/{ => ethernet/dec}/tulip/de4x5.h       |    2 -
 drivers/net/{ => ethernet/dec}/tulip/dmfe.c        |    2 +-
 drivers/net/{ => ethernet/dec}/tulip/eeprom.c      |    0
 drivers/net/{ => ethernet/dec}/tulip/interrupt.c   |    0
 drivers/net/{ => ethernet/dec}/tulip/media.c       |    0
 drivers/net/{ => ethernet/dec}/tulip/pnic.c        |    0
 drivers/net/{ => ethernet/dec}/tulip/pnic2.c       |    0
 drivers/net/{ => ethernet/dec}/tulip/timer.c       |    0
 drivers/net/{ => ethernet/dec}/tulip/tulip.h       |    0
 drivers/net/{ => ethernet/dec}/tulip/tulip_core.c  |    2 +-
 drivers/net/{ => ethernet/dec}/tulip/uli526x.c     |    2 +-
 drivers/net/{ => ethernet/dec}/tulip/winbond-840.c |    2 +-
 drivers/net/{ => ethernet/dec}/tulip/xircom_cb.c   |    0
 drivers/net/ethernet/dlink/Kconfig                 |   86 +
 drivers/net/ethernet/dlink/Makefile                |    8 +
 drivers/net/{ => ethernet/dlink}/de600.c           |    0
 drivers/net/{ => ethernet/dlink}/de600.h           |    0
 drivers/net/{ => ethernet/dlink}/de620.c           |    2 +-
 drivers/net/{ => ethernet/dlink}/de620.h           |    0
 drivers/net/{ => ethernet/dlink}/dl2k.c            |  107 +-
 drivers/net/{ => ethernet/dlink}/dl2k.h            |  110 +-
 drivers/net/{ => ethernet/dlink}/sundance.c        |    2 +-
 drivers/net/{ => ethernet}/dnet.c                  |    0
 drivers/net/{ => ethernet}/dnet.h                  |    0
 drivers/net/ethernet/emulex/Kconfig                |   23 +
 drivers/net/ethernet/emulex/Makefile               |    5 +
 drivers/net/ethernet/emulex/benet/Kconfig          |    6 +
 drivers/net/{ => ethernet/emulex}/benet/Makefile   |    0
 drivers/net/{ => ethernet/emulex}/benet/be.h       |  132 +-
 drivers/net/{ => ethernet/emulex}/benet/be_cmds.c  |  307 +-
 drivers/net/{ => ethernet/emulex}/benet/be_cmds.h  |  104 +-
 .../net/{ => ethernet/emulex}/benet/be_ethtool.c   |  168 +-
 drivers/net/{ => ethernet/emulex}/benet/be_hw.h    |   21 +-
 drivers/net/{ => ethernet/emulex}/benet/be_main.c  |  915 +-
 drivers/net/{ => ethernet}/ethoc.c                 |    2 +-
 drivers/net/ethernet/faraday/Kconfig               |   40 +
 drivers/net/ethernet/faraday/Makefile              |    6 +
 drivers/net/{ => ethernet/faraday}/ftgmac100.c     |    4 +-
 drivers/net/{ => ethernet/faraday}/ftgmac100.h     |    0
 drivers/net/{ => ethernet/faraday}/ftmac100.c      |    5 +-
 drivers/net/{ => ethernet/faraday}/ftmac100.h      |    0
 drivers/net/{ => ethernet}/fealnx.c                |    2 +-
 drivers/net/ethernet/freescale/Kconfig             |   88 +
 drivers/net/ethernet/freescale/Makefile            |   18 +
 drivers/net/{ => ethernet/freescale}/fec.c         |  117 +-
 drivers/net/{ => ethernet/freescale}/fec.h         |    0
 drivers/net/{ => ethernet/freescale}/fec_mpc52xx.c |    2 +-
 drivers/net/{ => ethernet/freescale}/fec_mpc52xx.h |    0
 .../net/{ => ethernet/freescale}/fec_mpc52xx_phy.c |    0
 .../net/{ => ethernet/freescale}/fs_enet/Kconfig   |    3 +-
 .../net/{ => ethernet/freescale}/fs_enet/Makefile  |    0
 drivers/net/{ => ethernet/freescale}/fs_enet/fec.h |    0
 .../freescale}/fs_enet/fs_enet-main.c              |    2 +-
 .../net/{ => ethernet/freescale}/fs_enet/fs_enet.h |    0
 .../net/{ => ethernet/freescale}/fs_enet/mac-fcc.c |    0
 .../net/{ => ethernet/freescale}/fs_enet/mac-fec.c |    0
 .../net/{ => ethernet/freescale}/fs_enet/mac-scc.c |    0
 .../{ => ethernet/freescale}/fs_enet/mii-bitbang.c |    0
 .../net/{ => ethernet/freescale}/fs_enet/mii-fec.c |    0
 drivers/net/{ => ethernet/freescale}/fsl_pq_mdio.c |    0
 drivers/net/{ => ethernet/freescale}/fsl_pq_mdio.h |    0
 drivers/net/{ => ethernet/freescale}/gianfar.c     |   12 +-
 drivers/net/{ => ethernet/freescale}/gianfar.h     |    0
 .../net/{ => ethernet/freescale}/gianfar_ethtool.c |    5 +-
 drivers/net/{ => ethernet/freescale}/gianfar_ptp.c |    0
 .../net/{ => ethernet/freescale}/gianfar_sysfs.c   |    0
 drivers/net/{ => ethernet/freescale}/ucc_geth.c    |   12 +-
 drivers/net/{ => ethernet/freescale}/ucc_geth.h    |    0
 .../{ => ethernet/freescale}/ucc_geth_ethtool.c    |    0
 drivers/net/ethernet/fujitsu/Kconfig               |   54 +
 drivers/net/ethernet/fujitsu/Makefile              |    7 +
 drivers/net/{ => ethernet/fujitsu}/at1700.c        |    2 +-
 drivers/net/{ => ethernet/fujitsu}/eth16i.c        |    2 +-
 .../net/{pcmcia => ethernet/fujitsu}/fmvj18x_cs.c  |    2 +-
 drivers/net/ethernet/hp/Kconfig                    |   32 +
 drivers/net/ethernet/hp/Makefile                   |    5 +
 drivers/net/{ => ethernet/hp}/hp100.c              |    4 +-
 drivers/net/{ => ethernet/hp}/hp100.h              |    0
 drivers/net/{ => ethernet/i825xx}/3c505.c          |    2 +-
 drivers/net/{ => ethernet/i825xx}/3c505.h          |    0
 drivers/net/{ => ethernet/i825xx}/3c507.c          |    0
 drivers/net/{ => ethernet/i825xx}/3c523.c          |    2 +-
 drivers/net/{ => ethernet/i825xx}/3c523.h          |    0
 drivers/net/{ => ethernet/i825xx}/3c527.c          |    2 +-
 drivers/net/{ => ethernet/i825xx}/3c527.h          |    0
 drivers/net/{ => ethernet/i825xx}/82596.c          |    2 +-
 drivers/net/ethernet/i825xx/Kconfig                |  183 +
 drivers/net/ethernet/i825xx/Makefile               |   20 +
 drivers/net/{ => ethernet/i825xx}/eepro.c          |    2 +-
 drivers/net/{ => ethernet/i825xx}/eexpress.c       |    2 +-
 drivers/net/{ => ethernet/i825xx}/eexpress.h       |    0
 drivers/net/{arm => ethernet/i825xx}/ether1.c      |    2 +-
 drivers/net/{arm => ethernet/i825xx}/ether1.h      |    0
 drivers/net/{ => ethernet/i825xx}/lasi_82596.c     |    0
 drivers/net/{ => ethernet/i825xx}/lib82596.c       |    2 +-
 drivers/net/{ => ethernet/i825xx}/lp486e.c         |    2 +-
 drivers/net/{ => ethernet/i825xx}/ni52.c           |    2 +-
 drivers/net/{ => ethernet/i825xx}/ni52.h           |    0
 drivers/net/{ => ethernet/i825xx}/sni_82596.c      |    0
 drivers/net/{ => ethernet/i825xx}/sun3_82586.c     |    2 +-
 drivers/net/{ => ethernet/i825xx}/sun3_82586.h     |    0
 drivers/net/{ => ethernet/i825xx}/znet.c           |    2 +-
 drivers/net/ethernet/ibm/Kconfig                   |   48 +
 drivers/net/ethernet/ibm/Makefile                  |    8 +
 drivers/net/{ => ethernet/ibm}/ehea/Makefile       |    0
 drivers/net/{ => ethernet/ibm}/ehea/ehea.h         |   21 +-
 drivers/net/{ => ethernet/ibm}/ehea/ehea_ethtool.c |   33 +-
 drivers/net/{ => ethernet/ibm}/ehea/ehea_hw.h      |   25 -
 drivers/net/{ => ethernet/ibm}/ehea/ehea_main.c    |  544 +-
 drivers/net/{ => ethernet/ibm}/ehea/ehea_phyp.c    |    0
 drivers/net/{ => ethernet/ibm}/ehea/ehea_phyp.h    |    0
 drivers/net/{ => ethernet/ibm}/ehea/ehea_qmr.c     |    0
 drivers/net/{ => ethernet/ibm}/ehea/ehea_qmr.h     |    2 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/Kconfig |   40 +-
 drivers/net/ethernet/ibm/emac/Makefile             |   11 +
 .../net/{ibm_newemac => ethernet/ibm/emac}/core.c  |   22 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/core.h  |   16 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/debug.c |    0
 .../net/{ibm_newemac => ethernet/ibm/emac}/debug.h |    2 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/emac.h  |    0
 .../net/{ibm_newemac => ethernet/ibm/emac}/mal.c   |    6 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/mal.h   |    4 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/phy.c   |    0
 .../net/{ibm_newemac => ethernet/ibm/emac}/phy.h   |    0
 .../net/{ibm_newemac => ethernet/ibm/emac}/rgmii.c |    0
 .../net/{ibm_newemac => ethernet/ibm/emac}/rgmii.h |    4 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/tah.c   |    0
 .../net/{ibm_newemac => ethernet/ibm/emac}/tah.h   |    4 +-
 .../net/{ibm_newemac => ethernet/ibm/emac}/zmii.c  |    0
 .../net/{ibm_newemac => ethernet/ibm/emac}/zmii.h  |    4 +-
 drivers/net/{ => ethernet/ibm}/ibmveth.c           |   11 +-
 drivers/net/{ => ethernet/ibm}/ibmveth.h           |    0
 drivers/net/{ => ethernet/ibm}/iseries_veth.c      |    2 +-
 drivers/net/ethernet/icplus/Kconfig                |   14 +
 drivers/net/ethernet/icplus/Makefile               |    5 +
 drivers/net/{ => ethernet/icplus}/ipg.c            |  199 +-
 drivers/net/{ => ethernet/icplus}/ipg.h            |    0
 drivers/net/ethernet/intel/Kconfig                 |  222 +
 drivers/net/ethernet/intel/Makefile                |   12 +
 drivers/net/{ => ethernet/intel}/e100.c            |    6 +-
 drivers/net/{ => ethernet/intel}/e1000/Makefile    |    0
 drivers/net/{ => ethernet/intel}/e1000/e1000.h     |   14 +-
 .../net/{ => ethernet/intel}/e1000/e1000_ethtool.c |    4 -
 drivers/net/{ => ethernet/intel}/e1000/e1000_hw.c  |   22 +-
 drivers/net/{ => ethernet/intel}/e1000/e1000_hw.h  |    0
 .../net/{ => ethernet/intel}/e1000/e1000_main.c    |  219 +-
 .../net/{ => ethernet/intel}/e1000/e1000_osdep.h   |    0
 .../net/{ => ethernet/intel}/e1000/e1000_param.c   |    0
 .../intel/e1000e/80003es2lan.c}                    |    9 +-
 drivers/net/{ => ethernet/intel}/e1000e/82571.c    |   25 +-
 drivers/net/{ => ethernet/intel}/e1000e/Makefile   |    2 +-
 drivers/net/{ => ethernet/intel}/e1000e/defines.h  |    0
 drivers/net/{ => ethernet/intel}/e1000e/e1000.h    |   35 +-
 drivers/net/{ => ethernet/intel}/e1000e/ethtool.c  |  101 +-
 drivers/net/{ => ethernet/intel}/e1000e/hw.h       |    0
 drivers/net/{ => ethernet/intel}/e1000e/ich8lan.c  |   69 +-
 drivers/net/{ => ethernet/intel}/e1000e/lib.c      |    0
 drivers/net/{ => ethernet/intel}/e1000e/netdev.c   |  267 +-
 drivers/net/{ => ethernet/intel}/e1000e/param.c    |    0
 drivers/net/{ => ethernet/intel}/e1000e/phy.c      |    0
 drivers/net/{ => ethernet/intel}/igb/Makefile      |    0
 drivers/net/{ => ethernet/intel}/igb/e1000_82575.c |   43 +-
 drivers/net/{ => ethernet/intel}/igb/e1000_82575.h |    2 +
 .../net/{ => ethernet/intel}/igb/e1000_defines.h   |    4 +
 drivers/net/{ => ethernet/intel}/igb/e1000_hw.h    |    0
 drivers/net/{ => ethernet/intel}/igb/e1000_mac.c   |   72 +-
 drivers/net/{ => ethernet/intel}/igb/e1000_mac.h   |    1 +
 drivers/net/{ => ethernet/intel}/igb/e1000_mbx.c   |    0
 drivers/net/{ => ethernet/intel}/igb/e1000_mbx.h   |    0
 drivers/net/{ => ethernet/intel}/igb/e1000_nvm.c   |    0
 drivers/net/{ => ethernet/intel}/igb/e1000_nvm.h   |    0
 drivers/net/{ => ethernet/intel}/igb/e1000_phy.c   |    6 +
 drivers/net/{ => ethernet/intel}/igb/e1000_phy.h   |    0
 drivers/net/{ => ethernet/intel}/igb/e1000_regs.h  |    1 +
 drivers/net/{ => ethernet/intel}/igb/igb.h         |  221 +-
 drivers/net/{ => ethernet/intel}/igb/igb_ethtool.c |   47 +-
 drivers/net/{ => ethernet/intel}/igb/igb_main.c    | 2289 +-
 drivers/net/{ => ethernet/intel}/igbvf/Makefile    |    0
 drivers/net/{ => ethernet/intel}/igbvf/defines.h   |    0
 drivers/net/{ => ethernet/intel}/igbvf/ethtool.c   |   61 -
 drivers/net/{ => ethernet/intel}/igbvf/igbvf.h     |    0
 drivers/net/{ => ethernet/intel}/igbvf/mbx.c       |    0
 drivers/net/{ => ethernet/intel}/igbvf/mbx.h       |    0
 drivers/net/{ => ethernet/intel}/igbvf/netdev.c    |   56 +-
 drivers/net/{ => ethernet/intel}/igbvf/regs.h      |    0
 drivers/net/{ => ethernet/intel}/igbvf/vf.c        |    0
 drivers/net/{ => ethernet/intel}/igbvf/vf.h        |    0
 drivers/net/{ => ethernet/intel}/ixgb/Makefile     |    0
 drivers/net/{ => ethernet/intel}/ixgb/ixgb.h       |    2 +
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_ee.c    |    2 +-
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_ee.h    |    4 +-
 .../net/{ => ethernet/intel}/ixgb/ixgb_ethtool.c   |  102 +-
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_hw.c    |    2 +-
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_hw.h    |    4 +-
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_ids.h   |    0
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_main.c  |   78 +-
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_osdep.h |    1 +
 drivers/net/{ => ethernet/intel}/ixgb/ixgb_param.c |   18 +-
 drivers/net/{ => ethernet/intel}/ixgbe/Makefile    |    0
 drivers/net/{ => ethernet/intel}/ixgbe/ixgbe.h     |   87 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_82598.c   |   45 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_82599.c   |  147 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_common.c  |  188 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_common.h  |    2 +-
 drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb.c |   58 +-
 drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb.h |    7 +-
 .../{ => ethernet/intel}/ixgbe/ixgbe_dcb_82598.c   |    9 +-
 .../{ => ethernet/intel}/ixgbe/ixgbe_dcb_82598.h   |    0
 .../{ => ethernet/intel}/ixgbe/ixgbe_dcb_82599.c   |   56 +-
 .../{ => ethernet/intel}/ixgbe/ixgbe_dcb_82599.h   |    2 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_dcb_nl.c  |  173 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_ethtool.c |  307 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_fcoe.c    |   47 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_fcoe.h    |    2 +
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_main.c    | 2332 +-
 drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_mbx.c |    0
 drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_mbx.h |    0
 drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_phy.c |   33 +-
 drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_phy.h |    0
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_sriov.c   |  255 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_sriov.h   |    6 +
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_type.h    |   80 +-
 .../net/{ => ethernet/intel}/ixgbe/ixgbe_x540.c    |   92 +-
 drivers/net/{ => ethernet/intel}/ixgbevf/Makefile  |    0
 drivers/net/{ => ethernet/intel}/ixgbevf/defines.h |    0
 drivers/net/{ => ethernet/intel}/ixgbevf/ethtool.c |   50 -
 drivers/net/{ => ethernet/intel}/ixgbevf/ixgbevf.h |    8 +-
 .../{ => ethernet/intel}/ixgbevf/ixgbevf_main.c    |  107 +-
 drivers/net/{ => ethernet/intel}/ixgbevf/mbx.c     |    0
 drivers/net/{ => ethernet/intel}/ixgbevf/mbx.h     |    0
 drivers/net/{ => ethernet/intel}/ixgbevf/regs.h    |    0
 drivers/net/{ => ethernet/intel}/ixgbevf/vf.c      |    0
 drivers/net/{ => ethernet/intel}/ixgbevf/vf.h      |    0
 drivers/net/{ => ethernet}/jme.c                   |   15 +-
 drivers/net/{ => ethernet}/jme.h                   |    1 -
 drivers/net/{ => ethernet}/korina.c                |    3 +-
 drivers/net/{ => ethernet}/lantiq_etop.c           |    2 +-
 drivers/net/ethernet/marvell/Kconfig               |  111 +
 drivers/net/ethernet/marvell/Makefile              |    8 +
 drivers/net/{ => ethernet/marvell}/mv643xx_eth.c   |   21 +-
 drivers/net/{ => ethernet/marvell}/pxa168_eth.c    |    0
 drivers/net/{ => ethernet/marvell}/skge.c          |   88 +-
 drivers/net/{ => ethernet/marvell}/skge.h          |    0
 drivers/net/{ => ethernet/marvell}/sky2.c          |  124 +-
 drivers/net/{ => ethernet/marvell}/sky2.h          |    0
 drivers/net/ethernet/mellanox/Kconfig              |   23 +
 drivers/net/ethernet/mellanox/Makefile             |    5 +
 drivers/net/ethernet/mellanox/mlx4/Kconfig         |   27 +
 drivers/net/{ => ethernet/mellanox}/mlx4/Makefile  |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/alloc.c   |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/catas.c   |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/cmd.c     |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/cq.c      |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/en_cq.c   |   31 +-
 .../net/{ => ethernet/mellanox}/mlx4/en_ethtool.c  |   14 +-
 drivers/net/{ => ethernet/mellanox}/mlx4/en_main.c |    6 +-
 .../net/{ => ethernet/mellanox}/mlx4/en_netdev.c   |  116 +-
 drivers/net/{ => ethernet/mellanox}/mlx4/en_port.c |   24 +-
 drivers/net/{ => ethernet/mellanox}/mlx4/en_port.h |   11 +-
 .../{ => ethernet/mellanox}/mlx4/en_resources.c    |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/en_rx.c   |   74 +-
 .../net/{ => ethernet/mellanox}/mlx4/en_selftest.c |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/en_tx.c   |   32 +-
 drivers/net/{ => ethernet/mellanox}/mlx4/eq.c      |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/fw.c      |    1 +
 drivers/net/{ => ethernet/mellanox}/mlx4/fw.h      |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/icm.c     |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/icm.h     |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/intf.c    |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/main.c    |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/mcg.c     |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/mlx4.h    |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/mlx4_en.h |   22 +-
 drivers/net/{ => ethernet/mellanox}/mlx4/mr.c      |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/pd.c      |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/port.c    |   15 +-
 drivers/net/{ => ethernet/mellanox}/mlx4/profile.c |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/qp.c      |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/reset.c   |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/sense.c   |    0
 drivers/net/{ => ethernet/mellanox}/mlx4/srq.c     |    0
 drivers/net/ethernet/micrel/Kconfig                |   69 +
 drivers/net/ethernet/micrel/Makefile               |    9 +
 drivers/net/{arm => ethernet/micrel}/ks8695net.c   |    2 +-
 drivers/net/{arm => ethernet/micrel}/ks8695net.h   |    0
 drivers/net/{ => ethernet/micrel}/ks8842.c         |    0
 drivers/net/{ => ethernet/micrel}/ks8851.c         |    0
 drivers/net/{ => ethernet/micrel}/ks8851.h         |    0
 drivers/net/{ => ethernet/micrel}/ks8851_mll.c     |    0
 drivers/net/{ => ethernet/micrel}/ksz884x.c        |    5 +-
 drivers/net/ethernet/microchip/Kconfig             |   38 +
 drivers/net/ethernet/microchip/Makefile            |    5 +
 drivers/net/{ => ethernet/microchip}/enc28j60.c    |    2 +-
 drivers/net/{ => ethernet/microchip}/enc28j60_hw.h |    0
 drivers/net/{ => ethernet}/mipsnet.c               |    2 +-
 drivers/net/ethernet/myricom/Kconfig               |   47 +
 drivers/net/ethernet/myricom/Makefile              |    5 +
 .../net/{ => ethernet/myricom}/myri10ge/Makefile   |    0
 .../net/{ => ethernet/myricom}/myri10ge/myri10ge.c |   31 +-
 .../{ => ethernet/myricom}/myri10ge/myri10ge_mcp.h |    0
 .../myricom}/myri10ge/myri10ge_mcp_gen_header.h    |    0
 drivers/net/ethernet/natsemi/Kconfig               |   83 +
 drivers/net/ethernet/natsemi/Makefile              |   10 +
 drivers/net/{ => ethernet/natsemi}/ibmlana.c       |    2 +-
 drivers/net/{ => ethernet/natsemi}/ibmlana.h       |    0
 drivers/net/{ => ethernet/natsemi}/jazzsonic.c     |    2 +-
 drivers/net/{ => ethernet/natsemi}/macsonic.c      |   11 +-
 drivers/net/{ => ethernet/natsemi}/natsemi.c       |    2 +-
 drivers/net/{ => ethernet/natsemi}/ns83820.c       |    9 +-
 drivers/net/{ => ethernet/natsemi}/sonic.c         |    0
 drivers/net/{ => ethernet/natsemi}/sonic.h         |    0
 drivers/net/{ => ethernet/natsemi}/xtsonic.c       |    2 +-
 drivers/net/ethernet/neterion/Kconfig              |   55 +
 drivers/net/ethernet/neterion/Makefile             |    6 +
 drivers/net/{ => ethernet/neterion}/s2io-regs.h    |    0
 drivers/net/{ => ethernet/neterion}/s2io.c         |   22 +-
 drivers/net/{ => ethernet/neterion}/s2io.h         |    0
 drivers/net/{ => ethernet/neterion}/vxge/Makefile  |    0
 .../net/{ => ethernet/neterion}/vxge/vxge-config.c |   11 +-
 .../net/{ => ethernet/neterion}/vxge/vxge-config.h |    4 +-
 .../{ => ethernet/neterion}/vxge/vxge-ethtool.c    |    0
 .../{ => ethernet/neterion}/vxge/vxge-ethtool.h    |    0
 .../net/{ => ethernet/neterion}/vxge/vxge-main.c   |   30 +-
 .../net/{ => ethernet/neterion}/vxge/vxge-main.h   |    0
 .../net/{ => ethernet/neterion}/vxge/vxge-reg.h    |    0
 .../{ => ethernet/neterion}/vxge/vxge-traffic.c    |   12 +-
 .../{ => ethernet/neterion}/vxge/vxge-traffic.h    |    0
 .../{ => ethernet/neterion}/vxge/vxge-version.h    |    0
 drivers/net/{ => ethernet}/netx-eth.c              |    2 +-
 drivers/net/ethernet/nuvoton/Kconfig               |   31 +
 drivers/net/ethernet/nuvoton/Makefile              |    5 +
 .../net/{arm => ethernet/nuvoton}/w90p910_ether.c  |    2 +-
 drivers/net/ethernet/nvidia/Kconfig                |   32 +
 drivers/net/ethernet/nvidia/Makefile               |    5 +
 drivers/net/{ => ethernet/nvidia}/forcedeth.c      |   40 +-
 drivers/net/{ => ethernet}/octeon/Kconfig          |    6 +-
 drivers/net/ethernet/octeon/Makefile               |    5 +
 drivers/net/{ => ethernet}/octeon/octeon_mgmt.c    |    4 +-
 drivers/net/ethernet/oki-semi/Kconfig              |   23 +
 drivers/net/ethernet/oki-semi/Makefile             |    5 +
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig      |   22 +
 .../net/{ => ethernet/oki-semi}/pch_gbe/Makefile   |    0
 .../net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe.h  |    0
 .../{ => ethernet/oki-semi}/pch_gbe/pch_gbe_api.c  |    0
 .../{ => ethernet/oki-semi}/pch_gbe/pch_gbe_api.h  |    0
 .../oki-semi}/pch_gbe/pch_gbe_ethtool.c            |    4 -
 .../{ => ethernet/oki-semi}/pch_gbe/pch_gbe_main.c |    3 +-
 .../oki-semi}/pch_gbe/pch_gbe_param.c              |    0
 .../{ => ethernet/oki-semi}/pch_gbe/pch_gbe_phy.c  |    0
 .../{ => ethernet/oki-semi}/pch_gbe/pch_gbe_phy.h  |    0
 drivers/net/ethernet/packetengines/Kconfig         |   47 +
 drivers/net/ethernet/packetengines/Makefile        |    6 +
 drivers/net/{ => ethernet/packetengines}/hamachi.c |    2 +-
 .../net/{ => ethernet/packetengines}/yellowfin.c   |    2 +-
 drivers/net/ethernet/pasemi/Kconfig                |   30 +
 drivers/net/ethernet/pasemi/Makefile               |    5 +
 drivers/net/{ => ethernet/pasemi}/pasemi_mac.c     |   15 +-
 drivers/net/{ => ethernet/pasemi}/pasemi_mac.h     |    0
 .../net/{ => ethernet/pasemi}/pasemi_mac_ethtool.c |    0
 drivers/net/ethernet/qlogic/Kconfig                |   54 +
 drivers/net/ethernet/qlogic/Makefile               |    8 +
 drivers/net/{ => ethernet/qlogic}/netxen/Makefile  |    0
 .../net/{ => ethernet/qlogic}/netxen/netxen_nic.h  |   10 +-
 .../{ => ethernet/qlogic}/netxen/netxen_nic_ctx.c  |    0
 .../qlogic}/netxen/netxen_nic_ethtool.c            |    3 -
 .../{ => ethernet/qlogic}/netxen/netxen_nic_hdr.h  |    0
 .../{ => ethernet/qlogic}/netxen/netxen_nic_hw.c   |    0
 .../{ => ethernet/qlogic}/netxen/netxen_nic_hw.h   |    0
 .../{ => ethernet/qlogic}/netxen/netxen_nic_init.c |    8 +-
 .../{ => ethernet/qlogic}/netxen/netxen_nic_main.c |  178 +-
 drivers/net/{ => ethernet/qlogic}/qla3xxx.c        |   14 +-
 drivers/net/{ => ethernet/qlogic}/qla3xxx.h        |    0
 drivers/net/{ => ethernet/qlogic}/qlcnic/Makefile  |    0
 drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic.h  |   32 +-
 .../net/{ => ethernet/qlogic}/qlcnic/qlcnic_ctx.c  |  312 +-
 .../{ => ethernet/qlogic}/qlcnic/qlcnic_ethtool.c  |   56 +-
 .../net/{ => ethernet/qlogic}/qlcnic/qlcnic_hdr.h  |    4 +-
 .../net/{ => ethernet/qlogic}/qlcnic/qlcnic_hw.c   |    4 +-
 .../net/{ => ethernet/qlogic}/qlcnic/qlcnic_init.c |   21 +-
 .../net/{ => ethernet/qlogic}/qlcnic/qlcnic_main.c |  185 +-
 drivers/net/{ => ethernet/qlogic}/qlge/Makefile    |    0
 drivers/net/{ => ethernet/qlogic}/qlge/qlge.h      |    0
 drivers/net/{ => ethernet/qlogic}/qlge/qlge_dbg.c  |    0
 .../net/{ => ethernet/qlogic}/qlge/qlge_ethtool.c  |    0
 drivers/net/{ => ethernet/qlogic}/qlge/qlge_main.c |   26 +-
 drivers/net/{ => ethernet/qlogic}/qlge/qlge_mpi.c  |    0
 drivers/net/ethernet/racal/Kconfig                 |   33 +
 drivers/net/ethernet/racal/Makefile                |    5 +
 drivers/net/{ => ethernet/racal}/ni5010.c          |    2 +-
 drivers/net/{ => ethernet/racal}/ni5010.h          |    0
 drivers/net/ethernet/rdc/Kconfig                   |   35 +
 drivers/net/ethernet/rdc/Makefile                  |    5 +
 drivers/net/{ => ethernet/rdc}/r6040.c             |   10 +-
 drivers/net/{ => ethernet/realtek}/8139cp.c        |   19 +-
 drivers/net/{ => ethernet/realtek}/8139too.c       |    2 +-
 drivers/net/ethernet/realtek/Kconfig               |  130 +
 drivers/net/ethernet/realtek/Makefile              |    9 +
 drivers/net/{ => ethernet/realtek}/atp.c           |    2 +-
 drivers/net/{ => ethernet/realtek}/atp.h           |    0
 drivers/net/{ => ethernet/realtek}/r8169.c         |  495 +-
 drivers/net/{ => ethernet/realtek}/sc92031.c       |   10 +-
 drivers/net/ethernet/renesas/Kconfig               |   19 +
 drivers/net/ethernet/renesas/Makefile              |    5 +
 drivers/net/{ => ethernet/renesas}/sh_eth.c        |   44 +-
 drivers/net/{ => ethernet/renesas}/sh_eth.h        |   17 +-
 drivers/net/{ => ethernet}/s6gmac.c                |    0
 drivers/net/ethernet/seeq/Kconfig                  |   47 +
 drivers/net/ethernet/seeq/Makefile                 |    7 +
 drivers/net/{arm => ethernet/seeq}/ether3.c        |    2 +-
 drivers/net/{arm => ethernet/seeq}/ether3.h        |    0
 drivers/net/{ => ethernet/seeq}/seeq8005.c         |    2 +-
 drivers/net/{ => ethernet/seeq}/seeq8005.h         |    0
 drivers/net/{ => ethernet/seeq}/sgiseeq.c          |    2 +-
 drivers/net/{ => ethernet/seeq}/sgiseeq.h          |    0
 drivers/net/{ => ethernet}/sfc/Kconfig             |    4 +-
 drivers/net/{ => ethernet}/sfc/Makefile            |    0
 drivers/net/{ => ethernet}/sfc/bitfield.h          |    0
 drivers/net/{ => ethernet}/sfc/efx.c               |   46 +-
 drivers/net/{ => ethernet}/sfc/efx.h               |    7 +-
 drivers/net/{ => ethernet}/sfc/enum.h              |    0
 drivers/net/{ => ethernet}/sfc/ethtool.c           |  111 +-
 drivers/net/{ => ethernet}/sfc/falcon.c            |    2 +
 drivers/net/{ => ethernet}/sfc/falcon_boards.c     |    0
 drivers/net/{ => ethernet}/sfc/falcon_xmac.c       |    0
 drivers/net/{ => ethernet}/sfc/filter.c            |    0
 drivers/net/{ => ethernet}/sfc/filter.h            |    0
 drivers/net/{ => ethernet}/sfc/io.h                |    0
 drivers/net/{ => ethernet}/sfc/mac.h               |    0
 drivers/net/{ => ethernet}/sfc/mcdi.c              |    0
 drivers/net/{ => ethernet}/sfc/mcdi.h              |    0
 drivers/net/{ => ethernet}/sfc/mcdi_mac.c          |    0
 drivers/net/{ => ethernet}/sfc/mcdi_pcol.h         |    0
 drivers/net/{ => ethernet}/sfc/mcdi_phy.c          |    0
 drivers/net/{ => ethernet}/sfc/mdio_10g.c          |    0
 drivers/net/{ => ethernet}/sfc/mdio_10g.h          |    0
 drivers/net/{ => ethernet}/sfc/mtd.c               |    0
 drivers/net/{ => ethernet}/sfc/net_driver.h        |    0
 drivers/net/{ => ethernet}/sfc/nic.c               |    0
 drivers/net/{ => ethernet}/sfc/nic.h               |    3 +-
 drivers/net/{ => ethernet}/sfc/phy.h               |    0
 drivers/net/{ => ethernet}/sfc/qt202x_phy.c        |    0
 drivers/net/{ => ethernet}/sfc/regs.h              |    0
 drivers/net/{ => ethernet}/sfc/rx.c                |    4 +-
 drivers/net/{ => ethernet}/sfc/selftest.c          |    0
 drivers/net/{ => ethernet}/sfc/selftest.h          |    0
 drivers/net/{ => ethernet}/sfc/siena.c             |    2 +
 drivers/net/{ => ethernet}/sfc/spi.h               |    0
 drivers/net/{ => ethernet}/sfc/tenxpress.c         |    0
 drivers/net/{ => ethernet}/sfc/tx.c                |   21 +-
 drivers/net/{ => ethernet}/sfc/txc43128_phy.c      |    0
 drivers/net/{ => ethernet}/sfc/workarounds.h       |    0
 drivers/net/ethernet/sgi/Kconfig                   |   36 +
 drivers/net/ethernet/sgi/Makefile                  |    6 +
 drivers/net/{ => ethernet/sgi}/ioc3-eth.c          |    2 +-
 drivers/net/{ => ethernet/sgi}/meth.c              |    0
 drivers/net/{ => ethernet/sgi}/meth.h              |    0
 drivers/net/ethernet/sis/Kconfig                   |   53 +
 drivers/net/ethernet/sis/Makefile                  |    6 +
 drivers/net/{ => ethernet/sis}/sis190.c            |    2 +-
 drivers/net/{ => ethernet/sis}/sis900.c            |    2 +-
 drivers/net/{ => ethernet/sis}/sis900.h            |    0
 drivers/net/ethernet/smsc/Kconfig                  |  137 +
 drivers/net/ethernet/smsc/Makefile                 |   11 +
 drivers/net/{ => ethernet/smsc}/epic100.c          |    2 +-
 drivers/net/{ => ethernet/smsc}/smc911x.c          |    2 +-
 drivers/net/{ => ethernet/smsc}/smc911x.h          |    0
 drivers/net/{ => ethernet/smsc}/smc9194.c          |    2 +-
 drivers/net/{ => ethernet/smsc}/smc9194.h          |    0
 .../net/{pcmcia => ethernet/smsc}/smc91c92_cs.c    |    2 +-
 drivers/net/{ => ethernet/smsc}/smc91x.c           |    2 +-
 drivers/net/{ => ethernet/smsc}/smc91x.h           |    0
 drivers/net/{ => ethernet/smsc}/smsc911x.c         |   89 +-
 drivers/net/{ => ethernet/smsc}/smsc911x.h         |    0
 drivers/net/{ => ethernet/smsc}/smsc9420.c         |    2 +-
 drivers/net/{ => ethernet/smsc}/smsc9420.h         |    0
 drivers/net/ethernet/stmicro/Kconfig               |   23 +
 drivers/net/ethernet/stmicro/Makefile              |    5 +
 drivers/net/{ => ethernet/stmicro}/stmmac/Kconfig  |   41 +-
 drivers/net/{ => ethernet/stmicro}/stmmac/Makefile |    5 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |  137 +
 drivers/net/{ => ethernet/stmicro}/stmmac/common.h |   89 +-
 drivers/net/{ => ethernet/stmicro}/stmmac/descs.h  |    0
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |  126 +
 .../net/{ => ethernet/stmicro}/stmmac/dwmac100.h   |    0
 .../net/{ => ethernet/stmicro}/stmmac/dwmac1000.h  |    0
 .../{ => ethernet/stmicro}/stmmac/dwmac1000_core.c |   11 +-
 .../{ => ethernet/stmicro}/stmmac/dwmac1000_dma.c  |   14 +-
 .../{ => ethernet/stmicro}/stmmac/dwmac100_core.c  |   12 +-
 .../{ => ethernet/stmicro}/stmmac/dwmac100_dma.c   |    0
 .../net/{ => ethernet/stmicro}/stmmac/dwmac_dma.h  |    1 +
 .../net/{ => ethernet/stmicro}/stmmac/dwmac_lib.c  |    0
 .../net/{ => ethernet/stmicro}/stmmac/enh_desc.c   |   22 +-
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |  131 +
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |  265 +
 .../net/{ => ethernet/stmicro}/stmmac/norm_desc.c  |   14 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |  126 +
 drivers/net/{ => ethernet/stmicro}/stmmac/stmmac.h |    8 +-
 .../{ => ethernet/stmicro}/stmmac/stmmac_ethtool.c |  148 +-
 .../{ => ethernet/stmicro}/stmmac/stmmac_main.c    |  479 +-
 .../{ => ethernet/stmicro}/stmmac/stmmac_mdio.c    |    0
 .../{ => ethernet/stmicro}/stmmac/stmmac_timer.c   |    0
 .../{ => ethernet/stmicro}/stmmac/stmmac_timer.h   |    0
 drivers/net/ethernet/sun/Kconfig                   |   88 +
 drivers/net/ethernet/sun/Makefile                  |   11 +
 drivers/net/{ => ethernet/sun}/cassini.c           |   25 +-
 drivers/net/{ => ethernet/sun}/cassini.h           |    0
 drivers/net/{ => ethernet/sun}/niu.c               |   34 +-
 drivers/net/{ => ethernet/sun}/niu.h               |    0
 drivers/net/{ => ethernet/sun}/sunbmac.c           |   33 +-
 drivers/net/{ => ethernet/sun}/sunbmac.h           |   17 -
 drivers/net/{ => ethernet/sun}/sungem.c            |   16 +-
 drivers/net/{ => ethernet/sun}/sungem.h            |    0
 drivers/net/{ => ethernet/sun}/sunhme.c            |   11 +-
 drivers/net/{ => ethernet/sun}/sunhme.h            |    0
 drivers/net/{ => ethernet/sun}/sunqe.c             |    2 +-
 drivers/net/{ => ethernet/sun}/sunqe.h             |    0
 drivers/net/{ => ethernet/sun}/sunvnet.c           |    2 +-
 drivers/net/{ => ethernet/sun}/sunvnet.h           |    0
 drivers/net/ethernet/tehuti/Kconfig                |   27 +
 drivers/net/ethernet/tehuti/Makefile               |    5 +
 drivers/net/{ => ethernet/tehuti}/tehuti.c         |   20 +-
 drivers/net/{ => ethernet/tehuti}/tehuti.h         |    0
 drivers/net/ethernet/ti/Kconfig                    |   77 +
 drivers/net/ethernet/ti/Makefile                   |    9 +
 drivers/net/{ => ethernet/ti}/cpmac.c              |    2 +-
 drivers/net/{ => ethernet/ti}/davinci_cpdma.c      |    0
 drivers/net/{ => ethernet/ti}/davinci_cpdma.h      |    0
 drivers/net/{ => ethernet/ti}/davinci_emac.c       |    2 +-
 drivers/net/{ => ethernet/ti}/davinci_mdio.c       |    0
 drivers/net/{ => ethernet/ti}/tlan.c               |    2 +-
 drivers/net/{ => ethernet/ti}/tlan.h               |    0
 drivers/net/ethernet/tile/Kconfig                  |   15 +
 drivers/net/{ => ethernet}/tile/Makefile           |    0
 drivers/net/{ => ethernet}/tile/tilepro.c          |    2 +-
 drivers/net/ethernet/toshiba/Kconfig               |   57 +
 drivers/net/ethernet/toshiba/Makefile              |   10 +
 drivers/net/{ => ethernet/toshiba}/ps3_gelic_net.c |    2 +-
 drivers/net/{ => ethernet/toshiba}/ps3_gelic_net.h |    0
 .../{ => ethernet/toshiba}/ps3_gelic_wireless.c    |    2 +-
 .../{ => ethernet/toshiba}/ps3_gelic_wireless.h    |    0
 drivers/net/{ => ethernet/toshiba}/spider_net.c    |    6 +-
 drivers/net/{ => ethernet/toshiba}/spider_net.h    |    2 +-
 .../{ => ethernet/toshiba}/spider_net_ethtool.c    |    0
 drivers/net/{ => ethernet/toshiba}/tc35815.c       |    2 +-
 drivers/net/ethernet/tundra/Kconfig                |   29 +
 drivers/net/ethernet/tundra/Makefile               |    5 +
 drivers/net/{ => ethernet/tundra}/tsi108_eth.c     |   13 +-
 drivers/net/{ => ethernet/tundra}/tsi108_eth.h     |    0
 drivers/net/ethernet/via/Kconfig                   |   59 +
 drivers/net/ethernet/via/Makefile                  |    6 +
 drivers/net/{ => ethernet/via}/via-rhine.c         |    2 +-
 drivers/net/{ => ethernet/via}/via-velocity.c      |  159 +-
 drivers/net/{ => ethernet/via}/via-velocity.h      |    0
 drivers/net/ethernet/xilinx/Kconfig                |   36 +
 drivers/net/ethernet/xilinx/Makefile               |    7 +
 drivers/net/{ => ethernet/xilinx}/ll_temac.h       |    0
 drivers/net/{ => ethernet/xilinx}/ll_temac_main.c  |   35 +-
 drivers/net/{ => ethernet/xilinx}/ll_temac_mdio.c  |    0
 .../net/{ => ethernet/xilinx}/xilinx_emaclite.c    |    0
 drivers/net/ethernet/xircom/Kconfig                |   31 +
 drivers/net/ethernet/xircom/Makefile               |    5 +
 .../net/{pcmcia => ethernet/xircom}/xirc2ps_cs.c   |    2 +-
 drivers/net/ethernet/xscale/Kconfig                |   32 +
 drivers/net/ethernet/xscale/Makefile               |    6 +
 drivers/net/{ => ethernet/xscale}/ixp2000/Kconfig  |    2 +-
 drivers/net/{ => ethernet/xscale}/ixp2000/Makefile |    0
 drivers/net/{ => ethernet/xscale}/ixp2000/caleb.c  |    0
 drivers/net/{ => ethernet/xscale}/ixp2000/caleb.h  |    0
 .../net/{ => ethernet/xscale}/ixp2000/enp2611.c    |    0
 .../{ => ethernet/xscale}/ixp2000/ixp2400-msf.c    |    0
 .../{ => ethernet/xscale}/ixp2000/ixp2400-msf.h    |    0
 .../{ => ethernet/xscale}/ixp2000/ixp2400_rx.uc    |    0
 .../{ => ethernet/xscale}/ixp2000/ixp2400_rx.ucode |    0
 .../{ => ethernet/xscale}/ixp2000/ixp2400_tx.uc    |    0
 .../{ => ethernet/xscale}/ixp2000/ixp2400_tx.ucode |    0
 drivers/net/{ => ethernet/xscale}/ixp2000/ixpdev.c |    0
 drivers/net/{ => ethernet/xscale}/ixp2000/ixpdev.h |    0
 .../{ => ethernet/xscale}/ixp2000/ixpdev_priv.h    |    0
 drivers/net/{ => ethernet/xscale}/ixp2000/pm3386.c |    0
 drivers/net/{ => ethernet/xscale}/ixp2000/pm3386.h |    0
 drivers/net/{arm => ethernet/xscale}/ixp4xx_eth.c  |    2 +-
 drivers/net/fddi/Kconfig                           |   77 +
 drivers/net/fddi/Makefile                          |    6 +
 drivers/net/{ => fddi}/defxx.c                     |    2 +-
 drivers/net/{ => fddi}/defxx.h                     |    0
 drivers/net/{ => fddi}/skfp/Makefile               |    0
 drivers/net/{ => fddi}/skfp/cfm.c                  |    0
 drivers/net/{ => fddi}/skfp/drvfbi.c               |    0
 drivers/net/{ => fddi}/skfp/ecm.c                  |    0
 drivers/net/{ => fddi}/skfp/ess.c                  |    0
 drivers/net/{ => fddi}/skfp/fplustm.c              |    0
 drivers/net/{ => fddi}/skfp/h/cmtdef.h             |    4 +-
 drivers/net/{ => fddi}/skfp/h/fddi.h               |    0
 drivers/net/{ => fddi}/skfp/h/fddimib.h            |    0
 drivers/net/{ => fddi}/skfp/h/fplustm.h            |    0
 drivers/net/{ => fddi}/skfp/h/hwmtm.h              |    2 +-
 drivers/net/{ => fddi}/skfp/h/mbuf.h               |    0
 drivers/net/{ => fddi}/skfp/h/osdef1st.h           |    0
 drivers/net/{ => fddi}/skfp/h/sba.h                |    4 +-
 drivers/net/{ => fddi}/skfp/h/sba_def.h            |    0
 drivers/net/{ => fddi}/skfp/h/skfbi.h              |    0
 drivers/net/{ => fddi}/skfp/h/skfbiinc.h           |    2 +-
 drivers/net/{ => fddi}/skfp/h/smc.h                |   14 +-
 drivers/net/{ => fddi}/skfp/h/smt.h                |    0
 drivers/net/{ => fddi}/skfp/h/smt_p.h              |    0
 drivers/net/{ => fddi}/skfp/h/smtstate.h           |    0
 drivers/net/{ => fddi}/skfp/h/supern_2.h           |    0
 drivers/net/{ => fddi}/skfp/h/targethw.h           |    6 +-
 drivers/net/{ => fddi}/skfp/h/targetos.h           |    2 +-
 drivers/net/{ => fddi}/skfp/h/types.h              |    0
 drivers/net/{ => fddi}/skfp/hwmtm.c                |    0
 drivers/net/{ => fddi}/skfp/hwt.c                  |    0
 drivers/net/{ => fddi}/skfp/pcmplc.c               |    0
 drivers/net/{ => fddi}/skfp/pmf.c                  |    0
 drivers/net/{ => fddi}/skfp/queue.c                |    0
 drivers/net/{ => fddi}/skfp/rmt.c                  |    0
 drivers/net/{ => fddi}/skfp/skfddi.c               |    2 +-
 drivers/net/{ => fddi}/skfp/smt.c                  |    0
 drivers/net/{ => fddi}/skfp/smtdef.c               |    0
 drivers/net/{ => fddi}/skfp/smtinit.c              |    0
 drivers/net/{ => fddi}/skfp/smttimer.c             |    0
 drivers/net/{ => fddi}/skfp/srf.c                  |    0
 drivers/net/hippi/Kconfig                          |   39 +
 drivers/net/hippi/Makefile                         |    5 +
 drivers/net/{ => hippi}/rrunner.c                  |    0
 drivers/net/{ => hippi}/rrunner.h                  |    0
 drivers/net/ibm_newemac/Makefile                   |   11 -
 drivers/net/irda/sh_irda.c                         |  124 +-
 drivers/net/macvlan.c                              |    8 +-
 drivers/net/macvtap.c                              |  183 +-
 drivers/net/octeon/Makefile                        |    2 -
 drivers/net/pci-skeleton.c                         | 1923 --
 drivers/net/pcmcia/Kconfig                         |  123 -
 drivers/net/pcmcia/Makefile                        |   16 -
 drivers/net/phy/Kconfig                            |    2 +-
 drivers/net/phy/dp83640.c                          |  214 +-
 drivers/net/phy/icplus.c                           |  100 +-
 drivers/net/phy/mdio-gpio.c                        |    2 +-
 drivers/net/phy/phy_device.c                       |    4 +-
 drivers/net/phy/vitesse.c                          |   34 +-
 drivers/net/plip/Kconfig                           |   38 +
 drivers/net/plip/Makefile                          |    5 +
 drivers/net/{ => plip}/plip.c                      |    0
 drivers/net/ppp/Kconfig                            |  175 +
 drivers/net/ppp/Makefile                           |   13 +
 drivers/net/{ => ppp}/bsd_comp.c                   |    0
 drivers/net/{ => ppp}/ppp_async.c                  |    0
 drivers/net/{ => ppp}/ppp_deflate.c                |    0
 drivers/net/{ => ppp}/ppp_generic.c                |    0
 drivers/net/{ => ppp}/ppp_mppe.c                   |    0
 drivers/net/{ => ppp}/ppp_mppe.h                   |    0
 drivers/net/{ => ppp}/ppp_synctty.c                |    0
 drivers/net/{ => ppp}/pppoe.c                      |    0
 drivers/net/{ => ppp}/pppox.c                      |    0
 drivers/net/{ => ppp}/pptp.c                       |    0
 drivers/net/slip/Kconfig                           |   79 +
 drivers/net/slip/Makefile                          |    6 +
 drivers/net/{ => slip}/slhc.c                      |    0
 drivers/net/{ => slip}/slip.c                      |   29 +-
 drivers/net/{ => slip}/slip.h                      |    9 -
 drivers/net/sungem_phy.c                           |    7 +-
 drivers/net/tokenring/3c359.c                      |    2 +-
 drivers/net/tokenring/Kconfig                      |   15 +-
 drivers/net/tokenring/Makefile                     |   21 +-
 drivers/net/tokenring/ibmtr.c                      |    2 +-
 drivers/net/{pcmcia => tokenring}/ibmtr_cs.c       |    2 +-
 drivers/net/tokenring/lanstreamer.c                |    2 +-
 drivers/net/tokenring/olympic.c                    |    2 +-
 drivers/net/tokenring/smctr.c                      |    2 +-
 drivers/net/tokenring/tms380tr.c                   |    2 +-
 drivers/net/tun.c                                  |    2 +-
 drivers/net/usb/Kconfig                            |    3 +
 drivers/net/usb/asix.c                             |  412 +-
 drivers/net/usb/catc.c                             |    2 +-
 drivers/net/usb/dm9601.c                           |    2 +-
 drivers/net/usb/int51x1.c                          |    2 +-
 drivers/net/usb/kaweth.c                           |    2 +-
 drivers/net/usb/lg-vl600.c                         |   19 +
 drivers/net/usb/mcs7830.c                          |    2 +-
 drivers/net/usb/pegasus.c                          |    2 +-
 drivers/net/usb/rtl8150.c                          |  113 +-
 drivers/net/usb/smsc75xx.c                         |    2 +-
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/usb/usbnet.c                           |    6 +
 drivers/net/virtio_net.c                           |   42 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   22 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |    2 +-
 drivers/net/wan/hdlc_ppp.c                         |   14 +-
 drivers/net/wan/hdlc_x25.c                         |   16 +-
 drivers/net/wan/lapbether.c                        |    3 +-
 drivers/net/wan/sbni.c                             |    2 +-
 drivers/net/wan/x25_asy.c                          |    3 +-
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    5 +-
 drivers/net/wireless/adm8211.c                     |    3 +-
 drivers/net/wireless/airo.c                        |    4 +-
 drivers/net/wireless/at76c50x-usb.c                |   18 +-
 drivers/net/wireless/ath/Kconfig                   |    1 +
 drivers/net/wireless/ath/Makefile                  |    1 +
 drivers/net/wireless/ath/ath.h                     |   53 +-
 drivers/net/wireless/ath/ath5k/ahb.c               |    4 +-
 drivers/net/wireless/ath/ath5k/ani.c               |    1 -
 drivers/net/wireless/ath/ath5k/ani.h               |    4 +
 drivers/net/wireless/ath/ath5k/ath5k.h             |   98 +-
 drivers/net/wireless/ath/ath5k/attach.c            |   18 +-
 drivers/net/wireless/ath/ath5k/base.c              |   37 +-
 drivers/net/wireless/ath/ath5k/base.h              |   55 +-
 drivers/net/wireless/ath/ath5k/caps.c              |    2 +-
 drivers/net/wireless/ath/ath5k/debug.c             |   15 +-
 drivers/net/wireless/ath/ath5k/desc.c              |    1 -
 drivers/net/wireless/ath/ath5k/dma.c               |    1 -
 drivers/net/wireless/ath/ath5k/eeprom.c            |   10 +-
 drivers/net/wireless/ath/ath5k/gpio.c              |    1 -
 drivers/net/wireless/ath/ath5k/initvals.c          |    1 -
 drivers/net/wireless/ath/ath5k/led.c               |    1 -
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   13 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |    5 +-
 drivers/net/wireless/ath/ath5k/phy.c               |   91 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   10 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   79 +-
 drivers/net/wireless/ath/ath5k/rfkill.c            |    2 +-
 drivers/net/wireless/ath/ath5k/sysfs.c             |    1 -
 drivers/net/wireless/ath/ath5k/trace.h             |    3 +-
 drivers/net/wireless/ath/ath6kl/Kconfig            |   15 +
 drivers/net/wireless/ath/ath6kl/Makefile           |   37 +
 drivers/net/wireless/ath/ath6kl/bmi.c              |  689 +
 drivers/net/wireless/ath/ath6kl/bmi.h              |  250 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 1914 ++
 drivers/net/wireless/ath/ath6kl/cfg80211.h         |   39 +
 drivers/net/wireless/ath/ath6kl/common.h           |   97 +
 drivers/net/wireless/ath/ath6kl/core.h             |  637 +
 drivers/net/wireless/ath/ath6kl/debug.c            |  934 +
 drivers/net/wireless/ath/ath6kl/debug.h            |  138 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h          |   77 +
 drivers/net/wireless/ath/ath6kl/hif.h              |  208 +
 drivers/net/wireless/ath/ath6kl/htc.c              | 2478 ++
 drivers/net/wireless/ath/ath6kl/htc.h              |  607 +
 drivers/net/wireless/ath/ath6kl/htc_hif.c          |  641 +
 drivers/net/wireless/ath/ath6kl/htc_hif.h          |   92 +
 drivers/net/wireless/ath/ath6kl/init.c             | 1727 ++
 drivers/net/wireless/ath/ath6kl/main.c             | 1477 +
 drivers/net/wireless/ath/ath6kl/sdio.c             |  949 +
 drivers/net/wireless/ath/ath6kl/target.h           |  364 +
 drivers/net/wireless/ath/ath6kl/testmode.c         |  167 +
 drivers/net/wireless/ath/ath6kl/testmode.h         |   36 +
 drivers/net/wireless/ath/ath6kl/txrx.c             | 1478 +
 drivers/net/wireless/ath/ath6kl/wmi.c              | 3127 +++
 drivers/net/wireless/ath/ath6kl/wmi.h              | 2282 ++
 drivers/net/wireless/ath/ath9k/Makefile            |    1 +
 drivers/net/wireless/ath/ath9k/ahb.c               |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c               |   17 +-
 drivers/net/wireless/ath/ath9k/ani.h               |    6 +-
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h   |  131 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   43 +-
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   |  266 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   56 +-
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h   | 3403 ++--
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |  257 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  204 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  280 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  310 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  610 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |  378 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |   24 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  123 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |  130 +-
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c        |  153 +
 drivers/net/wireless/ath/ath9k/ar9003_rtt.h        |   28 +
 .../net/wireless/ath/ath9k/ar9462_1p0_initvals.h   | 1833 ++
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   | 1928 ++
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   | 1673 ++
 drivers/net/wireless/ath/ath9k/ath9k.h             |   34 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   80 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   18 +-
 drivers/net/wireless/ath/ath9k/calib.h             |    1 +
 drivers/net/wireless/ath/ath9k/common.c            |   32 +-
 drivers/net/wireless/ath/ath9k/common.h            |    1 +
 drivers/net/wireless/ath/ath9k/debug.c             |  493 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   68 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |    7 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |   17 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |  272 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |  169 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |  241 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |   15 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    1 +
 drivers/net/wireless/ath/ath9k/htc.h               |    3 -
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |   10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   29 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   33 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   78 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  257 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   83 +-
 drivers/net/wireless/ath/ath9k/init.c              |   81 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   59 +-
 drivers/net/wireless/ath/ath9k/mac.h               |   57 +-
 drivers/net/wireless/ath/ath9k/main.c              |  629 +-
 drivers/net/wireless/ath/ath9k/pci.c               |   57 +-
 drivers/net/wireless/ath/ath9k/rc.c                |   44 +-
 drivers/net/wireless/ath/ath9k/rc.h                |    6 -
 drivers/net/wireless/ath/ath9k/recv.c              |  109 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   83 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  894 +-
 drivers/net/wireless/ath/carl9170/Kconfig          |   14 +
 drivers/net/wireless/ath/carl9170/carl9170.h       |   24 +
 drivers/net/wireless/ath/carl9170/cmd.c            |   34 +
 drivers/net/wireless/ath/carl9170/cmd.h            |    1 +
 drivers/net/wireless/ath/carl9170/fw.c             |    3 +
 drivers/net/wireless/ath/carl9170/fwcmd.h          |   11 +
 drivers/net/wireless/ath/carl9170/main.c           |  236 +-
 drivers/net/wireless/ath/carl9170/phy.c            |   16 +-
 drivers/net/wireless/ath/carl9170/version.h        |    4 +-
 drivers/net/wireless/ath/main.c                    |    8 +-
 drivers/net/wireless/ath/regd.h                    |    2 +-
 drivers/net/wireless/ath/regd_common.h             |    2 +-
 drivers/net/wireless/b43/Kconfig                   |   22 +-
 drivers/net/wireless/b43/b43.h                     |   65 +-
 drivers/net/wireless/b43/bus.c                     |    2 +
 drivers/net/wireless/b43/dma.c                     |  157 +-
 drivers/net/wireless/b43/dma.h                     |   16 +-
 drivers/net/wireless/b43/main.c                    |  133 +-
 drivers/net/wireless/b43/phy_common.c              |   32 +
 drivers/net/wireless/b43/phy_common.h              |    2 +
 drivers/net/wireless/b43/phy_ht.c                  |  205 +
 drivers/net/wireless/b43/phy_ht.h                  |   19 +
 drivers/net/wireless/b43/phy_lcn.c                 |  853 +-
 drivers/net/wireless/b43/phy_lcn.h                 |   19 +-
 drivers/net/wireless/b43/phy_n.c                   |  583 +-
 drivers/net/wireless/b43/phy_n.h                   |    4 +
 drivers/net/wireless/b43/pio.c                     |   12 +-
 drivers/net/wireless/b43/radio_2055.c              |    1 +
 drivers/net/wireless/b43/radio_2056.c              |    2 +
 drivers/net/wireless/b43/radio_2056.h              |   26 -
 drivers/net/wireless/b43/radio_2059.c              |    2 +
 drivers/net/wireless/b43/tables_nphy.c             |    1 +
 drivers/net/wireless/b43/tables_phy_ht.c           |   86 +
 drivers/net/wireless/b43/tables_phy_ht.h           |    4 +
 drivers/net/wireless/b43/tables_phy_lcn.c          |  690 +
 drivers/net/wireless/b43/tables_phy_lcn.h          |   18 +
 drivers/net/wireless/b43/xmit.c                    |  138 +-
 drivers/net/wireless/b43/xmit.h                    |   72 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |    5 -
 drivers/net/wireless/b43legacy/dma.c               |  374 +-
 drivers/net/wireless/b43legacy/dma.h               |  107 -
 drivers/net/wireless/b43legacy/main.c              |   11 +-
 drivers/net/wireless/brcm80211/Kconfig             |   35 +
 drivers/net/wireless/brcm80211/Makefile            |   23 +
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |   33 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |   32 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  371 +
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  626 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  776 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   57 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |  498 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |  895 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   58 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    | 1356 +
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |   60 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 4591 ++++
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |  252 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 3868 +++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |  375 +
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |   51 +
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  | 2079 ++
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |  378 +
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    | 1241 +
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.h    |   30 +
 drivers/net/wireless/brcm80211/brcmsmac/antsel.c   |  307 +
 drivers/net/wireless/brcm80211/brcmsmac/antsel.h   |   29 +
 .../brcm80211/brcmsmac/brcms_trace_events.c        |   23 +
 .../brcm80211/brcmsmac/brcms_trace_events.h        |   92 +
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  | 1591 ++
 drivers/net/wireless/brcm80211/brcmsmac/channel.h  |   53 +
 drivers/net/wireless/brcm80211/brcmsmac/d11.h      | 1898 ++
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      | 1425 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.h      |  120 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  | 1696 ++
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |  108 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     | 8775 ++++++
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |  735 +
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |  835 +
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h   |   82 +
 drivers/net/wireless/brcm80211/brcmsmac/otp.c      |  426 +
 drivers/net/wireless/brcm80211/brcmsmac/otp.h      |   36 +
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  | 2988 ++
 .../net/wireless/brcm80211/brcmsmac/phy/phy_hal.h  |  301 +
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  | 1169 +
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  | 5154 ++++
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.h  |  121 +
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |28876 ++++++++++++++++++++
 .../wireless/brcm80211/brcmsmac/phy/phy_qmath.c    |  308 +
 .../wireless/brcm80211/brcmsmac/phy/phy_qmath.h    |   42 +
 .../wireless/brcm80211/brcmsmac/phy/phy_radio.h    | 1533 ++
 .../net/wireless/brcm80211/brcmsmac/phy/phyreg_n.h |  167 +
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   | 3250 +++
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |   54 +
 .../net/wireless/brcm80211/brcmsmac/phy/phytbl_n.c |10630 +++++++
 .../net/wireless/brcm80211/brcmsmac/phy/phytbl_n.h |   50 +
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c |  225 +
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h |  182 +
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |  458 +
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |   38 +
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |  634 +
 drivers/net/wireless/brcm80211/brcmsmac/rate.c     |  514 +
 drivers/net/wireless/brcm80211/brcmsmac/rate.h     |  250 +
 drivers/net/wireless/brcm80211/brcmsmac/scb.h      |   82 +
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     | 1298 +
 drivers/net/wireless/brcm80211/brcmsmac/srom.h     |   34 +
 drivers/net/wireless/brcm80211/brcmsmac/stf.c      |  436 +
 drivers/net/wireless/brcm80211/brcmsmac/stf.h      |   42 +
 drivers/net/wireless/brcm80211/brcmsmac/types.h    |  352 +
 .../net/wireless/brcm80211/brcmsmac/ucode_loader.c |  109 +
 .../net/wireless/brcm80211/brcmsmac/ucode_loader.h |   58 +
 drivers/net/wireless/brcm80211/brcmutil/Makefile   |   28 +
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |  386 +
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   59 +
 .../net/wireless/brcm80211/include/brcmu_utils.h   |  195 +
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |  239 +
 .../net/wireless/brcm80211/include/chipcommon.h    |  284 +
 drivers/net/wireless/brcm80211/include/defs.h      |  104 +
 drivers/net/wireless/brcm80211/include/soc.h       |   90 +
 drivers/net/wireless/hostap/hostap_main.c          |    6 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    3 +-
 drivers/net/wireless/iwlegacy/iwl-3945-led.c       |    1 -
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c        |    1 -
 drivers/net/wireless/iwlegacy/iwl-3945.c           |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965-led.c       |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c        |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c        |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c           |    1 -
 drivers/net/wireless/iwlegacy/iwl-core.c           |    6 +-
 drivers/net/wireless/iwlegacy/iwl-core.h           |    6 +-
 drivers/net/wireless/iwlegacy/iwl-led.c            |    1 -
 drivers/net/wireless/iwlegacy/iwl3945-base.c       |    1 -
 drivers/net/wireless/iwlegacy/iwl4965-base.c       |    1 -
 drivers/net/wireless/iwlwifi/Kconfig               |   43 +-
 drivers/net/wireless/iwlwifi/Makefile              |   38 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   58 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c            |   90 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  104 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h         |   81 -
 drivers/net/wireless/iwlwifi/iwl-6000.c            |   93 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |  133 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c      |  299 -
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h          |   32 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         | 1120 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |  117 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |    4 +
 .../wireless/iwlwifi/{iwl-rx.c => iwl-agn-rx.c}    |  302 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |  104 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |  943 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c          |   82 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h          |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  992 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |  119 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1499 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h             |  216 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h             |   90 +-
 .../wireless/iwlwifi/{iwl-5000-hw.h => iwl-cfg.h}  |   73 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |   62 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  405 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |  179 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   18 +
 drivers/net/wireless/iwlwifi/iwl-debug.h           |   48 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  450 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  556 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |  306 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   11 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |   20 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |  184 -
 drivers/net/wireless/iwlwifi/iwl-io.c              |  192 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |   61 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |   16 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c             |   49 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |   21 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  764 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h          |  534 +
 drivers/net/wireless/iwlwifi/iwl-sta.c             |  832 -
 drivers/net/wireless/iwlwifi/iwl-sta.h             |  138 -
 drivers/net/wireless/iwlwifi/iwl-sv-open.c         |   30 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h  |   82 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h  |  436 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   | 1435 +
 .../{iwl-trans-tx-pcie.c => iwl-trans-pcie-tx.c}   |  699 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      | 1998 ++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c   |  979 -
 drivers/net/wireless/iwlwifi/iwl-trans.c           | 1115 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |  278 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    6 +-
 drivers/net/wireless/libertas/README               |   25 -
 drivers/net/wireless/libertas/cfg.c                |  120 +-
 drivers/net/wireless/libertas/cfg.h                |    1 +
 drivers/net/wireless/libertas/cmd.c                |    6 +-
 drivers/net/wireless/libertas/decl.h               |    6 +
 drivers/net/wireless/libertas/dev.h                |   30 +-
 drivers/net/wireless/libertas/ethtool.c            |    1 +
 drivers/net/wireless/libertas/if_sdio.c            |  277 +-
 drivers/net/wireless/libertas/if_spi.c             |    4 -
 drivers/net/wireless/libertas/if_usb.c             |   34 +-
 drivers/net/wireless/libertas/main.c               |  249 +-
 drivers/net/wireless/libertas/mesh.c               |   79 +-
 drivers/net/wireless/libertas/mesh.h               |   27 +-
 drivers/net/wireless/libertas/rx.c                 |    1 +
 drivers/net/wireless/libertas/tx.c                 |    1 +
 drivers/net/wireless/mac80211_hwsim.c              |    9 +-
 drivers/net/wireless/mwifiex/11n_aggr.c            |    5 +-
 drivers/net/wireless/mwifiex/11n_aggr.h            |    1 +
 drivers/net/wireless/mwifiex/Kconfig               |   11 +
 drivers/net/wireless/mwifiex/Makefile              |    3 +
 drivers/net/wireless/mwifiex/cfg80211.c            |  392 +-
 drivers/net/wireless/mwifiex/cfg80211.h            |    3 +-
 drivers/net/wireless/mwifiex/cfp.c                 |   10 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |   37 +-
 drivers/net/wireless/mwifiex/decl.h                |    9 -
 drivers/net/wireless/mwifiex/fw.h                  |   51 +-
 drivers/net/wireless/mwifiex/init.c                |   96 +-
 drivers/net/wireless/mwifiex/ioctl.h               |    5 +-
 drivers/net/wireless/mwifiex/join.c                |   35 +-
 drivers/net/wireless/mwifiex/main.c                |  282 +-
 drivers/net/wireless/mwifiex/main.h                |  107 +-
 drivers/net/wireless/mwifiex/pcie.c                | 1948 ++
 drivers/net/wireless/mwifiex/pcie.h                |  148 +
 drivers/net/wireless/mwifiex/scan.c                | 1647 +-
 drivers/net/wireless/mwifiex/sdio.c                |   19 +-
 drivers/net/wireless/mwifiex/sdio.h                |   24 +-
 drivers/net/wireless/mwifiex/sta_cmd.c             |   64 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |    2 +
 drivers/net/wireless/mwifiex/sta_event.c           |    9 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  295 +-
 drivers/net/wireless/mwifiex/sta_tx.c              |    2 +-
 drivers/net/wireless/mwifiex/txrx.c                |   45 +-
 drivers/net/wireless/mwifiex/util.c                |    5 +-
 drivers/net/wireless/mwifiex/util.h                |    9 +-
 drivers/net/wireless/mwifiex/wmm.c                 |   36 +-
 drivers/net/wireless/mwl8k.c                       |   16 +-
 drivers/net/wireless/orinoco/main.c                |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         |    2 +-
 drivers/net/wireless/orinoco/wext.c                |    1 +
 drivers/net/wireless/p54/eeprom.c                  |   26 +-
 drivers/net/wireless/p54/fwio.c                    |    2 +
 drivers/net/wireless/p54/main.c                    |  116 +-
 drivers/net/wireless/p54/p54.h                     |   18 +
 drivers/net/wireless/p54/p54spi.c                  |    2 +-
 drivers/net/wireless/p54/txrx.c                    |   72 +-
 drivers/net/wireless/ray_cs.c                      |    2 +-
 drivers/net/wireless/rndis_wlan.c                  |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |   49 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   42 +-
 drivers/net/wireless/rt2x00/rt2800.h               |    3 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |  198 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |   10 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |   61 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |    7 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   33 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   22 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   53 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |    7 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |    5 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   41 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    7 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    5 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    5 +-
 drivers/net/wireless/rtlwifi/base.c                |  167 +-
 drivers/net/wireless/rtlwifi/base.h                |    2 +
 drivers/net/wireless/rtlwifi/core.c                |   11 +-
 drivers/net/wireless/rtlwifi/debug.c               |    2 -
 drivers/net/wireless/rtlwifi/pci.c                 |   56 +-
 drivers/net/wireless/rtlwifi/pci.h                 |   30 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |  153 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |   77 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |  116 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |    6 -
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h       |    4 -
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h       |    6 -
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   35 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |   23 +-
 drivers/net/wireless/rtlwifi/rtl8192de/def.h       |  170 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |   15 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c        |   63 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |  121 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |    6 -
 drivers/net/wireless/rtlwifi/rtl8192se/def.h       |   41 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |   22 +-
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |   64 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |  169 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   40 -
 drivers/net/wireless/rtlwifi/wifi.h                |   54 +-
 drivers/net/wireless/wl1251/cmd.h                  |    2 +-
 drivers/net/wireless/wl1251/main.c                 |    3 +-
 drivers/net/wireless/wl1251/wl12xx_80211.h         |    2 +-
 drivers/net/wireless/wl12xx/Kconfig                |   10 -
 drivers/net/wireless/wl12xx/Makefile               |    6 +-
 drivers/net/wireless/wl12xx/acx.c                  |  378 +-
 drivers/net/wireless/wl12xx/acx.h                  |  413 +-
 drivers/net/wireless/wl12xx/boot.c                 |   51 +-
 drivers/net/wireless/wl12xx/boot.h                 |    3 +-
 drivers/net/wireless/wl12xx/cmd.c                  |  866 +-
 drivers/net/wireless/wl12xx/cmd.h                  |  354 +-
 drivers/net/wireless/wl12xx/conf.h                 |  387 +-
 drivers/net/wireless/wl12xx/debugfs.c              |  105 +-
 drivers/net/wireless/wl12xx/event.c                |   58 +-
 drivers/net/wireless/wl12xx/event.h                |   80 +-
 drivers/net/wireless/wl12xx/init.c                 |  113 +-
 drivers/net/wireless/wl12xx/io.h                   |    1 -
 drivers/net/wireless/wl12xx/main.c                 | 1345 +-
 drivers/net/wireless/wl12xx/ps.c                   |   12 +-
 drivers/net/wireless/wl12xx/reg.h                  |   75 -
 drivers/net/wireless/wl12xx/rx.c                   |   69 +-
 drivers/net/wireless/wl12xx/rx.h                   |   18 +-
 drivers/net/wireless/wl12xx/scan.c                 |  200 +-
 drivers/net/wireless/wl12xx/scan.h                 |   31 +-
 drivers/net/wireless/wl12xx/sdio.c                 |    4 +-
 drivers/net/wireless/wl12xx/sdio_test.c            |   17 +-
 drivers/net/wireless/wl12xx/spi.c                  |    4 +-
 drivers/net/wireless/wl12xx/tx.c                   |  192 +-
 drivers/net/wireless/wl12xx/tx.h                   |   26 +-
 drivers/net/wireless/wl12xx/wl12xx.h               |  174 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |   27 +-
 drivers/net/wireless/wl3501_cs.c                   |    2 +-
 drivers/net/wireless/zd1201.c                      |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    2 +-
 drivers/net/xen-netback/netback.c                  |   58 +-
 drivers/net/xen-netfront.c                         |   38 +-
 drivers/nfc/Kconfig                                |   11 +
 drivers/nfc/Makefile                               |    1 +
 drivers/nfc/nfcwilink.c                            |  342 +
 drivers/nfc/pn533.c                                |   21 +-
 drivers/s390/cio/qdio.h                            |   38 +-
 drivers/s390/cio/qdio_debug.c                      |    3 +
 drivers/s390/cio/qdio_main.c                       |  208 +-
 drivers/s390/cio/qdio_setup.c                      |   83 +-
 drivers/s390/cio/qdio_thinint.c                    |   88 +-
 drivers/s390/net/lcs.c                             |    2 +-
 drivers/s390/net/qeth_core.h                       |   50 +-
 drivers/s390/net/qeth_core_main.c                  |  780 +-
 drivers/s390/net/qeth_l2_main.c                    |    4 +-
 drivers/s390/net/qeth_l3.h                         |    4 +
 drivers/s390/net/qeth_l3_main.c                    |   92 +-
 drivers/s390/net/qeth_l3_sys.c                     |  110 +-
 drivers/scsi/bnx2fc/Kconfig                        |    3 +-
 drivers/scsi/bnx2fc/bnx2fc.h                       |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    6 +-
 drivers/scsi/bnx2i/Kconfig                         |    3 +-
 drivers/scsi/bnx2i/bnx2i.h                         |    2 +-
 drivers/scsi/cxgbi/cxgb3i/Kbuild                   |    2 +-
 drivers/scsi/cxgbi/cxgb3i/Kconfig                  |    3 +-
 drivers/scsi/cxgbi/cxgb4i/Kbuild                   |    2 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig                  |    3 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   22 +-
 drivers/scsi/cxgbi/libcxgbi.h                      |    2 +-
 drivers/scsi/fcoe/fcoe.c                           |    6 +-
 drivers/scsi/fcoe/fcoe_transport.c                 |    7 +-
 drivers/ssb/main.c                                 |   24 +-
 drivers/staging/Kconfig                            |    4 +-
 drivers/staging/Makefile                           |    5 +-
 drivers/staging/ath6kl/Kconfig                     |  158 -
 drivers/staging/ath6kl/Makefile                    |  122 -
 drivers/staging/ath6kl/TODO                        |   25 -
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |   54 -
 drivers/staging/ath6kl/bmi/src/bmi.c               | 1010 -
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |   87 -
 .../hif/sdio/linux_sdio/include/hif_internal.h     |  131 -
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   | 1273 -
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |  393 -
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          | 1479 -
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  401 -
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |  783 -
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |  755 -
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        | 1284 -
 drivers/staging/ath6kl/htc2/htc.c                  |  575 -
 drivers/staging/ath6kl/htc2/htc_debug.h            |   38 -
 drivers/staging/ath6kl/htc2/htc_internal.h         |  211 -
 drivers/staging/ath6kl/htc2/htc_recv.c             | 1572 --
 drivers/staging/ath6kl/htc2/htc_send.c             | 1018 -
 drivers/staging/ath6kl/htc2/htc_services.c         |  450 -
 drivers/staging/ath6kl/include/a_config.h          |   31 -
 drivers/staging/ath6kl/include/a_debug.h           |  195 -
 drivers/staging/ath6kl/include/a_drv.h             |   32 -
 drivers/staging/ath6kl/include/a_drv_api.h         |  204 -
 drivers/staging/ath6kl/include/a_osapi.h           |   32 -
 drivers/staging/ath6kl/include/aggr_recv_api.h     |  140 -
 drivers/staging/ath6kl/include/ar3kconfig.h        |   65 -
 drivers/staging/ath6kl/include/ar6000_api.h        |   32 -
 drivers/staging/ath6kl/include/ar6000_diag.h       |   48 -
 drivers/staging/ath6kl/include/ar6kap_common.h     |   44 -
 drivers/staging/ath6kl/include/athbtfilter.h       |  135 -
 drivers/staging/ath6kl/include/bmi.h               |  134 -
 .../ath6kl/include/common/AR6002/AR6K_version.h    |   52 -
 .../staging/ath6kl/include/common/AR6002/addrs.h   |   90 -
 .../common/AR6002/hw4.0/hw/apb_athr_wlan_map.h     |   40 -
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |   40 -
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   24 -
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |  552 -
 .../common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h    |  471 -
 .../include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h |  589 -
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |  187 -
 .../include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h  |  162 -
 .../include/common/AR6002/hw4.0/hw/uart_reg.h      |   40 -
 drivers/staging/ath6kl/include/common/athdefs.h    |   75 -
 drivers/staging/ath6kl/include/common/bmi_msg.h    |  233 -
 drivers/staging/ath6kl/include/common/cnxmgmt.h    |   36 -
 drivers/staging/ath6kl/include/common/dbglog.h     |  126 -
 drivers/staging/ath6kl/include/common/dbglog_id.h  |  558 -
 drivers/staging/ath6kl/include/common/discovery.h  |   75 -
 .../staging/ath6kl/include/common/epping_test.h    |  111 -
 drivers/staging/ath6kl/include/common/gmboxif.h    |   70 -
 drivers/staging/ath6kl/include/common/gpio_reg.h   |    9 -
 drivers/staging/ath6kl/include/common/htc.h        |  227 -
 .../staging/ath6kl/include/common/htc_services.h   |   52 -
 drivers/staging/ath6kl/include/common/pkt_log.h    |   45 -
 drivers/staging/ath6kl/include/common/roaming.h    |   41 -
 drivers/staging/ath6kl/include/common/targaddrs.h  |  395 -
 drivers/staging/ath6kl/include/common/testcmd.h    |  185 -
 drivers/staging/ath6kl/include/common/tlpm.h       |   38 -
 drivers/staging/ath6kl/include/common/wlan_defs.h  |   79 -
 drivers/staging/ath6kl/include/common/wmi.h        | 3220 ---
 drivers/staging/ath6kl/include/common/wmix.h       |  271 -
 drivers/staging/ath6kl/include/common_drv.h        |  104 -
 drivers/staging/ath6kl/include/dbglog_api.h        |   52 -
 drivers/staging/ath6kl/include/dl_list.h           |  153 -
 drivers/staging/ath6kl/include/dset_api.h          |   65 -
 drivers/staging/ath6kl/include/hci_transport_api.h |  259 -
 drivers/staging/ath6kl/include/hif.h               |  456 -
 drivers/staging/ath6kl/include/host_version.h      |   52 -
 drivers/staging/ath6kl/include/htc_api.h           |  575 -
 drivers/staging/ath6kl/include/htc_packet.h        |  227 -
 drivers/staging/ath6kl/include/wlan_api.h          |  128 -
 drivers/staging/ath6kl/include/wmi_api.h           |  441 -
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |  565 -
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |  572 -
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |   75 -
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |  969 -
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |  113 -
 drivers/staging/ath6kl/miscdrv/common_drv.c        |  910 -
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |  417 -
 drivers/staging/ath6kl/miscdrv/miscdrv.h           |   42 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       | 6267 -----
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |  626 -
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  455 -
 drivers/staging/ath6kl/os/linux/cfg80211.c         | 1892 --
 .../staging/ath6kl/os/linux/export_hci_transport.c |  124 -
 drivers/staging/ath6kl/os/linux/hci_bridge.c       | 1141 -
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  776 -
 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h |   36 -
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |  190 -
 .../staging/ath6kl/os/linux/include/athdrv_linux.h | 1217 -
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   61 -
 .../staging/ath6kl/os/linux/include/config_linux.h |   51 -
 .../staging/ath6kl/os/linux/include/debug_linux.h  |   50 -
 .../ath6kl/os/linux/include/export_hci_transport.h |   76 -
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |  177 -
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |  339 -
 .../staging/ath6kl/os/linux/include/wlan_config.h  |  108 -
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |  300 -
 drivers/staging/ath6kl/os/linux/netbuf.c           |  231 -
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |  117 -
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |  661 -
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |  397 -
 .../staging/ath6kl/wlan/include/ieee80211_node.h   |   93 -
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |  636 -
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |  199 -
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |   58 -
 drivers/staging/ath6kl/wmi/wmi.c                   | 6444 -----
 drivers/staging/ath6kl/wmi/wmi_host.h              |  102 -
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   19 +-
 drivers/staging/et131x/et1310_tx.c                 |   12 +-
 drivers/staging/et131x/et131x_netdev.c             |    2 +-
 drivers/staging/hv/netvsc_drv.c                    |    8 +-
 drivers/staging/octeon/ethernet.c                  |   12 +-
 drivers/staging/rtl8187se/r8180_core.c             |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +-
 drivers/staging/slicoss/slicoss.c                  |    2 +-
 drivers/staging/vt6655/device_main.c               |    2 +-
 drivers/staging/vt6656/main_usb.c                  |    2 +-
 drivers/staging/winbond/wbusb.c                    |    2 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |    2 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    2 +-
 drivers/virtio/virtio_ring.c                       |   10 +
 drivers/watchdog/bcm47xx_wdt.c                     |   27 +-
 drivers/xen/xen-pciback/xenbus.c                   |    2 +
 fs/sysfs/dir.c                                     |   20 +-
 fs/sysfs/file.c                                    |   56 +-
 fs/sysfs/inode.c                                   |    2 -
 include/linux/atalk.h                              |    3 +-
 include/linux/ax25.h                               |    2 +-
 include/linux/bcma/bcma.h                          |    9 +-
 include/linux/bcma/bcma_driver_chipcommon.h        |   94 +
 include/linux/bcma/bcma_driver_mips.h              |   51 +
 include/linux/bcma/bcma_soc.h                      |   16 +
 include/linux/caif/caif_socket.h                   |    7 +-
 include/linux/can.h                                |    4 +-
 include/linux/can/Kbuild                           |    1 +
 include/linux/can/bcm.h                            |    3 +-
 include/linux/can/core.h                           |    2 -
 include/linux/can/dev.h                            |    1 -
 include/linux/can/error.h                          |    2 -
 include/linux/can/gw.h                             |  162 +
 include/linux/can/netlink.h                        |    2 -
 include/linux/can/raw.h                            |    2 -
 include/linux/capability.h                         |    3 +-
 include/linux/cn_proc.h                            |   11 +
 include/linux/device.h                             |    2 +
 include/linux/ethtool.h                            |  180 +-
 include/linux/filter.h                             |    2 +-
 include/linux/ieee80211.h                          |  156 +-
 include/linux/if.h                                 |    1 +
 include/linux/if_ether.h                           |    2 +
 include/linux/if_link.h                            |   10 +
 include/linux/if_macvlan.h                         |    1 +
 include/linux/if_packet.h                          |  119 +
 include/linux/if_pppol2tp.h                        |    2 +-
 include/linux/if_pppox.h                           |    9 +-
 include/linux/in.h                                 |    2 +-
 include/linux/inet_diag.h                          |    3 +-
 include/linux/ip6_tunnel.h                         |    2 +
 include/linux/ipx.h                                |    2 +-
 include/linux/irda.h                               |    9 +-
 include/linux/l2tp.h                               |    7 +-
 include/linux/lapb.h                               |    3 +-
 include/linux/llc.h                                |   10 +-
 include/linux/mii.h                                |  210 +-
 include/linux/mlx4/device.h                        |    1 +
 include/linux/mm_types.h                           |   11 +
 include/linux/net_tstamp.h                         |   13 +-
 include/linux/netdevice.h                          |   16 +-
 include/linux/netfilter/xt_connlimit.h             |    1 +
 include/linux/netfilter/xt_conntrack.h             |    1 +
 include/linux/netfilter/xt_iprange.h               |    1 +
 include/linux/netfilter_arp/arp_tables.h           |   14 +-
 include/linux/netfilter_decnet.h                   |    3 +
 include/linux/netfilter_ipv4.h                     |    3 +
 include/linux/netfilter_ipv4/ip_tables.h           |   20 +-
 include/linux/netfilter_ipv6.h                     |    3 +
 include/linux/netfilter_ipv6/ip6_tables.h          |   22 +-
 include/linux/netlink.h                            |    2 +-
 include/linux/netrom.h                             |    2 +
 include/linux/nfc.h                                |    8 +
 include/linux/nl80211.h                            |  238 +-
 include/linux/pci.h                                |    2 +
 include/linux/phonet.h                             |    5 +-
 include/linux/phy.h                                |    2 +-
 include/linux/rfkill-gpio.h                        |    4 +
 include/linux/rose.h                               |    7 +-
 {arch/sh/include/asm => include/linux}/sh_eth.h    |    2 +-
 include/linux/skbuff.h                             |  262 +-
 include/linux/ssb/ssb.h                            |    2 +-
 include/linux/ssb/ssb_regs.h                       |   40 +
 {drivers/net => include/linux}/sungem_phy.h        |    2 +-
 include/linux/sysctl.h                             |    2 +-
 include/linux/sysfs.h                              |    1 +
 include/linux/tcp.h                                |    7 +-
 include/linux/tipc_config.h                        |    4 +
 include/linux/un.h                                 |    4 +-
 include/linux/virtio.h                             |    5 +
 include/linux/x25.h                                |    3 +-
 include/net/addrconf.h                             |    2 +-
 include/net/bluetooth/hci.h                        |   10 +
 include/net/bluetooth/hci_core.h                   |   25 +-
 include/net/bluetooth/l2cap.h                      |   11 +-
 include/net/bluetooth/mgmt.h                       |   16 +
 include/net/bluetooth/smp.h                        |   17 +
 include/net/caif/caif_hsi.h                        |   37 +-
 include/net/cfg80211-wext.h                        |   55 +
 include/net/cfg80211.h                             |  385 +-
 include/net/dcbevent.h                             |   18 +
 include/net/dcbnl.h                                |    3 +-
 include/net/dst.h                                  |    9 +-
 include/net/ieee80211_radiotap.h                   |    1 +
 include/net/if_inet6.h                             |    1 +
 include/net/inet_ecn.h                             |    8 +
 include/net/inet_timewait_sock.h                   |    3 +-
 include/net/ip.h                                   |   12 +-
 include/net/iucv/af_iucv.h                         |   52 +
 include/net/iucv/iucv.h                            |   36 +-
 include/net/lapb.h                                 |    2 +-
 include/net/lib80211.h                             |    3 -
 include/net/mac80211.h                             |  294 +-
 include/net/nfc/nci.h                              |  313 +
 include/net/nfc/nci_core.h                         |  184 +
 include/net/{ => nfc}/nfc.h                        |   11 +-
 include/net/regulatory.h                           |   16 +-
 include/net/sch_generic.h                          |   24 +-
 include/net/scm.h                                  |    5 +-
 include/net/sctp/structs.h                         |    1 +
 include/net/secure_seq.h                           |    2 +-
 include/net/sock.h                                 |   15 +-
 include/net/tcp.h                                  |   71 +-
 include/rdma/ib_addr.h                             |    6 +-
 kernel/sys.c                                       |    1 +
 kernel/sysctl_binary.c                             |    2 +-
 net/802/garp.c                                     |    4 +-
 net/802/stp.c                                      |    4 +-
 net/8021q/vlan.c                                   |    2 +-
 net/8021q/vlan_dev.c                               |    4 +-
 net/appletalk/ddp.c                                |    5 +-
 net/atm/lec.c                                      |    2 +-
 net/batman-adv/Makefile                            |    2 +-
 net/batman-adv/aggregation.c                       |  293 -
 net/batman-adv/aggregation.h                       |   46 -
 net/batman-adv/bat_iv_ogm.c                        | 1170 +
 net/batman-adv/bat_ogm.h                           |   35 +
 net/batman-adv/bat_sysfs.c                         |    2 +
 net/batman-adv/bitarray.c                          |    6 +-
 net/batman-adv/gateway_client.c                    |   10 +-
 net/batman-adv/hard-interface.c                    |   88 +-
 net/batman-adv/hard-interface.h                    |    1 +
 net/batman-adv/hash.h                              |   25 +-
 net/batman-adv/main.c                              |    4 +-
 net/batman-adv/main.h                              |    8 +-
 net/batman-adv/originator.c                        |   21 +-
 net/batman-adv/packet.h                            |   19 +-
 net/batman-adv/routing.c                           |  669 +-
 net/batman-adv/routing.h                           |   17 +-
 net/batman-adv/send.c                              |  313 +-
 net/batman-adv/send.h                              |    9 +-
 net/batman-adv/soft-interface.c                    |   36 +-
 net/batman-adv/translation-table.c                 |  206 +-
 net/batman-adv/translation-table.h                 |   21 +-
 net/batman-adv/types.h                             |    5 +-
 net/batman-adv/unicast.c                           |    6 +-
 net/batman-adv/unicast.h                           |    2 +-
 net/batman-adv/vis.c                               |   10 +-
 net/bluetooth/af_bluetooth.c                       |   30 +-
 net/bluetooth/bnep/core.c                          |    5 +-
 net/bluetooth/bnep/netdev.c                        |    2 +-
 net/bluetooth/cmtp/core.c                          |    5 +-
 net/bluetooth/hci_conn.c                           |   16 +-
 net/bluetooth/hci_core.c                           |   57 +-
 net/bluetooth/hci_event.c                          |   36 +-
 net/bluetooth/hci_sock.c                           |   18 +-
 net/bluetooth/hci_sysfs.c                          |    2 +
 net/bluetooth/hidp/core.c                          |   13 +-
 net/bluetooth/l2cap_core.c                         |  273 +-
 net/bluetooth/mgmt.c                               |  212 +-
 net/bluetooth/rfcomm/core.c                        |    5 +-
 net/bluetooth/smp.c                                |  421 +-
 net/bridge/br_device.c                             |    4 +-
 net/bridge/br_fdb.c                                |   23 +-
 net/bridge/br_if.c                                 |   41 +-
 net/bridge/br_input.c                              |   33 +-
 net/bridge/br_private.h                            |    7 +
 net/bridge/br_sysfs_br.c                           |   34 +
 net/bridge/netfilter/ebtable_broute.c              |    4 +-
 net/caif/cfcnfg.c                                  |   38 +-
 net/caif/cfctrl.c                                  |   23 +-
 net/caif/cfdbgl.c                                  |    7 +-
 net/caif/cfdgml.c                                  |    7 +-
 net/caif/cffrml.c                                  |    7 +-
 net/caif/cfmuxl.c                                  |    6 +-
 net/caif/cfrfml.c                                  |    7 +-
 net/caif/cfserl.c                                  |    7 +-
 net/caif/cfsrvl.c                                  |    8 +-
 net/caif/cfutill.c                                 |    7 +-
 net/caif/cfveil.c                                  |    7 +-
 net/caif/cfvidl.c                                  |    7 +-
 net/can/Kconfig                                    |   11 +
 net/can/Makefile                                   |    3 +
 net/can/af_can.c                                   |    6 +-
 net/can/af_can.h                                   |    2 -
 net/can/bcm.c                                      |    2 -
 net/can/gw.c                                       |  957 +
 net/can/proc.c                                     |    2 -
 net/can/raw.c                                      |    2 -
 net/core/datagram.c                                |   24 +-
 net/core/dev.c                                     |  336 +-
 net/core/dev_addr_lists.c                          |    4 +-
 net/core/dst.c                                     |   15 +-
 net/core/ethtool.c                                 |   20 +-
 net/core/fib_rules.c                               |    4 +-
 net/core/filter.c                                  |    4 +-
 net/core/flow.c                                    |   14 +-
 net/core/kmap_skb.h                                |    2 +-
 net/core/link_watch.c                              |    9 +-
 net/core/neighbour.c                               |   44 +-
 net/core/net-sysfs.c                               |   12 +-
 net/core/netpoll.c                                 |    4 +-
 net/core/pktgen.c                                  |   25 +-
 net/core/rtnetlink.c                               |   34 +-
 net/core/scm.c                                     |   10 +-
 net/core/secure_seq.c                              |    2 +-
 net/core/skbuff.c                                  |  174 +-
 net/core/sock.c                                    |   23 +-
 net/core/timestamping.c                            |   12 +-
 net/core/user_dma.c                                |    6 +-
 net/dcb/dcbnl.c                                    |   30 +-
 net/dccp/ccids/ccid2.c                             |   84 +-
 net/dccp/ccids/ccid2.h                             |    6 +
 net/dccp/dccp.h                                    |    1 +
 net/dccp/feat.c                                    |  202 +-
 net/dccp/feat.h                                    |    1 +
 net/dccp/proto.c                                   |    1 -
 net/decnet/dn_dev.c                                |    6 +-
 net/dsa/slave.c                                    |    3 -
 net/ieee802154/6lowpan.c                           |  891 +
 net/ieee802154/6lowpan.h                           |  212 +
 net/ieee802154/Kconfig                             |    6 +
 net/ieee802154/Makefile                            |    8 +-
 net/ipv4/af_inet.c                                 |    2 +-
 net/ipv4/cipso_ipv4.c                              |    2 +-
 net/ipv4/devinet.c                                 |    6 +-
 net/ipv4/fib_trie.c                                |   12 +-
 net/ipv4/gre.c                                     |    4 +-
 net/ipv4/icmp.c                                    |    5 +-
 net/ipv4/igmp.c                                    |   12 +-
 net/ipv4/inet_diag.c                               |    5 +
 net/ipv4/inet_lro.c                                |   10 +-
 net/ipv4/inet_timewait_sock.c                      |    1 +
 net/ipv4/ip_fragment.c                             |   40 +-
 net/ipv4/ip_gre.c                                  |    2 -
 net/ipv4/ip_output.c                               |   17 +-
 net/ipv4/ip_sockglue.c                             |    7 +-
 net/ipv4/ipip.c                                    |   10 +-
 net/ipv4/ipmr.c                                    |    8 +-
 net/ipv4/netfilter/nf_nat_amanda.c                 |    4 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   24 +-
 net/ipv4/netfilter/nf_nat_ftp.c                    |    4 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   36 +-
 net/ipv4/netfilter/nf_nat_irc.c                    |    4 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   16 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   28 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    4 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |    6 +-
 net/ipv4/netfilter/nf_nat_tftp.c                   |    4 +-
 net/ipv4/route.c                                   |   53 +-
 net/ipv4/syncookies.c                              |    2 +-
 net/ipv4/tcp.c                                     |   97 +-
 net/ipv4/tcp_input.c                               |  244 +-
 net/ipv4/tcp_ipv4.c                                |   57 +-
 net/ipv4/tcp_minisocks.c                           |    4 +-
 net/ipv4/tcp_output.c                              |  152 +-
 net/ipv4/tcp_timer.c                               |    2 -
 net/ipv4/udp.c                                     |   11 +-
 net/ipv4/xfrm4_policy.c                            |   14 +-
 net/ipv6/addrconf.c                                |   81 +-
 net/ipv6/datagram.c                                |    4 -
 net/ipv6/exthdrs.c                                 |    7 +-
 net/ipv6/icmp.c                                    |   28 +-
 net/ipv6/inet6_connection_sock.c                   |    9 +-
 net/ipv6/ip6_fib.c                                 |    4 -
 net/ipv6/ip6_output.c                              |   28 +-
 net/ipv6/ip6_tunnel.c                              |   54 +-
 net/ipv6/ipv6_sockglue.c                           |    2 +-
 net/ipv6/ndisc.c                                   |   42 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    4 +-
 net/ipv6/raw.c                                     |   11 +-
 net/ipv6/reassembly.c                              |    4 +-
 net/ipv6/sit.c                                     |   12 +-
 net/ipv6/syncookies.c                              |    6 +-
 net/ipv6/tcp_ipv6.c                                |   48 +-
 net/ipv6/udp.c                                     |    4 +-
 net/ipv6/xfrm6_output.c                            |   56 +-
 net/irda/irlan/irlan_eth.c                         |    2 +-
 net/iucv/Kconfig                                   |   14 +-
 net/iucv/af_iucv.c                                 |  870 +-
 net/iucv/iucv.c                                    |   23 +
 net/l2tp/l2tp_ppp.c                                |    9 +-
 net/lapb/lapb_iface.c                              |   29 +-
 net/mac80211/Kconfig                               |   25 +
 net/mac80211/agg-rx.c                              |   25 +-
 net/mac80211/agg-tx.c                              |   64 +-
 net/mac80211/cfg.c                                 |  497 +-
 net/mac80211/debugfs.c                             |   71 +-
 net/mac80211/debugfs_netdev.c                      |   59 +-
 net/mac80211/debugfs_sta.c                         |   37 +-
 net/mac80211/driver-ops.h                          |   91 +-
 net/mac80211/driver-trace.h                        |  117 +-
 net/mac80211/ht.c                                  |    8 +-
 net/mac80211/ibss.c                                |   16 +-
 net/mac80211/ieee80211_i.h                         |  104 +-
 net/mac80211/iface.c                               |   26 +-
 net/mac80211/key.c                                 |    4 +-
 net/mac80211/main.c                                |   25 +-
 net/mac80211/mesh.c                                |  213 +-
 net/mac80211/mesh.h                                |   38 +-
 net/mac80211/mesh_hwmp.c                           |  177 +-
 net/mac80211/mesh_pathtbl.c                        |  481 +-
 net/mac80211/mesh_plink.c                          |  257 +-
 net/mac80211/mlme.c                                |  138 +-
 net/mac80211/pm.c                                  |    2 +-
 net/mac80211/rate.c                                |   37 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   13 +-
 net/mac80211/rx.c                                  |  199 +-
 net/mac80211/scan.c                                |    4 +-
 net/mac80211/spectmgmt.c                           |    6 +-
 net/mac80211/sta_info.c                            |  977 +-
 net/mac80211/sta_info.h                            |  171 +-
 net/mac80211/status.c                              |  251 +-
 net/mac80211/tx.c                                  |  557 +-
 net/mac80211/util.c                                |  280 +-
 net/mac80211/wme.c                                 |   20 +-
 net/mac80211/wme.h                                 |    3 +-
 net/mac80211/work.c                                |   10 +-
 net/mac80211/wpa.c                                 |    3 +-
 net/netfilter/core.c                               |    4 +-
 net/netfilter/nf_conntrack_core.c                  |   12 +-
 net/netfilter/nf_conntrack_ecache.c                |    8 +-
 net/netfilter/nf_conntrack_extend.c                |    4 +-
 net/netfilter/nf_conntrack_helper.c                |    6 +-
 net/netfilter/nf_conntrack_netlink.c               |    6 +-
 net/netfilter/nf_log.c                             |   10 +-
 net/netfilter/nf_queue.c                           |    6 +-
 net/netfilter/nfnetlink.c                          |    6 +-
 net/netlabel/netlabel_domainhash.c                 |    6 +-
 net/netlabel/netlabel_unlabeled.c                  |    6 +-
 net/netlink/af_netlink.c                           |    7 +-
 net/nfc/Kconfig                                    |    2 +
 net/nfc/Makefile                                   |    1 +
 net/nfc/core.c                                     |   83 +-
 net/nfc/nci/Kconfig                                |   10 +
 net/nfc/nci/Makefile                               |    7 +
 net/nfc/nci/core.c                                 |  797 +
 net/nfc/nci/data.c                                 |  247 +
 net/nfc/nci/lib.c                                  |   94 +
 net/nfc/nci/ntf.c                                  |  258 +
 net/nfc/nci/rsp.c                                  |  226 +
 net/nfc/netlink.c                                  |   56 +
 net/nfc/nfc.h                                      |    6 +-
 net/nfc/rawsock.c                                  |   13 +-
 net/packet/af_packet.c                             |  987 +-
 net/phonet/af_phonet.c                             |    4 +-
 net/phonet/pn_dev.c                                |    6 +-
 net/phonet/socket.c                                |    6 +-
 net/rds/Kconfig                                    |    1 +
 net/rds/ib_rdma.c                                  |  112 +-
 net/rds/xlist.h                                    |   80 -
 net/rfkill/core.c                                  |    2 +-
 net/rfkill/rfkill-gpio.c                           |   11 +
 net/rfkill/rfkill-regulator.c                      |    1 -
 net/sched/cls_flow.c                               |  188 +-
 net/sched/sch_sfb.c                                |   13 +-
 net/sctp/associola.c                               |    1 +
 net/sctp/outqueue.c                                |    4 +
 net/sctp/protocol.c                                |    2 +-
 net/sctp/sm_make_chunk.c                           |    1 +
 net/sctp/sm_statefuns.c                            |    5 +
 net/socket.c                                       |    4 +-
 net/sunrpc/auth_gss/auth_gss.c                     |    4 +-
 net/tipc/bcast.c                                   |  111 +-
 net/tipc/bcast.h                                   |    1 -
 net/tipc/bearer.c                                  |    8 +-
 net/tipc/bearer.h                                  |    4 +-
 net/tipc/config.h                                  |    1 -
 net/tipc/discover.c                                |    6 -
 net/tipc/eth_media.c                               |   32 +-
 net/tipc/link.c                                    |  111 +-
 net/tipc/link.h                                    |    1 +
 net/tipc/name_distr.c                              |   35 +-
 net/tipc/net.c                                     |   11 -
 net/tipc/node.c                                    |   45 +-
 net/tipc/node.h                                    |   10 +-
 net/tipc/socket.c                                  |   51 +-
 net/tipc/subscr.c                                  |    3 +-
 net/tipc/subscr.h                                  |    6 -
 net/unix/af_unix.c                                 |   24 +-
 net/wireless/core.c                                |    2 +-
 net/wireless/core.h                                |    6 +-
 net/wireless/lib80211.c                            |   15 +-
 net/wireless/lib80211_crypt_ccmp.c                 |    2 -
 net/wireless/lib80211_crypt_tkip.c                 |    4 -
 net/wireless/lib80211_crypt_wep.c                  |    4 -
 net/wireless/mesh.c                                |    3 +
 net/wireless/mlme.c                                |   16 +-
 net/wireless/nl80211.c                             |  405 +-
 net/wireless/nl80211.h                             |    4 +
 net/wireless/reg.c                                 |   47 +-
 net/wireless/reg.h                                 |    2 +
 net/wireless/scan.c                                |   28 +
 net/wireless/sme.c                                 |   19 +-
 net/wireless/util.c                                |  194 +-
 net/wireless/wext-compat.c                         |  137 +-
 net/wireless/wext-compat.h                         |    8 +
 net/wireless/wext-sme.c                            |    3 +-
 net/xfrm/xfrm_ipcomp.c                             |   13 +-
 net/xfrm/xfrm_replay.c                             |   98 +-
 net/xfrm/xfrm_user.c                               |    4 +-
 virt/kvm/assigned-dev.c                            |    2 +
 virt/kvm/iommu.c                                   |    4 +
 2121 files changed, 200211 insertions(+), 104314 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/smsc911x.txt
 create mode 100644 arch/mips/bcm47xx/Kconfig
 create mode 100644 drivers/bcma/driver_mips.c
 create mode 100644 drivers/bcma/host_soc.c
 rename drivers/net/{pcmcia => arcnet}/com20020_cs.c (100%)
 delete mode 100644 drivers/net/arm/Kconfig
 delete mode 100644 drivers/net/arm/Makefile
 delete mode 100644 drivers/net/benet/Kconfig
 delete mode 100644 drivers/net/bna/bfa_ioc_ct.c
 delete mode 100644 drivers/net/bna/bfi_ctreg.h
 delete mode 100644 drivers/net/bna/bfi_ll.h
 delete mode 100644 drivers/net/bna/bna_ctrl.c
 delete mode 100644 drivers/net/bna/bna_hw.h
 delete mode 100644 drivers/net/bna/bna_txrx.c
 create mode 100644 drivers/net/can/sja1000/ems_pcmcia.c
 create mode 100644 drivers/net/can/sja1000/peak_pci.c
 rename drivers/net/{ => ethernet/3com}/3c501.c (99%)
 rename drivers/net/{ => ethernet/3com}/3c501.h (100%)
 rename drivers/net/{ => ethernet/3com}/3c509.c (99%)
 rename drivers/net/{ => ethernet/3com}/3c515.c (99%)
 rename drivers/net/{pcmcia => ethernet/3com}/3c574_cs.c (99%)
 rename drivers/net/{pcmcia => ethernet/3com}/3c589_cs.c (99%)
 rename drivers/net/{ => ethernet/3com}/3c59x.c (99%)
 create mode 100644 drivers/net/ethernet/3com/Kconfig
 create mode 100644 drivers/net/ethernet/3com/Makefile
 rename drivers/net/{ => ethernet/3com}/typhoon.c (99%)
 rename drivers/net/{ => ethernet/3com}/typhoon.h (100%)
 rename drivers/net/{ => ethernet/8390}/3c503.c (99%)
 rename drivers/net/{ => ethernet/8390}/3c503.h (100%)
 rename drivers/net/{ => ethernet/8390}/8390.c (97%)
 rename drivers/net/{ => ethernet/8390}/8390.h (100%)
 rename drivers/net/{ => ethernet/8390}/8390p.c (97%)
 create mode 100644 drivers/net/ethernet/8390/Kconfig
 create mode 100644 drivers/net/ethernet/8390/Makefile
 rename drivers/net/{ => ethernet/8390}/ac3200.c (99%)
 rename drivers/net/{ => ethernet/8390}/apne.c (100%)
 rename drivers/net/{ => ethernet/8390}/ax88796.c (99%)
 rename drivers/net/{pcmcia => ethernet/8390}/axnet_cs.c (99%)
 rename drivers/net/{ => ethernet/8390}/e2100.c (99%)
 rename drivers/net/{ => ethernet/8390}/es3210.c (100%)
 rename drivers/net/{arm => ethernet/8390}/etherh.c (99%)
 rename drivers/net/{ => ethernet/8390}/hp-plus.c (99%)
 rename drivers/net/{ => ethernet/8390}/hp.c (100%)
 rename drivers/net/{ => ethernet/8390}/hydra.c (99%)
 rename drivers/net/{ => ethernet/8390}/lib8390.c (100%)
 rename drivers/net/{ => ethernet/8390}/lne390.c (100%)
 rename drivers/net/{ => ethernet/8390}/mac8390.c (99%)
 rename drivers/net/{ => ethernet/8390}/ne-h8300.c (99%)
 rename drivers/net/{ => ethernet/8390}/ne.c (100%)
 rename drivers/net/{ => ethernet/8390}/ne2.c (100%)
 rename drivers/net/{ => ethernet/8390}/ne2k-pci.c (99%)
 rename drivers/net/{ => ethernet/8390}/ne3210.c (100%)
 rename drivers/net/{pcmcia => ethernet/8390}/pcnet_cs.c (99%)
 rename drivers/net/{ => ethernet/8390}/smc-mca.c (99%)
 rename drivers/net/{ => ethernet/8390}/smc-ultra.c (99%)
 rename drivers/net/{ => ethernet/8390}/smc-ultra32.c (99%)
 rename drivers/net/{ => ethernet/8390}/stnic.c (100%)
 rename drivers/net/{ => ethernet/8390}/wd.c (99%)
 rename drivers/net/{ => ethernet/8390}/zorro8390.c (99%)
 create mode 100644 drivers/net/ethernet/Kconfig
 create mode 100644 drivers/net/ethernet/Makefile
 create mode 100644 drivers/net/ethernet/adaptec/Kconfig
 create mode 100644 drivers/net/ethernet/adaptec/Makefile
 rename drivers/net/{ => ethernet/adaptec}/starfire.c (99%)
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 rename drivers/net/{ => ethernet/adi}/bfin_mac.c (99%)
 rename drivers/net/{ => ethernet/adi}/bfin_mac.h (100%)
 create mode 100644 drivers/net/ethernet/aeroflex/Kconfig
 create mode 100644 drivers/net/ethernet/aeroflex/Makefile
 rename drivers/net/{ => ethernet/aeroflex}/greth.c (98%)
 rename drivers/net/{ => ethernet/aeroflex}/greth.h (100%)
 create mode 100644 drivers/net/ethernet/alteon/Kconfig
 create mode 100644 drivers/net/ethernet/alteon/Makefile
 rename drivers/net/{ => ethernet/alteon}/acenic.c (99%)
 rename drivers/net/{ => ethernet/alteon}/acenic.h (100%)
 rename drivers/net/{ => ethernet/amd}/7990.c (100%)
 rename drivers/net/{ => ethernet/amd}/7990.h (100%)
 create mode 100644 drivers/net/ethernet/amd/Kconfig
 create mode 100644 drivers/net/ethernet/amd/Makefile
 rename drivers/net/{ => ethernet/amd}/a2065.c (99%)
 rename drivers/net/{ => ethernet/amd}/a2065.h (100%)
 rename drivers/net/{arm => ethernet/amd}/am79c961a.c (99%)
 rename drivers/net/{arm => ethernet/amd}/am79c961a.h (100%)
 rename drivers/net/{ => ethernet/amd}/amd8111e.c (99%)
 rename drivers/net/{ => ethernet/amd}/amd8111e.h (100%)
 rename drivers/net/{ => ethernet/amd}/ariadne.c (99%)
 rename drivers/net/{ => ethernet/amd}/ariadne.h (100%)
 rename drivers/net/{ => ethernet/amd}/atarilance.c (99%)
 rename drivers/net/{ => ethernet/amd}/au1000_eth.c (99%)
 rename drivers/net/{ => ethernet/amd}/au1000_eth.h (100%)
 rename drivers/net/{ => ethernet/amd}/declance.c (99%)
 rename drivers/net/{ => ethernet/amd}/depca.c (99%)
 rename drivers/net/{ => ethernet/amd}/depca.h (99%)
 rename drivers/net/{ => ethernet/amd}/hplance.c (99%)
 rename drivers/net/{ => ethernet/amd}/hplance.h (100%)
 rename drivers/net/{ => ethernet/amd}/lance.c (99%)
 rename drivers/net/{ => ethernet/amd}/mvme147.c (99%)
 rename drivers/net/{ => ethernet/amd}/ni65.c (99%)
 rename drivers/net/{ => ethernet/amd}/ni65.h (100%)
 rename drivers/net/{pcmcia => ethernet/amd}/nmclan_cs.c (99%)
 rename drivers/net/{ => ethernet/amd}/pcnet32.c (94%)
 rename drivers/net/{ => ethernet/amd}/sun3lance.c (99%)
 rename drivers/net/{ => ethernet/amd}/sunlance.c (99%)
 create mode 100644 drivers/net/ethernet/apple/Kconfig
 create mode 100644 drivers/net/ethernet/apple/Makefile
 rename drivers/net/{ => ethernet/apple}/bmac.c (99%)
 rename drivers/net/{ => ethernet/apple}/bmac.h (100%)
 rename drivers/net/{ => ethernet/apple}/mac89x0.c (99%)
 rename drivers/net/{ => ethernet/apple}/mace.c (99%)
 rename drivers/net/{ => ethernet/apple}/mace.h (100%)
 rename drivers/net/{ => ethernet/apple}/macmace.c (98%)
 create mode 100644 drivers/net/ethernet/atheros/Kconfig
 create mode 100644 drivers/net/ethernet/atheros/Makefile
 rename drivers/net/{ => ethernet/atheros}/atl1c/Makefile (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1c/atl1c.h (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1c/atl1c_ethtool.c (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1c/atl1c_hw.c (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1c/atl1c_hw.h (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1c/atl1c_main.c (99%)
 rename drivers/net/{ => ethernet/atheros}/atl1e/Makefile (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1e/atl1e.h (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1e/atl1e_ethtool.c (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1e/atl1e_hw.c (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1e/atl1e_hw.h (100%)
 rename drivers/net/{ => ethernet/atheros}/atl1e/atl1e_main.c (99%)
 rename drivers/net/{ => ethernet/atheros}/atl1e/atl1e_param.c (100%)
 rename drivers/net/{ => ethernet/atheros}/atlx/Makefile (100%)
 rename drivers/net/{ => ethernet/atheros}/atlx/atl1.c (99%)
 rename drivers/net/{ => ethernet/atheros}/atlx/atl1.h (100%)
 rename drivers/net/{ => ethernet/atheros}/atlx/atl2.c (99%)
 rename drivers/net/{ => ethernet/atheros}/atlx/atl2.h (100%)
 rename drivers/net/{ => ethernet/atheros}/atlx/atlx.c (100%)
 rename drivers/net/{ => ethernet/atheros}/atlx/atlx.h (100%)
 create mode 100644 drivers/net/ethernet/broadcom/Kconfig
 create mode 100644 drivers/net/ethernet/broadcom/Makefile
 rename drivers/net/{ => ethernet/broadcom}/b44.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/b44.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bcm63xx_enet.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/bcm63xx_enet.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2_fw.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/Makefile (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x.h (98%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_cmn.c (98%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_cmn.h (99%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_dcb.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_dcb.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_dump.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_ethtool.c (98%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_fw_defs.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_fw_file_hdr.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_hsi.h (99%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_init.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_init_ops.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_link.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_link.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_main.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_reg.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_sp.c (98%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_sp.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_stats.c (98%)
 rename drivers/net/{ => ethernet/broadcom}/bnx2x/bnx2x_stats.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/cnic.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/cnic.h (99%)
 rename drivers/net/{ => ethernet/broadcom}/cnic_defs.h (99%)
 rename drivers/net/{ => ethernet/broadcom}/cnic_if.h (100%)
 rename drivers/net/{ => ethernet/broadcom}/sb1250-mac.c (99%)
 rename drivers/net/{ => ethernet/broadcom}/tg3.c (98%)
 rename drivers/net/{ => ethernet/broadcom}/tg3.h (99%)
 create mode 100644 drivers/net/ethernet/brocade/Kconfig
 create mode 100644 drivers/net/ethernet/brocade/Makefile
 create mode 100644 drivers/net/ethernet/brocade/bna/Kconfig
 rename drivers/net/{ => ethernet/brocade}/bna/Makefile (52%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_cee.c (97%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_cee.h (100%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_cs.h (100%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_defs.h (81%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_defs_cna.h (94%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_defs_mfg_comm.h (73%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_defs_status.h (100%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_ioc.c (85%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfa_ioc.h (84%)
 create mode 100644 drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c
 create mode 100644 drivers/net/ethernet/brocade/bna/bfa_msgq.c
 create mode 100644 drivers/net/ethernet/brocade/bna/bfa_msgq.h
 rename drivers/net/{ => ethernet/brocade}/bna/bfi.h (65%)
 rename drivers/net/{ => ethernet/brocade}/bna/bfi_cna.h (100%)
 create mode 100644 drivers/net/ethernet/brocade/bna/bfi_enet.h
 create mode 100644 drivers/net/ethernet/brocade/bna/bfi_reg.h
 rename drivers/net/{ => ethernet/brocade}/bna/bna.h (66%)
 create mode 100644 drivers/net/ethernet/brocade/bna/bna_enet.c
 create mode 100644 drivers/net/ethernet/brocade/bna/bna_hw_defs.h
 create mode 100644 drivers/net/ethernet/brocade/bna/bna_tx_rx.c
 rename drivers/net/{ => ethernet/brocade}/bna/bna_types.h (58%)
 rename drivers/net/{ => ethernet/brocade}/bna/bnad.c (76%)
 rename drivers/net/{ => ethernet/brocade}/bna/bnad.h (74%)
 rename drivers/net/{ => ethernet/brocade}/bna/bnad_ethtool.c (65%)
 rename drivers/net/{ => ethernet/brocade}/bna/cna.h (62%)
 rename drivers/net/{ => ethernet/brocade}/bna/cna_fwimg.c (53%)
 create mode 100644 drivers/net/ethernet/cadence/Kconfig
 create mode 100644 drivers/net/ethernet/cadence/Makefile
 rename drivers/net/{arm => ethernet/cadence}/at91_ether.c (99%)
 rename drivers/net/{arm => ethernet/cadence}/at91_ether.h (100%)
 rename drivers/net/{ => ethernet/cadence}/macb.c (99%)
 rename drivers/net/{ => ethernet/cadence}/macb.h (100%)
 create mode 100644 drivers/net/ethernet/chelsio/Kconfig
 create mode 100644 drivers/net/ethernet/chelsio/Makefile
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/Makefile (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/common.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/cphy.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/cpl5_cmd.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/cxgb2.c (99%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/elmer0.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/espi.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/espi.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/fpga_defs.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/gmac.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/mv88e1xxx.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/mv88e1xxx.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/mv88x201x.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/my3126.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/pm3393.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/regs.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/sge.c (99%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/sge.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/subr.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/suni1x10gexp_regs.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/tp.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/tp.h (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/vsc7326.c (100%)
 rename drivers/net/{chelsio => ethernet/chelsio/cxgb}/vsc7326_reg.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/Makefile (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/adapter.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/ael1002.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/aq100x.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/common.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/cxgb3_ctl_defs.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/cxgb3_defs.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/cxgb3_ioctl.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/cxgb3_main.c (99%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/cxgb3_offload.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/cxgb3_offload.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/firmware_exports.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/l2t.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/l2t.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/mc5.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/regs.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/sge.c (99%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/sge_defs.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/t3_cpl.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/t3_hw.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/t3cdev.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/version.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/vsc8211.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb3/xgmac.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/Makefile (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/cxgb4.h (99%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/cxgb4_main.c (99%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/cxgb4_uld.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/l2t.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/l2t.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/sge.c (98%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/t4_hw.c (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/t4_hw.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/t4_msg.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/t4_regs.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4/t4fw_api.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4vf/Makefile (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4vf/adapter.h (99%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4vf/cxgb4vf_main.c (99%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4vf/sge.c (98%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4vf/t4vf_common.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4vf/t4vf_defs.h (100%)
 rename drivers/net/{ => ethernet/chelsio}/cxgb4vf/t4vf_hw.c (100%)
 create mode 100644 drivers/net/ethernet/cirrus/Kconfig
 create mode 100644 drivers/net/ethernet/cirrus/Makefile
 rename drivers/net/{ => ethernet/cirrus}/cs89x0.c (99%)
 rename drivers/net/{ => ethernet/cirrus}/cs89x0.h (100%)
 rename drivers/net/{arm => ethernet/cirrus}/ep93xx_eth.c (100%)
 create mode 100644 drivers/net/ethernet/cisco/Kconfig
 create mode 100644 drivers/net/ethernet/cisco/Makefile
 create mode 100644 drivers/net/ethernet/cisco/enic/Kconfig
 rename drivers/net/{ => ethernet/cisco}/enic/Makefile (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/cq_desc.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/cq_enet_desc.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic.h (90%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic_dev.c (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic_dev.h (78%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic_main.c (94%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic_pp.c (52%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic_pp.h (68%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic_res.c (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/enic_res.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/rq_enet_desc.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_cq.c (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_cq.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_dev.c (97%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_dev.h (97%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_devcmd.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_enet.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_intr.c (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_intr.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_nic.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_resource.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_rq.c (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_rq.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_rss.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_stats.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_vic.c (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_vic.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_wq.c (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/vnic_wq.h (100%)
 rename drivers/net/{ => ethernet/cisco}/enic/wq_enet_desc.h (100%)
 create mode 100644 drivers/net/ethernet/davicom/Kconfig
 create mode 100644 drivers/net/ethernet/davicom/Makefile
 rename drivers/net/{ => ethernet/davicom}/dm9000.c (99%)
 rename drivers/net/{ => ethernet/davicom}/dm9000.h (100%)
 create mode 100644 drivers/net/ethernet/dec/Kconfig
 create mode 100644 drivers/net/ethernet/dec/Makefile
 rename drivers/net/{ => ethernet/dec}/ewrk3.c (99%)
 rename drivers/net/{ => ethernet/dec}/ewrk3.h (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/21142.c (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/Kconfig (96%)
 rename drivers/net/{ => ethernet/dec}/tulip/Makefile (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/de2104x.c (99%)
 rename drivers/net/{ => ethernet/dec}/tulip/de4x5.c (99%)
 rename drivers/net/{ => ethernet/dec}/tulip/de4x5.h (99%)
 rename drivers/net/{ => ethernet/dec}/tulip/dmfe.c (99%)
 rename drivers/net/{ => ethernet/dec}/tulip/eeprom.c (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/interrupt.c (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/media.c (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/pnic.c (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/pnic2.c (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/timer.c (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/tulip.h (100%)
 rename drivers/net/{ => ethernet/dec}/tulip/tulip_core.c (99%)
 rename drivers/net/{ => ethernet/dec}/tulip/uli526x.c (99%)
 rename drivers/net/{ => ethernet/dec}/tulip/winbond-840.c (99%)
 rename drivers/net/{ => ethernet/dec}/tulip/xircom_cb.c (100%)
 create mode 100644 drivers/net/ethernet/dlink/Kconfig
 create mode 100644 drivers/net/ethernet/dlink/Makefile
 rename drivers/net/{ => ethernet/dlink}/de600.c (100%)
 rename drivers/net/{ => ethernet/dlink}/de600.h (100%)
 rename drivers/net/{ => ethernet/dlink}/de620.c (99%)
 rename drivers/net/{ => ethernet/dlink}/de620.h (100%)
 rename drivers/net/{ => ethernet/dlink}/dl2k.c (95%)
 rename drivers/net/{ => ethernet/dlink}/dl2k.h (81%)
 rename drivers/net/{ => ethernet/dlink}/sundance.c (99%)
 rename drivers/net/{ => ethernet}/dnet.c (100%)
 rename drivers/net/{ => ethernet}/dnet.h (100%)
 create mode 100644 drivers/net/ethernet/emulex/Kconfig
 create mode 100644 drivers/net/ethernet/emulex/Makefile
 create mode 100644 drivers/net/ethernet/emulex/benet/Kconfig
 rename drivers/net/{ => ethernet/emulex}/benet/Makefile (100%)
 rename drivers/net/{ => ethernet/emulex}/benet/be.h (84%)
 rename drivers/net/{ => ethernet/emulex}/benet/be_cmds.c (92%)
 rename drivers/net/{ => ethernet/emulex}/benet/be_cmds.h (94%)
 rename drivers/net/{ => ethernet/emulex}/benet/be_ethtool.c (84%)
 rename drivers/net/{ => ethernet/emulex}/benet/be_hw.h (94%)
 rename drivers/net/{ => ethernet/emulex}/benet/be_main.c (86%)
 rename drivers/net/{ => ethernet}/ethoc.c (99%)
 create mode 100644 drivers/net/ethernet/faraday/Kconfig
 create mode 100644 drivers/net/ethernet/faraday/Makefile
 rename drivers/net/{ => ethernet/faraday}/ftgmac100.c (99%)
 rename drivers/net/{ => ethernet/faraday}/ftgmac100.h (100%)
 rename drivers/net/{ => ethernet/faraday}/ftmac100.c (99%)
 rename drivers/net/{ => ethernet/faraday}/ftmac100.h (100%)
 rename drivers/net/{ => ethernet}/fealnx.c (99%)
 create mode 100644 drivers/net/ethernet/freescale/Kconfig
 create mode 100644 drivers/net/ethernet/freescale/Makefile
 rename drivers/net/{ => ethernet/freescale}/fec.c (93%)
 rename drivers/net/{ => ethernet/freescale}/fec.h (100%)
 rename drivers/net/{ => ethernet/freescale}/fec_mpc52xx.c (99%)
 rename drivers/net/{ => ethernet/freescale}/fec_mpc52xx.h (100%)
 rename drivers/net/{ => ethernet/freescale}/fec_mpc52xx_phy.c (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/Kconfig (89%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/Makefile (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/fec.h (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/fs_enet-main.c (99%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/fs_enet.h (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/mac-fcc.c (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/mac-fec.c (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/mac-scc.c (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/mii-bitbang.c (100%)
 rename drivers/net/{ => ethernet/freescale}/fs_enet/mii-fec.c (100%)
 rename drivers/net/{ => ethernet/freescale}/fsl_pq_mdio.c (100%)
 rename drivers/net/{ => ethernet/freescale}/fsl_pq_mdio.h (100%)
 rename drivers/net/{ => ethernet/freescale}/gianfar.c (99%)
 rename drivers/net/{ => ethernet/freescale}/gianfar.h (100%)
 rename drivers/net/{ => ethernet/freescale}/gianfar_ethtool.c (99%)
 rename drivers/net/{ => ethernet/freescale}/gianfar_ptp.c (100%)
 rename drivers/net/{ => ethernet/freescale}/gianfar_sysfs.c (100%)
 rename drivers/net/{ => ethernet/freescale}/ucc_geth.c (99%)
 rename drivers/net/{ => ethernet/freescale}/ucc_geth.h (100%)
 rename drivers/net/{ => ethernet/freescale}/ucc_geth_ethtool.c (100%)
 create mode 100644 drivers/net/ethernet/fujitsu/Kconfig
 create mode 100644 drivers/net/ethernet/fujitsu/Makefile
 rename drivers/net/{ => ethernet/fujitsu}/at1700.c (99%)
 rename drivers/net/{ => ethernet/fujitsu}/eth16i.c (99%)
 rename drivers/net/{pcmcia => ethernet/fujitsu}/fmvj18x_cs.c (99%)
 create mode 100644 drivers/net/ethernet/hp/Kconfig
 create mode 100644 drivers/net/ethernet/hp/Makefile
 rename drivers/net/{ => ethernet/hp}/hp100.c (99%)
 rename drivers/net/{ => ethernet/hp}/hp100.h (100%)
 rename drivers/net/{ => ethernet/i825xx}/3c505.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/3c505.h (100%)
 rename drivers/net/{ => ethernet/i825xx}/3c507.c (100%)
 rename drivers/net/{ => ethernet/i825xx}/3c523.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/3c523.h (100%)
 rename drivers/net/{ => ethernet/i825xx}/3c527.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/3c527.h (100%)
 rename drivers/net/{ => ethernet/i825xx}/82596.c (99%)
 create mode 100644 drivers/net/ethernet/i825xx/Kconfig
 create mode 100644 drivers/net/ethernet/i825xx/Makefile
 rename drivers/net/{ => ethernet/i825xx}/eepro.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/eexpress.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/eexpress.h (100%)
 rename drivers/net/{arm => ethernet/i825xx}/ether1.c (99%)
 rename drivers/net/{arm => ethernet/i825xx}/ether1.h (100%)
 rename drivers/net/{ => ethernet/i825xx}/lasi_82596.c (100%)
 rename drivers/net/{ => ethernet/i825xx}/lib82596.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/lp486e.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/ni52.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/ni52.h (100%)
 rename drivers/net/{ => ethernet/i825xx}/sni_82596.c (100%)
 rename drivers/net/{ => ethernet/i825xx}/sun3_82586.c (99%)
 rename drivers/net/{ => ethernet/i825xx}/sun3_82586.h (100%)
 rename drivers/net/{ => ethernet/i825xx}/znet.c (99%)
 create mode 100644 drivers/net/ethernet/ibm/Kconfig
 create mode 100644 drivers/net/ethernet/ibm/Makefile
 rename drivers/net/{ => ethernet/ibm}/ehea/Makefile (100%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea.h (96%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea_ethtool.c (91%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea_hw.h (88%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea_main.c (87%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea_phyp.c (100%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea_phyp.h (100%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea_qmr.c (100%)
 rename drivers/net/{ => ethernet/ibm}/ehea/ehea_qmr.h (99%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/Kconfig (63%)
 create mode 100644 drivers/net/ethernet/ibm/emac/Makefile
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/core.c (99%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/core.h (97%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/debug.c (100%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/debug.h (98%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/emac.h (100%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/mal.c (99%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/mal.h (99%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/phy.c (100%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/phy.h (100%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/rgmii.c (100%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/rgmii.h (96%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/tah.c (100%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/tah.h (97%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/zmii.c (100%)
 rename drivers/net/{ibm_newemac => ethernet/ibm/emac}/zmii.h (96%)
 rename drivers/net/{ => ethernet/ibm}/ibmveth.c (99%)
 rename drivers/net/{ => ethernet/ibm}/ibmveth.h (100%)
 rename drivers/net/{ => ethernet/ibm}/iseries_veth.c (99%)
 create mode 100644 drivers/net/ethernet/icplus/Kconfig
 create mode 100644 drivers/net/ethernet/icplus/Makefile
 rename drivers/net/{ => ethernet/icplus}/ipg.c (92%)
 rename drivers/net/{ => ethernet/icplus}/ipg.h (100%)
 create mode 100644 drivers/net/ethernet/intel/Kconfig
 create mode 100644 drivers/net/ethernet/intel/Makefile
 rename drivers/net/{ => ethernet/intel}/e100.c (99%)
 rename drivers/net/{ => ethernet/intel}/e1000/Makefile (100%)
 rename drivers/net/{ => ethernet/intel}/e1000/e1000.h (98%)
 rename drivers/net/{ => ethernet/intel}/e1000/e1000_ethtool.c (99%)
 rename drivers/net/{ => ethernet/intel}/e1000/e1000_hw.c (99%)
 rename drivers/net/{ => ethernet/intel}/e1000/e1000_hw.h (100%)
 rename drivers/net/{ => ethernet/intel}/e1000/e1000_main.c (97%)
 rename drivers/net/{ => ethernet/intel}/e1000/e1000_osdep.h (100%)
 rename drivers/net/{ => ethernet/intel}/e1000/e1000_param.c (100%)
 rename drivers/net/{e1000e/es2lan.c => ethernet/intel/e1000e/80003es2lan.c} (99%)
 rename drivers/net/{ => ethernet/intel}/e1000e/82571.c (98%)
 rename drivers/net/{ => ethernet/intel}/e1000e/Makefile (96%)
 rename drivers/net/{ => ethernet/intel}/e1000e/defines.h (100%)
 rename drivers/net/{ => ethernet/intel}/e1000e/e1000.h (96%)
 rename drivers/net/{ => ethernet/intel}/e1000e/ethtool.c (95%)
 rename drivers/net/{ => ethernet/intel}/e1000e/hw.h (100%)
 rename drivers/net/{ => ethernet/intel}/e1000e/ich8lan.c (98%)
 rename drivers/net/{ => ethernet/intel}/e1000e/lib.c (100%)
 rename drivers/net/{ => ethernet/intel}/e1000e/netdev.c (96%)
 rename drivers/net/{ => ethernet/intel}/e1000e/param.c (100%)
 rename drivers/net/{ => ethernet/intel}/e1000e/phy.c (100%)
 rename drivers/net/{ => ethernet/intel}/igb/Makefile (100%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_82575.c (98%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_82575.h (98%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_defines.h (99%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_hw.h (100%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_mac.c (95%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_mac.h (98%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_mbx.c (100%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_mbx.h (100%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_nvm.c (100%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_nvm.h (100%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_phy.c (99%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_phy.h (100%)
 rename drivers/net/{ => ethernet/intel}/igb/e1000_regs.h (99%)
 rename drivers/net/{ => ethernet/intel}/igb/igb.h (72%)
 rename drivers/net/{ => ethernet/intel}/igb/igb_ethtool.c (98%)
 rename drivers/net/{ => ethernet/intel}/igb/igb_main.c (81%)
 rename drivers/net/{ => ethernet/intel}/igbvf/Makefile (100%)
 rename drivers/net/{ => ethernet/intel}/igbvf/defines.h (100%)
 rename drivers/net/{ => ethernet/intel}/igbvf/ethtool.c (89%)
 rename drivers/net/{ => ethernet/intel}/igbvf/igbvf.h (100%)
 rename drivers/net/{ => ethernet/intel}/igbvf/mbx.c (100%)
 rename drivers/net/{ => ethernet/intel}/igbvf/mbx.h (100%)
 rename drivers/net/{ => ethernet/intel}/igbvf/netdev.c (98%)
 rename drivers/net/{ => ethernet/intel}/igbvf/regs.h (100%)
 rename drivers/net/{ => ethernet/intel}/igbvf/vf.c (100%)
 rename drivers/net/{ => ethernet/intel}/igbvf/vf.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgb/Makefile (100%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb.h (98%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_ee.c (99%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_ee.h (97%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_ethtool.c (90%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_hw.c (99%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_hw.h (99%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_ids.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_main.c (97%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_osdep.h (98%)
 rename drivers/net/{ => ethernet/intel}/ixgb/ixgb_param.c (97%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/Makefile (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe.h (91%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_82598.c (97%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_82599.c (95%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_common.c (96%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_common.h (99%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb.c (84%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb.h (95%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb_82598.c (97%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb_82598.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb_82599.c (88%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb_82599.h (98%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_dcb_nl.c (89%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_ethtool.c (93%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_fcoe.c (95%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_fcoe.h (97%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_main.c (85%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_mbx.c (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_mbx.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_phy.c (98%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_phy.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_sriov.c (73%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_sriov.h (87%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_type.h (97%)
 rename drivers/net/{ => ethernet/intel}/ixgbe/ixgbe_x540.c (91%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/Makefile (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/defines.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/ethtool.c (93%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/ixgbevf.h (98%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/ixgbevf_main.c (97%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/mbx.c (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/mbx.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/regs.h (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/vf.c (100%)
 rename drivers/net/{ => ethernet/intel}/ixgbevf/vf.h (100%)
 rename drivers/net/{ => ethernet}/jme.c (99%)
 rename drivers/net/{ => ethernet}/jme.h (99%)
 rename drivers/net/{ => ethernet}/korina.c (99%)
 rename drivers/net/{ => ethernet}/lantiq_etop.c (99%)
 create mode 100644 drivers/net/ethernet/marvell/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/Makefile
 rename drivers/net/{ => ethernet/marvell}/mv643xx_eth.c (99%)
 rename drivers/net/{ => ethernet/marvell}/pxa168_eth.c (100%)
 rename drivers/net/{ => ethernet/marvell}/skge.c (98%)
 rename drivers/net/{ => ethernet/marvell}/skge.h (100%)
 rename drivers/net/{ => ethernet/marvell}/sky2.c (98%)
 rename drivers/net/{ => ethernet/marvell}/sky2.h (100%)
 create mode 100644 drivers/net/ethernet/mellanox/Kconfig
 create mode 100644 drivers/net/ethernet/mellanox/Makefile
 create mode 100644 drivers/net/ethernet/mellanox/mlx4/Kconfig
 rename drivers/net/{ => ethernet/mellanox}/mlx4/Makefile (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/alloc.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/catas.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/cmd.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/cq.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_cq.c (89%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_ethtool.c (97%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_main.c (98%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_netdev.c (91%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_port.c (93%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_port.h (98%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_resources.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_rx.c (92%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_selftest.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/en_tx.c (97%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/eq.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/fw.c (99%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/fw.h (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/icm.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/icm.h (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/intf.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/main.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/mcg.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/mlx4.h (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/mlx4_en.h (97%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/mr.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/pd.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/port.c (99%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/profile.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/qp.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/reset.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/sense.c (100%)
 rename drivers/net/{ => ethernet/mellanox}/mlx4/srq.c (100%)
 create mode 100644 drivers/net/ethernet/micrel/Kconfig
 create mode 100644 drivers/net/ethernet/micrel/Makefile
 rename drivers/net/{arm => ethernet/micrel}/ks8695net.c (99%)
 rename drivers/net/{arm => ethernet/micrel}/ks8695net.h (100%)
 rename drivers/net/{ => ethernet/micrel}/ks8842.c (100%)
 rename drivers/net/{ => ethernet/micrel}/ks8851.c (100%)
 rename drivers/net/{ => ethernet/micrel}/ks8851.h (100%)
 rename drivers/net/{ => ethernet/micrel}/ks8851_mll.c (100%)
 rename drivers/net/{ => ethernet/micrel}/ksz884x.c (99%)
 create mode 100644 drivers/net/ethernet/microchip/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/Makefile
 rename drivers/net/{ => ethernet/microchip}/enc28j60.c (99%)
 rename drivers/net/{ => ethernet/microchip}/enc28j60_hw.h (100%)
 rename drivers/net/{ => ethernet}/mipsnet.c (99%)
 create mode 100644 drivers/net/ethernet/myricom/Kconfig
 create mode 100644 drivers/net/ethernet/myricom/Makefile
 rename drivers/net/{ => ethernet/myricom}/myri10ge/Makefile (100%)
 rename drivers/net/{ => ethernet/myricom}/myri10ge/myri10ge.c (99%)
 rename drivers/net/{ => ethernet/myricom}/myri10ge/myri10ge_mcp.h (100%)
 rename drivers/net/{ => ethernet/myricom}/myri10ge/myri10ge_mcp_gen_header.h (100%)
 create mode 100644 drivers/net/ethernet/natsemi/Kconfig
 create mode 100644 drivers/net/ethernet/natsemi/Makefile
 rename drivers/net/{ => ethernet/natsemi}/ibmlana.c (99%)
 rename drivers/net/{ => ethernet/natsemi}/ibmlana.h (100%)
 rename drivers/net/{ => ethernet/natsemi}/jazzsonic.c (99%)
 rename drivers/net/{ => ethernet/natsemi}/macsonic.c (98%)
 rename drivers/net/{ => ethernet/natsemi}/natsemi.c (99%)
 rename drivers/net/{ => ethernet/natsemi}/ns83820.c (99%)
 rename drivers/net/{ => ethernet/natsemi}/sonic.c (100%)
 rename drivers/net/{ => ethernet/natsemi}/sonic.h (100%)
 rename drivers/net/{ => ethernet/natsemi}/xtsonic.c (99%)
 create mode 100644 drivers/net/ethernet/neterion/Kconfig
 create mode 100644 drivers/net/ethernet/neterion/Makefile
 rename drivers/net/{ => ethernet/neterion}/s2io-regs.h (100%)
 rename drivers/net/{ => ethernet/neterion}/s2io.c (99%)
 rename drivers/net/{ => ethernet/neterion}/s2io.h (100%)
 rename drivers/net/{ => ethernet/neterion}/vxge/Makefile (100%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-config.c (99%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-config.h (99%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-ethtool.c (100%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-ethtool.h (100%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-main.c (99%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-main.h (100%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-reg.h (100%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-traffic.c (99%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-traffic.h (100%)
 rename drivers/net/{ => ethernet/neterion}/vxge/vxge-version.h (100%)
 rename drivers/net/{ => ethernet}/netx-eth.c (99%)
 create mode 100644 drivers/net/ethernet/nuvoton/Kconfig
 create mode 100644 drivers/net/ethernet/nuvoton/Makefile
 rename drivers/net/{arm => ethernet/nuvoton}/w90p910_ether.c (99%)
 create mode 100644 drivers/net/ethernet/nvidia/Kconfig
 create mode 100644 drivers/net/ethernet/nvidia/Makefile
 rename drivers/net/{ => ethernet/nvidia}/forcedeth.c (99%)
 rename drivers/net/{ => ethernet}/octeon/Kconfig (85%)
 create mode 100644 drivers/net/ethernet/octeon/Makefile
 rename drivers/net/{ => ethernet}/octeon/octeon_mgmt.c (99%)
 create mode 100644 drivers/net/ethernet/oki-semi/Kconfig
 create mode 100644 drivers/net/ethernet/oki-semi/Makefile
 create mode 100644 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/Makefile (100%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe.h (100%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe_api.c (100%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe_api.h (100%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe_ethtool.c (99%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe_main.c (99%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe_param.c (100%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe_phy.c (100%)
 rename drivers/net/{ => ethernet/oki-semi}/pch_gbe/pch_gbe_phy.h (100%)
 create mode 100644 drivers/net/ethernet/packetengines/Kconfig
 create mode 100644 drivers/net/ethernet/packetengines/Makefile
 rename drivers/net/{ => ethernet/packetengines}/hamachi.c (99%)
 rename drivers/net/{ => ethernet/packetengines}/yellowfin.c (99%)
 create mode 100644 drivers/net/ethernet/pasemi/Kconfig
 create mode 100644 drivers/net/ethernet/pasemi/Makefile
 rename drivers/net/{ => ethernet/pasemi}/pasemi_mac.c (99%)
 rename drivers/net/{ => ethernet/pasemi}/pasemi_mac.h (100%)
 rename drivers/net/{ => ethernet/pasemi}/pasemi_mac_ethtool.c (100%)
 create mode 100644 drivers/net/ethernet/qlogic/Kconfig
 create mode 100644 drivers/net/ethernet/qlogic/Makefile
 rename drivers/net/{ => ethernet/qlogic}/netxen/Makefile (100%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic.h (99%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic_ctx.c (100%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic_ethtool.c (99%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic_hdr.h (100%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic_hw.c (100%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic_hw.h (100%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic_init.c (99%)
 rename drivers/net/{ => ethernet/qlogic}/netxen/netxen_nic_main.c (94%)
 rename drivers/net/{ => ethernet/qlogic}/qla3xxx.c (99%)
 rename drivers/net/{ => ethernet/qlogic}/qla3xxx.h (100%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/Makefile (100%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic.h (98%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic_ctx.c (82%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic_ethtool.c (96%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic_hdr.h (99%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic_hw.c (99%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic_init.c (98%)
 rename drivers/net/{ => ethernet/qlogic}/qlcnic/qlcnic_main.c (95%)
 rename drivers/net/{ => ethernet/qlogic}/qlge/Makefile (100%)
 rename drivers/net/{ => ethernet/qlogic}/qlge/qlge.h (100%)
 rename drivers/net/{ => ethernet/qlogic}/qlge/qlge_dbg.c (100%)
 rename drivers/net/{ => ethernet/qlogic}/qlge/qlge_ethtool.c (100%)
 rename drivers/net/{ => ethernet/qlogic}/qlge/qlge_main.c (99%)
 rename drivers/net/{ => ethernet/qlogic}/qlge/qlge_mpi.c (100%)
 create mode 100644 drivers/net/ethernet/racal/Kconfig
 create mode 100644 drivers/net/ethernet/racal/Makefile
 rename drivers/net/{ => ethernet/racal}/ni5010.c (99%)
 rename drivers/net/{ => ethernet/racal}/ni5010.h (100%)
 create mode 100644 drivers/net/ethernet/rdc/Kconfig
 create mode 100644 drivers/net/ethernet/rdc/Makefile
 rename drivers/net/{ => ethernet/rdc}/r6040.c (99%)
 rename drivers/net/{ => ethernet/realtek}/8139cp.c (99%)
 rename drivers/net/{ => ethernet/realtek}/8139too.c (99%)
 create mode 100644 drivers/net/ethernet/realtek/Kconfig
 create mode 100644 drivers/net/ethernet/realtek/Makefile
 rename drivers/net/{ => ethernet/realtek}/atp.c (99%)
 rename drivers/net/{ => ethernet/realtek}/atp.h (100%)
 rename drivers/net/{ => ethernet/realtek}/r8169.c (91%)
 rename drivers/net/{ => ethernet/realtek}/sc92031.c (98%)
 create mode 100644 drivers/net/ethernet/renesas/Kconfig
 create mode 100644 drivers/net/ethernet/renesas/Makefile
 rename drivers/net/{ => ethernet/renesas}/sh_eth.c (98%)
 rename drivers/net/{ => ethernet/renesas}/sh_eth.h (97%)
 rename drivers/net/{ => ethernet}/s6gmac.c (100%)
 create mode 100644 drivers/net/ethernet/seeq/Kconfig
 create mode 100644 drivers/net/ethernet/seeq/Makefile
 rename drivers/net/{arm => ethernet/seeq}/ether3.c (99%)
 rename drivers/net/{arm => ethernet/seeq}/ether3.h (100%)
 rename drivers/net/{ => ethernet/seeq}/seeq8005.c (99%)
 rename drivers/net/{ => ethernet/seeq}/seeq8005.h (100%)
 rename drivers/net/{ => ethernet/seeq}/sgiseeq.c (99%)
 rename drivers/net/{ => ethernet/seeq}/sgiseeq.h (100%)
 rename drivers/net/{ => ethernet}/sfc/Kconfig (96%)
 rename drivers/net/{ => ethernet}/sfc/Makefile (100%)
 rename drivers/net/{ => ethernet}/sfc/bitfield.h (100%)
 rename drivers/net/{ => ethernet}/sfc/efx.c (98%)
 rename drivers/net/{ => ethernet}/sfc/efx.h (95%)
 rename drivers/net/{ => ethernet}/sfc/enum.h (100%)
 rename drivers/net/{ => ethernet}/sfc/ethtool.c (91%)
 rename drivers/net/{ => ethernet}/sfc/falcon.c (99%)
 rename drivers/net/{ => ethernet}/sfc/falcon_boards.c (100%)
 rename drivers/net/{ => ethernet}/sfc/falcon_xmac.c (100%)
 rename drivers/net/{ => ethernet}/sfc/filter.c (100%)
 rename drivers/net/{ => ethernet}/sfc/filter.h (100%)
 rename drivers/net/{ => ethernet}/sfc/io.h (100%)
 rename drivers/net/{ => ethernet}/sfc/mac.h (100%)
 rename drivers/net/{ => ethernet}/sfc/mcdi.c (100%)
 rename drivers/net/{ => ethernet}/sfc/mcdi.h (100%)
 rename drivers/net/{ => ethernet}/sfc/mcdi_mac.c (100%)
 rename drivers/net/{ => ethernet}/sfc/mcdi_pcol.h (100%)
 rename drivers/net/{ => ethernet}/sfc/mcdi_phy.c (100%)
 rename drivers/net/{ => ethernet}/sfc/mdio_10g.c (100%)
 rename drivers/net/{ => ethernet}/sfc/mdio_10g.h (100%)
 rename drivers/net/{ => ethernet}/sfc/mtd.c (100%)
 rename drivers/net/{ => ethernet}/sfc/net_driver.h (100%)
 rename drivers/net/{ => ethernet}/sfc/nic.c (100%)
 rename drivers/net/{ => ethernet}/sfc/nic.h (99%)
 rename drivers/net/{ => ethernet}/sfc/phy.h (100%)
 rename drivers/net/{ => ethernet}/sfc/qt202x_phy.c (100%)
 rename drivers/net/{ => ethernet}/sfc/regs.h (100%)
 rename drivers/net/{ => ethernet}/sfc/rx.c (99%)
 rename drivers/net/{ => ethernet}/sfc/selftest.c (100%)
 rename drivers/net/{ => ethernet}/sfc/selftest.h (100%)
 rename drivers/net/{ => ethernet}/sfc/siena.c (99%)
 rename drivers/net/{ => ethernet}/sfc/spi.h (100%)
 rename drivers/net/{ => ethernet}/sfc/tenxpress.c (100%)
 rename drivers/net/{ => ethernet}/sfc/tx.c (98%)
 rename drivers/net/{ => ethernet}/sfc/txc43128_phy.c (100%)
 rename drivers/net/{ => ethernet}/sfc/workarounds.h (100%)
 create mode 100644 drivers/net/ethernet/sgi/Kconfig
 create mode 100644 drivers/net/ethernet/sgi/Makefile
 rename drivers/net/{ => ethernet/sgi}/ioc3-eth.c (99%)
 rename drivers/net/{ => ethernet/sgi}/meth.c (100%)
 rename drivers/net/{ => ethernet/sgi}/meth.h (100%)
 create mode 100644 drivers/net/ethernet/sis/Kconfig
 create mode 100644 drivers/net/ethernet/sis/Makefile
 rename drivers/net/{ => ethernet/sis}/sis190.c (99%)
 rename drivers/net/{ => ethernet/sis}/sis900.c (99%)
 rename drivers/net/{ => ethernet/sis}/sis900.h (100%)
 create mode 100644 drivers/net/ethernet/smsc/Kconfig
 create mode 100644 drivers/net/ethernet/smsc/Makefile
 rename drivers/net/{ => ethernet/smsc}/epic100.c (99%)
 rename drivers/net/{ => ethernet/smsc}/smc911x.c (99%)
 rename drivers/net/{ => ethernet/smsc}/smc911x.h (100%)
 rename drivers/net/{ => ethernet/smsc}/smc9194.c (99%)
 rename drivers/net/{ => ethernet/smsc}/smc9194.h (100%)
 rename drivers/net/{pcmcia => ethernet/smsc}/smc91c92_cs.c (99%)
 rename drivers/net/{ => ethernet/smsc}/smc91x.c (99%)
 rename drivers/net/{ => ethernet/smsc}/smc91x.h (100%)
 rename drivers/net/{ => ethernet/smsc}/smsc911x.c (96%)
 rename drivers/net/{ => ethernet/smsc}/smsc911x.h (100%)
 rename drivers/net/{ => ethernet/smsc}/smsc9420.c (99%)
 rename drivers/net/{ => ethernet/smsc}/smsc9420.h (100%)
 create mode 100644 drivers/net/ethernet/stmicro/Kconfig
 create mode 100644 drivers/net/ethernet/stmicro/Makefile
 rename drivers/net/{ => ethernet/stmicro}/stmmac/Kconfig (63%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/Makefile (51%)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/chain_mode.c
 rename drivers/net/{ => ethernet/stmicro}/stmmac/common.h (70%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/descs.h (100%)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/descs_com.h
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac100.h (100%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac1000.h (100%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac1000_core.c (96%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac1000_dma.c (95%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac100_core.c (91%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac100_dma.c (100%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac_dma.h (98%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/dwmac_lib.c (100%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/enh_desc.c (95%)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/mmc.h
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/mmc_core.c
 rename drivers/net/{ => ethernet/stmicro}/stmmac/norm_desc.c (96%)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/ring_mode.c
 rename drivers/net/{ => ethernet/stmicro}/stmmac/stmmac.h (94%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/stmmac_ethtool.c (65%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/stmmac_main.c (80%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/stmmac_mdio.c (100%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/stmmac_timer.c (100%)
 rename drivers/net/{ => ethernet/stmicro}/stmmac/stmmac_timer.h (100%)
 create mode 100644 drivers/net/ethernet/sun/Kconfig
 create mode 100644 drivers/net/ethernet/sun/Makefile
 rename drivers/net/{ => ethernet/sun}/cassini.c (99%)
 rename drivers/net/{ => ethernet/sun}/cassini.h (100%)
 rename drivers/net/{ => ethernet/sun}/niu.c (99%)
 rename drivers/net/{ => ethernet/sun}/niu.h (100%)
 rename drivers/net/{ => ethernet/sun}/sunbmac.c (97%)
 rename drivers/net/{ => ethernet/sun}/sunbmac.h (95%)
 rename drivers/net/{ => ethernet/sun}/sungem.c (99%)
 rename drivers/net/{ => ethernet/sun}/sungem.h (100%)
 rename drivers/net/{ => ethernet/sun}/sunhme.c (99%)
 rename drivers/net/{ => ethernet/sun}/sunhme.h (100%)
 rename drivers/net/{ => ethernet/sun}/sunqe.c (99%)
 rename drivers/net/{ => ethernet/sun}/sunqe.h (100%)
 rename drivers/net/{ => ethernet/sun}/sunvnet.c (99%)
 rename drivers/net/{ => ethernet/sun}/sunvnet.h (100%)
 create mode 100644 drivers/net/ethernet/tehuti/Kconfig
 create mode 100644 drivers/net/ethernet/tehuti/Makefile
 rename drivers/net/{ => ethernet/tehuti}/tehuti.c (99%)
 rename drivers/net/{ => ethernet/tehuti}/tehuti.h (100%)
 create mode 100644 drivers/net/ethernet/ti/Kconfig
 create mode 100644 drivers/net/ethernet/ti/Makefile
 rename drivers/net/{ => ethernet/ti}/cpmac.c (99%)
 rename drivers/net/{ => ethernet/ti}/davinci_cpdma.c (100%)
 rename drivers/net/{ => ethernet/ti}/davinci_cpdma.h (100%)
 rename drivers/net/{ => ethernet/ti}/davinci_emac.c (99%)
 rename drivers/net/{ => ethernet/ti}/davinci_mdio.c (100%)
 rename drivers/net/{ => ethernet/ti}/tlan.c (99%)
 rename drivers/net/{ => ethernet/ti}/tlan.h (100%)
 create mode 100644 drivers/net/ethernet/tile/Kconfig
 rename drivers/net/{ => ethernet}/tile/Makefile (100%)
 rename drivers/net/{ => ethernet}/tile/tilepro.c (99%)
 create mode 100644 drivers/net/ethernet/toshiba/Kconfig
 create mode 100644 drivers/net/ethernet/toshiba/Makefile
 rename drivers/net/{ => ethernet/toshiba}/ps3_gelic_net.c (99%)
 rename drivers/net/{ => ethernet/toshiba}/ps3_gelic_net.h (100%)
 rename drivers/net/{ => ethernet/toshiba}/ps3_gelic_wireless.c (99%)
 rename drivers/net/{ => ethernet/toshiba}/ps3_gelic_wireless.h (100%)
 rename drivers/net/{ => ethernet/toshiba}/spider_net.c (99%)
 rename drivers/net/{ => ethernet/toshiba}/spider_net.h (99%)
 rename drivers/net/{ => ethernet/toshiba}/spider_net_ethtool.c (100%)
 rename drivers/net/{ => ethernet/toshiba}/tc35815.c (99%)
 create mode 100644 drivers/net/ethernet/tundra/Kconfig
 create mode 100644 drivers/net/ethernet/tundra/Makefile
 rename drivers/net/{ => ethernet/tundra}/tsi108_eth.c (99%)
 rename drivers/net/{ => ethernet/tundra}/tsi108_eth.h (100%)
 create mode 100644 drivers/net/ethernet/via/Kconfig
 create mode 100644 drivers/net/ethernet/via/Makefile
 rename drivers/net/{ => ethernet/via}/via-rhine.c (99%)
 rename drivers/net/{ => ethernet/via}/via-velocity.c (97%)
 rename drivers/net/{ => ethernet/via}/via-velocity.h (100%)
 create mode 100644 drivers/net/ethernet/xilinx/Kconfig
 create mode 100644 drivers/net/ethernet/xilinx/Makefile
 rename drivers/net/{ => ethernet/xilinx}/ll_temac.h (100%)
 rename drivers/net/{ => ethernet/xilinx}/ll_temac_main.c (97%)
 rename drivers/net/{ => ethernet/xilinx}/ll_temac_mdio.c (100%)
 rename drivers/net/{ => ethernet/xilinx}/xilinx_emaclite.c (100%)
 create mode 100644 drivers/net/ethernet/xircom/Kconfig
 create mode 100644 drivers/net/ethernet/xircom/Makefile
 rename drivers/net/{pcmcia => ethernet/xircom}/xirc2ps_cs.c (99%)
 create mode 100644 drivers/net/ethernet/xscale/Kconfig
 create mode 100644 drivers/net/ethernet/xscale/Makefile
 rename drivers/net/{ => ethernet/xscale}/ixp2000/Kconfig (94%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/Makefile (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/caleb.c (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/caleb.h (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/enp2611.c (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixp2400-msf.c (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixp2400-msf.h (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixp2400_rx.uc (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixp2400_rx.ucode (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixp2400_tx.uc (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixp2400_tx.ucode (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixpdev.c (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixpdev.h (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/ixpdev_priv.h (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/pm3386.c (100%)
 rename drivers/net/{ => ethernet/xscale}/ixp2000/pm3386.h (100%)
 rename drivers/net/{arm => ethernet/xscale}/ixp4xx_eth.c (99%)
 create mode 100644 drivers/net/fddi/Kconfig
 create mode 100644 drivers/net/fddi/Makefile
 rename drivers/net/{ => fddi}/defxx.c (99%)
 rename drivers/net/{ => fddi}/defxx.h (100%)
 rename drivers/net/{ => fddi}/skfp/Makefile (100%)
 rename drivers/net/{ => fddi}/skfp/cfm.c (100%)
 rename drivers/net/{ => fddi}/skfp/drvfbi.c (100%)
 rename drivers/net/{ => fddi}/skfp/ecm.c (100%)
 rename drivers/net/{ => fddi}/skfp/ess.c (100%)
 rename drivers/net/{ => fddi}/skfp/fplustm.c (100%)
 rename drivers/net/{ => fddi}/skfp/h/cmtdef.h (99%)
 rename drivers/net/{ => fddi}/skfp/h/fddi.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/fddimib.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/fplustm.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/hwmtm.h (99%)
 rename drivers/net/{ => fddi}/skfp/h/mbuf.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/osdef1st.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/sba.h (98%)
 rename drivers/net/{ => fddi}/skfp/h/sba_def.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/skfbi.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/skfbiinc.h (99%)
 rename drivers/net/{ => fddi}/skfp/h/smc.h (98%)
 rename drivers/net/{ => fddi}/skfp/h/smt.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/smt_p.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/smtstate.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/supern_2.h (100%)
 rename drivers/net/{ => fddi}/skfp/h/targethw.h (98%)
 rename drivers/net/{ => fddi}/skfp/h/targetos.h (99%)
 rename drivers/net/{ => fddi}/skfp/h/types.h (100%)
 rename drivers/net/{ => fddi}/skfp/hwmtm.c (100%)
 rename drivers/net/{ => fddi}/skfp/hwt.c (100%)
 rename drivers/net/{ => fddi}/skfp/pcmplc.c (100%)
 rename drivers/net/{ => fddi}/skfp/pmf.c (100%)
 rename drivers/net/{ => fddi}/skfp/queue.c (100%)
 rename drivers/net/{ => fddi}/skfp/rmt.c (100%)
 rename drivers/net/{ => fddi}/skfp/skfddi.c (99%)
 rename drivers/net/{ => fddi}/skfp/smt.c (100%)
 rename drivers/net/{ => fddi}/skfp/smtdef.c (100%)
 rename drivers/net/{ => fddi}/skfp/smtinit.c (100%)
 rename drivers/net/{ => fddi}/skfp/smttimer.c (100%)
 rename drivers/net/{ => fddi}/skfp/srf.c (100%)
 create mode 100644 drivers/net/hippi/Kconfig
 create mode 100644 drivers/net/hippi/Makefile
 rename drivers/net/{ => hippi}/rrunner.c (100%)
 rename drivers/net/{ => hippi}/rrunner.h (100%)
 delete mode 100644 drivers/net/ibm_newemac/Makefile
 delete mode 100644 drivers/net/octeon/Makefile
 delete mode 100644 drivers/net/pci-skeleton.c
 delete mode 100644 drivers/net/pcmcia/Kconfig
 delete mode 100644 drivers/net/pcmcia/Makefile
 create mode 100644 drivers/net/plip/Kconfig
 create mode 100644 drivers/net/plip/Makefile
 rename drivers/net/{ => plip}/plip.c (100%)
 create mode 100644 drivers/net/ppp/Kconfig
 create mode 100644 drivers/net/ppp/Makefile
 rename drivers/net/{ => ppp}/bsd_comp.c (100%)
 rename drivers/net/{ => ppp}/ppp_async.c (100%)
 rename drivers/net/{ => ppp}/ppp_deflate.c (100%)
 rename drivers/net/{ => ppp}/ppp_generic.c (100%)
 rename drivers/net/{ => ppp}/ppp_mppe.c (100%)
 rename drivers/net/{ => ppp}/ppp_mppe.h (100%)
 rename drivers/net/{ => ppp}/ppp_synctty.c (100%)
 rename drivers/net/{ => ppp}/pppoe.c (100%)
 rename drivers/net/{ => ppp}/pppox.c (100%)
 rename drivers/net/{ => ppp}/pptp.c (100%)
 create mode 100644 drivers/net/slip/Kconfig
 create mode 100644 drivers/net/slip/Makefile
 rename drivers/net/{ => slip}/slhc.c (100%)
 rename drivers/net/{ => slip}/slip.c (98%)
 rename drivers/net/{ => slip}/slip.h (94%)
 rename drivers/net/{pcmcia => tokenring}/ibmtr_cs.c (99%)
 create mode 100644 drivers/net/wireless/ath/ath6kl/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath6kl/Makefile
 create mode 100644 drivers/net/wireless/ath/ath6kl/bmi.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/bmi.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/cfg80211.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/common.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/core.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/debug.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/debug.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/hif-ops.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/hif.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/init.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/main.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/sdio.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/target.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/testmode.h
 create mode 100644 drivers/net/wireless/ath/ath6kl/txrx.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/wmi.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_rtt.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_rtt.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
 create mode 100644 drivers/net/wireless/brcm80211/Kconfig
 create mode 100644 drivers/net/wireless/brcm80211/Makefile
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/Makefile
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/Makefile
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/antsel.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/antsel.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/channel.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/channel.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/d11.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/dma.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/dma.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/main.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/main.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/otp.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/otp.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_qmath.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_qmath.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_radio.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phyreg_n.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_n.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_n.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/pmu.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/pmu.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/pub.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/rate.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/rate.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/scb.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/srom.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/srom.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/stf.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/stf.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/types.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/ucode_loader.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/ucode_loader.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmutil/Makefile
 create mode 100644 drivers/net/wireless/brcm80211/brcmutil/utils.c
 create mode 100644 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
 create mode 100644 drivers/net/wireless/brcm80211/include/brcmu_utils.h
 create mode 100644 drivers/net/wireless/brcm80211/include/brcmu_wifi.h
 create mode 100644 drivers/net/wireless/brcm80211/include/chipcommon.h
 create mode 100644 drivers/net/wireless/brcm80211/include/defs.h
 create mode 100644 drivers/net/wireless/brcm80211/include/soc.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-6000-hw.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
 rename drivers/net/wireless/iwlwifi/{iwl-rx.c => iwl-agn-rx.c} (77%)
 rename drivers/net/wireless/iwlwifi/{iwl-5000-hw.h => iwl-cfg.h} (60%)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-helpers.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-shared.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-sta.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-sta.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
 rename drivers/net/wireless/iwlwifi/{iwl-trans-tx-pcie.c => iwl-trans-pcie-tx.c} (52%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
 create mode 100644 drivers/net/wireless/mwifiex/pcie.c
 create mode 100644 drivers/net/wireless/mwifiex/pcie.h
 create mode 100644 drivers/nfc/nfcwilink.c
 delete mode 100644 drivers/staging/ath6kl/Kconfig
 delete mode 100644 drivers/staging/ath6kl/Makefile
 delete mode 100644 drivers/staging/ath6kl/TODO
 delete mode 100644 drivers/staging/ath6kl/bmi/include/bmi_internal.h
 delete mode 100644 drivers/staging/ath6kl/bmi/src/bmi.c
 delete mode 100644 drivers/staging/ath6kl/hif/common/hif_sdio_common.h
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.h
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_debug.h
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_internal.h
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_recv.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_send.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_services.c
 delete mode 100644 drivers/staging/ath6kl/include/a_config.h
 delete mode 100644 drivers/staging/ath6kl/include/a_debug.h
 delete mode 100644 drivers/staging/ath6kl/include/a_drv.h
 delete mode 100644 drivers/staging/ath6kl/include/a_drv_api.h
 delete mode 100644 drivers/staging/ath6kl/include/a_osapi.h
 delete mode 100644 drivers/staging/ath6kl/include/aggr_recv_api.h
 delete mode 100644 drivers/staging/ath6kl/include/ar3kconfig.h
 delete mode 100644 drivers/staging/ath6kl/include/ar6000_api.h
 delete mode 100644 drivers/staging/ath6kl/include/ar6000_diag.h
 delete mode 100644 drivers/staging/ath6kl/include/ar6kap_common.h
 delete mode 100644 drivers/staging/ath6kl/include/athbtfilter.h
 delete mode 100644 drivers/staging/ath6kl/include/bmi.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6K_version.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/addrs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_athr_wlan_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/uart_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/athdefs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/bmi_msg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/cnxmgmt.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dbglog.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dbglog_id.h
 delete mode 100644 drivers/staging/ath6kl/include/common/discovery.h
 delete mode 100644 drivers/staging/ath6kl/include/common/epping_test.h
 delete mode 100644 drivers/staging/ath6kl/include/common/gmboxif.h
 delete mode 100644 drivers/staging/ath6kl/include/common/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/htc.h
 delete mode 100644 drivers/staging/ath6kl/include/common/htc_services.h
 delete mode 100644 drivers/staging/ath6kl/include/common/pkt_log.h
 delete mode 100644 drivers/staging/ath6kl/include/common/roaming.h
 delete mode 100644 drivers/staging/ath6kl/include/common/targaddrs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/testcmd.h
 delete mode 100644 drivers/staging/ath6kl/include/common/tlpm.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wlan_defs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmi.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmix.h
 delete mode 100644 drivers/staging/ath6kl/include/common_drv.h
 delete mode 100644 drivers/staging/ath6kl/include/dbglog_api.h
 delete mode 100644 drivers/staging/ath6kl/include/dl_list.h
 delete mode 100644 drivers/staging/ath6kl/include/dset_api.h
 delete mode 100644 drivers/staging/ath6kl/include/hci_transport_api.h
 delete mode 100644 drivers/staging/ath6kl/include/hif.h
 delete mode 100644 drivers/staging/ath6kl/include/host_version.h
 delete mode 100644 drivers/staging/ath6kl/include/htc_api.h
 delete mode 100644 drivers/staging/ath6kl/include/htc_packet.h
 delete mode 100644 drivers/staging/ath6kl/include/wlan_api.h
 delete mode 100644 drivers/staging/ath6kl/include/wmi_api.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kconfig.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/common_drv.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/credit_dist.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/miscdrv.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_drv.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_pm.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/cfg80211.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/export_hci_transport.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/hci_bridge.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/cfg80211.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/config_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/debug_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/osapi_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/wlan_config.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/netbuf.c
 delete mode 100644 drivers/staging/ath6kl/reorder/aggr_rx_internal.h
 delete mode 100644 drivers/staging/ath6kl/reorder/rcv_aggr.c
 delete mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211.h
 delete mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211_node.h
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_node.c
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_utils.c
 delete mode 100644 drivers/staging/ath6kl/wmi/wmi.c
 delete mode 100644 drivers/staging/ath6kl/wmi/wmi_host.h
 create mode 100644 include/linux/bcma/bcma_driver_mips.h
 create mode 100644 include/linux/bcma/bcma_soc.h
 create mode 100644 include/linux/can/gw.h
 rename {arch/sh/include/asm => include/linux}/sh_eth.h (90%)
 rename {drivers/net => include/linux}/sungem_phy.h (98%)
 create mode 100644 include/net/cfg80211-wext.h
 create mode 100644 include/net/nfc/nci.h
 create mode 100644 include/net/nfc/nci_core.h
 rename include/net/{ => nfc}/nfc.h (94%)
 delete mode 100644 net/batman-adv/aggregation.c
 delete mode 100644 net/batman-adv/aggregation.h
 create mode 100644 net/batman-adv/bat_iv_ogm.c
 create mode 100644 net/batman-adv/bat_ogm.h
 create mode 100644 net/can/gw.c
 create mode 100644 net/ieee802154/6lowpan.c
 create mode 100644 net/ieee802154/6lowpan.h
 create mode 100644 net/nfc/nci/Kconfig
 create mode 100644 net/nfc/nci/Makefile
 create mode 100644 net/nfc/nci/core.c
 create mode 100644 net/nfc/nci/data.c
 create mode 100644 net/nfc/nci/lib.c
 create mode 100644 net/nfc/nci/ntf.c
 create mode 100644 net/nfc/nci/rsp.c
 delete mode 100644 net/rds/xlist.h
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
