Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2FVXMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:12:19 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:21392 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2FVXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:12:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1340406725!3842402!29
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/31] staging: comedi: ni_daq_700: cleanup the driver
Date: Fri, 22 Jun 2012 16:12:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221612.05750.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a full cleanup of the ni_daq_700 comedi driver.

This driver was originally based on the 8255 driver which exports
a subdevice interface used by other comedi drivers. This makes
the ni_daq_700 driver overly complex. Also, the exported symbols
in it are not referenced by any other code or declared in any
headers.

The pcmcia support code in this driver is also overly complex. All
the driver needs from the pcmcia support is for the device to be
enabled and to get the iobase address of the card. Everything else
appears to be cut-and-paste from other drivers.

H Hartley Sweeten (31):
  staging: comedi: ni_daq_700: remove exported symbols
  staging: comedi: ni_daq_700: move the MODULE_* stuff to the EOF
  staging: comedi: ni_daq_700: add the module_{init,exit} declarations
  staging: comedi: ni_daq_700: consolidate and init and exit functions
  staging: comedi: ni_daq_700: change driver registration order
  staging: comedi: ni_daq_700: cleanup to the pcmcia_driver declaration
  staging: comedi: ni_daq_700: remove some useless comments
  staging: comedi: ni_daq_700: refactor the pcmcia support code
  staging: comedi: ni_daq_700: Move the comedi_driver variable
  staging: comedi: ni_daq_700: Remove the unused private data struct
  staging: comedi: ni_daq_700: Remove a "do nothing" function stub
  staging: comedi: ni_daq_700: Remove unused variables from the
    boardinfo
  staging: comedi: ni_daq_700: Remove unneeded variables from the
    boardinfo
  staging: comedi: ni_daq_700: Remove bustype variable from the
    boardinfo
  staging: comedi: ni_daq_700: move the boardinfo variable
  staging: comedi: ni_daq_700: remove thisboard macro
  staging: comedi: ni_daq_700: remove unused private data variable
  staging: comedi: ni_daq_700: remove the CALLBACK_* code
  staging: comedi: ni_daq_700: remove a couple unused defines
  staging: comedi: ni_daq_700: remove the subdev_700_init function
  staging: comedi: ni_daq_700: remove the #ifdef'ed out irq code
  staging: comedi: ni_daq_700: change to 'attach' printk's to
    dev_printk's
  staging: comedi: ni_daq_700: remove local variable in the 'attach'
    function
  staging: comedi: ni_daq_700: remove some dangling ';'
  staging: comedi: ni_daq_700: use a local var to fix a > 80 char line
    issue
  staging: comedi: ni_daq_700: fix return for insn_config function
  staging: comedi: ni_daq_700: cleanup pcmcia debug output messages
  staging: comedi: ni_daq_700: remove unused pcmcia 'stop' logic
  staging: comedi: ni_daq_700: remove unneeded pcmcia private data
  staging: comedi: ni_daq_700: remove the pcmcia suspend/resume
  staging: comedi: ni_daq_700: refactor the pcmcia attach/detach

 drivers/staging/comedi/drivers/ni_daq_700.c | 508 +++++-----------------------
 1 file changed, 81 insertions(+), 427 deletions(-)

-- 
1.7.11

