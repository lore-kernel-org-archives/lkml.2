Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab2EIG3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:29:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38751 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654Ab2EIFwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:54 -0400
Message-Id: <20120509055037.912139755@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 058/167] [PATCH] lockd: fix the endianness bug
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e847469bf77a1d339274074ed068d461f0c872bc upstream.

comparing be32 values for < is not doing the right thing...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/lockd/clnt4xdr.c |    2 +-
 fs/lockd/clntxdr.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/clnt4xdr.c b/fs/lockd/clnt4xdr.c
index 3ddcbb1..13ad153 100644
--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -241,7 +241,7 @@ static int decode_nlm4_stat(struct xdr_stream *xdr, __be32 *stat)
 	p = xdr_inline_decode(xdr, 4);
 	if (unlikely(p == NULL))
 		goto out_overflow;
-	if (unlikely(*p > nlm4_failed))
+	if (unlikely(ntohl(*p) > ntohl(nlm4_failed)))
 		goto out_bad_xdr;
 	*stat = *p;
 	return 0;
diff --git a/fs/lockd/clntxdr.c b/fs/lockd/clntxdr.c
index 3d35e3e..d269ada 100644
--- a/fs/lockd/clntxdr.c
+++ b/fs/lockd/clntxdr.c
@@ -236,7 +236,7 @@ static int decode_nlm_stat(struct xdr_stream *xdr,
 	p = xdr_inline_decode(xdr, 4);
 	if (unlikely(p == NULL))
 		goto out_overflow;
-	if (unlikely(*p > nlm_lck_denied_grace_period))
+	if (unlikely(ntohl(*p) > ntohl(nlm_lck_denied_grace_period)))
 		goto out_enum;
 	*stat = *p;
 	return 0;
-- 
1.7.10



