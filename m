Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1KHXJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:09:49 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:59929 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1KHXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:09:48 -0500
Subject: [PATCH] misc/eeprom: Fix dependecy on 'PPC_MPC5200_GPIO'
From: Paul Bolle <pebolle@tiscali.nl>
To: Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 00:09:39 +0100
Message-ID: <1320793779.14409.415.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver for the DigsyMTC display configuration EEPROMs device got
added by commit 469dded183 ("misc/eeprom: add eeprom access driver for
digsy_mtc board"). Its Kconfig symbol depends on PPC_MPC5200_GPIO. But
at the time that driver got added PPC_MPC5200_GPIO was already renamed
to GPIO_MPC5200, by commit 6eae1ace68 ("gpio: Move mpc5200 gpio driver
to drivers/gpio").

So make this driver depend on GPIO_MPC5200. And since GPIO_MPC5200 itself
implies that GPIOLIB is set, that dependency can be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested: I haven't got the hardware nor the PPC toolchain needed to
build this. And it seems this needs (build) testing anyhow.

1) Sent to the people who wrote the two patches mentioned in the commit
explanation and CC'd the non-authors who signed-off these patches.

2) It looks like the config tools do not complain about dependencies
that cannot be met because of a Kconfig symbol that doesn't even exist.
Is that correct? If so, shouldn't they be made to complain in that case?

 drivers/misc/eeprom/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index 26cf12c..701edf6 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -85,7 +85,7 @@ config EEPROM_93XX46
 
 config EEPROM_DIGSY_MTC_CFG
 	bool "DigsyMTC display configuration EEPROMs device"
-	depends on PPC_MPC5200_GPIO && GPIOLIB && SPI_GPIO
+	depends on GPIO_MPC5200 && SPI_GPIO
 	help
 	  This option enables access to display configuration EEPROMs
 	  on digsy_mtc board. You have to additionally select Microwire
-- 
1.7.4.4

