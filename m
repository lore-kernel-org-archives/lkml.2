Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1BDEOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:14:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41963 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1BDEOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:14:14 -0500
Date: Fri, 4 Feb 2011 15:14:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the tty tree with the i.MX tree
Message-Id: <20110204151408.9988102e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/Kconfig between commit
47d37d6f94ccf32d302492f969209930b2411f9e ("serial: Add auart driver for
i.MX23/28") from the i.M tree and commit
4564e1ef219fa69ed827fe2613569543a6b26fbc ("serial: pch_uart: support new
device ML7213") from the tty tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/Kconfig
index ef164f5,aaedbad..0000000
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@@ -1574,18 -1596,8 +1573,23 @@@ config SERIAL_PCH_UAR
  	  which is an IOH(Input/Output Hub) for x86 embedded processor.
  	  Enabling PCH_DMA, this PCH UART works as DMA mode.
  
+ 	  This driver also can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/
+ 	  Output Hub) which is for IVI(In-Vehicle Infotainment) use.
+ 	  ML7213 is companion chip for Intel Atom E6xx series.
+ 	  ML7213 is completely compatible for Intel EG20T PCH.
++
 +config SERIAL_MXS_AUART
 +	depends on ARCH_MXS
 +	tristate "MXS AUART support"
 +	select SERIAL_CORE
 +	help
 +	  This driver supports the MXS Application UART (AUART) port.
 +
 +config SERIAL_MXS_AUART_CONSOLE
 +	bool "MXS AUART console support"
 +	depends on SERIAL_MXS_AUART=y
 +	select SERIAL_CORE_CONSOLE
 +	help
 +	  Enable a MXS AUART port to be the system console.
 +
  endmenu
