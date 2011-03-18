Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1CREk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:40:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51897 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1CREkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:40:23 -0400
Date: Fri, 18 Mar 2011 15:40:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denis Turischev <denis@compulab.co.il>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: manual merge of the spi tree with the mfd tree
Message-Id: <20110318154017.e45aa888.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the spi tree got a conflict in
drivers/gpio/Kconfig between commit 390ff13830e5 ("gpio: Add Tunnel Creek
support to sch_gpio") from the mfd tree and commit 61ab3fe57e45 ("gpio;
Make Intel chipset gpio drivers depend on x86") from the spi tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.  I am assuming that the Tunnel Creek stuff should also depend
on X86?
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/Kconfig
index 7ef9108,b46442d..0000000
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@@ -100,8 -100,8 +100,8 @@@ config GPIO_VR41X
  	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint
  
  config GPIO_SCH
 -	tristate "Intel SCH GPIO"
 +	tristate "Intel SCH/TunnelCreek GPIO"
- 	depends on GPIOLIB && PCI
+ 	depends on GPIOLIB && PCI && X86
  	select MFD_CORE
  	select LPC_SCH
  	help
