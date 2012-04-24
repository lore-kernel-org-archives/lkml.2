Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2DXGJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:09:08 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:45709 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab2DXGJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:09:05 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, <spear-devel@list.st.com>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 0/9] clk: Add non CONFIG_HAVE_CLK routines
Date: Tue, 24 Apr 2012 11:26:08 +0530
Message-ID: <cover.1335246730.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers are shared between architectures that may or may not have HAVE_CLK
selected for them. To remove compilation errors for them we enclose clk_*()
calls in these drivers within #ifdef CONFIG_HAVE_CLK, #endif.

This patchset removes the need of these CONFIG_HAVE_CLK statements, by
introducing dummy routines when HAVE_CLK is not selected by platforms. So,
definition of these routines will always be available. These calls will return
error for platforms that don't select HAVE_CLK.

V1->V2:
- Removed few patches as they might break working drivers
- Updated 1st patch, as it doesn't apply cleanly on latest linux-next after this
  got applied.

  commit a8a97db984bdc5e89d42e41891543d2daaf314cb
  Author: Mark Brown <broonie@sirena.org.uk>
  Date:   Thu Apr 5 11:42:09 2012 +0100

      ARM: 7376/1: clkdev: Implement managed clk_get()

- Similarly, updated stmmac patch as there were updates for it too.

Viresh Kumar (9):
  clk: Add non CONFIG_HAVE_CLK routines
  clk: Remove redundant depends on from drivers/Kconfig
  ata/pata_arasan: Remove conditional compilation of clk code
  ata/sata_mv: Remove conditional compilation of clk code
  net/c_can: Remove conditional compilation of clk code
  net/stmmac: Remove conditional compilation of clk code
  gadget/m66592: Remove conditional compilation of clk code
  gadget/r8a66597: Remove conditional compilation of clk code
  usb/host/r8a66597: Remove conditional compilation of clk code

 drivers/ata/pata_arasan_cf.c                      |   39 ++---
 drivers/ata/sata_mv.c                             |   10 --
 drivers/clk/Kconfig                               |    2 -
 drivers/net/can/c_can/c_can_platform.c            |   28 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |   41 -----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   31 +++--
 drivers/usb/gadget/m66592-udc.c                   |   19 +--
 drivers/usb/gadget/m66592-udc.h                   |    5 -
 drivers/usb/gadget/r8a66597-udc.c                 |   21 +--
 drivers/usb/gadget/r8a66597-udc.h                 |    5 -
 drivers/usb/host/r8a66597-hcd.c                   |   28 +---
 drivers/usb/host/r8a66597.h                       |    5 -
 include/linux/clk.h                               |  168 +++++++++++++-------
 13 files changed, 176 insertions(+), 226 deletions(-)

-- 
1.7.9

