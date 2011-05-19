Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab1ESXD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:03:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:45409 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1ESXD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:03:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="439379933"
From: "Rao, Nikhil" <nikhil.rao@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Topic: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Index: AQHMFZ+wwMCJ5f57lUKQ3lDQVr7GwpSTFQXQgAB42ID//97J8IABfUoA///cXEA=
Date: Thu, 19 May 2011 23:03:53 +0000
Message-ID: <1F668163772FA946975B9466A9DFF729BEDD@ORSMSX101.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755018E1CF482@orsmsx508.amr.corp.intel.com>
 <4FF5AC937153B0459463C1A88EB478F2010DFD3D3F@orsmsx505.amr.corp.intel.com>
 <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
 <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
 <20110518210754.GA28476@elte.hu>
 <1F668163772FA946975B9466A9DFF729B6A3@ORSMSX101.amr.corp.intel.com>
 <20110518212351.GE28476@elte.hu>
 <1F668163772FA946975B9466A9DFF729B7E4@ORSMSX101.amr.corp.intel.com>
 <20110519180940.GD6139@elte.hu>
In-Reply-To: <20110519180940.GD6139@elte.hu>
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

This patch removes a check that causes incorrect scheduler domain setup (SMP instead of SMT) and bootlog warning messages when cpuid extensions for topology enumeration are not supported and the number of processors reported to the OS is smaller than smp_num_siblings

Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/cpu/common.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c index cbc70a2..d2bcd54 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -477,13 +477,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
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
> Sent: Thursday, May 19, 2011 11:10 AM
> To: Rao, Nikhil
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org; Siddha, Suresh B; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86: Removing unnecessary check in detect_ht
> 
> * Rao, Nikhil <nikhil.rao@intel.com> wrote:
> 
> > Hi Ingo,
> >
> > Reposting as per your feedback.
> 
> Please send a patch that applies to the x86 tree cleanly:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> Thanks,
> 
> 	Ingo
