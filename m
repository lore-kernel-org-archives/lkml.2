Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1CAP11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:27:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58382 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab1CAP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:27:07 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 8/8] amd64_edac: Fix decode_syndrome types
Date: Tue,  1 Mar 2011 16:26:56 +0100
Message-Id: <1298993216-19434-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Those should all be unsigned.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index cc4f887..0be30e9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1700,15 +1700,15 @@ static u16 x8_vectors[] = {
 	0x0100, 0x0200, 0x0400, 0x0800, 0x1000, 0x2000, 0x4000, 0x8000,
 };
 
-static int decode_syndrome(u16 syndrome, u16 *vectors, int num_vecs,
-			   int v_dim)
+static int decode_syndrome(u16 syndrome, u16 *vectors, unsigned num_vecs,
+			   unsigned v_dim)
 {
 	unsigned int i, err_sym;
 
 	for (err_sym = 0; err_sym < num_vecs / v_dim; err_sym++) {
 		u16 s = syndrome;
-		int v_idx =  err_sym * v_dim;
-		int v_end = (err_sym + 1) * v_dim;
+		unsigned v_idx =  err_sym * v_dim;
+		unsigned v_end = (err_sym + 1) * v_dim;
 
 		/* walk over all 16 bits of the syndrome */
 		for (i = 1; i < (1U << 16); i <<= 1) {
-- 
1.7.4.rc2

