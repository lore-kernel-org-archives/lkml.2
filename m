Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab2ILXop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:44:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab2ILXoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:44:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 41/46] fuse: fix retrieve length
Date: Wed, 12 Sep 2012 16:39:31 -0700
Message-Id: <20120912233821.956379215@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit c9e67d483776d8d2a5f3f70491161b205930ffe1 upstream.

In some cases fuse_retrieve() would return a short byte count if offset was
non-zero.  The data returned was correct, though.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1524,6 +1524,7 @@ static int fuse_retrieve(struct fuse_con
 		req->pages[req->num_pages] = page;
 		req->num_pages++;
 
+		offset = 0;
 		num -= this_num;
 		total_len += this_num;
 		index++;


