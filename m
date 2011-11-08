Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1KHHGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:06:07 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:51550 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab1KHHGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:06:03 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 0/2] mfd/stmpe: Add SPI interface support
Date: Tue, 8 Nov 2011 12:35:49 +0530
Message-ID: <cover.1320735864.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few STMPE controller can have register interface over SPI or I2C. Current
implementation only supports I2C and all code is present in a single file
stmpe.c.

This patchset separates out code into three files
- stmpe: specific to controller only
- stmpe-i2c: specific to i2c interface
- stmpe-spi: specific to spi interface

In order to rebase it cleanly, please apply earlier floated patch 
	"mfd/stmpe: Add support for irq over gpio pin"

Viresh Kumar (2):
  mfd/stmpe: separate out controller and interface specific code
  mfd/stmpe: Add support for SPI interface

 drivers/mfd/Kconfig       |   19 ++++++-
 drivers/mfd/Makefile      |    2 +
 drivers/mfd/stmpe-i2c.c   |  116 +++++++++++++++++++++++++++++++++++
 drivers/mfd/stmpe-spi.c   |  147 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/stmpe.c       |  128 ++++++++++++---------------------------
 drivers/mfd/stmpe.h       |   34 ++++++++++
 include/linux/mfd/stmpe.h |    7 ++-
 7 files changed, 361 insertions(+), 92 deletions(-)
 create mode 100644 drivers/mfd/stmpe-i2c.c
 create mode 100644 drivers/mfd/stmpe-spi.c

-- 
1.7.2.2

