Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2CHH0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:26:11 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:42966 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2CHH0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:26:10 -0500
Date: Thu, 8 Mar 2012 10:25:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kai Bankett <chaosman@ontika.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] qnx6fs: silence a Sparse warning
Message-ID: <20120308072551.GA27713@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090207.4F585F08.0004,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a  __force to silence a sparse warning:
	fs/qnx6/inode.c:88:22: warning: cast to restricted __fs32

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index e44012d..acf9241 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -85,7 +85,7 @@ static int qnx6_get_block(struct inode *inode, sector_t iblock,
 
 static int qnx6_check_blockptr(__fs32 ptr)
 {
-	if (ptr == ~(__fs32)0) {
+	if (ptr == ~(__force __fs32)0) {
 		printk(KERN_ERR "qnx6: hit unused blockpointer.\n");
 		return 0;
 	}
