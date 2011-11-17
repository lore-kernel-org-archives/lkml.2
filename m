Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab1KRJ1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:27:30 -0500
Received: from www17.your-server.de ([213.133.104.17]:48452 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab1KRJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:28 -0500
Subject: [PATCH] qnx4fs: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: al@alarsen.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.304.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
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
