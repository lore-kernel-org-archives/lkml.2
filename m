Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2FNOtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:49:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab2FNOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:49:24 -0400
Date: Thu, 14 Jun 2012 07:49:09 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-214e270b5f5f6a85400a817d5305c797b2b7467a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120614075026.GH3383@dhcp-26-207.brq.redhat.com>
References: <20120614075026.GH3383@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic/es7000+summit:
  Always make valid apicid from a cpumask
Git-Commit-ID: 214e270b5f5f6a85400a817d5305c797b2b7467a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:49:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  214e270b5f5f6a85400a817d5305c797b2b7467a
Gitweb:     http://git.kernel.org/tip/214e270b5f5f6a85400a817d5305c797b2b7467a
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 14 Jun 2012 09:50:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:53:15 +0200

x86/apic/es7000+summit: Always make valid apicid from a cpumask

In case of invalid parameters cpu_mask_to_apicid_and() might
return apicid value of 0 (on Summit) or a uninitialized value
(on ES7000), although it is supposed to return apicid of cpu-0
at least. Fix the operation to always return a valid apicid.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120614075026.GH3383@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/es7000_32.c |    2 ++
 arch/x86/kernel/apic/summit_32.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 0c1347d..9882093 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -545,6 +545,8 @@ es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 		apicid = new_apicid;
 		round++;
 	}
+	if (!round)
+		return -EINVAL;
 	*dest_id = apicid;
 	return 0;
 }
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index e6cc182..b6e6185 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -282,6 +282,8 @@ summit_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 		apicid |= new_apicid;
 		round++;
 	}
+	if (!round)
+		return -EINVAL;
 	*dest_id = apicid;
 	return 0;
 }
