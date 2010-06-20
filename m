Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0FTIC4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 04:02:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65043 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab0FTICw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 04:02:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E8UsNlu+22RblWxgbh4wNs9C5o0yOJV01XcuP5FAtPH8PmBvIDtFtxsNmsg3MzxOR/
         VCEHkelXR4xA0q7Wsb0ZUqfAyObfjXHxQ5QsrcrgwtW0grSXARMpmhRg0Nw5UzQz3dMh
         fAtUzkX+3eAJLhz6sHyIdUdAxx8PwQNSnKuDo=
From: Neal Buckendahl <nealb001@gmail.com>
To: nealb001@gmail.com, dwmw2@infradead.org, Artem.Bityutskiy@nokia.com,
       rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
       mohanlaljangir@gmail.com, maximlevitsky@gmail.com, julia@diku.dk,
       jkosina@suse.cz
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Neal Buckendahl <nealb@tbcnet.com>
Subject: [PATCH] Mtd: fixed coding style issues in afs.c ar7part.c cmdlinepart.c inftlcore.c This is a patch to the files afs.c ar7part.c cmdlinepart.c inftlcore.c that fixes up warnings found by the checkpatch.pl tool Signed-off-by: Neal Buckendahl <nealb001@gmail.com>
Date: Sun, 20 Jun 2010 03:01:54 -0500
Message-Id: <1277020914-10984-1-git-send-email-nealb001@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neal Buckendahl <nealb@tbcnet.com>

---
 drivers/mtd/afs.c         |    9 ++-
 drivers/mtd/ar7part.c     |    2 +-
 drivers/mtd/cmdlinepart.c |  167 ++++++++++++++++++++-------------------------
 drivers/mtd/inftlcore.c   |   47 ++++++++-----
 4 files changed, 109 insertions(+), 116 deletions(-)

