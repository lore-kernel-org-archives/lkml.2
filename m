Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1ABHZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:37095 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1ABHZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 221/260] powerpc/perf: Fix sampling enable for PPC970
Date: Sun,  2 Jan 2011 02:18:37 -0500
Message-Id: <1293952756-15010-222-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:11.0198 (UTC) FILETIME=[0CF895E0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

commit 9f5f9ffe50e90ed73040d2100db8bfc341cee352 upstream.

The logic to distinguish marked instruction events from ordinary events
on PPC970 and derivatives was flawed.  The result is that instruction
sampling didn't get enabled in the PMU for some marked instruction
events, so they would never trigger.  This fixes it by adding the
appropriate break statements in the switch statement.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/ppc970-pmu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 8eff48e..3fee685 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -169,9 +169,11 @@ static int p970_marked_instr_event(u64 event)
 	switch (unit) {
 	case PM_VPU:
 		mask = 0x4c;		/* byte 0 bits 2,3,6 */
+		break;
 	case PM_LSU0:
 		/* byte 2 bits 0,2,3,4,6; all of byte 1 */
 		mask = 0x085dff00;
+		break;
 	case PM_LSU1L:
 		mask = 0x50 << 24;	/* byte 3 bits 4,6 */
 		break;
-- 
1.7.3.3

