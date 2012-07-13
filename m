Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162008Ab2GMApm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 20:45:42 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:54375 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab2GMApk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:45:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1342140337!8537925!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] staging: comedi: remove the devpriv and thisboard macros
Date: Thu, 12 Jul 2012 17:45:31 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207121745.31613.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros 'devpriv' and 'thisboard' rely on a local variable having
a specific name and yeild pointers derived from that variable. Replace
the macros with local variables where used and use to comedi_board()
helper to get the 'thisboard' pointer.

The dt282x driver needs some initial cleanup to remove some macros that
use the 'devpriv' macro.

There are still a couple comedi drivers that have the macros but they are
pretty tangled up and require a bit more work.

Unfortunately this patch adds quite a few lines-of-code to the drivers.
But, it cleans up the CodingStyle issue pointed out in Chapter 12:

2) macros that depend on having a local variable with a magic name:

#define FOO(val) bar(index, val)

might look like a good thing, but it's confusing as hell when one reads the
code and it's prone to breakage from seemingly innocent changes.

H Hartley Sweeten (2):
  staging: comedi: dt282x: remove the outw wrapper macros
  staging: comedi: remove the devpriv and thisboard macros

 .../staging/comedi/drivers/addi-data/addi_common.c |  19 +++-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |   2 +
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |  14 +++
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |  11 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |  21 +++-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |  17 ++-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  16 +++
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |   8 ++
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |  12 ++
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |  14 +++
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |  19 +++-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |  42 +++++--
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  27 ++++-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |  18 +++
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |  18 +++
 drivers/staging/comedi/drivers/adl_pci9111.c       |  36 ++++--
 drivers/staging/comedi/drivers/adl_pci9118.c       |  55 +++++++++-
 drivers/staging/comedi/drivers/adq12b.c            |  10 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  45 +++++++-
 drivers/staging/comedi/drivers/adv_pci1723.c       |  20 ++--
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  22 +++-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   8 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |  11 --
 drivers/staging/comedi/drivers/amplc_dio200.c      |  10 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |  12 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |  11 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |   9 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   3 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |   4 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   2 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |  27 ++---
 drivers/staging/comedi/drivers/cb_pcidio.c         |  11 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |  23 ++--
 drivers/staging/comedi/drivers/cb_pcimdda.c        |  29 +++--
 drivers/staging/comedi/drivers/comedi_bond.c       |  26 ++---
 drivers/staging/comedi/drivers/comedi_parport.c    |  16 ++-
 drivers/staging/comedi/drivers/comedi_test.c       |  17 ++-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |   6 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |  27 ++++-
 drivers/staging/comedi/drivers/das08.c             |   8 +-
 drivers/staging/comedi/drivers/das08_cs.c          |   4 +-
 drivers/staging/comedi/drivers/das16.c             |  19 +++-
 drivers/staging/comedi/drivers/das16m1.c           |  14 ++-
 drivers/staging/comedi/drivers/das1800.c           |  41 +++++--
 drivers/staging/comedi/drivers/das6402.c           |  11 +-
 drivers/staging/comedi/drivers/das800.c            |  29 +++--
 drivers/staging/comedi/drivers/dt2801.c            |  28 +++--
 drivers/staging/comedi/drivers/dt2811.c            |   9 +-
 drivers/staging/comedi/drivers/dt2814.c            |   8 +-
 drivers/staging/comedi/drivers/dt2815.c            |   8 +-
 drivers/staging/comedi/drivers/dt282x.c            | 122 +++++++++++++--------
 drivers/staging/comedi/drivers/dt3000.c            |  28 ++++-
 drivers/staging/comedi/drivers/dt9812.c            |  13 ++-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |  18 ++-
 drivers/staging/comedi/drivers/fl512.c             |   9 +-
 drivers/staging/comedi/drivers/icp_multi.c         |  36 ++++--
 drivers/staging/comedi/drivers/ii_pci20kc.c        |  10 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |   5 +-
 drivers/staging/comedi/drivers/me4000.c            |  55 ++++++++--
 drivers/staging/comedi/drivers/me4000.h            |   4 -
 drivers/staging/comedi/drivers/me_daq.c            |  27 +++--
 drivers/staging/comedi/drivers/mpc624.c            |   6 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        |  11 --
 drivers/staging/comedi/drivers/multiq3.c           |   7 +-
 drivers/staging/comedi/drivers/ni_6527.c           |  23 +++-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  27 +++--
 drivers/staging/comedi/drivers/ni_at_ao.c          |  12 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |  11 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |  19 +---
 drivers/staging/comedi/drivers/ni_labpc.c          |  53 +++++++--
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |  10 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |  34 +++++-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   4 +-
 drivers/staging/comedi/drivers/pcl711.c            |  11 +-
 drivers/staging/comedi/drivers/pcl726.c            |   8 +-
 drivers/staging/comedi/drivers/pcl812.c            |  23 +++-
 drivers/staging/comedi/drivers/pcl816.c            |  19 +++-
 drivers/staging/comedi/drivers/pcl818.c            |  28 ++++-
 drivers/staging/comedi/drivers/pcm3724.c           |  11 +-
 drivers/staging/comedi/drivers/pcmad.c             |   6 +-
 drivers/staging/comedi/drivers/pcmda12.c           |   8 +-
 drivers/staging/comedi/drivers/pcmmio.c            |  50 ++++++---
 drivers/staging/comedi/drivers/pcmuio.c            |  30 +++--
 drivers/staging/comedi/drivers/rtd520.c            |   2 +-
 drivers/staging/comedi/drivers/rti800.c            |   9 +-
 drivers/staging/comedi/drivers/rti802.c            |   8 +-
 drivers/staging/comedi/drivers/s526.c              |  16 +--
 drivers/staging/comedi/drivers/s626.c              |   5 +-
 drivers/staging/comedi/drivers/serial2002.c        |  21 ++--
 89 files changed, 1233 insertions(+), 443 deletions(-)

-- 
1.7.11

