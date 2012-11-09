Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2KIOU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:20:26 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46786 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab2KIOUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:24 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH v3 00/10] sta2x11-mfd patches
Date: Fri,  9 Nov 2012 15:19:51 +0100
Message-Id: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Hi,

this is v3 of a patchset submitted on
2012/10/22 (see https://lkml.org/lkml/2012/10/22/290)
and 2012/09/12 (see https://lkml.org/lkml/2012/9/12/139).
Here's a summary of changes in v3:

* Regmap support fix:
sta2x11_apb_soc_regs_writeable_reg() fixed as
suggested by Mark Brown
(see https://lkml.org/lkml/2012/10/23/448)

* Regmap support fix: regmap field in struct
sta2x11_mfd (a single struct regmap * in v2) becomes
an array of struct regmap pointers, one per platform
device.

Davide Ciminaghi (10):
  drivers/mfd/sta2x11-mfd: add apb-soc regs driver and factor out
    common code
  drivers/mfd/sta2x11-mfd: add regmap support
  drivers/mfd/sta2x11-mfd: add sta2x11_mfd_get_regs_data() function
  drivers/mfd/sta2x11-mfd: use defines for platform devices' names
  drivers/mfd/sta2x11-mfd: only add sta2x11_mfd if it hasn't already
    been added
  drivers/mfd/sta2x11-mfd: platform probe: don't mind about gpio
    platform data
  drivers/mfd/sta2x11-mfd: use one lock per device instead of one lock
    per mfd
  drivers/mfd/sta2x11-mfd: add scr (otp registers) platform driver
  drivers/mfd/sta2x11-mfd: add defines for some sta2x11 sctl registers
  drivers/mfd/sta2x11-mfd: add myself to copyright

 drivers/mfd/Kconfig             |    1 +
 drivers/mfd/sta2x11-mfd.c       |  532 +++++++++++++++++++++++++++------------
 include/linux/mfd/sta2x11-mfd.h |  198 ++++++++++++++-
 3 files changed, 574 insertions(+), 157 deletions(-)

-- 
1.7.10.4

