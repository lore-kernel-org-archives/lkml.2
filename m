Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2FKFid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:38:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab2FKFic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:38:32 -0400
Message-ID: <4FD5844D.4010900@suse.com>
Date: Mon, 11 Jun 2012 11:08:21 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Justin Lecher <jlec@gentoo.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com
Subject: [PATCH] [RESEND] fs: cachefiles: Add support for large files in filesystem
 caching
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch which was first posted here:

   https://lkml.org/lkml/2012/4/3/193

and tested by me and picked up by the maintainer here:

   https://lkml.org/lkml/2012/5/1/57

But it seems to not to have made to the linux-next or Linus tree.
I'm resending what it seems like a lost patch.


From: Justin Lecher <jlec@gentoo.org>

Support the caching of large files.

https://bugzilla.kernel.org/show_bug.cgi?id=31182

Signed-off-by: Justin Lecher <jlec@gentoo.org>
Tested-by: Suresh Jayaraman <sjayaraman@suse.com>
---
 fs/cachefiles/rdwr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 0e3c092..d136686 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -919,7 +919,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 	dget(object->backer);
 	mntget(cache->mnt);
 	file = dentry_open(object->backer, cache->mnt, O_RDWR,
-			   cache->cache_cred);
+			   (O_RDWR | O_LARGEFILE), cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 	} else {
