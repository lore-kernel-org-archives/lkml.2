Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2JYXbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 19:31:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2JYXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 19:31:40 -0400
Date: Thu, 25 Oct 2012 16:31:18 -0700
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-f82f64dd9f485e13f29f369772d4a0e868e5633a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com>
References: <CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm: Undo incorrect revert in arch/x86/mm/
 init.c
Git-Commit-ID: f82f64dd9f485e13f29f369772d4a0e868e5633a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 16:31:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f82f64dd9f485e13f29f369772d4a0e868e5633a
Gitweb:     http://git.kernel.org/tip/f82f64dd9f485e13f29f369772d4a0e868e5633a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 25 Oct 2012 15:45:26 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 25 Oct 2012 15:45:45 -0700

x86, mm: Undo incorrect revert in arch/x86/mm/init.c

Commit

    844ab6f9 x86, mm: Find_early_table_space based on ranges that are actually being mapped

added back some lines back wrongly that has been removed in commit

    7b16bbf97 Revert "x86/mm: Fix the size calculation of mapping tables"

remove them again.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc287d6..d7aea41 100644
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
