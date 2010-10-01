Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0JAHGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:37 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45892 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab0JAHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:32 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Michael Neuling <mikey@neuling.org>, Anton Blanchard <anton@samba.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 16/18] powerpc: Fix endianness issues in alignment handler
Date: Fri,  1 Oct 2010 17:06:09 +1000
Message-Id: <1285916771-18033-17-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch reverses the order of the high and low bits in the alignment
handler on little endian, which should be enough to fix any alignment
exceptions.

Please note that this patch is largely untested.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/kernel/align.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index 8184ee9..fc357c6 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -712,12 +712,22 @@ int fix_alignment(struct pt_regs *regs)
 		double dd;
 		unsigned char v[8];
 		struct {
+#ifdef __LITTLE_ENDIAN__
+			int	 low32;
+			unsigned hi32;
+#else
 			unsigned hi32;
 			int	 low32;
+#endif
 		} x32;
 		struct {
+#ifdef __LITTLE_ENDIAN__
+			short	      low16;
+			unsigned char hi48[6];
+#else
 			unsigned char hi48[6];
 			short	      low16;
+#endif
 		} x16;
 	} data;
 
-- 
1.7.1

