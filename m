Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0GLCx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:53:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53540 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0GLCx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=g4fmcVOQnGClF1SbLksV/H8xP3kOLYSSw5bm58Lx8uThLEYnmtZlw8OQe560UQoSm3
         74O0u4sSLLfdCoy+m8Keq2ziHcb59wJ1ny8oys4xPC/YVqg0Djqf7tGKihkbttP2Dgdo
         LYFSrrzmnPIDi+U7mGJo0WkDSFpQsk/pTMjSU=
Message-ID: <4C3A83A1.4000309@gmail.com>
Date: Sun, 11 Jul 2010 21:53:21 -0500
From: Neal B <nealb001@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: dwmw2@infradead.org, rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
        mohanlaljangir@gmail.com, maximlevitsky@gmail.com,
        Julia Lawall <julia@diku.dk>, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] Mtd: fixed tab/space related issues.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is dependent on [patch 4/6]
 From c7a714a1a7dce6585e117835748517d0c7b48767 Mon Sep 17 00:00:00 2001
From: Neal Buckendahl <nealb001@gmail.com>
Date: Sun, 11 Jul 2010 18:37:30 -0500
Subject: [PATCH 5/6] Mtd: fixed tab/space related issues found by the 
checkpatch.pl tool
      Signed-off-by: Neal Buckendahl <nealb001@gmail.com>

---
  drivers/mtd/cmdlinepart.c |   52 
++++++++++++++++++++++----------------------
  1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 38666bb..2423ade 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -34,7 +34,7 @@

  /* debug macro */
  #if 0
-#define dbg(x) do { printk("DEBUG-CMDLINE-PART: "); printk x; } while(0)
+#define dbg(x) do { printk("DEBUG-CMDLINE-PART: "); printk x; } while (0)
  #else
  #define dbg(x)
  #endif
@@ -67,11 +67,11 @@ static int cmdline_parsed = 0;
   * syntax has been verified ok.
   */
  static struct mtd_partition * newpart(char *s,
-                                      char **retptr,
-                                      int *num_parts,
-                                      int this_part,
-                                      unsigned char **extra_mem_ptr,
-                                      int extra_mem_size)
+					char **retptr,
+					int *num_parts,
+					int this_part,
+					unsigned char **extra_mem_ptr,
+					int extra_mem_size)
  {
  	struct mtd_partition *parts;
  	unsigned long size;
@@ -98,19 +98,19 @@ static struct mtd_partition * newpart(char *s,
  	/* fetch partition name and flags */
  	mask_flags = 0; /* this is going to be a regular partition */
  	delim = 0;
-        /* check for offset */
-        if (*s == '@') {
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
  		delim = ')';

  	if (delim) {
  		char *p;

-	    	name = ++s;
+		name = ++s;
  		p = strchr(name, delim);
  		if (!p) {
  			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
@@ -119,24 +119,24 @@ static struct mtd_partition * newpart(char *s,
  		name_len = p - name;
  		s = p + 1;
  	} else {
-	    	name = NULL;
+		name = NULL;
  		name_len = 13; /* Partition_000 */
  	}

  	/* record name length for memory allocation later */
  	extra_mem_size += name_len + 1;

-        /* test for options */
-        if (strncmp(s, "ro", 2) == 0) {
+	/* test for options */
+	if (strncmp(s, "ro", 2) == 0) {
  		mask_flags |= MTD_WRITEABLE;
  		s += 2;
          }

-        /* if lk is found do NOT unlock the MTD partition*/
-        if (strncmp(s, "lk", 2) == 0) {
+	/* if lk is found do NOT unlock the MTD partition*/
+	if (strncmp(s, "lk", 2) == 0) {
  		mask_flags |= MTD_POWERUP_LOCK;
  		s += 2;
-        }
+	}

  	/* test if more partitions are following */
  	if (*s == ',') {
@@ -200,14 +200,14 @@ static int mtdpart_setup_real(char *s)
  {
  	cmdline_parsed = 1;

-	for( ; s != NULL; ) {
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
  		if (!(p = strchr(s, ':'))) {
  			printk(KERN_ERR ERRP "no mtd-id\n");
@@ -280,8 +280,8 @@ static int mtdpart_setup_real(char *s)
   * the first one in the chain if a NULL mtd_id is passed in.
   */
  static int parse_cmdline_partitions(struct mtd_info *master,
-                             struct mtd_partition **pparts,
-                             unsigned long origin)
+				    struct mtd_partition **pparts,
+				    unsigned long origin)
  {
  	unsigned long offset;
  	int i;
@@ -292,9 +292,9 @@ static int parse_cmdline_partitions(struct mtd_info 
*master,
  	if (!cmdline_parsed)
  		mtdpart_setup_real(cmdline);

-	for(part = partitions; part; part = part->next) {
+	for (part = partitions; part; part = part->next) {
  		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id))) {
-			for(i = 0, offset = 0; i < part->num_parts; i++) {
+			for (i = 0, offset = 0; i < part->num_parts; i++) {
  				if (part->parts[i].offset == OFFSET_CONTINUOUS)
  				  part->parts[i].offset = offset;
  				else
-- 
1.7.1


