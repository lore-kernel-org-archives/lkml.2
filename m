Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab2BJAGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:06:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703Ab2BJABi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 16/31] edac/ppc4xx_edac: Fix compilation
Date: Thu,  9 Feb 2012 22:01:15 -0200
Message-Id: <1328832090-9166-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that nobody is cross-compiling for this arch anymore...

drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_probe':
drivers/edac/ppc4xx_edac.c:188:12: error: storage class specified for parameter 'ppc4xx_edac_remove'
...
drivers/edac/ppc4xx_edac.c:1068:19: error: 'match' undeclared (first use in this function)
drivers/edac/ppc4xx_edac.c:1068:19: note: each undeclared identifier is reported only once for each function it appears in
drivers/edac/ppc4xx_edac.c:1068:36: warning: left-hand operand of comma expression has no effect [-Wunused-value]

Acked-by: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ppc4xx_edac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 0f06f14..1adaddf 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -184,7 +184,7 @@ struct ppc4xx_ecc_status {
 
 /* Function Prototypes */
 
-static int ppc4xx_edac_probe(struct platform_device *device)
+static int ppc4xx_edac_probe(struct platform_device *device);
 static int ppc4xx_edac_remove(struct platform_device *device);
 
 /* Global Variables */
@@ -1065,7 +1065,7 @@ ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
 
 	mci->mod_name		= PPC4XX_EDAC_MODULE_NAME;
 	mci->mod_ver		= PPC4XX_EDAC_MODULE_REVISION;
-	mci->ctl_name		= match->compatible,
+	mci->ctl_name		= ppc4xx_edac_match->compatible,
 	mci->dev_name		= np->full_name;
 
 	/* Initialize callbacks */
-- 
1.7.8

