Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1GVGaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:30:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1GVGaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:30:01 -0400
Date: Thu, 21 Jul 2011 23:26:51 -0700 (PDT)
Message-Id: <20110721.232651.1449248174820939714.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, matt@ozlabs.org
Subject: Re: linux-next: build warning after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110722162433.a280b3b71cff9c08fe18956f@canb.auug.org.au>
References: <20110722162433.a280b3b71cff9c08fe18956f@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 21 Jul 2011 23:26:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 22 Jul 2011 16:24:33 +1000

> warning: (PPC) selects HAVE_BPF_JIT which has unmet direct dependencies (NET)
> 
> Introduced by commit 0ca87f05ba8b ("net: filter: BPF 'JIT' compiler for
> PPC64").
> 
> I suspect that the fix is to move the
> 
> config HAVE_BPF_JIT
>         bool
> 
> lines to outside the "if NET" in net/Kconfig.

I'm going to fix this the way it's dealt with in the x86_64 case
for now, thanks for the report:

--------------------
net: Fix ppc64 BPF JIT dependencies.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/powerpc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 39860fc..cdf7a0a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -134,7 +134,7 @@ config PPC
 	select GENERIC_IRQ_SHOW_LEVEL
 	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_SYSCALL_TRACEPOINTS
-	select HAVE_BPF_JIT if PPC64
+	select HAVE_BPF_JIT if (PPC64 && NET)
 
 config EARLY_PRINTK
 	bool
-- 
1.7.6

