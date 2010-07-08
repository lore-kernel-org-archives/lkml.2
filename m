Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab0GHPz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:55:26 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20472 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0GHPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:55:24 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz936eMzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L58XK3-02-JHW-02
X-M-MSG: 
Date: Thu, 8 Jul 2010 17:55:30 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Dave Jones <davej@redhat.com>
CC: Mark Langsdorf <Mark.Langsdorf@amd.com>, Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, <cpufreq@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] powernow-k8: Limit Pstate transition latency check
Message-ID: <20100708155530.GA5301@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Pstate transition latency check was added for broken F10h BIOSen
which wrongly contain a value of 0 for transition and bus master
latency. Fam11h and later, however, (will) have similar transition
latency so extend that behavior for them too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 7ec2123..3e90cce 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1023,13 +1023,12 @@ static int get_transition_latency(struct powernow_k8_data *data)
 	}
 	if (max_latency == 0) {
 		/*
-		 * Fam 11h always returns 0 as transition latency.
-		 * This is intended and means "very fast". While cpufreq core
-		 * and governors currently can handle that gracefully, better
-		 * set it to 1 to avoid problems in the future.
-		 * For all others it's a BIOS bug.
+		 * Fam 11h and later may return 0 as transition latency. This
+		 * is intended and means "very fast". While cpufreq core and
+		 * governors currently can handle that gracefully, better set it
+		 * to 1 to avoid problems in the future.
 		 */
-		if (boot_cpu_data.x86 != 0x11)
+		if (boot_cpu_data.x86 < 0x11)
 			printk(KERN_ERR FW_WARN PFX "Invalid zero transition "
 				"latency\n");
 		max_latency = 1;
-- 
1.7.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

