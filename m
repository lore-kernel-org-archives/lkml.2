Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2EVKxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:53:22 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:47511 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab2EVKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:53:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frank Arnold <frank.arnold@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] x86, MCE: Fix 32-bit build
Date: Tue, 22 May 2012 12:53:46 +0200
Message-Id: <1337684026-19740-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1337684026-19740-1-git-send-email-bp@amd64.org>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Got bitten again by the BIT() macro:

arch/x86/kernel/cpu/mcheck/mce.c: In function '__mcheck_cpu_apply_quirks':
arch/x86/kernel/cpu/mcheck/mce.c:1453:6: warning: left shift count >= width of type
arch/x86/kernel/cpu/mcheck/mce.c:1454:7: warning: left shift count >= width of type

Fix it already.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 888fbf9d0adf..0456b9a08086 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1450,9 +1450,9 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 				 rdmsrl(msrs[i], val);
 
 				 /* CntP bit set? */
-				 if (val & BIT(62)) {
-					 val &= ~BIT(62);
-					 wrmsrl(msrs[i], val);
+				 if (val & BIT_64(62)) {
+					val &= ~BIT_64(62);
+					wrmsrl(msrs[i], val);
 				 }
 			 }
 
-- 
1.7.9.3.362.g71319

