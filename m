Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1KPL0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:26:36 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:47290 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008Ab1KPL0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:26:35 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Cc: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <grant.likely@secretlab.ca>
Subject: [PATCH 0/5] stmpe: mfd & gpio updates
Date: Wed, 16 Nov 2011 16:56:05 +0530
Message-ID: <cover.1321442150.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does following:
- Fixes bug with "mfd/stmpe: Pass partnum as param to stmpe_probe()" patch
- Adds in support for STMPE610 and 801

STMPE801 has a different set of register as compared to other variants. So it is
specially handled at few places in mfd's and gpio's stmpe driver.

Note: To successfully apply this patchset, first apply following patches already
sent and acked over list:
- mfd/stmpe: Add support for irq over gpio pin
- mfd/stmpe: separate out controller and interface specific code
- mfd/stmpe: Add support for SPI interface

Pratyush Anand (1):
  mfd/stmpe: Move struct stmpe_variant_info to linux/mfd/stmpe.h

Viresh Kumar (4):
  mfd/stmpe: Pass partnum as param to stmpe_probe()
  mfd/stmpe: Add support for stmpe variant 610
  mfd/stmpe: ADD support for stmpe variant 801
  gpio/gpio-stmpe: ADD support for stmpe variant 801

 drivers/gpio/gpio-stmpe.c |   31 ++++++++++-
 drivers/mfd/stmpe-i2c.c   |   13 +----
 drivers/mfd/stmpe-spi.c   |    7 ++-
 drivers/mfd/stmpe.c       |  125 ++++++++++++++++++++++++++++++++++++++-------
 drivers/mfd/stmpe.h       |   53 +++++++------------
 include/linux/mfd/stmpe.h |   37 +++++++++++++-
 6 files changed, 198 insertions(+), 68 deletions(-)

-- 
1.7.2.2
