Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2AMOl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:41:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:54404 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2AMOl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:41:26 -0500
Date: Fri, 13 Jan 2012 17:41:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>, autofs@linux.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] autofs4: double lock typo in autofs4_write()
Message-ID: <20120113144113.GA25667@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F10428D.00D8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second mutex_lock() should be an unlock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 9ef5b29..da8876d 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -76,7 +76,7 @@ static int autofs4_write(struct autofs_sb_info *sbi,
 		data += wr;
 		bytes -= wr;
 	}
-	mutex_lock(&sbi->pipe_mutex);
+	mutex_unlock(&sbi->pipe_mutex);
 
 	set_fs(fs);
 
