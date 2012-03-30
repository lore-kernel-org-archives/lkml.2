Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936134Ab2C3VeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:34:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54161 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966336Ab2C3Vcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:52 -0400
X-Sasl-enc: p+ahsfxnEpfrNKhoMQfi8ZzJ8jJXVfvNimoIdT0oN3l/ 1333143170
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:49:01 2012
Message-Id: <20120330194900.895534266@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 173/175] nfsd: dont allow zero length strings in cache_parse()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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


