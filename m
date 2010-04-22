Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab0DVTvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:51:48 -0400
Received: from kroah.org ([198.145.64.141]:40954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab0DVT2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.884297269@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [095/197] NFSv4: Fall back to ordinary lookup if nfs4_atomic_open() returns EISDIR
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 80e60639f1b7c121a7fea53920c5a4b94009361a upstream.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1025,12 +1025,12 @@ static struct dentry *nfs_atomic_lookup(
 				res = NULL;
 				goto out;
 			/* This turned out not to be a regular file */
+			case -EISDIR:
 			case -ENOTDIR:
 				goto no_open;
 			case -ELOOP:
 				if (!(nd->intent.open.flags & O_NOFOLLOW))
 					goto no_open;
-			/* case -EISDIR: */
 			/* case -EINVAL: */
 			default:
 				goto out;


