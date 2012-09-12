Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab2ILXfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:35:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2ILXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:35:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 092/108] fuse: fix retrieve length
Date: Wed, 12 Sep 2012 16:29:30 -0700
Message-Id: <20120912232500.160215890@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1576,6 +1576,7 @@ static int fuse_retrieve(struct fuse_con
 		req->pages[req->num_pages] = page;
 		req->num_pages++;
 
+		offset = 0;
 		num -= this_num;
 		total_len += this_num;
 		index++;


