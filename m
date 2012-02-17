Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2BQBAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60911 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771Ab2BQBAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:02 -0500
X-Sasl-enc: VLmGNW99+C2+ihWky8QOQcYLE08hHZmMJmDrdIDNWLc6 1329440401
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:36 2012
Message-Id: <20120217005536.529468911@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: [18/28] cifs: request oplock when doing open on lookup
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 8b0192a5f478da1c1ae906bf3ffff53f26204f56 upstream.

Currently, it's always set to 0 (no oplock requested).

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_ino
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
-	__u32 oplock = 0;
+	__u32 oplock = enable_oplocks ? REQ_OPLOCK : 0;
 	__u16 fileHandle = 0;
 	bool posix_open = false;
 	struct cifs_sb_info *cifs_sb;


