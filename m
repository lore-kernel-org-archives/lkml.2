Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2JAXXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:23:23 -0400
Received: from 1wt.eu ([62.212.114.60]:35350 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904Ab2JAXBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:22 -0400
Message-Id: <20121001225200.363096738@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 065/180] nfsd: dont allow zero length strings in cache_parse()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6d8d17499810479eabd10731179c04b2ca22152f upstream.

There is no point in passing a zero length string here and quite a
few of that cache_parse() implementations will Oops if count is
zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sunrpc/cache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 25f7801..e3fea46 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -719,6 +719,8 @@ static ssize_t cache_do_downcall(char *kaddr, const char __user *buf,
 {
 	ssize_t ret;
 
+	if (count == 0)
+		return -EINVAL;
 	if (copy_from_user(kaddr, buf, count))
 		return -EFAULT;
 	kaddr[count] = '\0';
-- 
1.7.2.1.45.g54fbc



