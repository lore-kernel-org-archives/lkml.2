Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1EWVs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:48:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53470 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab1EWVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:48:26 -0400
Subject: [GIT PULL] PTP class and drivers from Richard Cochran
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 14:48:19 -0700
Message-ID: <1306187299.2968.17.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Sorry for this being a bit late. I got mixed up and thought you had
already merged Richard's patches into -tip. 

Anyway, Richard's v15 patches, plus one fix-up from me are available in
the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/40/tip/timers/ptp

John Stultz (1):
      ptp: Fix dp83640 build warning when building statically

Richard Cochran (4):
      ptp: Added a brand new class driver for ptp clocks.
      ptp: Added a clock that uses the eTSEC found on the MPC85xx.
      ptp: Added a clock driver for the IXP46x.
      ptp: Added a clock driver for the National Semiconductor PHYTER.

 Documentation/ABI/testing/sysfs-ptp                |   98 ++
 .../devicetree/bindings/net/fsl-tsec-phy.txt       |   54 +
 Documentation/ptp/ptp.txt                          |   89 ++
 Documentation/ptp/testptp.c                        |  381 +++++++
 Documentation/ptp/testptp.mk                       |   33 +
 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h      |   78 ++
 arch/powerpc/boot/dts/mpc8313erdb.dts              |   13 +
 arch/powerpc/boot/dts/mpc8572ds.dts                |   13 +
 arch/powerpc/boot/dts/p2020ds.dts                  |   13 +
 arch/powerpc/boot/dts/p2020rdb.dts                 |   13 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/net/Makefile                               |    1 +
 drivers/net/arm/ixp4xx_eth.c                       |  195 ++++-
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
 include/linux/ptp_classify.h                       |    7 +
 include/linux/ptp_clock.h                          |   84 ++
 include/linux/ptp_clock_kernel.h                   |  139 +++
 29 files changed, 4406 insertions(+), 3 deletions(-)
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


