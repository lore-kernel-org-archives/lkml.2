Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0HNUyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 16:54:49 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42149 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0HNUyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 16:54:47 -0400
Date: Sat, 14 Aug 2010 22:54:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux arch <linux-arch@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [GIT] defconfig + unifdef cleanup (touches many archs)
Message-ID: <20100814205445.GA29267@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Following pull request contains two simple cleanups.
[See end of mail for the full diffstat]
I would like these to be included during the merge
window to avoid too much merge issues later.

The use of unifdef-y in various Kbuild files for
exported headers is dropped. unifdef-y have had the
same functionality as header-y for a long time.
And people assumed it was special...
All users are dropped (touches a lot of arch Kbuild
files too).

The diffstat for this change alone looks like this:

 Documentation/kbuild/makefiles.txt    |    6 -
 arch/alpha/include/asm/Kbuild         |   11 +-
 arch/arm/include/asm/Kbuild           |    2 +-
 arch/blackfin/include/asm/Kbuild      |    4 +-
 arch/cris/include/asm/Kbuild          |    5 +-
 arch/frv/include/asm/Kbuild           |    3 +-
 arch/ia64/include/asm/Kbuild          |    9 +-
 arch/parisc/include/asm/Kbuild        |    2 +-
 arch/powerpc/include/asm/Kbuild       |   53 ++--
 arch/s390/include/asm/Kbuild          |   11 +-
 arch/sh/include/asm/Kbuild            |    9 +-
 arch/x86/include/asm/Kbuild           |   29 +-
 include/asm-generic/Kbuild            |    9 +-
 include/asm-generic/Kbuild.asm        |   67 +++---
 include/drm/Kbuild                    |   26 +-
 include/linux/Kbuild                  |  468 ++++++++++++++++----------------
 include/linux/byteorder/Kbuild        |    4 +-
 include/linux/dvb/Kbuild              |    7 +-
 include/linux/netfilter/Kbuild        |   19 +-
 include/linux/netfilter_arp/Kbuild    |    3 +-
 include/linux/netfilter_bridge/Kbuild |    5 +-
 include/linux/netfilter_ipv4/Kbuild   |    5 +-
 include/linux/netfilter_ipv6/Kbuild   |    5 +-
 include/linux/nfsd/Kbuild             |   12 +-
 include/linux/sunrpc/Kbuild           |    2 +-
 include/sound/Kbuild                  |    9 +-
 include/video/Kbuild                  |    5 +-
 scripts/Makefile.headersinst          |    3 +-
 28 files changed, 387 insertions(+), 406 deletions(-)


I wrote a small script to convert remaining defconfig
file to the new minimal format.
The script checked that the resulting .config was
the same with the old (verbose) format and the
new (minimal) format.
This turned out to be a very good regression test as
I found 2 issues in kconfig and one issue in
arch/sh/Kconfig and one issue in arch/tile/Makefile.
Fixes for these are sent via the usual channels and
is _not_ in this pull request.
This pull does not depend on having these issues solved.


The summary of the defconfig changes looks like this:

 197 files changed, 1181 insertions(+), 207237 deletions(-)

A nice noise reduction patch.


Please pull from:

The following changes since commit c29c08b59875fe053471cf9eb66f8cfef39bc509:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jejb/scsi-misc-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/cleanup.git master

	Sam


Sam Ravnborg (4):
      include: replace unifdef-y with header-y
      archs: replace unifdef-y with header-y
      kbuild: drop unifdef-y support
      defconfig reduction

