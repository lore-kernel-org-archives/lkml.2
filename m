Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0KDWHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:07:51 -0400
Received: from nm10.bullet.mail.ne1.yahoo.com ([98.138.90.73]:29614 "HELO
	nm10.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752429Ab0KDWHt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:07:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 351676.82393.bm@omp1034.mail.ne1.yahoo.com
Message-ID: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
X-YMail-OSG: TZbwfiwVM1kOOjXK0X1J2JV7fdIjd1Q5p9V3c18M8oWn5w4
 hv_d9tTlgVqQKsYSKbGQUOc0Dv7lXQY6LrBXl1WzCQD0DT4s42CPvCbHyTt0
 8wsu2er6rP72Iuhu8YWGdkiU2JcxLDxDY1n17Ya5ab6LYKiKpwvFYK9pFRLs
 4f8WPgmjW7caWhilaDKfYuXEyET75m.j0GMdwQPNFmesDPZnpAKqY.RtU5c.
 aNA.0DJRubbLQTy1Y1vTZoZ5gBCzSUhy00lwud2DL61750ClGAQFbrQxZwar
 R8xC4kQBT1LKQIC8P7cQExaL_gsonhNysQ8C04Oy7fZE3l7vm6L_MONv.NjF
 msMR3UaYAZBi_ZW9lZAwKgMzzwEkq1EWIblwWA7jG
X-RocketYMMF: multiplicador
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Thu, 4 Nov 2010 15:07:47 -0700 (PDT)
From: =?iso-8859-1?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?= 
	<andre@bsrsoft.com.br>
Reply-To: andre@bsrsoft.com.br
Subject: [PATCH 1/1] fs: Small refactoring of the code in ext4 2.6.37-rc1
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>

Hi.
Small refactoring of the code in order to make minor enhancements to critical areas.
The notation x + 1 has been replaced by more efficient notation x + +.

Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
---
Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
--- linux-2.6.37-rc1/fs/ext4/extents.c	2010-11-01 09:54:12.000000000 -0200
+++ linux-2.6.37-rc1-patched/fs/ext4/extents.c	2010-11-04 19:54:26.000000000 -0200
@@ -555,9 +555,9 @@ ext4_ext_binsearch(struct inode *inode,
 	while (l <= r) {
 		m = l + (r - l) / 2;
 		if (block < le32_to_cpu(m->ee_block))
-			r = m - 1;
+			r = m--;
 		else
-			l = m + 1;
+			l = m++;
 		ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ee_block),
 				m, le32_to_cpu(m->ee_block),
 				r, le32_to_cpu(r->ee_block));
@@ -1557,7 +1557,7 @@ static int ext4_ext_try_to_merge(struct
 		if (ext4_ext_is_uninitialized(ex))
 			uninitialized = 1;
 		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
-				+ ext4_ext_get_actual_len(ex + 1));
+				+ ext4_ext_get_actual_len(ex++));
 		if (uninitialized)
 			ext4_ext_mark_uninitialized(ex);


      
