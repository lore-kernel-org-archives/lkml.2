Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1ERVBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:01:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:47737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab1ERVBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:01:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,233,1304319600"; 
   d="scan'208";a="4215174"
From: "Rao, Nikhil" <nikhil.rao@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rao, Nikhil" <nikhil.rao@intel.com>
Subject: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Topic: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Index: AQHMFZ6wJPU1hqPFeEm3pwmWQya4qw==
Date: Wed, 18 May 2011 21:01:00 +0000
Message-ID: <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755018E1CF482@orsmsx508.amr.corp.intel.com>
	 <4FF5AC937153B0459463C1A88EB478F2010DFD3D3F@orsmsx505.amr.corp.intel.com>
	 <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
In-Reply-To: <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {8567C132-8FB2-4641-8BD6-CDF1298D6651}
x-cr-hashedpuzzle: DRb3 ETR9 G4Y0 KRTo KZ8M K+tl L4bH TPbz X8go YRbW ZQy0
 ik2u rOUc vj5V ye5H
 zVJ6;5;aABwAGEAQAB6AHkAdABvAHIALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGkAbgBnAG8AQAByAGUAZABoAGEAdAAuAGMAbwBtADsAdABnAGwAeABAAGwAaQBuAHUAdAByAG8AbgBpAHgALgBkAGUAOwB4ADgANgBAAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{8567C132-8FB2-4641-8BD6-CDF1298D6651};bgBpAGsAaABpAGwALgByAGEAbwBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Wed,
 18 May 2011 21:00:41
 GMT;WwBQAEEAVABDAEgAXQAgACAAeAA4ADYAOgAgAFIAZQBtAG8AdgBpAG4AZwAgAHUAbgBuAGUAYwBlAHMAcwBhAHIAeQAgAGMAaABlAGMAawAgAGkAbgAgAGQAZQB0AGUAYwB0AF8AaAB0AA==
x-originating-ip: [10.9.131.214]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4IL1JIe005583

This patch removes a check that prevents correct CPU topology setup
when cpuid extensions for topology enumeration are not supported and
the number of processors reported to the OS is smaller than 
smp_num_siblings

Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
CC: <stable@kernel.org>
---
 arch/x86/kernel/cpu/common.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2ced007..6547084 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -458,13 +458,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
        if (smp_num_siblings <= 1)
                goto out;
 
-       if (smp_num_siblings > nr_cpu_ids) {
-               pr_warning("CPU: Unsupported number of siblings %d",
-                          smp_num_siblings);
-               smp_num_siblings = 1;
-               return;
-       }
-
        index_msb = get_count_order(smp_num_siblings);
        c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
 
-- 
1.7.4.2
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
