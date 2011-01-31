Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1AaCOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:14:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59860 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab1AaCOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:14:08 -0500
Date: Mon, 31 Jan 2011 13:14:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: linux-next: manual merge of the msm tree with the arm tree
Message-Id: <20110131131406.52d3aceb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the msm tree got a conflict in
arch/arm/mach-msm/include/mach/memory.h between commit
66a37c58abc2d7e953e339c64721dc53fb140b38 ("ARM: P2V: separate PHYS_OFFSET
from platform definitions") from the arm tree and commit
a2ad9421ce19f57e99b7a5e8798b8697b916d673 ("msm: Physical offset for
MSM8960") from the msm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-msm/include/mach/memory.h
index 176875d,014bbd3..0000000
--- a/arch/arm/mach-msm/include/mach/memory.h
+++ b/arch/arm/mach-msm/include/mach/memory.h
@@@ -18,15 -18,17 +18,17 @@@
  
  /* physical offset of RAM */
  #if defined(CONFIG_ARCH_QSD8X50) && defined(CONFIG_MSM_SOC_REV_A)
 -#define PHYS_OFFSET		UL(0x00000000)
 +#define PLAT_PHYS_OFFSET		UL(0x00000000)
  #elif defined(CONFIG_ARCH_QSD8X50)
 -#define PHYS_OFFSET		UL(0x20000000)
 +#define PLAT_PHYS_OFFSET		UL(0x20000000)
  #elif defined(CONFIG_ARCH_MSM7X30)
 -#define PHYS_OFFSET		UL(0x00200000)
 +#define PLAT_PHYS_OFFSET		UL(0x00200000)
  #elif defined(CONFIG_ARCH_MSM8X60)
 -#define PHYS_OFFSET		UL(0x40200000)
 +#define PLAT_PHYS_OFFSET		UL(0x40200000)
+ #elif defined(CONFIG_ARCH_MSM8960)
 -#define PHYS_OFFSET		UL(0x40200000)
++#define PLAT_PHYS_OFFSET		UL(0x40200000)
  #else
 -#define PHYS_OFFSET		UL(0x10000000)
 +#define PLAT_PHYS_OFFSET		UL(0x10000000)
  #endif
  
  #endif
