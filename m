Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0GLCyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:54:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54959 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab0GLCyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=D1GqyuENfAyEyWnPWzfe7PPfCrAvDt7FW2mL7inE9womWreRoaibDqffF+sGt/8wxD
         TK20QHVFynLiJ7gr7ZaW3bi/lJ9eB+74Fkj3jmyQRf2r7m1CyXZL5hYTk4meqLJkhYEO
         tVojZajVBVDgc85XMFKTPNhPPLP6caHkSWvmY=
Message-ID: <4C3A83E7.3040807@gmail.com>
Date: Sun, 11 Jul 2010 21:54:31 -0500
From: Neal B <nealb001@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: dwmw2@infradead.org, rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
        mohanlaljangir@gmail.com, maximlevitsky@gmail.com,
        Julia Lawall <julia@diku.dk>, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] Mtd: Removed legacy dbg function.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is dependent on [patch 4/6 and patch 5/6]
 From 4840c4e191b3a507784298e8e3a5131b10901241 Mon Sep 17 00:00:00 2001
From: Neal Buckendahl <nealb001@gmail.com>
Date: Sun, 11 Jul 2010 18:42:39 -0500
Subject: [PATCH 6/6] Mtd: Removed legacy dbg function which is no longer 
needed.
      Signed-off-by: Neal Buckendahl <nealb001@gmail.com>

---
  drivers/mtd/cmdlinepart.c |   20 --------------------
  1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 2423ade..d20258c 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -32,13 +32,6 @@
  /* error message prefix */
  #define ERRP "mtd: "

-/* debug macro */
-#if 0
-#define dbg(x) do { printk("DEBUG-CMDLINE-PART: "); printk x; } while (0)
-#else
-#define dbg(x)
-#endif
-

  /* special size referring to all the remaining space in a partition */
  #define SIZE_REMAINING UINT_MAX
@@ -175,13 +168,6 @@ static struct mtd_partition * newpart(char *s,
  	parts[this_part].name = extra_mem;
  	extra_mem += name_len + 1;

-	dbg(("partition %d: name <%s>, offset %llx, size %llx, mask flags %x\n",
-	     this_part,
-	     parts[this_part].name,
-	     parts[this_part].offset,
-	     parts[this_part].size,
-	     parts[this_part].mask_flags));
-
  	/* return (updated) pointer to extra_mem memory */
  	if (extra_mem_ptr)
  	  *extra_mem_ptr = extra_mem;
@@ -215,8 +201,6 @@ static int mtdpart_setup_real(char *s)
  		}
  		mtd_id_len = p - mtd_id;

-		dbg(("parsing <%s>\n", p+1));
-
  		/*
  		 * parse one mtd. have it reserve memory for the
  		 * struct cmdline_mtd_partition and the mtd-id string.
@@ -253,10 +237,6 @@ static int mtdpart_setup_real(char *s)
  		this_mtd->next = partitions;
  		partitions = this_mtd;

-		dbg(("mtdid=<%s> num_parts=<%d>\n",
-		     this_mtd->mtd_id, this_mtd->num_parts));
-
-
  		/* EOS - we're done */
  		if (*s == 0)
  			break;
-- 
1.7.1


