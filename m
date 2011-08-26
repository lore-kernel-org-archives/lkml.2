Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1H0O4E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab1H0Ozy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:55:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:01:21 2011
Message-Id: <20110826220121.451986846@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:58:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [18/19] fuse: check size of FUSE_NOTIFY_INVAL_ENTRY message
In-Reply-To: <20110826220137.GA14059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit c2183d1e9b3f313dd8ba2b1b0197c8d9fb86a7ae upstream.

FUSE_NOTIFY_INVAL_ENTRY didn't check the length of the write so the
message processing could overrun and result in a "kernel BUG at
fs/fuse/dev.c:629!"

Reported-by: Han-Wen Nienhuys <hanwenn@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/dev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -899,6 +899,10 @@ static int fuse_notify_inval_entry(struc
 	if (outarg.namelen > FUSE_NAME_MAX)
 		goto err;
 
+	err = -EINVAL;
+	if (size != sizeof(outarg) + outarg.namelen + 1)
+		goto err;
+
 	name.name = buf;
 	name.len = outarg.namelen;
 	err = fuse_copy_one(cs, buf, outarg.namelen + 1);


