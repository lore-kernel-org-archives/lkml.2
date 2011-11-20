Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1KTMgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 07:36:06 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:51982 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1KTMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 07:36:04 -0500
From: Anders Larsen <al@alarsen.net>
To: trivial@kernel.org
Subject: [PATCH] qnx4fs: Use kmemdup rather than duplicating its implementation
Date: Sun, 20 Nov 2011 13:35:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-35-generic; KDE/4.4.5; x86_64; ; )
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111201335.57713.al@alarsen.net>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

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
