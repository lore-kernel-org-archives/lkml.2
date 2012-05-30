Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2E3Rqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:46:45 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:35168 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab2E3Rqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:46:40 -0400
Date: Wed, 30 May 2012 19:46:10 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH RFC 3/3] i2c-nomadik: depend on ARM_AMBA, not PLAT_NOMADIK
Message-ID: <5be16088e4f9170da1540a3e4abe54175d5bcce2.1338398567.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1338398567.git.rubini@gnudd.com>
In-Reply-To: <cover.1338398567.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gateware device has been used outside of the Nomadik world, using
the pci-amba bridge driver, so loosen the dependencies.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/i2c/busses/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 7244c8b..e9f9c5d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -479,10 +479,11 @@ config I2C_MXS
 
 config I2C_NOMADIK
 	tristate "ST-Ericsson Nomadik/Ux500 I2C Controller"
-	depends on PLAT_NOMADIK
+	depends on ARM_AMBA
 	help
 	  If you say yes to this option, support will be included for the
-	  I2C interface from ST-Ericsson's Nomadik and Ux500 architectures.
+	  I2C interface from ST-Ericsson's Nomadik and Ux500 architectures,
+	  as well as the STA2X11 PCIe I/O HUB.
 
 config I2C_NUC900
 	tristate "NUC900 I2C Driver"
-- 
1.7.7.2
