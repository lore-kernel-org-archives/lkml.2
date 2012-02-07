Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2BGO04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:26:56 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34162 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2BGO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:26:49 -0500
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/6] MCE, AMD: Correct bank 5 error signatures
Date: Tue,  7 Feb 2012 15:26:06 +0100
Message-Id: <1328624767-7956-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1328624767-7956-1-git-send-email-bp@amd64.org>
References: <1328624767-7956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... and remove superfluous ErrorCodeExt check.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/edac/mce_amd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index f6ebe5e..88a9297 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -136,7 +136,7 @@ static const char * const fr_ex_mce_desc[] = {
 	"Physical register file AG0 port",
 	"Physical register file AG1 port",
 	"Flag register file",
-	"DE correctable error could not be corrected"
+	"DE error occurred"
 };
 
 static bool f12h_dc_mce(u16 ec, u8 xec)
@@ -577,9 +577,6 @@ static void amd_decode_fr_mce(struct mce *m)
 	if (c->x86 == 0xf || c->x86 == 0x11)
 		goto wrong_fr_mce;
 
-	if (c->x86 != 0x15 && xec != 0x0)
-		goto wrong_fr_mce;
-
 	pr_emerg(HW_ERR "%s Error: ",
 		 (c->x86 == 0x15 ? "Execution Unit" : "FIROB"));
 
-- 
1.7.8.rc0

