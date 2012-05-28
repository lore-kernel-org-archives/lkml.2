Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2E1DeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:34:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52234 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab2E1D3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:48 -0400
Message-Id: <20120528031214.469676457@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 084/117] cifs: fix revalidation test in cifs_llseek()
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 48a5730e5b71201e226ff06e245bf308feba5f10 upstream.

This test is always true so it means we revalidate the length every
time, which generates more network traffic.  When it is SEEK_SET or
SEEK_CUR, then we don't need to revalidate.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ca6a379..541ef81 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -699,7 +699,7 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
 	 * the cached file length
 	 */
-	if (origin != SEEK_SET || origin != SEEK_CUR) {
+	if (origin != SEEK_SET && origin != SEEK_CUR) {
 		int rc;
 		struct inode *inode = file->f_path.dentry->d_inode;
 


