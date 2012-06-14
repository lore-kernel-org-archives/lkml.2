Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2FNHuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab2FNHuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:50:50 -0400
Date: Thu, 14 Jun 2012 09:50:44 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/6] x86/apic/es7000: Make apicid of a cluster (not CPU) from
 a cpumask
Message-ID: <20120614075043.GI3383@dhcp-26-207.brq.redhat.com>
References: <cover.1339657103.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1339657103.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_mask_to_apicid_and() always returns apicid of a single CPU, even in
case multiple CPUs were requested. This update fixes a typo and forces
apicid of a cluster to be returned.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
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
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
