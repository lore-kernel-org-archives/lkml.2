Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab0EDBH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 21:07:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34459 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983Ab0EDBH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 21:07:28 -0400
Date: Tue, 4 May 2010 11:07:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Walker <c_dwalke@quicinc.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>
Subject: linux-next: manual merge of the msm tree with the arm tree
Message-Id: <20100504110725.0b44d877.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Today's linux-next merge of the msm tree got a conflict in
arch/arm/mach-msm/Kconfig between commit
4b53eb4f5d78416456bb969ce30e3bed2731d744 ("arm: msm: allow ARCH_MSM to
have v7 cpus") from the arm tree and commit
e17047ea51cc2eac3e920e5a669f99efd44f446f ("arm: msm: smd: use either
package v3 or v4 not both") from the msm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-msm/Kconfig
index b9fd5c5,69cc693..0000000
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@@ -28,15 -45,14 +45,16 @@@ choic
  endchoice
  
  config MACH_HALIBUT
- 	depends on ARCH_MSM
+ 	depends on ARCH_MSM7X00A
 +	select CPU_V6
  	default y
  	bool "Halibut Board (QCT SURF7201A)"
  	help
  	  Support for the Qualcomm SURF7201A eval board.
  
  config MACH_TROUT
+ 	depends on ARCH_MSM7X00A
 +	select CPU_V6
  	default y
  	bool "HTC Dream (aka trout)"
  	help
