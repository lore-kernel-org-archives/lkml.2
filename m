Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab2FHONu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:13:50 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:53055 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932652Ab2FHONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:13:48 -0400
Message-ID: <1339164804.7078.160.camel@cumari.coelho.fi>
Subject: pull request: new wl18xx wireless driver for TI WiLink8 chips
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        arik@wizery.com, assaf@ti.com
Date: Fri, 08 Jun 2012 17:13:24 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-B0+is7dZhy7y1F2f5BDQ"
X-Mailer: Evolution 3.2.2-1+b1
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B0+is7dZhy7y1F2f5BDQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a big pull request intended for 3.6 that contains a new
mac80211-based driver for Texas Instruments' WiLink8 chip family[1].
The new driver is based on the existing wlcore module that is already
used by the wl12xx driver, and implements mostly the hardware-specific
parts and new features.

There is a bunch of fixes and small improvements in the wl12xx and
wlcore modules as well, but the vast majority of patches are the actual
inclusion of the new driver or changes in wlcore and wl12xx that are
related to it.

Thanks a lot to Arik Nemtsov for all the effort and help in putting the
wl18xx together! Thanks to Assaf Azulay also for all the
behind-the-scenes work needed to make this possible!

Please pull or let me know if there's any problem.

Cheers,
Luca.

[1] http://www.ti.com/ww/en/wtbu/wilink8/



