Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0I1Rut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:50:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36601 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab0I1Rur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:50:47 -0400
Date: Tue, 28 Sep 2010 18:50:47 +0100
To: ralf@linux-mips.org
Subject: [PATCH 4/5] mips: fix error values in case of bad_stack
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P0eKF-0006jH-5I@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we want EFAULT, not -<syscall number>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mips/kernel/scall32-o32.S |    2 +-
 arch/mips/kernel/scall64-o32.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index d3edb9f..da98051 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -169,7 +169,7 @@ stackargs:
 	 * We probably should handle this case a bit more drastic.
 	 */
 bad_stack:
-	negu	v0				# error
+	li	v0, EFAULT
 	sw	v0, PT_R2(sp)
 	li	t0, 1				# set error flag
 	sw	t0, PT_R7(sp)
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 7ce0a36..d2bc285 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -156,7 +156,7 @@ trace_a_syscall:
 	 * The stackpointer for a call with more than 4 arguments is bad.
 	 */
 bad_stack:
-	dnegu	v0			# error
+	li	v0, EFAULT
 	sd	v0, PT_R2(sp)
 	li	t0, 1			# set error flag
 	sd	t0, PT_R7(sp)
-- 
1.5.6.5


