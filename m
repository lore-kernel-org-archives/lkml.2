Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab1KJAKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:10:51 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43561
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933486Ab1KJAJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:09:00 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [RFC PATCH 11/17] powerpc/e500: Use the correct assembler flags for e500mc and e5500
Date: Wed,  9 Nov 2011 19:07:09 -0500
Message-Id: <1320883635-17194-12-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "-me500" assembler option is intended only for use on e500v1 or
e500v2 systems.  On modern binutils it will refuse to assemble standard
floating point opcodes, and it will translate "lwsync" into "sync".

This fixes the e500mc/e5500 kernel build on recent binutils.

For e500mc/e5500 with standard PowerPC floating point, the assembler
options "-me500mc" or "-me500mc64" should be used, although they are not
strictly necessary depending on which opcodes are in use.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index c17bc29..bd443ee2 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -133,7 +133,8 @@ endif
 cpu-as-$(CONFIG_4xx)		+= -Wa,-m405
 cpu-as-$(CONFIG_6xx)		+= -Wa,-maltivec
 cpu-as-$(CONFIG_POWER4)		+= -Wa,-maltivec
-cpu-as-$(CONFIG_E500)		+= -Wa,-me500
+cpu-as-$(CONFIG_FSL_E500_V1_V2)	+= -Wa,-me500
+cpu-as-$(CONFIG_FSL_E500MC)	+= -Wa,-me500mc
 cpu-as-$(CONFIG_FSL_E200)	+= -Wa,-me200
 
 KBUILD_AFLAGS += $(cpu-as-y)
-- 
1.7.2.5

