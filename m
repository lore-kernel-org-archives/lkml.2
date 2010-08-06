Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab0HFSfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:35:45 -0400
Received: from kroah.org ([198.145.64.141]:48609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761904Ab0HFSfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.130535101@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [12/38] 9p: strlen() doesnt count the terminator
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 5c4bfa17f3ec46becec4b23d12323f7605ebd696 upstream.

This is an off by one bug because strlen() doesn't count the NULL
terminator.  We strcpy() addr into a fixed length array of size
UNIX_PATH_MAX later on.

The addr variable is the name of the device being mounted.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/9p/trans_fd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -948,7 +948,7 @@ p9_fd_create_unix(struct p9_client *clie
 
 	csocket = NULL;
 
-	if (strlen(addr) > UNIX_PATH_MAX) {
+	if (strlen(addr) >= UNIX_PATH_MAX) {
 		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
 			addr);
 		return -ENAMETOOLONG;


