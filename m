Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0FANah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:30:37 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45675 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab0FAN3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:29:23 -0400
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <norsk5@yahoo.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <linux-edac@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/6] amd64_edac: Fix DCT base address selector
Date: Tue,  1 Jun 2010 15:29:31 +0200
Message-Id: <1275398971-12439-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275398971-12439-1-git-send-email-bp@amd64.org>
References: <1275398971-12439-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The correct check is to verify whether in high range we're below 4GB
and not to extract the DctSelBaseAddr again. See "2.8.5 Routing DRAM
Requests" in the F10h BKDG.

Cc: <stable@kernel.org> # .32.x .33.x
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 80600f1..6866b98 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1432,7 +1432,7 @@ static inline u64 f10_get_base_addr_offset(u64 sys_addr, int hi_range_sel,
 	u64 chan_off;
 
 	if (hi_range_sel) {
-		if (!(dct_sel_base_addr & 0xFFFFF800) &&
+		if (!(dct_sel_base_addr & 0xFFFF0000) &&
 		   hole_valid && (sys_addr >= 0x100000000ULL))
 			chan_off = hole_off << 16;
 		else
-- 
1.7.1

