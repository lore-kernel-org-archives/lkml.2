Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880Ab2DXWkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:40:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab2DXWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:39:17 -0400
Message-Id: <20120424223257.121245734@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 42/42] lockd: fix the endianness bug
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e847469bf77a1d339274074ed068d461f0c872bc upstream.

comparing be32 values for < is not doing the right thing...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/clnt4xdr.c |    2 +-
 fs/lockd/clntxdr.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -241,7 +241,7 @@ static int decode_nlm4_stat(struct xdr_s
 	p = xdr_inline_decode(xdr, 4);
 	if (unlikely(p == NULL))
 		goto out_overflow;
-	if (unlikely(*p > nlm4_failed))
+	if (unlikely(ntohl(*p) > ntohl(nlm4_failed)))
 		goto out_bad_xdr;
 	*stat = *p;
 	return 0;
--- a/fs/lockd/clntxdr.c
+++ b/fs/lockd/clntxdr.c
@@ -236,7 +236,7 @@ static int decode_nlm_stat(struct xdr_st
 	p = xdr_inline_decode(xdr, 4);
 	if (unlikely(p == NULL))
 		goto out_overflow;
-	if (unlikely(*p > nlm_lck_denied_grace_period))
+	if (unlikely(ntohl(*p) > ntohl(nlm_lck_denied_grace_period)))
 		goto out_enum;
 	*stat = *p;
 	return 0;


