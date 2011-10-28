Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1J1Mfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:35:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:25039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab1J1Mfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013500"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 00/19] First round in OTG rework
Date: Fri, 28 Oct 2011 15:35:06 +0300
Message-Id: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Anton wanted a minor change to isp1704_charger.c. If there are no
problems with musb, I think this set is starting to be ready.


Changes since v5:
- Cleanup isp1704_charger.c

Quick summary:
This introduces struct usb_phy and struct usb_otg that
replace struct otg_transceiver. The transceiver and phy
members from struct otg_transceiver are left in struct
usb_phy and otg specific members are moved to struct
usb_otg.

So the idea is simply to separate USB PHY handling from OTG.


Heikki Krogerus (19):
  usb: otg: Rename otg_transceiver to usb_phy
  usb: otg: Rename usb_otg and usb_xceiv to usb_phy
  usb: otg: Separate otg members from usb_phy
  usb: otg: ab8500: Start using struct usb_otg
  usb: otg: fsl: Start using struct usb_otg
  usb: otg: gpio_vbus: Start using struct usb_otg
  usb: otg: isp1301_omap: Start using struct usb_otg
  usb: otg: msm: Start using struct usb_otg
  usb: otg: langwell: Start using struct usb_otg
  usb: otg: nop: Start using struct usb_otg
  usb: otg: twl4030: Start using struct usb_otg
  usb: otg: twl6030: Start using struct usb_otg
  usb: otg: ulpi: Start using struct usb_otg
  arm: imx: Start using struct usb_otg
  usb: musb: Start using struct usb_otg
  power_supply: Convert all users to new usb_phy
  usb: Convert all users to new usb_phy
  usb: otg: Remove OTG specific members from usb_phy
  usb: otg: Convert all users to pass struct usb_otg for OTG functions

 arch/arm/mach-imx/mx31moboard-devboard.c   |   24 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c    |   24 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c            |   20 +-
 arch/arm/mach-tegra/include/mach/usb_phy.h |    2 +-
 arch/arm/plat-mxc/include/mach/mxc_ehci.h  |    2 +-
 arch/arm/plat-mxc/include/mach/ulpi.h      |    6 +-
 arch/arm/plat-mxc/ulpi.c                   |    8 +-
 drivers/power/isp1704_charger.c            |  106 ++++---
 drivers/power/pda_power.c                  |   10 +-
 drivers/power/twl4030_charger.c            |   20 +-
 drivers/usb/gadget/ci13xxx_msm.c           |    4 +-
 drivers/usb/gadget/ci13xxx_udc.c           |   17 +-
 drivers/usb/gadget/ci13xxx_udc.h           |    2 +-
 drivers/usb/gadget/fsl_udc_core.c          |    9 +-
 drivers/usb/gadget/fsl_usb2_udc.h          |    2 +-
 drivers/usb/gadget/langwell_udc.c          |   12 +-
 drivers/usb/gadget/langwell_udc.h          |    2 +-
 drivers/usb/gadget/omap_udc.c              |   25 +-
 drivers/usb/gadget/omap_udc.h              |    2 +-
 drivers/usb/gadget/pxa25x_udc.c            |   13 +-
 drivers/usb/gadget/pxa25x_udc.h            |    2 +-
 drivers/usb/gadget/pxa27x_udc.c            |   11 +-
 drivers/usb/gadget/pxa27x_udc.h            |    2 +-
 drivers/usb/host/ehci-fsl.c                |    6 +-
 drivers/usb/host/ehci-hub.c                |    2 +-
 drivers/usb/host/ehci-msm.c                |   14 +-
 drivers/usb/host/ehci-mxc.c                |   12 +-
 drivers/usb/host/ehci-tegra.c              |   14 +-
 drivers/usb/host/ehci.h                    |    2 +-
 drivers/usb/host/ohci-omap.c               |   10 +-
 drivers/usb/host/ohci.h                    |    2 +-
 drivers/usb/musb/am35x.c                   |   42 ++--
 drivers/usb/musb/blackfin.c                |   28 +-
 drivers/usb/musb/da8xx.c                   |   42 ++--
 drivers/usb/musb/davinci.c                 |   33 ++-
 drivers/usb/musb/musb_core.c               |  174 ++++++------
 drivers/usb/musb/musb_core.h               |    2 +-
 drivers/usb/musb/musb_gadget.c             |   63 ++--
 drivers/usb/musb/musb_host.c               |    8 +-
 drivers/usb/musb/musb_virthub.c            |   37 ++--
 drivers/usb/musb/omap2430.c                |   67 +++---
 drivers/usb/musb/tusb6010.c                |   82 +++---
 drivers/usb/musb/ux500.c                   |    8 +-
 drivers/usb/otg/Kconfig                    |    2 +-
 drivers/usb/otg/ab8500-usb.c               |   93 ++++---
 drivers/usb/otg/fsl_otg.c                  |  120 +++++----
 drivers/usb/otg/fsl_otg.h                  |    4 +-
 drivers/usb/otg/gpio_vbus.c                |   61 +++--
 drivers/usb/otg/isp1301_omap.c             |  360 ++++++++++++-----------
 drivers/usb/otg/langwell_otg.c             |  387 +++++++++++++------------
 drivers/usb/otg/msm_otg.c                  |  430 ++++++++++++++--------------
 drivers/usb/otg/nop-usb-xceiv.c            |   66 ++---
 drivers/usb/otg/otg.c                      |   50 ++--
 drivers/usb/otg/otg_fsm.c                  |  174 ++++++------
 drivers/usb/otg/otg_fsm.h                  |    2 +-
 drivers/usb/otg/twl4030-usb.c              |   81 +++---
 drivers/usb/otg/twl6030-usb.c              |  111 ++++----
 drivers/usb/otg/ulpi.c                     |  116 ++++----
 drivers/usb/otg/ulpi_viewport.c            |    6 +-
 include/linux/usb/intel_mid_otg.h          |    8 +-
 include/linux/usb/msm_hsusb.h              |    4 +-
 include/linux/usb/otg.h                    |  200 +++++++------
 include/linux/usb/ulpi.h                   |    4 +-
 63 files changed, 1720 insertions(+), 1532 deletions(-)

-- 
1.7.4.1

