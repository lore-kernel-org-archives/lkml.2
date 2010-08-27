Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0H0DcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 23:32:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47835
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201Ab0H0DcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 23:32:21 -0400
Date: Thu, 26 Aug 2010 20:32:36 -0700 (PDT)
Message-Id: <20100826.203236.71085896.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100827111400.58bf82d1.sfr@canb.auug.org.au>
References: <20100827111400.58bf82d1.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Aug 2010 11:14:00 +1000

> After merging the nert tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/stmmac/stmmac_timer.c: In function 'stmmac_open_ext_timer':
> drivers/net/stmmac/stmmac_timer.c:60: error: 'CONFIG_RTC_HCTOSYS_DEVICE' undeclared (first use in this function)
> 
> Maybe exposed by commit ac75791aa943c7953521cb4fa7728bf51f9abd2d ("stmmac:
> remove dead option in the driver's Kconfig") since presumably we used to
> not build this driver.

Strange, it built on sparc64 for whatever reason :-)

I've just pushed the following fix to net-next-2.6, thanks.

--------------------
stmmac: Make time functionality depend upon RTC_HCTOSYS_DEVICE

Based upon a report by Stephen Rothwell.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/stmmac/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/stmmac/Kconfig b/drivers/net/stmmac/Kconfig
index 6439680..3c2af7c 100644
--- a/drivers/net/stmmac/Kconfig
+++ b/drivers/net/stmmac/Kconfig
@@ -32,6 +32,7 @@ config STMMAC_DUAL_MAC
 config STMMAC_TIMER
 	bool "STMMAC Timer optimisation"
 	default n
+	depends on RTC_HCTOSYS_DEVICE
 	help
 	  Use an external timer for mitigating the number of network
 	  interrupts. Currently, for SH architectures, it is possible
-- 
1.7.2.2

