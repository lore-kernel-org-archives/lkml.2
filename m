Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab2GKVsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:48:05 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:18529 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2GKVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:48:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1342043279!9405131!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/30] staging: comedi: move 'struct pci_dev *' into comedi_device
Date: Wed, 11 Jul 2012 14:47:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111447.47402.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the comedi pci drivers have a struct pci_dev * in their private
data to hold the pointer to the pci device. Some of the drivers only
have private data because of this pointer.

Move the variable into the comedi_device struct and remove the private
data for the drivers that no longer need it.

This only updates the drivers that have been cleaned up enough or only
need simple changes to make the conversion. The other comedi pci drivers
will be converted to use the common pci_dev pointer as they are cleaned
up.

The cb_pcidio and dyna_pci10xx drivers have a bit of additional cleanup
to remove some of the unneeded private data variables and to use the
comedi_device iobase variable.

H Hartley Sweeten (30):
  staging: comedi: add pci_dev pointer to comedi_device
  staging: comedi: adl_pci6208: use comedi_device pci_dev pointer
  staging: comedi: adl_pci7230: use comedi_device pci_dev pointer
  staging: comedi: adl_pci7230: remove private data
  staging: comedi: adl_pci7296: use comedi_device pci_dev pointer
  staging: comedi: adl_pci7296: remove private data
  staging: comedi: adl_pci7432: use comedi_device pci_dev pointer
  staging: comedi: adl_pci7432: remove private data
  staging: comedi: adl_pci8164: use comedi_device pci_dev pointer
  staging: comedi: adl_pci8164: remove private data
  staging: comedi: adl_pci9111: use comedi_device pci_dev pointer
  staging: comedi: adl_pci9118: use comedi_device pci_dev pointer
  staging: comedi: cb_pcidas: use comedi_device pci_dev pointer
  staging: comedi: cb_pcidio: factor out the "find pci device" code
  staging: comedi: cb_pcidio: cleanup the "find pci device" code
  staging: comedi: cb_pcidio: use comedi_device pci_dev pointer
  staging: comedi: cb_pcidio: use comedi_device iobase
  staging: comedi: cb_pcidio: remove private data
  staging: comedi: contec_pci_dio: factor out the "find pci device"
    code
  staging: comedi: contec_pci_dio: cleanup the "find pci device" code
  staging: comedi: contec_pci_dio: use comedi_device pci_dev pointer
  staging: comedi: contec_pci_dio: remove private data
  staging: comedi: dyna_pci10xx: factor out the "find pci device" code
  staging: comedi: dyna_pci10xx: cleanup the "find pci device" code
  staging: comedi: dyna_pci10xx: use comedi_device pci_dev pointer
  staging: comedi: dyna_pci10xx: remove unused variables in the private
    data
  staging: comedi: dyna_pci10xx: use comedi_device iobase
  staging: comedi: ke_counter: factor out the "find pci device" code
  staging: comedi: ke_counter: cleanup the "find pci device" code
  staging: comedi: contec_pci_dio: use comedi_device pci_dev pointer

 drivers/staging/comedi/comedidev.h              |   2 +
 drivers/staging/comedi/drivers/adl_pci6208.c    |  17 ++--
 drivers/staging/comedi/drivers/adl_pci7230.c    |  24 ++---
 drivers/staging/comedi/drivers/adl_pci7296.c    |  24 ++---
 drivers/staging/comedi/drivers/adl_pci7432.c    |  24 ++---
 drivers/staging/comedi/drivers/adl_pci8164.c    |  24 ++---
 drivers/staging/comedi/drivers/adl_pci9111.c    |  25 +++--
 drivers/staging/comedi/drivers/adl_pci9118.c    |  23 +++--
 drivers/staging/comedi/drivers/cb_pcidas.c      |  31 +++---
 drivers/staging/comedi/drivers/cb_pcidio.c      | 115 ++++++++---------------
 drivers/staging/comedi/drivers/contec_pci_dio.c | 119 +++++++++++------------
 drivers/staging/comedi/drivers/dyna_pci10xx.c   | 120 +++++++++---------------
 drivers/staging/comedi/drivers/ke_counter.c     | 108 +++++++++------------
 13 files changed, 258 insertions(+), 398 deletions(-)

-- 
1.7.11

