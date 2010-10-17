Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0JQOvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:51:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34172 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0JQOvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OJuGruAvFgpPookEplPn3iU5CAOXUakyLiAAjjgXrVrmrt1jcnupP24ukOJiODkaww
         x8sd6j8fMAjOBemwxY1ohfujI4i/YxE73zDPgygM3fX24/UXU+ecJ8GfJ5RmfCugVr66
         Gc7PxMvi27Jy1vGjluUB+Vd4QwViIQ2CyhYPA=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Vivek Mahajan <vivek.mahajan@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Harninder Rai <harninder.rai@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] powerpc: sysdev: fix signedness bug
Date: Sun, 17 Oct 2010 18:51:41 +0400
Message-Id: <1287327102-9068-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sram_params.sram_size and sram_params.sram_offset were unsigned.
If get_cache_sram_size() or get_cache_sram_offset() returns error code
then it is not seen to the caller.  Made sram_size and sram_offset signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c b/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
index cc8d655..23b85ac 100644
--- a/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
+++ b/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
@@ -94,14 +94,14 @@ static int __devinit mpc85xx_l2ctlr_of_probe(struct platform_device *dev,
 	l2cache_size = *prop;
 
 	sram_params.sram_size  = get_cache_sram_size();
-	if (sram_params.sram_size <= 0) {
+	if ((int)sram_params.sram_size <= 0) {
 		dev_err(&dev->dev,
 			"Entire L2 as cache, Aborting Cache-SRAM stuff\n");
 		return -EINVAL;
 	}
 
 	sram_params.sram_offset  = get_cache_sram_offset();
-	if (sram_params.sram_offset <= 0) {
+	if ((int64_t)sram_params.sram_offset <= 0) {
 		dev_err(&dev->dev,
 			"Entire L2 as cache, provide a valid sram offset\n");
 		return -EINVAL;
-- 
1.7.0.4

