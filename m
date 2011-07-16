Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1GPDZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 23:25:28 -0400
Received: from eastrmfepo102.cox.net ([68.230.241.214]:40021 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1GPDZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 23:25:27 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 23:25:27 EDT
X-CT-Class: Clean
X-CT-Score: 0.00
X-CT-RefID: str=0001.0A020208.4E21011B.0002,ss=1,re=0.000,fgs=0
X-CT-Spam: 0
X-Authority-Analysis: v=1.1 cv=mwl0/2xM3ubHJTXa6l4kGPt5l4r2ytuQtfJUKIGJKFg=
 c=1 sm=1 a=SbnaPJgvhvEA:10 a=6ozKSxwDZsYA:10 a=kj9zAlcOel0A:10
 a=P/0Lj++K3U41h/fRNoatIQ==:17 a=9YPF7Q6M6CNIacGhoq4A:9
 a=sQauaP2SSAhirK_V2gAA:7 a=CjuIK1q_8ugA:10 a=P/0Lj++K3U41h/fRNoatIQ==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; none
Date: Fri, 15 Jul 2011 23:05:15 -0400
From: Will Simoneau <simoneau@ele.uri.edu>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sun4m SMP: fix wrong shift instruction in IPI handler
Message-ID: <20110716030515.GA13614@ele.uri.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 [Linux 2.6.38 x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This shift instruction appears to be shifting in the wrong direction.
Without this change, my SparcStation-20MP hangs just after bringing up
the second CPU:

Entering SMP Mode...
Starting CPU 2 at f02b4e90
Brought up 2 CPUs
Total of 2 processors activated (99.52 BogoMIPS).
   *** stuck ***

Signed-off-by: Will Simoneau <simoneau@ele.uri.edu>
---
 arch/sparc/kernel/entry.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/entry.S b/arch/sparc/kernel/entry.S
index 9fe08a1..f445e98 100644
--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -293,7 +293,7 @@ maybe_smp4m_msg:
 	WRITE_PAUSE
 	wr	%l4, PSR_ET, %psr
 	WRITE_PAUSE
-	sll	%o3, 28, %o2		! shift for simpler checks below
+	srl	%o3, 28, %o2		! shift for simpler checks below
 maybe_smp4m_msg_check_single:
 	andcc	%o2, 0x1, %g0
 	beq,a	maybe_smp4m_msg_check_mask
