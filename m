Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab0G2P3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:29:06 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40061 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757811Ab0G2P3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:29:03 -0400
Date: Thu, 29 Jul 2010 17:29:02 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/3] Removing conditionalizing containing exactly the same
 code
Message-ID: <62a933db8d615bbc8b277fc7decb76964808795d.1280417117.git.siccegge@cs.fau.de>
References: <cover.1280417117.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280417117.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this because there's no PPC64 in um, however both branches of
this ifdef contain the exactly same code (modulo comment).

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/um/sys-ppc/shared/sysdep/ptrace.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/um/sys-ppc/shared/sysdep/ptrace.h b/arch/um/sys-ppc/shared/sysdep/ptrace.h
index 0e3230e..4ae9be9 100644
--- a/arch/um/sys-ppc/shared/sysdep/ptrace.h
+++ b/arch/um/sys-ppc/shared/sysdep/ptrace.h
@@ -9,11 +9,8 @@
 
 /* the following taken from <asm-ppc/ptrace.h> */
 
-#ifdef CONFIG_PPC64
-#define PPC_REG unsigned long /*long*/
-#else
 #define PPC_REG unsigned long
-#endif
+
 struct sys_pt_regs_s {
 	PPC_REG gpr[32];
 	PPC_REG nip;
-- 
1.7.0.4