The following changes since commit 2eb278e083549f4eb29838037004054b3b55df62=
:

  mac80211: unify SW/offload remain-on-channel (2012-06-06 15:31:18 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to bf34e68352ac9f8deae3e78c2825ac9fe373e73e:

  Merge branch 'wl12xx-next' into for-linville (2012-06-08 16:43:19 +0300)

----------------------------------------------------------------

Arik Nemtsov (42):
      wl18xx: create per-chip-family private storage
      wl18xx: set the number of Tx descriptors
      wl18xx: set normal/GEM Tx spare block counts
      wl18xx: implement hw op for calculating hw block count per packet
      wl18xx: implement hw op for setting blocks in hw_tx_desc
      wl18xx: implement hw op for setting frame length in tx_hw_desc
      wl18xx: define HW-rate translation elements/tables
      wl18xx: add fw_status private data
      wl18xx: set Rx block-size alignment quirk
      wl18xx: implement hw op for getting rx buffer data alignment
      wl18xx: implement hw op for getting rx packet data length
      wl18xx: implement immediate Tx completion
      wlcore/wl18xx: add hw op for setting Tx HW checksum
      wlcore/wl18xx: add hw op for Rx HW checksum
      wlcore: track current channel type per vif
      wl18xx: send channel type to FW on role start
      wl18xx: ipmlement ap_rate_mask hw op
      wlcore: support peer MIMO rates
      wlcore/wl18xx: enable MIMO/wide-chan rates in AP-mode rate config
      wl18xx: set HT capabilities
      wl18xx: add module param for overriding HT caps
      wl18xx: read FW pc on recovery
      wl18xx: disable FW log functionality
      wl18xx: implement hw op to read PG version
      wl18xx: init Tx-released index to 0 on HW init
      wl18xx: don't upload NVS to FW
      wl18xx: change board type enum according to new FW
      wlcore/wl12xx/18xx: split fw_status struct into two
      wlcore: fix sparse warnings related to static functions
      wlcore: fix dynamic_ps_timeout time regression
      wlcore: fixes for connection_loss_work
      wl18xx: add dependency on mac80211
      wlcore: remove duplicate BUG_ON during recovery
      wlcore/wl12xx/wl18xx: introduce quirk to remove TKIP header space
      wlcore/wl12xx/wl18xx: handle spare blocks spacial cases per arch
      wlcore: add stop reason bitmap for waking/starting queues
      wlcore: stop queues on Tx flush
      wlcore/wl12xx/wl18xx: implement op_set_key per HW arch
      wl18xx: allow FW-log by default for PG2.0
      wl18xx: align wl18xx_conf_phy with FW variant and remove it
      wl18xx: clean up phy module parameters
      wlcore/wl12xx/wl18xx: make NVS file optional for wl18xx

Assaf Azulay (2):
      wl18xx: change default tcp_checksum to false
      wlcore: increase number of BA sessions to 3

Eliad Peller (9):
      wlcore: use the original elp time in forced_ps mode
      wlcore: use correct link for bcast/multicast frames
      wlcore: flush before stopping AP
      wlcore: set wl->ht_cap per-band
      wlcore: flush tx on CHANGE_CHANNEL
      wlcore: increase WL1271_EVENT_TIMEOUT
      wl12xx: send beacon loss events to userspace
      wl12xx/wl18xx: add erp protection IE to the beacon filter
      wlcore: compare ssid_len before comparing ssids

Eyal Shapira (2):
      wlcore: add support macros to easily add conf debugfs entries
      wlcore: add debugfs control over rx interrupt pacing

Grant Erickson (1):
      wl12xx: Add support for an external 26 MHz crystal source

Ido Reis (6):
      wl18xx: fix PHY_INIT addresses mem size
      wl18xx: support PG2 version of the chip
      wl18xx: FW/PHY arguments added for PG2
      wl18xx: PG2.0 HW Watch dog interrupt support
      wl18xx: pad only last frame in aggregration buffer for PG2
      wl18xx: update fw statistics

Igal Chernobelsky (1):
      wlcore: modify bss loss parameters

Luciano Coelho (58):
      wl18xx: add new module
      wlcore_sdio/wl18xx: use SDIO revision number to identify wl18xx chips
      wl18xx: add empty operations struct
      wl18xx: add partition table
      wl18xx: add register table
      wl18xx: add identify chip operation
      wl18xx: add some boot operations and hw-specific configurations
      wl18xx: add trigger command and ack event operations
      wl18xx: add hw_init operation
      wl18xx: add runtime configuration parameters
      wl18xx: add board type module argument
      wl18xx: translate and write the board type to SCR_PAD2
      wl18xx: read clock frequency and do top init accordingly
      wlcore: rename wl12xx.h to wlcore_i.h
      wlcore/wl12xx: move ref_clock and tcxo_clock elements to wl12xx
      wlcore/wl12xx: move rx_mem_pool_addr element to wl12xx
      wlcore/wl12xx: add plt_init op and move the code to wl12xx
      wl18xx: add plt_init operation
      wl18xx: change the low_band_component_type for HDK boards
      wl18xx: add number of antennas and dc2dc type as module params
      wl18xx: add module parameter to disable TCP checksum
      wl18xx: derive the MAC address from the BD_ADDR in fuse ROM
      wl18xx: add a module parameter to control 11a support
      wlcore: add module parameter to dump SDIO reads and writes
      wl18xx: copy the default configuration before checking the board_type
      wl18xx: changed default board_type to HDK
      wlcore: add space for private area when allocating fw_status
      wl18xx: change low_band_component_type value for COM8
      wlcore: reorder identify_chip and get_hw_info
      wl18xx: disable MCS_13 for wl18xx PG 1.0
      wlcore: update beacon and probe_resp templates when rates change
      wlcore: use all AP basic rates as default
      wlcore: abstract debugfs fw_stats to be handled by the lower drivers
      wlcore: add debugfs macro to help print fw statistics arrays
      wl12xx: implement fw status debugfs entries
      wl18xx: implement fw status debugfs entries
      wlcore: create private static_data area and add operation to parse it
      wl18xx: print the PHY firmware version from the private static data
      wlcore: print the interrupt status when recovery is triggered
      wl18xx: don't use MIMO when ht_mode is set to wide
      wlcore: use proper values for supported local rates
      wl18xx: add module parameter to force SISO 20MHz
      wl18xx: add power limit reference value to mac_and_phy settings
      wl18xx: export low/high band component values as module params
      wl18xx: export pwr_limit_reference_11_abg value as a module parameter
      wlcore/wl12xx/wl18xx: move lower driver debugfs to a subdir
      wlcore: increase aggregation buffer size by one page
      wl18xx: increase tx_ba_win_size to 64
      wl18xx: use new fw stats structures
      wlcore/wl12xx/wl18xx: don't use TX align quirk for wl127x
      wl18xx: add support to clear FW statistics
      wlcore: export raw binary with the FW statistics in debugfs
      wlcore/wl18xx/wl12xx: use u8 instead of bool for host_fast_wakeup_sup=
port
      wlcore: use u8 instead of enum for bcn_filt_mode
      wlcore/wl18xx: the conf structs must be packed so they can be exporte=
d
      wlcore/wl18xx: export conf struct in a debugfs file
      wl18xx: read configuration structure from a binary file
      Merge branch 'wl12xx-next' into for-linville

Victor Goldenshtein (5):
      wl12xx: fix fm_coex parameters configuration
      wl18xx: fix fm_coex parameters configuration
      wlcore: don't enable BET for high basic rates
      wlcore: wait for roc complete only for the first roc command
      wlcore: set channels 12-14 as pactive for sched scan

Yoni Divinsky (5):
      wlcore: use psd_type indexing according to spec
      wl12xx: set the irq polarity before loading the fw
      wlcore: fix the CONF_TX_AC_ANY_TID to be 0xff
      wlcore: do not send stop fwlog cmd if fw is hanged
      wlcore: add role_id to all the sched_scan commands

 drivers/net/wireless/ti/Kconfig                         |    1 +
 drivers/net/wireless/ti/Makefile                        |    1 +
 drivers/net/wireless/ti/wl12xx/Makefile                 |    2 +-
 drivers/net/wireless/ti/wl12xx/acx.h                    |  237 ++++++++
 drivers/net/wireless/ti/wl12xx/cmd.c                    |    8 +-
 drivers/net/wireless/ti/wl12xx/debugfs.c                |  243 ++++++++
 drivers/net/wireless/ti/wl12xx/debugfs.h                |   28 +
 drivers/net/wireless/ti/wl12xx/main.c                   |  242 ++++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h                 |    8 +
 drivers/net/wireless/ti/wl18xx/Kconfig                  |    7 +
 drivers/net/wireless/ti/wl18xx/Makefile                 |    3 +
 drivers/net/wireless/ti/wl18xx/acx.c                    |  111 ++++
 drivers/net/wireless/ti/wl18xx/acx.h                    |  291 +++++++++
 drivers/net/wireless/ti/wl18xx/conf.h                   |   92 +++
 drivers/net/wireless/ti/wl18xx/debugfs.c                |  403 +++++++++++=
++
 drivers/net/wireless/ti/wl18xx/debugfs.h                |   28 +
 drivers/net/wireless/ti/wl18xx/io.c                     |   60 ++
 drivers/net/wireless/ti/wl18xx/io.h                     |   28 +
 drivers/net/wireless/ti/wl18xx/main.c                   | 1462 +++++++++++=
++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/reg.h                    |  191 ++++++
 drivers/net/wireless/ti/wl18xx/tx.c                     |  127 ++++
 drivers/net/wireless/ti/wl18xx/tx.h                     |   46 ++
 drivers/net/wireless/ti/wl18xx/wl18xx.h                 |   88 +++
 drivers/net/wireless/ti/wlcore/acx.c                    |    8 +-
 drivers/net/wireless/ti/wlcore/acx.h                    |  254 +-------
 drivers/net/wireless/ti/wlcore/boot.c                   |   57 +-
 drivers/net/wireless/ti/wlcore/boot.h                   |    1 +
 drivers/net/wireless/ti/wlcore/cmd.c                    |   62 +-
 drivers/net/wireless/ti/wlcore/cmd.h                    |   13 +-
 drivers/net/wireless/ti/wlcore/conf.h                   |   93 ++-
 drivers/net/wireless/ti/wlcore/debugfs.c                |  390 ++++-------=
-
 drivers/net/wireless/ti/wlcore/debugfs.h                |   87 +++
 drivers/net/wireless/ti/wlcore/event.c                  |   24 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h                 |   78 +++
 drivers/net/wireless/ti/wlcore/init.c                   |    3 +
 drivers/net/wireless/ti/wlcore/main.c                   |  504 ++++++++---=
-----
 drivers/net/wireless/ti/wlcore/ps.c                     |   21 +-
 drivers/net/wireless/ti/wlcore/rx.c                     |   11 +-
 drivers/net/wireless/ti/wlcore/rx.h                     |    7 +-
 drivers/net/wireless/ti/wlcore/scan.c                   |   52 +-
 drivers/net/wireless/ti/wlcore/scan.h                   |   19 +-
 drivers/net/wireless/ti/wlcore/sdio.c                   |   35 +-
 drivers/net/wireless/ti/wlcore/tx.c                     |  185 ++++--
 drivers/net/wireless/ti/wlcore/tx.h                     |   49 +-
 drivers/net/wireless/ti/wlcore/wlcore.h                 |   70 ++-
 drivers/net/wireless/ti/wlcore/{wl12xx.h =3D> wlcore_i.h} |   44 +-
 46 files changed, 4818 insertions(+), 956 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl18xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/conf.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/main.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/reg.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/wl18xx.h
 rename drivers/net/wireless/ti/wlcore/{wl12xx.h =3D> wlcore_i.h} (95%)

--=20
Cheers,
Luca.



--=-B0+is7dZhy7y1F2f5BDQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0giEAAoJEKFHnKIaPMX6iGAQAJMqwf90md/hRPQ1AhExesFm
fIzu8oPd3w3I0xK9ySag1moJ3TBka8vY19aSG2+8mLLqUV28yg9JA9jLaLTW5SWL
n5bhCi2OAYY/Woh/23MfthP0IMnHJ1Tg0I6m1HEAJ2VM8D8wBDNygVpMi28eO+iE
wjPZrv6FBOotU2L6EvgWZZI+f3VSanlAyxBdRyBBj1iiZyvdL6qUWC90Aw9Q77Dd
G6pg64m4Yhkl2I7qDeXHDIcXSU1B84g1OFJ+mHONlZoNoVIFWHwESeCdTAYzI0Mp
0dzBg5T/8GCWdeLKf7JJ4OzHKO3ysxaCowfM/ZeDxJYOgZrF2fwowQ0Tnvq86495
CFpZ4HzDnofK2C3AFbn77txKua0Dt7UDwlOQcCkC47C0igJeJdvdzGQw3UDRfcTp
VjA9lL6FWbJ11AAF9+jtk9xhorMyHF+yYH3Sgm/knxfuaCwgqgSyzRt33KI/g6Tb
lgQ8uLdKMi29ZUfBQvD5thhN7NBaiiYui8Mw9NutrO8YfDxEakampOSnLK14UpHo
sijLA/j9kifsGcDsTbd3gDZprXyHHjcZPXG73nz95EB6YyFMVGr2ccZOZqMf4fDM
L2tXkxSsHTeKYdC7PckdQOiAGEwXcX98jqfVIU/Tz6ztNWjW0M9VphOhdCRL5ztk
uHAQgqdOjTi7iplfQK/C
=RFr+
-----END PGP SIGNATURE-----

--=-B0+is7dZhy7y1F2f5BDQ--

