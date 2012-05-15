Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578Ab2EOC1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:27:40 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53554 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898Ab2EOCSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 169/179] x86, UV: Remove UV delay in starting slave cpus
Date: Mon, 14 May 2012 22:14:25 -0400
Message-ID: <1337048075-6132-170-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 05e33fc20ea5e493a2a1e7f1d04f43cdf89f83ed upstream.

Delete the 10 msec delay between the INIT and SIPI when starting
slave cpus. I can find no requirement for this delay. BIOS also
has similar code sequences without the delay.

Removing the delay reduces boot time by 40 sec. Every bit helps.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Link: http://lkml.kernel.org/r/20110805140900.GA6774@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 25a1b3c..2872559 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -144,7 +144,6 @@ static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_ri
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
-	mdelay(10);
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
-- 
1.7.9.6

