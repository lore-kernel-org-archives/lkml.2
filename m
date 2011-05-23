Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1EWB6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:58:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43278 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1EWB6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:58:05 -0400
Date: Mon, 23 May 2011 11:58:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20110523115802.be763121.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/Kconfig between commit 5f23188e036a ("ARM: 6900/1: Suspend: Fix
build error on ARCH_S5PC100") from the arm tree and commit a73ddc61e8f1
("ARM: S5P6442: Removing ARCH_S5P6442") from the s5p tree.

I fixed it up (see below) anc can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index af8e274,e81c72c..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -2021,7 -1998,7 +2009,7 @@@ menu "Power management options
  source "kernel/power/Kconfig"
  
  config ARCH_SUSPEND_POSSIBLE
- 	depends on !ARCH_S5P64X0 && !ARCH_S5P6442 && !ARCH_S5PC100
 -	depends on !ARCH_S5P64X0
++	depends on !ARCH_S5P64X0 && !ARCH_S5PC100
  	depends on CPU_ARM920T || CPU_ARM926T || CPU_SA1100 || \
  		CPU_V6 || CPU_V6K || CPU_V7 || CPU_XSC3 || CPU_XSCALE
  	def_bool y
