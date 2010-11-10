Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0KJTDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:33 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49277 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab0KJTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:31 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 05/12] EDAC, MCE: No F15h LS MCE decoder
Date: Wed, 10 Nov 2010 20:02:14 +0100
Message-Id: <1289415741-15000-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h BD doesn't generate LS MCEs so warn about it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 7eb2706..44e6cda 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -467,7 +467,7 @@ static void amd_decode_ls_mce(struct mce *m)
 	u16 ec = m->status & 0xffff;
 	u8 xec = (m->status >> 16) & xec_mask;
 
-	if (boot_cpu_data.x86 == 0x14) {
+	if (boot_cpu_data.x86 >= 0x14) {
 		pr_emerg("You shouldn't be seeing an LS MCE on this cpu family,"
 			 " please report on LKML.\n");
 		return;
-- 
1.7.3.1.50.g1e633

