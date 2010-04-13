Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0DMGNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:13:11 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:59654 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0DMGNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EvG1+y8cPZ++OcFPrmr+fyLY0a598ehwLO2jj84BSiP6iLOl+DV2wrvIYYmkOec+WL
         D46uYeksjF9DsH+A63J477+Wc08KQDGQzMOs6gIjqs1SnbDQhZn1dlQM48D+W88yzrrT
         P8yHl5pt8taPhOdKRl79WQZcSmK20Vvb3nCUw=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de
Cc: shane.warden@onyxneon.com, randy.dunlap@oracle.com,
       mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: fix macros do - while loop and spaces before tabs issues in comedidev.h
Date: Tue, 13 Apr 2010 01:13:01 -0500
Message-Id: <1271139181-10146-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the comedidev.h file that fixes up two macros do - while
loop and a space before tabs warnings found by the checkpatch.pl tool.

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/comedidev.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index ebdccfd..1b0d84b 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -57,14 +57,15 @@
 	static int __init x ## _init_module(void)			\
 		{return comedi_driver_register(&(x)); }			\
 	static void __exit x ## _cleanup_module(void)			\
-		{comedi_driver_unregister(&(x)); } 			\
+		{comedi_driver_unregister(&(x)); }			\
 	module_init(x ## _init_module);					\
 	module_exit(x ## _cleanup_module);
 
-#define COMEDI_MODULE_MACROS						\
-	MODULE_AUTHOR("Comedi http://www.comedi.org");		\
+#define COMEDI_MODULE_MACROS	do {		                        \
+	MODULE_AUTHOR("Comedi http://www.comedi.org");		        \
 	MODULE_DESCRIPTION("Comedi low-level driver");			\
-	MODULE_LICENSE("GPL");
+	MODULE_LICENSE("GPL");                                          \
+} while (0)
 
 #define COMEDI_INITCLEANUP(x)						\
 	COMEDI_MODULE_MACROS		\
@@ -402,7 +403,7 @@ int insn_inval(struct comedi_device *dev, struct comedi_subdevice *s,
 #define RANGE(a, b)		{(a)*1e6, (b)*1e6, 0}
 #define RANGE_ext(a, b)		{(a)*1e6, (b)*1e6, RF_EXTERNAL}
 #define RANGE_mA(a, b)		{(a)*1e6, (b)*1e6, UNIT_mA}
-#define RANGE_unitless(a, b)	{(a)*1e6, (b)*1e6, 0}	/* XXX */
+#define RANGE_unitless(a, b)	do {(a)*1e6, (b)*1e6, 0} while (0) /* XXX */
 #define BIP_RANGE(a)		{-(a)*1e6, (a)*1e6, 0}
 #define UNI_RANGE(a)		{0, (a)*1e6, 0}
 
-- 
1.5.4.3

