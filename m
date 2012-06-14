Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2FNOuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:50:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab2FNOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:50:13 -0400
Date: Thu, 14 Jun 2012 07:50:02 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-5a0a2a308113086cc800a203d903271c9caa1611@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120614075043.GI3383@dhcp-26-207.brq.redhat.com>
References: <20120614075043.GI3383@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic/es7000: Make apicid of a cluster (not CPU)
  from a cpumask
Git-Commit-ID: 5a0a2a308113086cc800a203d903271c9caa1611
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:50:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a0a2a308113086cc800a203d903271c9caa1611
Gitweb:     http://git.kernel.org/tip/5a0a2a308113086cc800a203d903271c9caa1611
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 14 Jun 2012 09:50:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:53:16 +0200

x86/apic/es7000: Make apicid of a cluster (not CPU) from a cpumask

cpu_mask_to_apicid_and() always returns apicid of a single CPU,
even in case multiple CPUs were requested. This update fixes a
typo and forces apicid of a cluster to be returned.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120614075043.GI3383@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/es7000_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 9882093..0874799 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -542,7 +542,7 @@ es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 
 			return -EINVAL;
 		}
-		apicid = new_apicid;
+		apicid |= new_apicid;
 		round++;
 	}
 	if (!round)
