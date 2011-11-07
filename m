Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1KGRLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:11:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:57397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1KGRK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:10:58 -0500
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Stephane Eranian <eranian@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Date: Mon, 07 Nov 2011 18:09:49 +0100
In-Reply-To: <20111107165603.GD2332@linux.vnet.ibm.com>
References: <20111027075901.GB2313@linux.vnet.ibm.com>
	 <20111027080016.GA16885@elte.hu> <4EAA14A1.5060204@cn.fujitsu.com>
	 <20111029182710.GG6160@linux.vnet.ibm.com>
	 <4EAE57AF.1060706@cn.fujitsu.com>
	 <20111031093256.GI6160@linux.vnet.ibm.com>
	 <4EAF5B68.8090005@cn.fujitsu.com> <1320678902.18053.63.camel@twins>
	 <CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
	 <1320683756.17809.28.camel@twins>
	 <20111107165603.GD2332@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320685789.17809.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 08:56 -0800, Paul E. McKenney wrote:
> 
> If this really is a false positive, what should be used to get rid of
> the splats? 


Probably something slightly less horrid than the below.. ;-)

---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d1a1bee..8f05201 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -229,7 +229,7 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 static inline struct perf_cgroup *
 perf_cgroup_from_task(struct task_struct *task)
 {
-	return container_of(task_subsys_state(task, perf_subsys_id),
+	return container_of(task_subsys_state_check(task, perf_subsys_id, 1),
 			struct perf_cgroup, css);
 }
 

