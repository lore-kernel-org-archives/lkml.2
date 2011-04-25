Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab1DYQjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:39:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43741 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1DYQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Pift4XeeFftw11eJ0pgEb7wGDLSEYoB73b5nleAWt5EQEy/iumf80I0WY6jJgySG0z
         Wy5+XDceQ43q4o1Grx57GmD6ZesSaRb1tAUmWhQNyjJsLxNNaNc+h6V49wuHMpt0Y3OB
         IL7SL+RI1eT8ZTxh2uCLpCXxpfGrs82R4uM30=
Subject: [PATCH] drivers, char: Use {k,v}zalloc to allocate memory
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 22:39:18 +0600
Message-ID: <1303749558.21057.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let memory allocator initialize the allocated memory as null, thus
remove the use of memset.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 966a95b..25d139c 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -271,14 +271,13 @@ mspec_mmap(struct file *file, struct
vm_area_struct *vma,
 	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
 	if (vdata_size <= PAGE_SIZE)
-		vdata = kmalloc(vdata_size, GFP_KERNEL);
+		vdata = kzalloc(vdata_size, GFP_KERNEL);
 	else {
-		vdata = vmalloc(vdata_size);
+		vdata = vzalloc(vdata_size);
 		flags = VMD_VMALLOCED;
 	}
 	if (!vdata)
 		return -ENOMEM;
-	memset(vdata, 0, vdata_size);
 
 	vdata->vm_start = vma->vm_start;
 	vdata->vm_end = vma->vm_end;

