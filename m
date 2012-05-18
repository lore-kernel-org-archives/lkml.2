Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843Ab2ERCxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:53:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40602 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030743Ab2ERCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:53 -0400
Message-Id: <20120518023301.498916812@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Roese <sr@denx.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/53] stmmac: Fix compilation error in mmc_core.c
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Roese <sr@denx.de>

commit 1dd8117e3320fb42ec40ef2ace982871572d34ed upstream.

Fix this error:

  CC      drivers/net/ethernet/stmicro/stmmac/mmc_core.o
drivers/net/ethernet/stmicro/stmmac/mmc_core.c: In function 'dwmac_mmc_ctrl':
drivers/net/ethernet/stmicro/stmmac/mmc_core.c:143:2: error: implicit
  declaration of function 'pr_debug' [-Werror=implicit-function-declaration]

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
index 41e6b33..c07cfe9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
@@ -22,6 +22,7 @@
   Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 *******************************************************************************/
 
+#include <linux/kernel.h>
 #include <linux/io.h>
 #include "mmc.h"
 
-- 
1.7.10



