Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934339Ab2KZRSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:18:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934289Ab2KZRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 269/270] x86, mm: Undo incorrect revert in arch/x86/mm/init.c
Date: Mon, 26 Nov 2012 14:59:19 -0200
Message-Id: <1353949160-26803-270-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit f82f64dd9f485e13f29f369772d4a0e868e5633a upstream.

Commit

    844ab6f9 x86, mm: Find_early_table_space based on ranges that are actually being mapped

added back some lines back wrongly that has been removed in commit

    7b16bbf97 Revert "x86/mm: Fix the size calculation of mapping tables"

remove them again.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/mm/init.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 5e967a3..4e4dcda 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -65,10 +65,6 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 #ifdef CONFIG_X86_32
 			extra += PMD_SIZE;
 #endif
-			/* The first 2/4M doesn't use large pages. */
-			if (mr[i].start < PMD_SIZE)
-				extra += range;
-
 			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		} else {
 			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
-- 
1.7.9.5

