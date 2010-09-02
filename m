Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0IBBiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:38:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39737
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab0IBBiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:38:18 -0400
Date: Wed, 01 Sep 2010 18:38:35 -0700 (PDT)
Message-Id: <20100901.183835.219746796.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for September 1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100901133614.2580f238.sfr@canb.auug.org.au>
References: <20100901133614.2580f238.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 1 Sep 2010 13:36:14 +1000

> The net tree still has its build failure for which I have reverted a
> commit.

Stephen I'm about to commit the following to net-next-2.6 in the meantime
to deal with that so you don't have to revert whilst Fujita works on
the more cleaner solution.

--------------------
starfire: Temporary kludge to fix powerpc build.

Add a dma_addr_t 64-bit case for powerpc with 64-bit phys addresses.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/starfire.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index c3bf288..4adf124 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -148,7 +148,7 @@ static int full_duplex[MAX_UNITS] = {0, };
  * This SUCKS.
  * We need a much better method to determine if dma_addr_t is 64-bit.
  */
-#if (defined(__i386__) && defined(CONFIG_HIGHMEM64G)) || defined(__x86_64__) || defined (__ia64__) || defined(__alpha__) || defined(__mips64__) || (defined(__mips__) && defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR))
+#if (defined(__i386__) && defined(CONFIG_HIGHMEM64G)) || defined(__x86_64__) || defined (__ia64__) || defined(__alpha__) || defined(__mips64__) || (defined(__mips__) && defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR)) || (defined(__powerpc64__) || defined(CONFIG_PHYS_64BIT))
 /* 64-bit dma_addr_t */
 #define ADDR_64BITS	/* This chip uses 64 bit addresses. */
 #define netdrv_addr_t __le64
-- 
1.7.2.2

