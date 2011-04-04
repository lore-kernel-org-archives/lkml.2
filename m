Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1DDRG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:06:29 -0400
Received: from mail.perches.com ([173.55.12.10]:4474 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1DDRG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:06:28 -0400
From: Joe Perches <joe@perches.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] thinkpad_acpi: Correct !CONFIG_THINKPAD_ACPI_VIDEO warning
Date: Mon,  4 Apr 2011 10:06:24 -0700
Message-Id: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <20110404130036.GB16669@srcf.ucam.org>
References: <20110404130036.GB16669@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move TPACPI_HANDLE declaration into #ifdef block
and neaten it a bit.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index a08561f..2eaecd4 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -534,15 +534,6 @@ TPACPI_HANDLE(hkey, ec, "\\_SB.HKEY",	/* 600e/x, 770e, 770x */
 	   "HKEY",		/* all others */
 	   );			/* 570 */
 
-TPACPI_HANDLE(vid, root, "\\_SB.PCI.AGP.VGA",	/* 570 */
-	   "\\_SB.PCI0.AGP0.VID0",	/* 600e/x, 770x */
-	   "\\_SB.PCI0.VID0",	/* 770e */
-	   "\\_SB.PCI0.VID",	/* A21e, G4x, R50e, X30, X40 */
-	   "\\_SB.PCI0.AGP.VGA",	/* X100e and a few others */
-	   "\\_SB.PCI0.AGP.VID",	/* all others */
-	   );				/* R30, R31 */
-
-
 /*************************************************************************
  * ACPI helpers
  */
@@ -4442,6 +4433,15 @@ static int video_orig_autosw;
 static int video_autosw_get(void);
 static int video_autosw_set(int enable);
 
+TPACPI_HANDLE(vid, root,
+	      "\\_SB.PCI.AGP.VGA",	/* 570 */
+	      "\\_SB.PCI0.AGP0.VID0",	/* 600e/x, 770x */
+	      "\\_SB.PCI0.VID0",	/* 770e */
+	      "\\_SB.PCI0.VID",		/* A21e, G4x, R50e, X30, X40 */
+	      "\\_SB.PCI0.AGP.VGA",	/* X100e and a few others */
+	      "\\_SB.PCI0.AGP.VID",	/* all others */
+	);				/* R30, R31 */
+
 TPACPI_HANDLE(vid2, root, "\\_SB.PCI0.AGPB.VID");	/* G41 */
 
 static int __init video_init(struct ibm_init_struct *iibm)
-- 
1.7.4.2.g597a6.dirty