Full diffstat:

 Documentation/kbuild/makefiles.txt                 |    6 -
 arch/alpha/defconfig                               |  884 +--------
 arch/alpha/include/asm/Kbuild                      |   11 +-
 arch/arm/include/asm/Kbuild                        |    2 +-
 arch/avr32/configs/atngw100_defconfig              | 1249 -----------
 arch/avr32/configs/atngw100_evklcd100_defconfig    | 1374 ------------
 arch/avr32/configs/atngw100_evklcd101_defconfig    | 1369 ------------
 arch/avr32/configs/atngw100_mrmt_defconfig         | 1213 -----------
 arch/avr32/configs/atngw100mkii_defconfig          | 1254 -----------
 .../avr32/configs/atngw100mkii_evklcd100_defconfig | 1377 ------------
 .../avr32/configs/atngw100mkii_evklcd101_defconfig | 1378 ------------
 arch/avr32/configs/atstk1002_defconfig             | 1319 ------------
 arch/avr32/configs/atstk1003_defconfig             |  946 +--------
 arch/avr32/configs/atstk1004_defconfig             |  601 +------
 arch/avr32/configs/atstk1006_defconfig             | 1321 ------------
 arch/avr32/configs/favr-32_defconfig               | 1079 +----------
 arch/avr32/configs/hammerhead_defconfig            | 1311 +------------
 arch/avr32/configs/merisc_defconfig                | 1105 ----------
 arch/avr32/configs/mimc200_defconfig               |  991 +---------
 arch/blackfin/configs/BF518F-EZBRD_defconfig       | 1307 ------------
 arch/blackfin/configs/BF526-EZBRD_defconfig        | 1594 --------------
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig     | 1698 ---------------
 arch/blackfin/configs/BF527-EZKIT_defconfig        | 1651 --------------
 arch/blackfin/configs/BF533-EZKIT_defconfig        | 1222 -----------
 arch/blackfin/configs/BF533-STAMP_defconfig        | 1384 ------------
 arch/blackfin/configs/BF537-STAMP_defconfig        | 1435 -------------
 arch/blackfin/configs/BF538-EZKIT_defconfig        | 1365 ------------
 arch/blackfin/configs/BF548-EZKIT_defconfig        | 1757 ---------------
 arch/blackfin/configs/BF561-ACVILON_defconfig      | 1482 -------------
 arch/blackfin/configs/BF561-EZKIT_defconfig        | 1206 -----------
 arch/blackfin/configs/BlackStamp_defconfig         | 1098 +----------
 arch/blackfin/configs/CM-BF527_defconfig           | 1404 ------------
 arch/blackfin/configs/CM-BF533_defconfig           |  841 --------
 arch/blackfin/configs/CM-BF537E_defconfig          | 1112 ----------
 arch/blackfin/configs/CM-BF537U_defconfig          |  986 ---------
 arch/blackfin/configs/CM-BF548_defconfig           | 1367 ------------
 arch/blackfin/configs/CM-BF561_defconfig           | 1049 ---------
 arch/blackfin/configs/H8606_defconfig              | 1085 +----------
 arch/blackfin/configs/IP0X_defconfig               | 1164 +----------
 arch/blackfin/configs/PNAV-10_defconfig            | 1371 ------------
 arch/blackfin/configs/SRV1_defconfig               | 1217 +-----------
 arch/blackfin/configs/TCM-BF518_defconfig          | 1240 -----------
 arch/blackfin/configs/TCM-BF537_defconfig          | 1085 ----------
 arch/blackfin/include/asm/Kbuild                   |    4 +-
 arch/cris/configs/artpec_3_defconfig               |  538 -----
 arch/cris/configs/etrax-100lx_defconfig            |  489 +-----
 arch/cris/configs/etrax-100lx_v2_defconfig         |  537 -----
 arch/cris/configs/etraxfs_defconfig                |  545 -----
 arch/cris/include/asm/Kbuild                       |    5 +-
 arch/frv/defconfig                                 |  600 +------
 arch/frv/include/asm/Kbuild                        |    3 +-
 arch/h8300/defconfig                               |  333 +---
 arch/ia64/configs/bigsur_defconfig                 |  183 +-
 arch/ia64/configs/generic_defconfig                |  351 ++--
 arch/ia64/configs/gensparse_defconfig              |  313 ++--
 arch/ia64/configs/sim_defconfig                    |   87 +-
 arch/ia64/configs/tiger_defconfig                  |  265 ++--
 arch/ia64/configs/xen_domu_defconfig               |  279 ++--
 arch/ia64/configs/zx1_defconfig                    |  231 +-
 arch/ia64/include/asm/Kbuild                       |    9 +-
 arch/m32r/configs/m32104ut_defconfig               |  897 +--------
 arch/m32r/configs/m32700ut.smp_defconfig           |  779 +-------
 arch/m32r/configs/m32700ut.up_defconfig            |  777 +-------
 arch/m32r/configs/mappi.nommu_defconfig            |  609 ------
 arch/m32r/configs/mappi.smp_defconfig              |  710 +-------
 arch/m32r/configs/mappi.up_defconfig               |  709 +------
 arch/m32r/configs/mappi2.opsp_defconfig            |  681 ------
 arch/m32r/configs/mappi2.vdec2_defconfig           |  680 ------
 arch/m32r/configs/mappi3.smp_defconfig             |  714 +-------
 arch/m32r/configs/oaks32r_defconfig                |  583 -----
 arch/m32r/configs/opsput_defconfig                 |  664 ------
 arch/m32r/configs/usrv_defconfig                   |  693 +------
 arch/m68k/configs/amiga_defconfig                  |  867 +--------
 arch/m68k/configs/apollo_defconfig                 |  784 -------
 arch/m68k/configs/atari_defconfig                  |  824 +-------
 arch/m68k/configs/bvme6000_defconfig               |  758 -------
 arch/m68k/configs/hp300_defconfig                  |  793 -------
 arch/m68k/configs/mac_defconfig                    |  815 -------
 arch/m68k/configs/multi_defconfig                  |  895 +--------
 arch/m68k/configs/mvme147_defconfig                |  759 -------
 arch/m68k/configs/mvme16x_defconfig                |  758 -------
 arch/m68k/configs/q40_defconfig                    |  839 --------
 arch/m68k/configs/sun3_defconfig                   |  779 -------
 arch/m68k/configs/sun3x_defconfig                  |  790 -------
 arch/m68knommu/configs/m5208evb_defconfig          |  559 -----
 arch/m68knommu/configs/m5249evb_defconfig          |  580 -----
 arch/m68knommu/configs/m5272c3_defconfig           |  580 -----
 arch/m68knommu/configs/m5275evb_defconfig          |  580 -----
 arch/m68knommu/configs/m5307c3_defconfig           |  600 ------
 arch/m68knommu/configs/m5407c3_defconfig           |  589 -----
 arch/m68knommu/defconfig                           |  588 +-----
 arch/microblaze/configs/mmu_defconfig              |  842 +--------
 arch/microblaze/configs/nommu_defconfig            |  849 +--------
 arch/mips/configs/ar7_defconfig                    | 1119 ----------
 arch/mips/configs/bcm47xx_defconfig                | 1593 --------------
 arch/mips/configs/bcm63xx_defconfig                | 1135 ----------
 arch/mips/configs/bigsur_defconfig                 | 1357 ------------
 arch/mips/configs/capcella_defconfig               |  779 +-------
 arch/mips/configs/cavium-octeon_defconfig          |  850 +--------
 arch/mips/configs/cobalt_defconfig                 | 1143 +----------
 arch/mips/configs/db1000_defconfig                 | 1064 ----------
 arch/mips/configs/db1100_defconfig                 | 1085 ----------
 arch/mips/configs/db1200_defconfig                 | 1396 ------------
 arch/mips/configs/db1500_defconfig                 | 1152 ----------
 arch/mips/configs/db1550_defconfig                 | 1292 -----------
 arch/mips/configs/decstation_defconfig             |  860 +--------
 arch/mips/configs/e55_defconfig                    |  543 -----
 arch/mips/configs/fuloong2e_defconfig              | 1563 --------------
 arch/mips/configs/gpr_defconfig                    | 1711 ---------------
 arch/mips/configs/ip22_defconfig                   |  918 +--------
 arch/mips/configs/ip27_defconfig                   | 1167 +----------
 arch/mips/configs/ip28_defconfig                   |  807 +-------
 arch/mips/configs/ip32_defconfig                   | 1031 ---------
 arch/mips/configs/jazz_defconfig                   | 1116 +----------
 arch/mips/configs/jmr3927_defconfig                |  800 -------
 arch/mips/configs/lasat_defconfig                  |  753 -------
 arch/mips/configs/lemote2f_defconfig               | 1750 ---------------
 arch/mips/configs/malta_defconfig                  | 1250 +-----------
 arch/mips/configs/markeins_defconfig               | 1269 +-----------
 arch/mips/configs/mipssim_defconfig                |  601 +------
 arch/mips/configs/mpc30x_defconfig                 |  780 -------
 arch/mips/configs/msp71xx_defconfig                | 1400 +------------
 arch/mips/configs/mtx1_defconfig                   | 1797 ----------------
 arch/mips/configs/pb1100_defconfig                 | 1096 ----------
 arch/mips/configs/pb1200_defconfig                 | 1397 ------------
 arch/mips/configs/pb1500_defconfig                 | 1233 -----------
 arch/mips/configs/pb1550_defconfig                 | 1288 -----------
 arch/mips/configs/pnx8335-stb225_defconfig         | 1051 +---------
 arch/mips/configs/pnx8550-jbs_defconfig            | 1204 +-----------
 arch/mips/configs/pnx8550-stb810_defconfig         | 1200 +-----------
 arch/mips/configs/powertv_defconfig                | 1535 --------------
 arch/mips/configs/rb532_defconfig                  | 1328 ------------
 arch/mips/configs/rbtx49xx_defconfig               |  981 ---------
 arch/mips/configs/rm200_defconfig                  | 1379 +------------
 arch/mips/configs/sb1250-swarm_defconfig           |  960 +--------
 arch/mips/configs/tb0219_defconfig                 |  830 +--------
 arch/mips/configs/tb0226_defconfig                 |  833 +--------
 arch/mips/configs/tb0287_defconfig                 | 1003 +---------
 arch/mips/configs/workpad_defconfig                |  708 ------
 arch/mips/configs/wrppmc_defconfig                 |  896 +--------
 arch/mips/configs/yosemite_defconfig               |  824 +-------
 arch/mn10300/configs/asb2303_defconfig             |  563 -----
 arch/parisc/configs/712_defconfig                  |  909 --------
 arch/parisc/configs/a500_defconfig                 | 1110 ----------
 arch/parisc/configs/b180_defconfig                 | 1144 ----------
 arch/parisc/configs/c3000_defconfig                | 1353 +------------
 arch/parisc/configs/default_defconfig              | 1380 ------------
 arch/parisc/include/asm/Kbuild                     |    2 +-
 arch/powerpc/include/asm/Kbuild                    |   53 +-
 arch/s390/defconfig                                |  970 ---------
 arch/s390/include/asm/Kbuild                       |   11 +-
 arch/score/configs/spct6600_defconfig              |  632 ------
 arch/sh/configs/ap325rxa_defconfig                 | 1331 ------------
 arch/sh/configs/cayman_defconfig                   | 1319 ------------
 arch/sh/configs/dreamcast_defconfig                | 1087 ----------
 arch/sh/configs/ecovec24-romimage_defconfig        | 1016 ---------
 arch/sh/configs/ecovec24_defconfig                 | 1631 --------------
 arch/sh/configs/edosk7705_defconfig                |  481 -----
 arch/sh/configs/edosk7760_defconfig                | 1118 ----------
 arch/sh/configs/espt_defconfig                     | 1159 ----------
 arch/sh/configs/hp6xx_defconfig                    |  936 --------
 arch/sh/configs/kfr2r09-romimage_defconfig         |  763 -------
 arch/sh/configs/kfr2r09_defconfig                  | 1033 ---------
 arch/sh/configs/landisk_defconfig                  | 1446 -------------
 arch/sh/configs/lboxre2_defconfig                  | 1324 ------------
 arch/sh/configs/magicpanelr2_defconfig             | 1060 ---------
 arch/sh/configs/microdev_defconfig                 |  974 ---------
 arch/sh/configs/migor_defconfig                    | 1304 ------------
 arch/sh/configs/polaris_defconfig                  |  972 ---------
 arch/sh/configs/r7780mp_defconfig                  | 1569 --------------
 arch/sh/configs/r7785rp_defconfig                  | 1582 --------------
 arch/sh/configs/rsk7201_defconfig                  |  745 -------
 arch/sh/configs/rsk7203_defconfig                  | 1159 ----------
 arch/sh/configs/rts7751r2d1_defconfig              | 1582 --------------
 arch/sh/configs/rts7751r2dplus_defconfig           | 1661 ---------------
 arch/sh/configs/sdk7780_defconfig                  | 1568 --------------
 arch/sh/configs/sdk7786_defconfig                  | 1773 +----------------
 arch/sh/configs/se7206_defconfig                   | 1000 ---------
 arch/sh/configs/se7343_defconfig                   | 1244 -----------
 arch/sh/configs/se7619_defconfig                   |  706 ------
 arch/sh/configs/se7705_defconfig                   |  996 ---------
 arch/sh/configs/se7712_defconfig                   | 1088 ----------
 arch/sh/configs/se7721_defconfig                   | 1229 -----------
 arch/sh/configs/se7722_defconfig                   | 1031 ---------
 arch/sh/configs/se7724_defconfig                   | 1682 ---------------
 arch/sh/configs/se7750_defconfig                   | 1030 ---------
 arch/sh/configs/se7751_defconfig                   |  990 ---------
 arch/sh/configs/se7780_defconfig                   | 1366 ------------
 arch/sh/configs/sh03_defconfig                     | 1218 -----------
 arch/sh/configs/sh7710voipgw_defconfig             | 1012 ---------
 arch/sh/configs/sh7724_generic_defconfig           |  707 ------
 arch/sh/configs/sh7763rdp_defconfig                | 1172 ----------
 arch/sh/configs/sh7770_generic_defconfig           |  697 ------
 arch/sh/configs/sh7785lcr_32bit_defconfig          | 1734 ---------------
 arch/sh/configs/sh7785lcr_defconfig                | 1537 --------------
 arch/sh/configs/shmin_defconfig                    |  908 --------
 arch/sh/configs/shx3_defconfig                     | 1312 ------------
 arch/sh/configs/snapgear_defconfig                 |  954 ---------
 arch/sh/configs/systemh_defconfig                  |  677 ------
 arch/sh/configs/titan_defconfig                    | 1612 --------------
 arch/sh/configs/ul2_defconfig                      | 1233 -----------
 arch/sh/configs/urquell_defconfig                  | 1732 ---------------
 arch/sh/include/asm/Kbuild                         |    9 +-
 arch/sparc/configs/sparc32_defconfig               | 1120 ----------
 arch/sparc/configs/sparc64_defconfig               | 1714 ---------------
 arch/tile/configs/tile_defconfig                   | 1219 -----------
 arch/x86/configs/i386_defconfig                    | 2242 +-------------------
 arch/x86/configs/x86_64_defconfig                  | 2209 +-------------------
 arch/x86/include/asm/Kbuild                        |   29 +-
 include/asm-generic/Kbuild                         |    9 +-
 include/asm-generic/Kbuild.asm                     |   67 +-
 include/drm/Kbuild                                 |   26 +-
 include/linux/Kbuild                               |  468 ++--
 include/linux/byteorder/Kbuild                     |    4 +-
 include/linux/dvb/Kbuild                           |    7 +-
 include/linux/netfilter/Kbuild                     |   19 +-
 include/linux/netfilter_arp/Kbuild                 |    3 +-
 include/linux/netfilter_bridge/Kbuild              |    5 +-
 include/linux/netfilter_ipv4/Kbuild                |    5 +-
 include/linux/netfilter_ipv6/Kbuild                |    5 +-
 include/linux/nfsd/Kbuild                          |   12 +-
 include/linux/sunrpc/Kbuild                        |    2 +-
 include/sound/Kbuild                               |    9 +-
 include/video/Kbuild                               |    5 +-
 scripts/Makefile.headersinst                       |    3 +-
 225 files changed, 1568 insertions(+), 207643 deletions(-)
