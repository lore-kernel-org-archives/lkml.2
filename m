Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab1EPVYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:24:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:37290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1EPVX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:23:57 -0400
Date: Mon, 16 May 2011 21:23:22 GMT
From: tip-bot for Ondrej Zary <linux@rainbow-software.org>
Message-ID: <tip-865be7a81071a77014c83cd01536c989eed362b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux@rainbow-software.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux@rainbow-software.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201105162138.15416.linux@rainbow-software.org>
References: <201105162138.15416.linux@rainbow-software.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Fix detection of Celeron Covington stepping A1 and B0
Git-Commit-ID: 865be7a81071a77014c83cd01536c989eed362b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 21:23:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  865be7a81071a77014c83cd01536c989eed362b4
Gitweb:     http://git.kernel.org/tip/865be7a81071a77014c83cd01536c989eed362b4
Author:     Ondrej Zary <linux@rainbow-software.org>
AuthorDate: Mon, 16 May 2011 21:38:08 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 May 2011 13:24:21 -0700

x86, cpu: Fix detection of Celeron Covington stepping A1 and B0

Steppings A1 and B0 of Celeron Covington are currently misdetected as
Pentium II (Dixon). Fix it by removing the stepping check.

[ hpa: this fixes this specific bug... the CPUID documentation
  specifies that the L2 cache size can disambiguate additional CPUs;
  this patch does not fix that. ]

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Link: http://lkml.kernel.org/r/201105162138.15416.linux@rainbow-software.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index df86bc8..32e86aa 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -400,12 +400,10 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 		switch (c->x86_model) {
 		case 5:
-			if (c->x86_mask == 0) {
-				if (l2 == 0)
-					p = "Celeron (Covington)";
-				else if (l2 == 256)
-					p = "Mobile Pentium II (Dixon)";
-			}
+			if (l2 == 0)
+				p = "Celeron (Covington)";
+			else if (l2 == 256)
+				p = "Mobile Pentium II (Dixon)";
 			break;
 
 		case 6:
