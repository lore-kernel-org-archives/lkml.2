Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1HYFRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:17:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53066 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab1HYFRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:17:52 -0400
Date: Thu, 25 Aug 2011 15:17:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@yxit.co.uk>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the moduleh tree with the arm tree
Message-Id: <20110825151748.8e41e0ded739187a1432cf0b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
arch/arm/mach-bcmring/mm.c between commit 2d5e975b2194 ("ARM:
mach-bcmring: Setup consistent dma size at boot time") from the arm tree
and commit 9bc7d81e271e ("arm: fix implicit use of page.h in
mach-bcmring/mach-jornada") from the moduleh tree.

Jst context changes I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-bcmring/mm.c
index 8616876,293b6d3..0000000
--- a/arch/arm/mach-bcmring/mm.c
+++ b/arch/arm/mach-bcmring/mm.c
@@@ -13,7 -13,7 +13,8 @@@
  *****************************************************************************/
  
  #include <linux/platform_device.h>
 +#include <linux/dma-mapping.h>
+ #include <asm/page.h>
  #include <asm/mach/map.h>
  
  #include <mach/hardware.h>
