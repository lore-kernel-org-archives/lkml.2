Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0KEDIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:08:42 -0400
Received: from mail.perches.com ([173.55.12.10]:4057 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0KEDIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:38 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/49] crypto: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:30 -0700
Message-Id: <0a38da3a2e3a157f239a64b87f1a941ea4e0798c.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 crypto/deflate.c |    3 +--
 crypto/zlib.c    |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 463dc85..cbc7a33 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -48,12 +48,11 @@ static int deflate_comp_init(struct deflate_ctx *ctx)
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->comp_stream;
 
-	stream->workspace = vmalloc(zlib_deflate_workspacesize());
+	stream->workspace = vzalloc(zlib_deflate_workspacesize());
 	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	memset(stream->workspace, 0, zlib_deflate_workspacesize());
 	ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
 	                        -DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
 	                        Z_DEFAULT_STRATEGY);
diff --git a/crypto/zlib.c b/crypto/zlib.c
index c3015733..739b8fc 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -95,11 +95,10 @@ static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
 	zlib_comp_exit(ctx);
 
 	workspacesize = zlib_deflate_workspacesize();
-	stream->workspace = vmalloc(workspacesize);
+	stream->workspace = vzalloc(workspacesize);
 	if (!stream->workspace)
 		return -ENOMEM;
 
-	memset(stream->workspace, 0, workspacesize);
 	ret = zlib_deflateInit2(stream,
 				tb[ZLIB_COMP_LEVEL]
 					? nla_get_u32(tb[ZLIB_COMP_LEVEL])
-- 
1.7.3.1.g432b3.dirty

