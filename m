Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab1KKNtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:49:11 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:15228
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239Ab1KKNtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:49:09 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
From: Liu Gang <Gang.Liu@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <paul.gortmaker@windriver.com>, <r58472@freescale.com>,
        <B11780@freescale.com>, <r61911@freescale.com>,
        Liu Gang <Gang.Liu@freescale.com>
Subject: [PATCH] fsl-rio: fix compile error
Date: Fri, 11 Nov 2011 21:48:28 +0800
Message-ID: <1321019308-7785-1-git-send-email-Gang.Liu@freescale.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "#include <linux/module.h>" was replaced by "#include <linux/export.h>"
in the patch "powerpc: various straight conversions from module.h --> export.h".
This will cause the following compile problem:
arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
arch/powerpc/sysdev/fsl_rio.c:296: error: implicit declaration of function 'search_exception_tables'.

The file fsl_rio.c needs the declaration of function "search_exception_tables"
in the header file "linux/module.h".

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index de170fd..22ffccd 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -23,7 +23,7 @@
  */
 
 #include <linux/init.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
-- 
1.7.3.1


