Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1ESCkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:40:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:19073 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab1ESCkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:40:06 -0400
X-ExtLoop1: 1
From: "Rao, Nikhil" <nikhil.rao@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Topic: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Index: AQHMFZ+wwMCJ5f57lUKQ3lDQVr7GwpSTFQXQgAB42ID//97J8A==
Date: Thu, 19 May 2011 02:40:03 +0000
Message-ID: <1F668163772FA946975B9466A9DFF729B7E4@ORSMSX101.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755018E1CF482@orsmsx508.amr.corp.intel.com>
 <4FF5AC937153B0459463C1A88EB478F2010DFD3D3F@orsmsx505.amr.corp.intel.com>
 <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
 <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
 <20110518210754.GA28476@elte.hu>
 <1F668163772FA946975B9466A9DFF729B6A3@ORSMSX101.amr.corp.intel.com>
 <20110518212351.GE28476@elte.hu>
In-Reply-To: <20110518212351.GE28476@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.131.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Reposting as per your feedback.

Thanks,
Nikhil

---
This patch removes a check that causes incorrect scheduler domain
setup (SMP instead of SMT) and bootlog warning messages when cpuid
extensions for topology enumeration are not supported and the number
of processors reported to the OS is smaller than smp_num_siblings

Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
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

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Wednesday, May 18, 2011 2:24 PM
> To: Rao, Nikhil
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org; Siddha, Suresh B; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86: Removing unnecessary check in detect_ht
> 
> 
> * Rao, Nikhil <nikhil.rao@intel.com> wrote:
> 
> > Nothing apart from what you mention - bootlog message and SMP instead
> of SMT.
> 
> Mind putting this information into the changelog and repost the patch?
> It's
> arguably the kind of practical information that most readers of
> changelogs are
> interested in.
> 
> Thanks,
> 
> 	Ingo
