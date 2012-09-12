Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2ILKLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:11:42 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:39799 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab2ILKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:11:41 -0400
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 0/8 RESEND] sta2x11-mfd patches
Date: Wed, 12 Sep 2012 12:11:11 +0200
Message-Id: <1347444680-31479-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Hi,

this is a resend of a patchset dated Jun 10th (see
https://lkml.org/lkml/2012/6/10/188) even if some of the
commits have been squashed.

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

Davide

Davide Ciminaghi (8):
  sta2x11-mfd : add apb-soc regs driver and factor out common code
  sta2x11-mfd : add sta2x11_mfd_get_regs_data() function
  sta2x11-mfd : use defines for platform devices' names
  sta2x11-mfd : only add sta2x11_mfd if it hasn't already been added
  sta2x11-mfd : platform probe: don't mind about gpio platform data
  sta2x11-mfd : use one lock per device instead of one lock per mfd.
  sta2x11-mfd : add defines for some sta2x11 sctl registers.
  sta2x11-mfd : add myself to copyright

 drivers/mfd/sta2x11-mfd.c       |  416 ++++++++++++++++++++++++++-------------
 include/linux/mfd/sta2x11-mfd.h |  190 ++++++++++++++++++-
 2 files changed, 470 insertions(+), 136 deletions(-)

-- 
1.7.9.1

