Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1DRG2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 02:28:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1DRG2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 02:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=X3Ax3ICkVyNtcTjK1PzsaM4BpN7i3Jnp3LWBTqECrBJrPTNxnOFDp1FU43RGJ78uh2
         IQzQk/FVYp7DX8fnEITSGBXTamS92r186XCKcqPlvp1iYWx0HkMJRPfViFwE0/MVsMgl
         2zak022ao9Usn5n/ReS6n0KU+QwA69ULcXL30=
Date: Mon, 18 Apr 2011 08:27:43 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH V14 0/4] ptp: IEEE 1588 hardware clock support
Message-ID: <cover.1303107532.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Introduction

  The aim of this patch set is to add support for PTP Hardware Clocks
  (PHCs) into the Linux kernel. The patch series builds upon the
  dynamic posix clock work appearing in kernel version 2.6.39.

  Support for obtaining timestamps from a PHC already exists via the
  SO_TIMESTAMPING socket option, integrated in kernel version 2.6.30.
  This patch set completes the picture by allow user space programs to
  adjust the PHC and to control its ancillary features.

* Patches for ptpd on sf.net
  https://sourceforge.net/tracker/?group_id=139814&atid=744634
  3225599 [PATCH 1/3] Convert to POSIX clock API.
  3225603 [PATCH 2/3] Adapted to use the Linux PTP Hardware Clock API. 
  3225607 [PATCH 3/3] Adapted to use the newer SO_TIMESTAMPING Linux API.

* PHC Patch ChangeLog
** v14
*** general
    - fixed unregister method to allow a clean module removal
    - blocked fifo readers no longer prohibit module removal
    - export skb_clone_tx_timestamp for module use
*** phyter
    - allow mutiple clock/mdio bus instances
    - fix endian bug in packet matching code for LE host
    - fix module related null pointer dereference
    - warn rather than BUG when MAC driver is missing

* Why all the CCs?
  - One driver is for PowerPC, and adds device tree stuff.
  - One driver is for the ARM Xscale IXP465.

* Previous Discussions
  - [V13] http://lkml.org/lkml/2011/3/27/2
  - [V12] http://lkml.org/lkml/2011/2/28/53
  - [V11] http://lkml.org/lkml/2011/2/23/107
  - [V10] http://lkml.org/lkml/2011/1/27/71
  - [V9]  http://lkml.org/lkml/2011/1/13/65
  - [V8]  http://lkml.org/lkml/2010/12/31/128
  - [V7]  http://lkml.org/lkml/2010/12/16/195
  - [V6]  http://lkml.org/lkml/2010/9/23/310
  - [V5]  http://lkml.org/lkml/2010/8/16/90
  - Thomas Gleixner: Rework of the PTP support series core code
    http://lkml.org/lkml/2011/2/1/137
  - Dynamic clock devices [RFC]
    http://lkml.org/lkml/2010/11/4/290
  - POSIX clock tuning syscall with dynamic clock ids
    http://lkml.org/lkml/2010/9/3/119
  - POSIX clock tuning syscall with static clock ids
    http://lkml.org/lkml/2010/8/23/49
  - Versions 1-4 appeared on the netdev list.


Richard Cochran (4):
  ptp: Added a brand new class driver for ptp clocks.
  ptp: Added a clock that uses the eTSEC found on the MPC85xx.
  ptp: Added a clock driver for the IXP46x.
  ptp: Added a clock driver for the National Semiconductor PHYTER.

 Documentation/ABI/testing/sysfs-ptp                |   98 ++
 .../devicetree/bindings/net/fsl-tsec-phy.txt       |   54 +
 Documentation/ptp/ptp.txt                          |   89 ++
 Documentation/ptp/testptp.c                        |  368 +++++++
 Documentation/ptp/testptp.mk                       |   33 +
 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h      |   78 ++
 arch/powerpc/boot/dts/mpc8313erdb.dts              |   13 +
 arch/powerpc/boot/dts/mpc8572ds.dts                |   13 +
 arch/powerpc/boot/dts/p2020ds.dts                  |   13 +
 arch/powerpc/boot/dts/p2020rdb.dts                 |   13 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/net/Makefile                               |    1 +
 drivers/net/arm/ixp4xx_eth.c                       |  192 ++++-
 drivers/net/gianfar_ptp.c                          |  588 +++++++++++
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/dp83640.c                          | 1100 ++++++++++++++++++++
 drivers/net/phy/dp83640_reg.h                      |  267 +++++
 drivers/ptp/Kconfig                                |   75 ++
 drivers/ptp/Makefile                               |    7 +
 drivers/ptp/ptp_chardev.c                          |  159 +++
 drivers/ptp/ptp_clock.c                            |  343 ++++++
 drivers/ptp/ptp_ixp46x.c                           |  332 ++++++
 drivers/ptp/ptp_private.h                          |   92 ++
 drivers/ptp/ptp_sysfs.c                            |  230 ++++
 include/linux/Kbuild                               |    1 +
 include/linux/ptp_clock.h                          |   84 ++
 include/linux/ptp_clock_kernel.h                   |  139 +++
 28 files changed, 4383 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-ptp
 create mode 100644 Documentation/ptp/ptp.txt
 create mode 100644 Documentation/ptp/testptp.c
 create mode 100644 Documentation/ptp/testptp.mk
 create mode 100644 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
 create mode 100644 drivers/net/gianfar_ptp.c
 create mode 100644 drivers/net/phy/dp83640.c
 create mode 100644 drivers/net/phy/dp83640_reg.h
 create mode 100644 drivers/ptp/Kconfig
 create mode 100644 drivers/ptp/Makefile
 create mode 100644 drivers/ptp/ptp_chardev.c
 create mode 100644 drivers/ptp/ptp_clock.c
 create mode 100644 drivers/ptp/ptp_ixp46x.c
 create mode 100644 drivers/ptp/ptp_private.h
 create mode 100644 drivers/ptp/ptp_sysfs.c
 create mode 100644 include/linux/ptp_clock.h
 create mode 100644 include/linux/ptp_clock_kernel.h

