Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1EYRSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:18:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:11083 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1EYRSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="4724673"
Subject: Re: [PATCH]  x86: Removing unnecessary check in detect_ht
From: Nikhil P Rao <nikhil.rao@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110520114620.GE14745@elte.hu>
References: <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
	 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
	 <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
	 <20110518210754.GA28476@elte.hu>
	 <1F668163772FA946975B9466A9DFF729B6A3@ORSMSX101.amr.corp.intel.com>
	 <20110518212351.GE28476@elte.hu>
	 <1F668163772FA946975B9466A9DFF729B7E4@ORSMSX101.amr.corp.intel.com>
	 <20110519180940.GD6139@elte.hu>
	 <1F668163772FA946975B9466A9DFF729BEDD@ORSMSX101.amr.corp.intel.com>
	 <20110520114620.GE14745@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 10:18:41 -0700
Message-ID: <1306343921.19325.1.camel@fedora13>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.34.73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a check that causes incorrect scheduler domain
setup (SMP instead of SMT) and bootlog warning messages when cpuid
extensions for topology enumeration are not supported and the number
of processors reported to the OS is smaller than smp_num_siblings

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
---
 arch/x86/kernel/cpu/common.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cbc70a2..d2bcd54 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -477,13 +477,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	if (smp_num_siblings <= 1)
 		goto out;
 
-	if (smp_num_siblings > nr_cpu_ids) {
-		pr_warning("CPU: Unsupported number of siblings %d",
-			   smp_num_siblings);
-		smp_num_siblings = 1;
-		return;
-	}
-
 	index_msb = get_count_order(smp_num_siblings);
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
 
-- 
1.7.4.4


On Fri, 2011-05-20 at 13:46 +0200, Ingo Molnar wrote:

> Your patch does not apply because it's whitespace damaged (all tabs got 
> converted to spaces). Please see Documentation/email-clients.txt.
> 
> Thanks,
> 
> 	Ingo


