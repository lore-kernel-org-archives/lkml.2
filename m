Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2ITJHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:07:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:34318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2ITJHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="208538089"
Date: Thu, 20 Sep 2012 12:10:14 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
Message-ID: <20120920091013.GV15548@intel.com>
References: <20120920173622.2aa7209cd241a3945f4384d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920173622.2aa7209cd241a3945f4384d4@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:36:22PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/ethernet/i825xx/znet.c: In function 'hardware_init':
> drivers/net/ethernet/i825xx/znet.c:868:2: error: implicit declaration of function 'isa_virt_to_bus' [-Werror=implicit-function-declaration]
> 
> Caused by commit 1d3ff76759b7 ("i825xx: znet: fix compiler warnings when
> building a 64-bit kernel").  Is there some Kconfig dependency missing (CONFIG_ISA)?

If we make it dependent on CONFIG_ISA then the driver cannot be built with
64-bit kernel. Then again is there someone running 64-bit kernel on Zenith
Z-note notebook? From the pictures it looks like very ancient "laptop".

An alternative is to make it depend on X86 like this:

diff --git a/drivers/net/ethernet/i825xx/Kconfig b/drivers/net/ethernet/i825xx/Kconfig
index fed5080..959faf7 100644
--- a/drivers/net/ethernet/i825xx/Kconfig
+++ b/drivers/net/ethernet/i825xx/Kconfig
@@ -150,7 +150,7 @@ config SUN3_82586
 
 config ZNET
 	tristate "Zenith Z-Note support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ISA_DMA_API
+	depends on EXPERIMENTAL && ISA_DMA_API && X86
 	---help---
 	  The Zenith Z-Note notebook computer has a built-in network
 	  (Ethernet) card, and this is the Linux driver for it. Note that the
