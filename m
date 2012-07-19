Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2GSBXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:23:36 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:64461 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2GSBXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:23:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1342661011!7942438!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/90] staging: comedi: cleanup the pci_dev usage
Date: Wed, 18 Jul 2012 18:23:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181823.21230.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the comedi pci drivers currently store a pointer to the pci_dev
in their private data. We can use the 'struct device *hw_dev' variable
in the comedi_device struct instead and introduce a wrapper for
to_pci_dev() to allow the drivers to easily get the pci_dev.

This patchset does just that. It also removes the private data from
the drivers that no longer needed it.

Some of the drivers required a bit of cleanup to their "find pci device"
code or the private data in order to make the conversion cleaner.

There are still a couple drivers, specifically the ni and addi ones,
that need additional work before they can be converted cleanly.

H Hartley Sweeten (90):
  staging: comedi: comedidev.h: introduce comedi_to_pci_dev() helper
  staging: comedi: adl_pci6208: store the pci_dev in the comedi_device
  staging: comedi: adl_pci7230: store the pci_dev in the comedi_device
  staging: comedi: adl_pci7230: remove the private data
  staging: comedi: adl_pci7296: store the pci_dev in the comedi_device
  staging: comedi: adl_pci7296: remove the private data
  staging: comedi: adl_pci7432: store the pci_dev in the comedi_device
  staging: comedi: adl_pci7432: remove the private data
  staging: comedi: adl_pci8164: store the pci_dev in the comedi_device
  staging: comedi: adl_pci8164: remove the private data
  staging: comedi: adl_pci9111: store the pci_dev in the comedi_device
  staging: comedi: adl_pci9118: store the pci_dev in the comedi_device
  staging: comedi: adv_pci1723: factor out the "find pci device" code
  staging: comedi: adv_pci1723: cleanup "find pci device" code
  staging: comedi: adv_pci1723: move comedi_pci_enable() into the attach
  staging: comedi: adv_pci1723: store the pci_dev in the comedi_device
  staging: comedi: adv_pci1710: factor out the "find pci device" code
  staging: comedi: adv_pci1710: cleanup "find pci device" code
  staging: comedi: adv_pci1710: move comedi_pci_enable() into the attach
  staging: comedi: adv_pci1710: store the pci_dev in the comedi_device
  staging: comedi: adv_pci_dio: factor out the "find pci device" code
  staging: comedi: adv_pci_dio: remove CheckAndAllocCard()
  staging: comedi: adv_pci_dio: cleanup "find pci device" code
  staging: comedi: adv_pci_dio: store the pci_dev in the comedi_device
  staging: comedi: cb_pcidas: store the pci_dev in the comedi_device
  staging: comedi: cb_pcidio: factor out the "find pci device" code
  staging: comedi: cb_pcidio: cleanup "find pci device" code
  staging: comedi: cb_pcidio: store the pci_dev in the comedi_device
  staging: comedi: amplc_dio200: cleanup "find pci device" code
  staging: comedi: amplc_dio200: store the pci_dev in the comedi_device
  staging: comedi: amplc_pc236: cleanup "find pci device" code
  staging: comedi: amplc_pc236: store the pci_dev in the comedi_device
  staging: comedi: amplc_pc263: cleanup "find pci device" code
  staging: comedi: amplc_pc263: store the pci_dev in the comedi_device
  staging: comedi: amplc_pci224: cleanup "find pci device" code
  staging: comedi: amplc_pci224: store the pci_dev in the comedi_device
  staging: comedi: amplc_pci230: cleanup "find pci device" code
  staging: comedi: amplc_pci230: store the pci_dev in the comedi_device
  staging: comedi: cb_pcidas64: factor out the "find pci device" code
  staging: comedi: cb_pcidas64: cleanup "find pci device" code
  staging: comedi: cb_pcidas64: store the pci_dev in the comedi_device
  staging: comedi: cb_pcidda: factor out the "find pci device" code
  staging: comedi: cb_pcidda: cleanup "find pci device" code
  staging: comedi: cb_pcidda: store the pci_dev in the comedi_device
  staging: comedi: cb_pcidio: store the iobase in the comedi_device
  staging: comedi: cb_pcidio: remove the private data
  staging: comedi: cb_pcimdas: factor out the "find pci device" code
  staging: comedi: cb_pcimdas: cleanup "find pci device" code
  staging: comedi: cb_pcimdas: remove the debug print of the pci bars
  staging: comedi: cb_pcimdas: cleanup the private data
  staging: comedi: cb_pcimdas: remove BADR1 from the private data
  staging: comedi: cb_pcimdas: remove BADR4 from the private data
  staging: comedi: cb_pcimdas: remove BADR2 from the private data
  staging: comedi: cb_pcimdas: remove BADR0 from the private data
  staging: comedi: cb_pcimdas: store the pci_dev in the comedi_device
  staging: comedi: contec_pci_dio: factor out the "find pci device" code
  staging: comedi: contec_pci_dio: cleanup "find pci device" code
  staging: comedi: contec_pci_dio: store the pci_dev in the comedi_device
  staging: comedi: contec_pci_dio: remove the private data
  staging: comedi: daqboard2000: factor out the "find pci device" code
  staging: comedi: daqboard2000: cleanup "find pci device" code
  staging: comedi: daqboard2000: remove 'got_regions' from private data
  staging: comedi: daqboard2000: store the pci_dev in the comedi_device
  staging: comedi: daqboard2000: void *plx should be a void __iomem *
  staging: comedi: dt3000: cleanup "find pci device" code
  staging: comedi: dt3000: move the setup_pci() code into the attach
  staging: comedi: dt3000: remove 'phys_addr' from the private data
  staging: comedi: dt3000: store the pci_dev in the comedi_device
  staging: comedi: dyna_pci10xx: factor out the "find pci device" code
  staging: comedi: dyna_pci10xx: cleanup "find pci device" code
  staging: comedi: dyna_pci10xx: remove the 'start_stop_sem' mutex
  staging: comedi: dyna_pci10xx: remove 'valid' from the private data
  staging: comedi: dyna_pci10xx: remove unused bars from the private data
  staging: comedi: dyna_pci10xx: use dev->iobase
  staging: comedi: dyna_pci10xx: store the pci_dev in the comedi_device
  staging: comedi: dyna_pci10xx: fix detach
  staging: comedi: ke_counter: factor out the "find pci device" code
  staging: comedi: ke_counter: cleanup "find pci device" code
  staging: comedi: ke_counter: minor cleanup of cnt_attach()
  staging: comedi: ke_counter: store the pci_dev in the comedi_device
  staging: comedi: ke_counter: remove the cnt_board_nbr macro
  staging: comedi: me_daq: factor out the "find pci device" code
  staging: comedi: me_daq: cleanup "find pci device" code
  staging: comedi: me_daq: store the pci_dev in the comedi_device
  staging: comedi: rtd520: remove the debug print of the pci addresses
  staging: comedi: rtd520: remove 'got_regions' from private data
  staging: comedi: rtd520: remove the '#if 0' code in the attach
  staging: comedi: rtd520: store the pci_dev in the comedi_device
  staging: comedi: aio_iiro_16: remove the private data
  staging: comedi: s526: remove unused variables in the private data

 drivers/staging/comedi/comedidev.h              |   5 +
 drivers/staging/comedi/drivers/adl_pci6208.c    |  19 ++--
 drivers/staging/comedi/drivers/adl_pci7230.c    |  28 ++---
 drivers/staging/comedi/drivers/adl_pci7296.c    |  28 ++---
 drivers/staging/comedi/drivers/adl_pci7432.c    |  28 ++---
 drivers/staging/comedi/drivers/adl_pci8164.c    |  28 ++---
 drivers/staging/comedi/drivers/adl_pci9111.c    |  29 ++---
 drivers/staging/comedi/drivers/adl_pci9118.c    |  33 +++---
 drivers/staging/comedi/drivers/adv_pci1710.c    | 119 +++++++++-----------
 drivers/staging/comedi/drivers/adv_pci1723.c    |  96 +++++++---------
 drivers/staging/comedi/drivers/adv_pci_dio.c    | 112 +++++++------------
 drivers/staging/comedi/drivers/aio_iiro_16.c    |  11 --
 drivers/staging/comedi/drivers/amplc_dio200.c   |  73 +++++-------
 drivers/staging/comedi/drivers/amplc_pc236.c    |  71 +++++-------
 drivers/staging/comedi/drivers/amplc_pc263.c    |  82 +++++---------
 drivers/staging/comedi/drivers/amplc_pci224.c   |  62 +++++------
 drivers/staging/comedi/drivers/amplc_pci230.c   |  47 ++++----
 drivers/staging/comedi/drivers/cb_pcidas.c      |  32 +++---
 drivers/staging/comedi/drivers/cb_pcidas64.c    | 108 +++++++++---------
 drivers/staging/comedi/drivers/cb_pcidda.c      |  86 +++++++--------
 drivers/staging/comedi/drivers/cb_pcidio.c      | 109 ++++++------------
 drivers/staging/comedi/drivers/cb_pcimdas.c     | 140 +++++++++---------------
 drivers/staging/comedi/drivers/contec_pci_dio.c | 121 ++++++++++----------
 drivers/staging/comedi/drivers/daqboard2000.c   | 118 ++++++++++----------
 drivers/staging/comedi/drivers/dt3000.c         | 127 ++++++++-------------
 drivers/staging/comedi/drivers/dyna_pci10xx.c   | 136 +++++++++--------------
 drivers/staging/comedi/drivers/ke_counter.c     | 111 +++++++++----------
 drivers/staging/comedi/drivers/me_daq.c         |  99 ++++++++---------
 drivers/staging/comedi/drivers/rtd520.c         | 103 +++++------------
 drivers/staging/comedi/drivers/s526.c           |   8 --
 30 files changed, 882 insertions(+), 1287 deletions(-)

-- 
1.7.11

