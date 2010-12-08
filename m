Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0LHBBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:13 -0500
Received: from kroah.org ([198.145.64.141]:48950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab0LHBBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:11 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:33 2010
Message-Id: <20101208005733.791057740@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [124/289] ipc: shm: fix information leak to userland
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segooon@gmail.com>

commit 3af54c9bd9e6f14f896aac1bb0e8405ae0bc7a44 upstream.

The shmid_ds structure is copied to userland with shm_unused{,2,3}
fields unitialized.  It leads to leaking of contents of kernel stack
memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/shm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -473,6 +473,7 @@ static inline unsigned long copy_shmid_t
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;


