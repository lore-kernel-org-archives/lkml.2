Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3AJPpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:45:05 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54498 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3AJPcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:32 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v3 03/44] Revert some of "binfmt_elf: cleanups"
Date: Thu, 10 Jan 2013 15:30:31 +0000
Message-ID: <1357831872-29451-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "binfmt_elf: cleanups"
(f670d0ecda73b7438eec9ed108680bc5f5362ad8) removed an ifndef elf_map but
this breaks compilation for metag which does define elf_map.

This adds the ifndef back in as it was before, but does not affect the
other cleanups made by that patch.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
---
 fs/binfmt_elf.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 9b67173..269f13a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -340,6 +340,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	return 0;
 }
 
+#ifndef elf_map
+
 static unsigned long elf_map(struct file *filep, unsigned long addr,
 		struct elf_phdr *eppnt, int prot, int type,
 		unsigned long total_size)
@@ -374,6 +376,8 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	return(map_addr);
 }
 
+#endif /* !elf_map */
+
 static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
 {
 	int i, first_idx = -1, last_idx = -1;
-- 
1.7.7.6


