Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2EXHwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:52:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2EXHwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:52:30 -0400
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	 <1337844471.9783.48.camel@laptop>
	 <CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 09:52:16 +0200
Message-ID: <1337845936.9783.57.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 09:41 +0200, Stephane Eranian wrote:
> So should we mark that
> > as bad as well?
> >
> I never could but was told it was there too.
> 
> > Also, do you happen to know if/when a u-code update would appear?
> >
> I am hoping Intel will release the ucode update very soon now. I will
> post a patch
> to re-enable PEBS on model 42 when that happens.

OK, so how about I queue the below and if the u-code updates gets
released before this hits Linus' tree we'll make it all go away ;-)

---
Subject: perf,x86: Mark PEBS as broken on SNB-EP as well

As per information from Intel.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..6c8e400 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1840,8 +1840,8 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
-		x86_add_quirk(intel_sandybridge_quirk);
 	case 45: /* SandyBridge, "Romely-EP" */
+		x86_add_quirk(intel_sandybridge_quirk);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 


