Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1KMSTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:19:19 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:59292 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1KMSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:19:18 -0500
X-Greylist: delayed 1874 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Nov 2011 13:19:18 EST
From: Anders Larsen <al@alarsen.net>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] qnx4fs: Use kmemdup rather than duplicating its implementation
Date: Sun, 13 Nov 2011 18:47:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-35-generic; KDE/4.4.5; x86_64; ; )
Cc: Thomas Meyer <thomas@m3y3r.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111131847.49842.al@alarsen.net>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Anders Larsen <al@alarsen.net>
---

diff -u -p a/fs/qnx4/inode.c b/fs/qnx4/inode.c
--- a/fs/qnx4/inode.c 2011-11-07 19:38:23.987165894 +0100
+++ b/fs/qnx4/inode.c 2011-11-08 10:33:59.882543999 +0100
@@ -199,12 +199,13 @@ static const char *qnx4_checkroot(struct
 					if (!strcmp(rootdir->di_fname,
 						    QNX4_BMNAME)) {
 						found = 1;
-						qnx4_sb(sb)->BitMap = kmalloc( sizeof( struct qnx4_inode_entry ), GFP_KERNEL );
+						qnx4_sb(sb)->BitMap = kmemdup(rootdir,
+									      sizeof(struct qnx4_inode_entry),
+									      GFP_KERNEL);
 						if (!qnx4_sb(sb)->BitMap) {
 							brelse (bh);
 							return "not enough memory for bitmap inode";
-						}
-						memcpy( qnx4_sb(sb)->BitMap, rootdir, sizeof( struct qnx4_inode_entry ) );	/* keep bitmap inode known */
+						}/* keep bitmap inode known */
 						break;
 					}
 				}
