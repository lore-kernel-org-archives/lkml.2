Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2LEQJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:35 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55549 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab2LEQJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:22 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2 05/44] Revert some of "binfmt_elf: cleanups"
Date: Wed, 5 Dec 2012 16:08:23 +0000
Message-ID: <1354723742-6195-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "binfmt_elf: cleanups"
(f670d0ecda73b7438eec9ed108680bc5f5362ad8) removed an ifndef elf_map but
this breaks compilation for metag which does define elf_map.

This adds the ifndef back in as it was before, but does not affect the
other cleanups made by that patch.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/binfmt_elf.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fbd9f60..34493b5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -321,6 +321,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	return 0;
 }
 
+#ifndef elf_map
+
 static unsigned long elf_map(struct file *filep, unsigned long addr,
 		struct elf_phdr *eppnt, int prot, int type,
 		unsigned long total_size)
@@ -355,6 +357,8 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	return(map_addr);
 }
 
+#endif /* !elf_map */
+
 static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
 {
 	int i, first_idx = -1, last_idx = -1;
-- 
1.7.7.6


