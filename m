Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab1CZAGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:06:38 -0400
Received: from kroah.org ([198.145.64.141]:35904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386Ab1CZAGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:58 2011
Message-Id: <20110326000458.136359661@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mi Jinlong <mijinlong@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [22/35] nfsd41: modify the members value of nfsd4_op_flags
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mi Jinlong <mijinlong@cn.fujitsu.com>

commit 5ece3cafbd88d4da5c734e1810c4a2e6474b57b2 upstream.

The members of nfsd4_op_flags, (ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS)
equals to  ALLOWED_AS_FIRST_OP, maybe that's not what we want.

OP_PUTROOTFH with op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
can't appears as the first operation with out SEQUENCE ops.

This patch modify the wrong value of ALLOWED_WITHOUT_FH etc which
was introduced by f9bb94c4.

Reviewed-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Mi Jinlong <mijinlong@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -953,8 +953,8 @@ typedef __be32(*nfsd4op_func)(struct svc
 			      void *);
 enum nfsd4_op_flags {
 	ALLOWED_WITHOUT_FH = 1 << 0,	/* No current filehandle required */
-	ALLOWED_ON_ABSENT_FS = 2 << 0,	/* ops processed on absent fs */
-	ALLOWED_AS_FIRST_OP = 3 << 0,	/* ops reqired first in compound */
+	ALLOWED_ON_ABSENT_FS = 1 << 1,	/* ops processed on absent fs */
+	ALLOWED_AS_FIRST_OP = 1 << 2,	/* ops reqired first in compound */
 };
 
 struct nfsd4_operation {


