Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2DSXOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:14:31 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60479 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751771Ab2DSXOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:14:30 -0400
Message-ID: <4F909C78.7000008@xenotime.net>
Date: Thu, 19 Apr 2012 16:15:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] nfsd: fix nfs4recover.f printk format warning
References: <20120419164643.d9f918d44c890722b7707508@canb.auug.org.au>
In-Reply-To: <20120419164643.d9f918d44c890722b7707508@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings -- both items are size_t,
so use %zu to print them.

fs/nfsd/nfs4recover.c:580:3: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'
fs/nfsd/nfs4recover.c:580:3: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	"J. Bruce Fields" <bfields@fieldses.org>
Cc:	linux-nfs@vger.kernel.org
---
 fs/nfsd/nfs4recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120419.orig/fs/nfsd/nfs4recover.c
+++ linux-next-20120419/fs/nfsd/nfs4recover.c
@@ -577,7 +577,7 @@ cld_pipe_downcall(struct file *filp, con
 	struct cld_net *cn = nn->cld_net;
 
 	if (mlen != sizeof(*cmsg)) {
-		dprintk("%s: got %lu bytes, expected %lu\n", __func__, mlen,
+		dprintk("%s: got %zu bytes, expected %zu\n", __func__, mlen,
 			sizeof(*cmsg));
 		return -EINVAL;
 	}
