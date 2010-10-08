Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0JHSgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:36:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54950 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0JHSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:36:41 -0400
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        ralf@linux-mips.org, tony.luck@intel.com
Subject: [PATCH] Define _addr_lsb in siginfo_t for mips v2
Date: Fri,  8 Oct 2010 20:36:15 +0200
Message-Id: <1286562975-27974-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Define an _addr_lsb field in the mips and ia64 siginfo_ts, following
the asm-generic version. This just puts the field over padding.

This fixes a compilation problem introduced with a337fda.

v2: Drop ia64 hunk which is not needed

Cc: ralf@linux-mips.org
Cc: tony.luck@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/mips/include/asm/siginfo.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/siginfo.h b/arch/mips/include/asm/siginfo.h
index 96e28f1..709f7d4 100644
--- a/arch/mips/include/asm/siginfo.h
+++ b/arch/mips/include/asm/siginfo.h
@@ -88,6 +88,7 @@ typedef struct siginfo {
 #ifdef __ARCH_SI_TRAPNO
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
+			short _addr_lsb;	
 		} _sigfault;
 
 		/* SIGPOLL, SIGXFSZ (To do ...)  */
-- 
1.7.1

