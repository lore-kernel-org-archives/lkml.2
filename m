Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2HUBrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:47:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41647 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2HUBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:47:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo "endianess" in printk
Date: Tue, 21 Aug 2012 10:47:27 +0900
Message-Id: <1345513647-21810-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3.4.g91e4bfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo "endianess" in various printk

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/firewire/ohci.c                    | 2 +-
 drivers/remoteproc/remoteproc_elf_loader.c | 4 ++--
 fs/qnx6/inode.c                            | 2 +-
 fs/qnx6/qnx6.h                             | 2 +-
 scripts/basic/fixdep.c                     | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index c788dbd..86d3d10 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -329,7 +329,7 @@ module_param_named(quirks, param_quirks, int, 0644);
 MODULE_PARM_DESC(quirks, "Chip quirks (default = 0"
 	", nonatomic cycle timer = "	__stringify(QUIRK_CYCLE_TIMER)
 	", reset packet generation = "	__stringify(QUIRK_RESET_PACKET)
-	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
+	", AR/selfID endianness = "	__stringify(QUIRK_BE_HEADERS)
 	", no 1394a enhancements = "	__stringify(QUIRK_NO_1394A)
 	", disable MSI = "		__stringify(QUIRK_NO_MSI)
 	", TI SLLZ059 erratum = "	__stringify(QUIRK_TI_SLLZ059)
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index e1f89d6..0d36f94 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -66,13 +66,13 @@ rproc_elf_sanity_check(struct rproc *rproc, const struct firmware *fw)
 		return -EINVAL;
 	}
 
-	/* We assume the firmware has the same endianess as the host */
+	/* We assume the firmware has the same endianness as the host */
 # ifdef __LITTLE_ENDIAN
 	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB) {
 # else /* BIG ENDIAN */
 	if (ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
 # endif
-		dev_err(dev, "Unsupported firmware endianess\n");
+		dev_err(dev, "Unsupported firmware endianness\n");
 		return -EINVAL;
 	}
 
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index 1b37fff..9bdfd71 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -285,7 +285,7 @@ static struct buffer_head *qnx6_check_first_superblock(struct super_block *s,
 		if (fs32_to_cpu(sbi, sb->sb_magic) == QNX6_SUPER_MAGIC) {
 			/* we got a big endian fs */
 			QNX6DEBUG((KERN_INFO "qnx6: fs got different"
-					" endianess.\n"));
+					" endianness.\n"));
 			return bh;
 		} else
 			sbi->s_bytesex = BYTESEX_LE;
diff --git a/fs/qnx6/qnx6.h b/fs/qnx6/qnx6.h
index b00fcc9..81b7224 100644
--- a/fs/qnx6/qnx6.h
+++ b/fs/qnx6/qnx6.h
@@ -31,7 +31,7 @@ struct qnx6_sb_info {
 	int			s_blks_off;	/* blkoffset fs-startpoint */
 	int			s_ptrbits;	/* indirect pointer bitfield */
 	unsigned long		s_mount_opt;	/* all mount options */
-	int			s_bytesex;	/* holds endianess info */
+	int			s_bytesex;	/* holds endianness info */
 	struct inode *		inodes;
 	struct inode *		longfile;
 };
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index cb1f50c..7f6425e 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -409,7 +409,7 @@ static void traps(void)
 	int *p = (int *)test;
 
 	if (*p != INT_CONF) {
-		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianess? %#x\n",
+		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianness? %#x\n",
 			*p);
 		exit(2);
 	}
-- 
1.7.12.rc3.4.g91e4bfe

