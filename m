Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2FNHuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:50:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab2FNHuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:50:32 -0400
Date: Thu, 14 Jun 2012 09:50:27 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/6] x86/apic/es7000+summit: Always make valid apicid from a
 cpumask
Message-ID: <20120614075026.GH3383@dhcp-26-207.brq.redhat.com>
References: <cover.1339657103.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1339657103.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of invalid parameters cpu_mask_to_apicid_and() might return
apicid value of 0 (on Summit) or a uninitialized value (on ES7000),
although it is supposed to return apicid of cpu-0 at least. Fix the
operation to always return a valid apicid.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
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
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
