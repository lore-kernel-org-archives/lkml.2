Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab2HQClJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:41:09 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:53151 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2HQClH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:41:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1345171265!7151497!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/35] staging: comedi: update comedi pci drivers
Date: Thu, 16 Aug 2012 19:40:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161940.55761.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the manual legacy 'attach' callback in the comedi pci drivers
that have it stubbed out. The 'attach' callback is not optional in
the comedi core.

Cleanup and convert some of the other comedi pci drivers to use
the 'attach_pci' callback and remove the legacy 'attach'.

H Hartley Sweeten (35):
  staging: comedi: adl_pci6208: remove manual legacy attach
  staging: comedi: adl_pci7296: remove manual legacy attach
  staging: comedi: adl_pci7x3x: remove manual legacy attach
  staging: comedi: adl_pci8164: use attach_pci callback
  staging: comedi: cb_pcidas: use attach_pci callback
  staging: comedi: cb_pcidio: remove thisboard macro
  staging: comedi: cb_pcidio: use attach_pci callback
  staging: comedi: cb_pcidda: remove thisboard and devpriv macros
  staging: comedi: cb_pcidda: remove forward declarations
  staging: comedi: cb_pcidda: use attach_pci callback
  staging: comedi: cb_pcimdas: remove thisboard and devpriv macros
  staging: comedi: cb_pcimdas: remove forward declarations
  staging: comedi: cb_pcimdas: use attach_pci callback
  staging: comedi: cb_pcimdda: remove REG_SZ and REGS_BARINDEX macros
  staging: comedi: cb_pcimdda: remove thisboard and devpriv macros
  staging: comedi: cb_pcimdda: remove forward declarations
  staging: comedi: cb_pcimdda: add namespace to the driver
  staging: comedi: cb_pcimdda: cleanup pci probe
  staging: comedi: cb_pcimdda: use dev->iobase
  staging: comedi: cb_pcimdda: store the pci_dev in the comedi_device
  staging: comedi: cb_pcimdda: cleanup the 8255 subdevice init
  staging: comedi: cb_pcimdda: remove the DIO_METHODS
  staging: comedi: cb_pcimdda: remove dio_chans from the private data
  staging: comedi: cb_pcimdda: define the register map
  staging: comedi: cb_pcimdda: remove dio_offset from the boardinfo
  staging: comedi: cb_pcimdda: remove regs_badrindex and reg_sz from
    boardinfo
  staging: comedi: cb_pcimdda: remove ao_chans and ao_bits from
    boardinfo
  staging: comedi: cb_pcimdda: remove boardinfo
  staging: comedi: cb_pcimdda: remove attached_to_8255 from private
    data
  staging: comedi: cb_pcimdda: fix bug in call to subdev_8255_cleanup
  staging: comedi: cb_pcimdda: minor cleanup of the private data
  staging: comedi: cb_pcimdda: cleanup the analog out read/write
  staging: comedi: cb_pcimdda: use attach_pci callback
  staging: comedi: dyna_pci10xx: remove manual legacy attach
  staging: comedi: ke_counter: use attach_pci callback

 drivers/staging/comedi/drivers/adl_pci6208.c  |  10 -
 drivers/staging/comedi/drivers/adl_pci7296.c  |  10 -
 drivers/staging/comedi/drivers/adl_pci7x3x.c  |  10 -
 drivers/staging/comedi/drivers/adl_pci8164.c  |  65 +----
 drivers/staging/comedi/drivers/cb_pcidas.c    |  84 ++----
 drivers/staging/comedi/drivers/cb_pcidda.c    | 382 +++++++++++--------------
 drivers/staging/comedi/drivers/cb_pcidio.c    | 104 +++----
 drivers/staging/comedi/drivers/cb_pcimdas.c   | 279 ++++++++-----------
 drivers/staging/comedi/drivers/cb_pcimdda.c   | 387 ++++++--------------------
 drivers/staging/comedi/drivers/dyna_pci10xx.c |  10 -
 drivers/staging/comedi/drivers/ke_counter.c   |  83 ++----
 11 files changed, 475 insertions(+), 949 deletions(-)

-- 
1.7.11

