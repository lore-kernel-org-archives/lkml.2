Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1J0OSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:18:41 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:57604 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754313Ab1J0OSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:18:40 -0400
Message-ID: <4EA9683D.8030100@dev.rtsoft.ru>
Date: Thu, 27 Oct 2011 18:18:37 +0400
From: Rusev <arusev@dev.rtsoft.ru>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: benh@kernel.crashing.org, paulus@samba.org, galak@kernel.crashing.org,
        Shengzhou.Liu@freescale.com, Shaohui.Xie@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Fix for fsl_upm
Content-Type: multipart/mixed;
 boundary="------------090608020905030200050608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090608020905030200050608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

patch is vs. 2.6.39, yet it applied to 3.1




--------------090608020905030200050608
Content-Type: text/x-patch;
 name="fsl_lbc.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fsl_lbc.c.patch"

Fix of UPM driver for Freescale PowerPC processors

If Freescale LBC driver fails to initialise itself from device tree,
then internal structure is freed only but not NULL-fied.
As result functions fsl_lbc_find() after checking the structure is not NULL are
trying to access device registers.

Signed-off-by: Alexandre Rusev <arusev@dev.rtsoft.ru> 
--- linux-2.6.39.old/arch/powerpc/sysdev/fsl_lbc.c	2011-10-27 03:17:28.000000000 +0400
+++ linux-2.6.39/arch/powerpc/sysdev/fsl_lbc.c	2011-10-27 05:06:44.000000000 +0400
@@ -322,6 +322,7 @@ static int __devinit fsl_lbc_ctrl_probe(
 err:
 	iounmap(fsl_lbc_ctrl_dev->regs);
 	kfree(fsl_lbc_ctrl_dev);
+	fsl_lbc_ctrl_dev = NULL;
 	return ret;
 }
 

--------------090608020905030200050608--
