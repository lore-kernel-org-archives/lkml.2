Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0CTR3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:29:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:57381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0CTR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:29:14 -0400
Subject: Re: 2.6.34-rc2: cpu hotplug test failure on x86_64
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <4BA50319.3040301@in.ibm.com>
References: <4BA50319.3040301@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 18:29:09 +0100
Message-ID: <1269106149.9440.517.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 22:47 +0530, Sachin Sant wrote:
> Running cpu hotplug tests on a x86_64 box results in
> the following BUG.
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> IP: [<ffffffff81037388>] amd_pmu_cpu_offline+0x38/0x67

I guess something like the below might work.

---
 arch/x86/kernel/cpu/perf_event_amd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 358a8e3..0189af4 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -345,6 +345,8 @@ static void amd_pmu_cpu_offline(int cpu)
 		return;
 
 	cpuhw = &per_cpu(cpu_hw_events, cpu);
+	if (!cpuhw)
+		return;
 
 	raw_spin_lock(&amd_nb_lock);
 


