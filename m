Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2FKA6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:58:30 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40528 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab2FKA63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:29 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 00/14] sta2x11-mfd patches
Date: Mon, 11 Jun 2012 02:57:45 +0200
Message-Id: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Hi,

I'm working on the implementation of the common clock framework
for the STA2X11 (aka CONNEXT) soc.
To configure, enable and disable clocks, some general purpose
registers (apb-soc-registers) must be accessed. Such registers
can be reached through bar #1 of a multifunction pci device,
which is not covered by the current version of sta2x11-mfd.
This patch series adds support for the apb-soc-registers device
and rearranges the sta2x11-mfd driver to avoid unnecessary
code duplications and to cope with the increased number of platform
devices.


Davide Ciminaghi (14):
  sta2x11 mfd : also deal with PCI_DEVICE_ID_STMICRO_VIC.
  sta2x11-mfd : add apb-soc regs driver and factor out common code
  sta2x11-mfd : only add sta2x11_mfd if it hasn't already been added
  sta2x11-mfd : platform probe: don't mind about gpio platform data
  sta2x11-mfd : make enum sta2x11_mfd_plat_dev public
  sta2x11-mfd, sta2x11-mfd.h: add more platform device types
  sta2x11-mfd : implement apbreg_mask and sctl_mask as static inlines
  sta2x11-mfd : add apb-soc-regs defines and mask function
  sta2x11-mfd : add apb-soc-regs debugfs register set
  sta2x11-mfd : use one lock per device instead of one lock per mfd.
  sta2x11-mfd : add defines for platform devices' names
  sta2x11-mfd : use defines for platform devices' names
  sta2x11-mfd : add sta2x11_mfd_get_regs_data() function
  sta2x11-mfd : add myself to copyright

 drivers/mfd/sta2x11-mfd.c       |  416 ++++++++++++++++++++++++++-------------
 include/linux/mfd/sta2x11-mfd.h |  169 ++++++++++++++++-
 2 files changed, 449 insertions(+), 136 deletions(-)

-- 
1.7.9.1

