Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0GHQV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:21:26 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:29833
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753534Ab0GHQVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:21:24 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 12:21:24 EDT
X-SpamScore: -14
X-BigFish: VPS-14(zz936eMzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L58Y0A-02-K8U-02
X-M-MSG: 
Date: Thu, 8 Jul 2010 18:05:14 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Dave Jones <davej@redhat.com>
CC: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] powernow-k8: Fix misleading variable naming
Message-ID: <20100708160514.GB3958@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdmsr() takes the lower 32 bits as a second argument and the high 32 as
a third. Fix the names accordingly since they were swapped.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 3e90cce..2258202 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -910,8 +910,8 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data,
 {
 	int i;
 	u32 hi = 0, lo = 0;
-	rdmsr(MSR_PSTATE_CUR_LIMIT, hi, lo);
-	data->max_hw_pstate = (hi & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
+	rdmsr(MSR_PSTATE_CUR_LIMIT, lo, hi);
+	data->max_hw_pstate = (lo & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
 
 	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
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

