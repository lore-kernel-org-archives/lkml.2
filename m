Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1KMVwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 16:52:44 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:49903 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1KMVwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 16:52:43 -0500
Subject: [PATCH] [TRIVIAL] spi: drop "select SPI_MASTER_OF"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 22:52:40 +0100
Message-ID: <1321221160.20271.100.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no Kconfig symbol named SPI_MASTER_OF. The select statement for
that symbol is a nop. Drop it.

While we're touching that Kconfig entry also drop a superfluous
dependency on SPI (this entry is wrapped in "if SPI" / "endif").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "yes "" | make ARCH=powerpc config" before and after
applying this patch. Identical .config files were generated, as was
expected.

1) This select statement was added in commit 42bbb70980 ("powerpc/5200:
Add mpc5200-spi (non-PSC) device driver"). Perhaps this was a leftover
from some draft development. (Currently it seems OF_SPI, a hidden
config, will do the right thing for the interaction of OF and SPI master
controllers. Not that I understand this stuff ...)


 drivers/spi/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a1fd73d..950ccb7 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -174,8 +174,7 @@ config SPI_LM70_LLP
 
 config SPI_MPC52xx
 	tristate "Freescale MPC52xx SPI (non-PSC) controller support"
-	depends on PPC_MPC52xx && SPI
-	select SPI_MASTER_OF
+	depends on PPC_MPC52xx
 	help
 	  This drivers supports the MPC52xx SPI controller in master SPI
 	  mode.
-- 
1.7.4.4

