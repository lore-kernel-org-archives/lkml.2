Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936582Ab2C3WiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:38:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52476 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935313Ab2C3VIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:08:41 -0400
Message-Id: <20120330195737.492447288@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:59:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 107/108] nfsd: dont allow zero length strings in cache_parse()
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6d8d17499810479eabd10731179c04b2ca22152f upstream.

There is no point in passing a zero length string here and quite a
few of that cache_parse() implementations will Oops if count is
zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/cache.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -828,6 +828,8 @@ static ssize_t cache_do_downcall(char *k
 {
 	ssize_t ret;
 
+	if (count == 0)
+		return -EINVAL;
 	if (copy_from_user(kaddr, buf, count))
 		return -EFAULT;
 	kaddr[count] = '\0';


