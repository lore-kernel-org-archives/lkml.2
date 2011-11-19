Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab1KSAPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:15:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab1KSAJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:29 2011
Message-Id: <20111119000329.053991778@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [13/26] hfs: add sanity check for file name length
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bc5b8a9003132ae44559edd63a1623b7b99dfb68 upstream.

On a corrupted file system the ->len field could be wrong leading to
a buffer overflow.

Reported-and-acked-by: Clement LECIGNE <clement.lecigne@netasq.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hfs/trans.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/hfs/trans.c
+++ b/fs/hfs/trans.c
@@ -40,6 +40,8 @@ int hfs_mac2asc(struct super_block *sb,
 
 	src = in->name;
 	srclen = in->len;
+	if (srclen > HFS_NAMELEN)
+		srclen = HFS_NAMELEN;
 	dst = out;
 	dstlen = HFS_MAX_NAMELEN;
 	if (nls_io) {


