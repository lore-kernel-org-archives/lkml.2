Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0KEDS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:18:28 -0400
Received: from mail.perches.com ([173.55.12.10]:4046 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab0KEDIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:36 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/49] arch/s390: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:28 -0700
Message-Id: <4860ebaf7a0b6851c44d83be77db188e19a5388e.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/hypfs/hypfs_diag.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/s390/hypfs/hypfs_diag.c b/arch/s390/hypfs/hypfs_diag.c
index cd4a81b..1b1acef 100644
--- a/arch/s390/hypfs/hypfs_diag.c
+++ b/arch/s390/hypfs/hypfs_diag.c
@@ -570,12 +570,11 @@ static int dbfs_d204_open(struct inode *inode, struct file *file)
 	if (!data)
 		return -ENOMEM;
 	buf_size = PAGE_SIZE * (diag204_buf_pages + 1) + sizeof(d204->hdr);
-	data->base = vmalloc(buf_size);
+	data->base = vzalloc(buf_size);
 	if (!data->base) {
 		rc = -ENOMEM;
 		goto fail_kfree_data;
 	}
-	memset(data->base, 0, buf_size);
 	d204 = page_align_ptr(data->base + sizeof(d204->hdr))
 		- sizeof(d204->hdr);
 	rc = diag204_do_store(&d204->buf, diag204_buf_pages);
-- 
1.7.3.1.g432b3.dirty

