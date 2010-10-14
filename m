Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0JNVQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:16:15 -0400
Received: from king.tilera.com ([72.1.168.226]:52855 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab0JNVQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:13 -0400
Message-Id: <a4dbc5ee52e8741522a2f87067b80116c6c7a934.1287090286.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 15:14:29 -0400
Subject: [PATCH 04/14] arch/tile: change lower bound on syscall error return to -4095
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:12.0996 (UTC) FILETIME=[07A27040:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we were using -1023, which is fine for normal syscall
error returns, but the common value in use for other platforms
is -4095, and one Tilera-specific driver does use values in the
-1100 range, so tickled this bug.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index c62c2f4..f87c5c0 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1020,7 +1020,7 @@ STD_ENTRY(interrupt_return)
 
 	/* Set r1 to errno if we are returning an error, otherwise zero. */
 	{
-	 moveli r29, 1024
+	 moveli r29, 4096
 	 sub    r1, zero, r0
 	}
 	slt_u   r29, r1, r29
-- 
1.6.5.2