diff --git a/drivers/mtd/afs.c b/drivers/mtd/afs.c
index cec7ab9..d127171 100644
--- a/drivers/mtd/afs.c
+++ b/drivers/mtd/afs.c
@@ -162,8 +162,8 @@ afs_read_iis(struct mtd_info *mtd, struct image_info_struct *iis, u_int ptr)
 }
 
 static int parse_afs_partitions(struct mtd_info *mtd,
-                         struct mtd_partition **pparts,
-                         unsigned long origin)
+			struct mtd_partition **pparts,
+			unsigned long origin)
 {
 	struct mtd_partition *parts;
 	u_int mask, off, idx, sz;
@@ -235,11 +235,12 @@ static int parse_afs_partitions(struct mtd_info *mtd,
 		strcpy(str, iis.name);
 
 		parts[idx].name		= str;
-		parts[idx].size		= (iis.length + mtd->erasesize - 1) & ~(mtd->erasesize - 1);
+		parts[idx].size		= (iis.length + mtd->erasesize - 1)&
+						~(mtd->erasesize - 1);
 		parts[idx].offset	= img_ptr;
 		parts[idx].mask_flags	= 0;
 
-		printk("  mtd%d: at 0x%08x, %5lluKiB, %8u, %s\n",
+		printk(KERN_INFO "  mtd%d: at 0x%08x, %5lluKiB, %8u, %s\n",
 			idx, img_ptr, parts[idx].size / 1024,
 			iis.imageNumber, str);
 
diff --git a/drivers/mtd/ar7part.c b/drivers/mtd/ar7part.c
index 6697a1e..7ccfdca 100644
--- a/drivers/mtd/ar7part.c
+++ b/drivers/mtd/ar7part.c
@@ -148,6 +148,6 @@ static int __init ar7_parser_init(void)
 module_init(ar7_parser_init);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR(	"Felix Fietkau <nbd@openwrt.org>, "
+MODULE_AUTHOR("Felix Fietkau <nbd@openwrt.org>, "
 		"Eugene Konev <ejka@openwrt.org>");
 MODULE_DESCRIPTION("MTD partitioning for TI AR7");
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 1479da6..ef5ea7e 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -34,7 +34,8 @@
 
 /* debug macro */
 #if 0
-#define dbg(x) do { printk("DEBUG-CMDLINE-PART: "); printk x; } while(0)
+#define dbg(x) do { printk(KERN_DEBUG "DEBUG-CMDLINE-PART: "); printk x;
+		} while (0)
 #else
 #define dbg(x)
 #endif
@@ -56,7 +57,7 @@ static struct cmdline_mtd_partition *partitions;
 
 /* the command line passed to mtdpart_setupd() */
 static char *cmdline;
-static int cmdline_parsed = 0;
+static int cmdline_parsed = 1;
 
 /*
  * Parse one partition definition for an MTD. Since there can be many
@@ -66,12 +67,12 @@ static int cmdline_parsed = 0;
  * is allocated upon the last definition being found. At that point the
  * syntax has been verified ok.
  */
-static struct mtd_partition * newpart(char *s,
-                                      char **retptr,
-                                      int *num_parts,
-                                      int this_part,
-                                      unsigned char **extra_mem_ptr,
-                                      int extra_mem_size)
+static struct mtd_partition *newpart(char *s,
+					char **retptr,
+					int *num_parts,
+					int this_part,
+					unsigned char **extra_mem_ptr,
+					int extra_mem_size)
 {
 	struct mtd_partition *parts;
 	unsigned long size;
@@ -83,17 +84,15 @@ static struct mtd_partition * newpart(char *s,
 	unsigned int mask_flags;
 
 	/* fetch the partition size */
-	if (*s == '-')
-	{	/* assign all remaining space to this partition */
+	if (*s == '-') {
+		/* assign all remaining space to this partition */
 		size = SIZE_REMAINING;
 		s++;
-	}
-	else
-	{
+	} else {
 		size = memparse(s, &s);
-		if (size < PAGE_SIZE)
-		{
-			printk(KERN_ERR ERRP "partition size too small (%lx)\n", size);
+		if (size < PAGE_SIZE) {
+			printk(KERN_ERR ERRP "partition size too small (%lx)\n"
+			, size);
 			return NULL;
 		}
 	}
@@ -101,61 +100,51 @@ static struct mtd_partition * newpart(char *s,
 	/* fetch partition name and flags */
 	mask_flags = 0; /* this is going to be a regular partition */
 	delim = 0;
-        /* check for offset */
-        if (*s == '@')
-	{
-                s++;
-                offset = memparse(s, &s);
-        }
-        /* now look for name */
+	/* check for offset */
+	if (*s == '@') {
+		s++;
+		offset = memparse(s, &s);
+	}
+	/* now look for name */
 	if (*s == '(')
-	{
 		delim = ')';
-	}
 
-	if (delim)
-	{
+	if (delim) {
 		char *p;
-
-	    	name = ++s;
+		name = ++s;
 		p = strchr(name, delim);
-		if (!p)
-		{
-			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
+		if (!p) {
+			printk(KERN_ERR ERRP
+			"no closing %c found in partition name\n", delim);
 			return NULL;
 		}
 		name_len = p - name;
 		s = p + 1;
-	}
-	else
-	{
-	    	name = NULL;
+	} else {
+		name = NULL;
 		name_len = 13; /* Partition_000 */
 	}
 
 	/* record name length for memory allocation later */
 	extra_mem_size += name_len + 1;
 
-        /* test for options */
-        if (strncmp(s, "ro", 2) == 0)
-	{
+	/* test for options */
+	if (strncmp(s, "ro", 2) == 0) {
 		mask_flags |= MTD_WRITEABLE;
 		s += 2;
-        }
+	}
 
-        /* if lk is found do NOT unlock the MTD partition*/
-        if (strncmp(s, "lk", 2) == 0)
-	{
+	/* if lk is found do NOT unlock the MTD partition*/
+	if (strncmp(s, "lk", 2) == 0) {
 		mask_flags |= MTD_POWERUP_LOCK;
 		s += 2;
-        }
+	}
 
 	/* test if more partitions are following */
-	if (*s == ',')
-	{
-		if (size == SIZE_REMAINING)
-		{
-			printk(KERN_ERR ERRP "no partitions allowed after a fill-up partition\n");
+	if (*s == ',') {
+		if (size == SIZE_REMAINING) {
+			printk(KERN_ERR ERRP
+			"no partitions allowed after a fill-up partition\n");
 			return NULL;
 		}
 		/* more partitions follow, parse them */
@@ -163,34 +152,29 @@ static struct mtd_partition * newpart(char *s,
 				&extra_mem, extra_mem_size);
 		if (!parts)
 			return NULL;
-	}
-	else
-	{	/* this is the last partition: allocate space for all */
+	} else {
+		/* this is the last partition: allocate space for all */
 		int alloc_size;
 
 		*num_parts = this_part + 1;
 		alloc_size = *num_parts * sizeof(struct mtd_partition) +
 			     extra_mem_size;
 		parts = kzalloc(alloc_size, GFP_KERNEL);
-		if (!parts)
-		{
+		if (!parts) {
 			printk(KERN_ERR ERRP "out of memory\n");
 			return NULL;
 		}
 		extra_mem = (unsigned char *)(parts + *num_parts);
 	}
-	/* enter this partition (offset will be calculated later if it is zero at this point) */
+	/* enter this partition (offset will be calculated later if it is zero
+	   at this point) */
 	parts[this_part].size = size;
 	parts[this_part].offset = offset;
 	parts[this_part].mask_flags = mask_flags;
 	if (name)
-	{
 		strlcpy(extra_mem, name, name_len + 1);
-	}
 	else
-	{
 		sprintf(extra_mem, "Partition_%03d", this_part);
-	}
 	parts[this_part].name = extra_mem;
 	extra_mem += name_len + 1;
 
@@ -203,7 +187,7 @@ static struct mtd_partition * newpart(char *s,
 
 	/* return (updated) pointer to extra_mem memory */
 	if (extra_mem_ptr)
-	  *extra_mem_ptr = extra_mem;
+		*extra_mem_ptr = extra_mem;
 
 	/* return (updated) pointer command line string */
 	*retptr = s;
@@ -217,20 +201,19 @@ static struct mtd_partition * newpart(char *s,
  */
 static int mtdpart_setup_real(char *s)
 {
-	cmdline_parsed = 1;
+	cmdline_parsed = 0;
 
-	for( ; s != NULL; )
-	{
+	for ( ; s != NULL; ) {
 		struct cmdline_mtd_partition *this_mtd;
 		struct mtd_partition *parts;
-	    	int mtd_id_len;
+		int mtd_id_len;
 		int num_parts;
 		char *p, *mtd_id;
 
-	    	mtd_id = s;
+		mtd_id = s;
 		/* fetch <mtd-id> */
-		if (!(p = strchr(s, ':')))
-		{
+		p = strchr(s, ':');
+		if (!p) {
 			printk(KERN_ERR ERRP "no mtd-id\n");
 			return 0;
 		}
@@ -246,11 +229,11 @@ static int mtdpart_setup_real(char *s)
 				&s,		/* out: updated cmdline ptr */
 				&num_parts,	/* out: number of parts */
 				0,		/* first partition */
-				(unsigned char**)&this_mtd, /* out: extra mem */
+				(unsigned char **)&this_mtd,/*out: extra mem */
 				mtd_id_len + 1 + sizeof(*this_mtd) +
-				sizeof(void*)-1 /*alignment*/);
-		if(!parts)
-		{
+				sizeof(void *)-1 /*alignment*/);
+		if (!parts) {
+
 			/*
 			 * An error occurred. We're either:
 			 * a) out of memory, or
@@ -259,15 +242,15 @@ static int mtdpart_setup_real(char *s)
 			 * unlikely to succeed in parsing any more
 			 */
 			 return 0;
-		 }
+		}
 
 		/* align this_mtd */
 		this_mtd = (struct cmdline_mtd_partition *)
-			ALIGN((unsigned long)this_mtd, sizeof(void*));
+		ALIGN((unsigned long)this_mtd, sizeof(void *));
 		/* enter results */
 		this_mtd->parts = parts;
 		this_mtd->num_parts = num_parts;
-		this_mtd->mtd_id = (char*)(this_mtd + 1);
+		this_mtd->mtd_id = (char *)(this_mtd + 1);
 		strlcpy(this_mtd->mtd_id, mtd_id, mtd_id_len + 1);
 
 		/* link into chain */
@@ -283,9 +266,9 @@ static int mtdpart_setup_real(char *s)
 			break;
 
 		/* does another spec follow? */
-		if (*s != ';')
-		{
-			printk(KERN_ERR ERRP "bad character after partition (%c)\n", *s);
+		if (*s != ';') {
+			printk(KERN_ERR ERRP
+			"bad character after partition (%c)\n", *s);
 			return 0;
 		}
 		s++;
@@ -301,8 +284,8 @@ static int mtdpart_setup_real(char *s)
  * the first one in the chain if a NULL mtd_id is passed in.
  */
 static int parse_cmdline_partitions(struct mtd_info *master,
-                             struct mtd_partition **pparts,
-                             unsigned long origin)
+				struct mtd_partition **pparts,
+				unsigned long origin)
 {
 	unsigned long offset;
 	int i;
@@ -310,27 +293,27 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 	const char *mtd_id = master->name;
 
 	/* parse command line */
-	if (!cmdline_parsed)
+	if (cmdline_parsed)
 		mtdpart_setup_real(cmdline);
 
-	for(part = partitions; part; part = part->next)
-	{
-		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
-		{
-			for(i = 0, offset = 0; i < part->num_parts; i++)
-			{
+	for (part = partitions; part; part = part->next) {
+		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id))) {
+			for (i = 0, offset = 0; i < part->num_parts; i++) {
 				if (part->parts[i].offset == OFFSET_CONTINUOUS)
-				  part->parts[i].offset = offset;
+					part->parts[i].offset = offset;
 				else
 				  offset = part->parts[i].offset;
 				if (part->parts[i].size == SIZE_REMAINING)
-				  part->parts[i].size = master->size - offset;
-				if (offset + part->parts[i].size > master->size)
-				{
+					part->parts[i].size = master->size -
+					offset;
+				if (offset + part->parts[i].size
+				  > master->size) {
 					printk(KERN_WARNING ERRP
-					       "%s: partitioning exceeds flash size, truncating\n",
+					       "%s: partitioning exceeds \
+					       flash size, truncating\n",
 					       part->mtd_id);
-					part->parts[i].size = master->size - offset;
+					part->parts[i].size = master->size -
+					offset;
 					part->num_parts = i;
 				}
 				offset += part->parts[i].size;
diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
index 015a7fe..1634694 100644
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -34,9 +34,9 @@
 #include <linux/mtd/nftl.h>
 #include <linux/mtd/inftl.h>
 #include <linux/mtd/nand.h>
-#include <asm/uaccess.h>
-#include <asm/errno.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+#include <linux/io.h>
 
 /*
  * Maximum number of loops while examining next block, to have a
@@ -103,7 +103,8 @@ static void inftl_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 		}
 	}
 
-	if (inftl->mbd.size != inftl->heads * inftl->cylinders * inftl->sectors) {
+	if (inftl->mbd.size != inftl->heads * inftl->cylinders *
+	    inftl->sectors) {
 		/*
 		  Oh no we don't have
 		   mbd.size == heads * cylinders * sectors
@@ -114,7 +115,7 @@ static void inftl_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 			"(== 0x%lx sects)\n",
 			inftl->cylinders, inftl->heads , inftl->sectors,
 			(long)inftl->cylinders * (long)inftl->heads *
-			(long)inftl->sectors );
+			(long)inftl->sectors);
 	}
 
 	if (add_mtd_blktrans_dev(&inftl->mbd)) {
@@ -248,7 +249,8 @@ static u16 INFTL_findfreeblock(struct INFTLrecord *inftl, int desperate)
 	return BLOCK_NIL;
 }
 
-static u16 INFTL_foldchain(struct INFTLrecord *inftl, unsigned thisVUC, unsigned pendingblock)
+static u16 INFTL_foldchain(struct INFTLrecord *inftl, unsigned thisVUC,
+			   unsigned pendingblock)
 {
 	u16 BlockMap[MAX_SECTORS_PER_UNIT];
 	unsigned char BlockDeleted[MAX_SECTORS_PER_UNIT];
@@ -279,7 +281,7 @@ static u16 INFTL_foldchain(struct INFTLrecord *inftl, unsigned thisVUC, unsigned
 	 */
 	silly = MAX_LOOPS;
 	while (thisEUN < inftl->nb_blocks) {
-		for (block = 0; block < inftl->EraseSize/SECTORSIZE; block ++) {
+		for (block = 0; block < inftl->EraseSize/SECTORSIZE; block++) {
 			if ((BlockMap[block] != BLOCK_NIL) ||
 			    BlockDeleted[block])
 				continue;
@@ -291,7 +293,7 @@ static u16 INFTL_foldchain(struct INFTLrecord *inftl, unsigned thisVUC, unsigned
 			else
 				status = oob.b.Status | oob.b.Status1;
 
-			switch(status) {
+			switch (status) {
 			case SECTOR_FREE:
 			case SECTOR_IGNORE:
 				break;
@@ -341,7 +343,7 @@ static u16 INFTL_foldchain(struct INFTLrecord *inftl, unsigned thisVUC, unsigned
 
 		/*
 		 * Copy only in non free block (free blocks can only
-                 * happen in case of media errors or deleted blocks).
+		 * happen in case of media errors or deleted blocks).
 		 */
 		if (BlockMap[block] == BLOCK_NIL)
 			continue;
@@ -476,7 +478,7 @@ static inline u16 INFTL_findwriteunit(struct INFTLrecord *inftl, unsigned block)
 {
 	unsigned int thisVUC = block / (inftl->EraseSize / SECTORSIZE);
 	unsigned int thisEUN, writeEUN, prev_block, status;
-	unsigned long blockofs = (block * SECTORSIZE) & (inftl->EraseSize -1);
+	unsigned long blockofs = (block * SECTORSIZE) & (inftl->EraseSize - 1);
 	struct mtd_info *mtd = inftl->mbd.mtd;
 	struct inftl_oob oob;
 	struct inftl_bci bci;
@@ -504,7 +506,7 @@ static inline u16 INFTL_findwriteunit(struct INFTLrecord *inftl, unsigned block)
 			DEBUG(MTD_DEBUG_LEVEL3, "INFTL: status of block %d in "
 				"EUN %d is %x\n", block , writeEUN, status);
 
-			switch(status) {
+			switch (status) {
 			case SECTOR_FREE:
 				writeEUN = thisEUN;
 				break;
@@ -677,7 +679,7 @@ static void INFTL_trydeletechain(struct INFTLrecord *inftl, unsigned thisVUC)
 			else
 				status = bci.Status | bci.Status1;
 
-			switch(status) {
+			switch (status) {
 			case SECTOR_FREE:
 			case SECTOR_IGNORE:
 				break;
@@ -719,7 +721,8 @@ static void INFTL_trydeletechain(struct INFTLrecord *inftl, unsigned thisVUC)
 
 		/* If the chain is all gone already, we're done */
 		if (thisEUN == BLOCK_NIL) {
-			DEBUG(MTD_DEBUG_LEVEL2, "INFTL: Empty VUC %d for deletion was already absent\n", thisEUN);
+			DEBUG(MTD_DEBUG_LEVEL2, "INFTL: Empty VUC %d \
+			for deletion was already absent\n", thisEUN);
 			return;
 		}
 
@@ -759,7 +762,8 @@ static void INFTL_trydeletechain(struct INFTLrecord *inftl, unsigned thisVUC)
 
 static int INFTL_deleteblock(struct INFTLrecord *inftl, unsigned block)
 {
-	unsigned int thisEUN = inftl->VUtable[block / (inftl->EraseSize / SECTORSIZE)];
+	unsigned int thisEUN = inftl->VUtable[block / (inftl->EraseSize /
+				SECTORSIZE)];
 	unsigned long blockofs = (block * SECTORSIZE) & (inftl->EraseSize - 1);
 	struct mtd_info *mtd = inftl->mbd.mtd;
 	unsigned int status;
@@ -811,7 +815,8 @@ foundit:
 		bci.Status = bci.Status1 = SECTOR_DELETED;
 		if (inftl_write_oob(mtd, ptr, 8, &retlen, (char *)&bci) < 0)
 			return -EIO;
-		INFTL_trydeletechain(inftl, block / (inftl->EraseSize / SECTORSIZE));
+		INFTL_trydeletechain(inftl, block / (inftl->EraseSize /
+		SECTORSIZE));
 	}
 	return 0;
 }
@@ -868,7 +873,8 @@ static int inftl_readblock(struct mtd_blktrans_dev *mbd, unsigned long block,
 			   char *buffer)
 {
 	struct INFTLrecord *inftl = (void *)mbd;
-	unsigned int thisEUN = inftl->VUtable[block / (inftl->EraseSize / SECTORSIZE)];
+	unsigned int thisEUN = inftl->VUtable[block / (inftl->EraseSize /
+				SECTORSIZE)];
 	unsigned long blockofs = (block * SECTORSIZE) & (inftl->EraseSize - 1);
 	struct mtd_info *mtd = inftl->mbd.mtd;
 	unsigned int status;
@@ -943,7 +949,7 @@ static struct mtd_blktrans_ops inftl_tr = {
 	.name		= "inftl",
 	.major		= INFTL_MAJOR,
 	.part_bits	= INFTL_PARTN_BITS,
-	.blksize 	= 512,
+	.blksize	= 512,
 	.getgeo		= inftl_getgeo,
 	.readsect	= inftl_readblock,
 	.writesect	= inftl_writeblock,
@@ -966,5 +972,8 @@ module_init(init_inftl);
 module_exit(cleanup_inftl);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Greg Ungerer <gerg@snapgear.com>, David Woodhouse <dwmw2@infradead.org>, Fabrice Bellard <fabrice.bellard@netgem.com> et al.");
-MODULE_DESCRIPTION("Support code for Inverse Flash Translation Layer, used on M-Systems DiskOnChip 2000, Millennium and Millennium Plus");
+MODULE_AUTHOR("Greg Ungerer <gerg@snapgear.com>, \
+	      David Woodhouse <dwmw2@infradead.org>, \
+	      Fabrice Bellard <fabrice.bellard@netgem.com> et al.");
+MODULE_DESCRIPTION("Support code for Inverse Flash Translation Layer, used on \
+		    M-Systems DiskOnChip 2000, Millennium and Millennium Plus");
-- 
1.7.1

