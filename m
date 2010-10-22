Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab0JVSYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49977 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755Ab0JVSYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=kYB+ZkXzqYi/beTkKh3ENoH2NZDVO7iHiJIFLLiXhQiPaiHCuPgrVb3NPCBvqNvWJW
         F1v5gvr7fKSKv6P8Bz04se3do29OcgcqcR45gv3gGd/nWaTM38PPrOcvQWKdWLCNKgAx
         17j49LGXrMRj8NcYHQbAIA9Pmj+n9wbOT6VAM=
Message-ID: <4CC1D6D0.8040108@gmail.com>
Date: Fri, 22 Oct 2010 20:24:16 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Li Yi <yi.li@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [RFC][PATCH 3/8] Removal of dead code from arch/blackfin/include/asm/irqflags.h
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 12282e20f3cb7757bfe333cac43174751453c15b
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Thu Oct 21 23:53:26 2010 +0200

    Removal of dead code from
    arch/blackfin/include/asm/irqflags.h
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: Li Yi <yi.li@analog.com>
    CC: <uclinux-dist-devel@blackfin.uclinux.org>
    CC: <linux-kernel@vger.kernel.org>

diff --git a/arch/blackfin/include/asm/irqflags.h b/arch/blackfin/include/asm/irqflags.h
index 813a1af..26dfd27 100644
--- a/arch/blackfin/include/asm/irqflags.h
+++ b/arch/blackfin/include/asm/irqflags.h
@@ -137,42 +137,10 @@ static inline void local_irq_restore_hw_notrace(unsigned long flags)
 		local_irq_enable_hw_notrace();
 }
 
-#ifdef CONFIG_IPIPE_TRACE_IRQSOFF
-# define local_irq_disable_hw()				\
-	do {						\
-		if (!irqs_disabled_hw()) {		\
-			local_irq_disable_hw_notrace();	\
-			ipipe_trace_begin(0x80000000);	\
-		}					\
-	} while (0)
-# define local_irq_enable_hw()				\
-	do {						\
-		if (irqs_disabled_hw()) {		\
-			ipipe_trace_end(0x80000000);	\
-			local_irq_enable_hw_notrace();	\
-		}					\
-	} while (0)
-# define local_irq_save_hw(flags)			\
-	do {						\
-		local_save_flags_hw(flags);		\
-		if (!irqs_disabled_flags_hw(flags)) {	\
-			local_irq_disable_hw_notrace();	\
-			ipipe_trace_begin(0x80000001);	\
-		}					\
-	} while (0)
-# define local_irq_restore_hw(flags)			\
-	do {						\
-		if (!irqs_disabled_flags_hw(flags)) {	\
-			ipipe_trace_end(0x80000001);	\
-			local_irq_enable_hw_notrace();	\
-		}					\
-	} while (0)
-#else /* !CONFIG_IPIPE_TRACE_IRQSOFF */
 # define local_irq_disable_hw()		local_irq_disable_hw_notrace()
 # define local_irq_enable_hw()		local_irq_enable_hw_notrace()
 # define local_irq_save_hw(flags)	local_irq_save_hw_notrace(flags)
 # define local_irq_restore_hw(flags)	local_irq_restore_hw_notrace(flags)
-#endif /* !CONFIG_IPIPE_TRACE_IRQSOFF */
 
 #else /* CONFIG_IPIPE */
 
