Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab2J2VmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:42:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:48919 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933141Ab2J2Vl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 49/54] x86, mm: Undo incorrect revert in arch/x86/mm/init.c
Date: Mon, 29 Oct 2012 14:40:50 -0700
Message-Id: <20121029213808.235026558@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/init.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -65,10 +65,6 @@ static void __init find_early_table_spac
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


