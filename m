Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2BGO0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:26:54 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34160 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2BGO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:26:49 -0500
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/6] MCE, AMD: Correct ucode patch buffer description
Date: Tue,  7 Feb 2012 15:26:03 +0100
Message-Id: <1328624767-7956-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1328624767-7956-1-git-send-email-bp@amd64.org>
References: <1328624767-7956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This MC1 error signature is called differently now, fix it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/edac/mce_amd.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 0ee1c0a..5626e17 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -88,7 +88,7 @@ static const char * const f15h_ic_mce_desc[] = {
 	"Parity error for IC probe tag valid bit",
 	"PFB non-cacheable bit parity error",
 	"PFB valid bit parity error",			/* xec = 0xd */
-	"patch RAM",					/* xec = 010 */
+	"Microcode Patch Buffer",			/* xec = 010 */
 	"uop queue",
 	"insn buffer",
 	"predecode buffer",
@@ -354,7 +354,11 @@ static bool f15h_ic_mce(u16 ec, u8 xec)
 		pr_cont("%s.\n", f15h_ic_mce_desc[xec-2]);
 		break;
 
-	case 0x10 ... 0x14:
+	case 0x10:
+		pr_cont("%s.\n", f15h_ic_mce_desc[xec-4]);
+		break;
+
+	case 0x11 ... 0x14:
 		pr_cont("Decoder %s parity error.\n", f15h_ic_mce_desc[xec-4]);
 		break;
 
-- 
1.7.8.rc0

