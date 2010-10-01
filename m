Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0JADxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 23:53:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50630 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0JADxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 23:53:08 -0400
Date: Fri, 1 Oct 2010 13:53:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the oprofile tree with the tip tree
Message-Id: <20101001135301.5307c860.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Today's linux-next merge of the oprofile tree got a conflict in
arch/arm/oprofile/common.c between commit
98d943b02f6f1b57787ff1aa6f34d019a407e3ee ("oprofile, ARM: Release
resources on failure") from the tip tree and commit
c7fd239a647ead1c336a051012d6bb96465ea8c6 ("ARM: oprofile: fix and
simplify init/exit functions") from the oprofile tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/oprofile/common.c
index d1fb5b2,d660cb8..0000000
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@@ -395,6 -393,13 +394,14 @@@ int __init oprofile_arch_init(struct op
  	else
  		pr_info("oprofile: using %s\n", ops->cpu_type);
  
+ out:
+ 	if (ret) {
+ 		for_each_possible_cpu(cpu)
+ 			kfree(perf_events[cpu]);
+ 		kfree(counter_config);
++		counter_config = NULL;
+ 	}
+ 
  	return ret;
  }
  
