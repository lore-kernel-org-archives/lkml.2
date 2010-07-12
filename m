Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0GLCvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:51:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50708 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0GLCvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=lpLZzCR4yvn6H9N2gVDjt6uWwYBxaBXEtPng/MtzhRxkTFIJ0GVfkJ/UaTRsB72nxi
         Ki3Ba3vYA+PjUDDVgs8Z+Fe9zD13zRVZnovSmAOAeIEvW4Gx7er0wlezfMnQf0AAMb7A
         QFQjRX74t/dPiLr6VI2ta59BjJeeqF++1km9o=
Message-ID: <4C3A8325.3080007@gmail.com>
Date: Sun, 11 Jul 2010 21:51:17 -0500
From: Neal B <nealb001@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: dwmw2@infradead.org, rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
        mohanlaljangir@gmail.com, maximlevitsky@gmail.com,
        Julia Lawall <julia@diku.dk>, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] Mtd: fixed open brace.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 7c0b352854c7d80e57327ba65d42b9060dc13705 Mon Sep 17 00:00:00 2001
From: Neal Buckendahl <nealb001@gmail.com>
Date: Sun, 11 Jul 2010 18:23:17 -0500
Subject: [PATCH 4/6] Mtd: fixed open brace { related issues found by the 
checkpatch.pl tool
      Signed-off-by: Neal Buckendahl <nealb001@gmail.com>

---
  drivers/mtd/cmdlinepart.c |   71 
++++++++++++++------------------------------
  1 files changed, 23 insertions(+), 48 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 1479da6..38666bb 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -83,16 +83,13 @@ static struct mtd_partition * newpart(char *s,
  	unsigned int mask_flags;

  	/* fetch the partition size */
-	if (*s == '-')
-	{	/* assign all remaining space to this partition */
+	if (*s == '-') {
+	/* assign all remaining space to this partition */
  		size = SIZE_REMAINING;
  		s++;
-	}
-	else
-	{
+	} else {
  		size = memparse(s, &s);
-		if (size < PAGE_SIZE)
-		{
+		if (size < PAGE_SIZE) {
  			printk(KERN_ERR ERRP "partition size too small (%lx)\n", size);
  			return NULL;
  		}
@@ -102,33 +99,26 @@ static struct mtd_partition * newpart(char *s,
  	mask_flags = 0; /* this is going to be a regular partition */
  	delim = 0;
          /* check for offset */
-        if (*s == '@')
-	{
+        if (*s == '@') {
                  s++;
                  offset = memparse(s, &s);
          }
          /* now look for name */
  	if (*s == '(')
-	{
  		delim = ')';
-	}

-	if (delim)
-	{
+	if (delim) {
  		char *p;

  	    	name = ++s;
  		p = strchr(name, delim);
-		if (!p)
-		{
+		if (!p) {
  			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
  			return NULL;
  		}
  		name_len = p - name;
  		s = p + 1;
-	}
-	else
-	{
+	} else {
  	    	name = NULL;
  		name_len = 13; /* Partition_000 */
  	}
@@ -137,24 +127,20 @@ static struct mtd_partition * newpart(char *s,
  	extra_mem_size += name_len + 1;

          /* test for options */
-        if (strncmp(s, "ro", 2) == 0)
-	{
+        if (strncmp(s, "ro", 2) == 0) {
  		mask_flags |= MTD_WRITEABLE;
  		s += 2;
          }

          /* if lk is found do NOT unlock the MTD partition*/
-        if (strncmp(s, "lk", 2) == 0)
-	{
+        if (strncmp(s, "lk", 2) == 0) {
  		mask_flags |= MTD_POWERUP_LOCK;
  		s += 2;
          }

  	/* test if more partitions are following */
-	if (*s == ',')
-	{
-		if (size == SIZE_REMAINING)
-		{
+	if (*s == ',') {
+		if (size == SIZE_REMAINING) {
  			printk(KERN_ERR ERRP "no partitions allowed after a fill-up 
partition\n");
  			return NULL;
  		}
@@ -163,17 +149,15 @@ static struct mtd_partition * newpart(char *s,
  				&extra_mem, extra_mem_size);
  		if (!parts)
  			return NULL;
-	}
-	else
-	{	/* this is the last partition: allocate space for all */
+	} else {
+	/* this is the last partition: allocate space for all */
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
@@ -183,12 +167,9 @@ static struct mtd_partition * newpart(char *s,
  	parts[this_part].size = size;
  	parts[this_part].offset = offset;
  	parts[this_part].mask_flags = mask_flags;
-	if (name)
-	{
+	if (name) {
  		strlcpy(extra_mem, name, name_len + 1);
-	}
-	else
-	{
+	} else {
  		sprintf(extra_mem, "Partition_%03d", this_part);
  	}
  	parts[this_part].name = extra_mem;
@@ -219,8 +200,7 @@ static int mtdpart_setup_real(char *s)
  {
  	cmdline_parsed = 1;

-	for( ; s != NULL; )
-	{
+	for( ; s != NULL; ) {
  		struct cmdline_mtd_partition *this_mtd;
  		struct mtd_partition *parts;
  	    	int mtd_id_len;
@@ -229,8 +209,7 @@ static int mtdpart_setup_real(char *s)

  	    	mtd_id = s;
  		/* fetch <mtd-id> */
-		if (!(p = strchr(s, ':')))
-		{
+		if (!(p = strchr(s, ':'))) {
  			printk(KERN_ERR ERRP "no mtd-id\n");
  			return 0;
  		}
@@ -313,20 +292,16 @@ static int parse_cmdline_partitions(struct 
mtd_info *master,
  	if (!cmdline_parsed)
  		mtdpart_setup_real(cmdline);

-	for(part = partitions; part; part = part->next)
-	{
-		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
-		{
-			for(i = 0, offset = 0; i < part->num_parts; i++)
-			{
+	for(part = partitions; part; part = part->next) {
+		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id))) {
+			for(i = 0, offset = 0; i < part->num_parts; i++) {
  				if (part->parts[i].offset == OFFSET_CONTINUOUS)
  				  part->parts[i].offset = offset;
  				else
  				  offset = part->parts[i].offset;
  				if (part->parts[i].size == SIZE_REMAINING)
  				  part->parts[i].size = master->size - offset;
-				if (offset + part->parts[i].size > master->size)
-				{
+				if (offset + part->parts[i].size > master->size) {
  					printk(KERN_WARNING ERRP
  					       "%s: partitioning exceeds flash size, truncating\n",
  					       part->mtd_id);
-- 
1.7.1


