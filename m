Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2JCXFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:05:05 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:42851 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932265Ab2JCXFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:05:03 -0400
Message-ID: <506CC48E.2020303@xenotime.net>
Date: Wed, 03 Oct 2012 16:04:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] asymmetric keys: fix printk format warning
References: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
In-Reply-To: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning in x509_cert_parser.c:

crypto/asymmetric_keys/x509_cert_parser.c: In function 'x509_note_OID':
crypto/asymmetric_keys/x509_cert_parser.c:113:3: warning: format '%zu' expects type 'size_t', but argument 2 has type 'long unsigned int'

Builds cleanly on i386 and x86_64.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
 crypto/asymmetric_keys/x509_cert_parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20121003.orig/crypto/asymmetric_keys/x509_cert_parser.c
+++ linux-next-20121003/crypto/asymmetric_keys/x509_cert_parser.c
@@ -110,7 +110,7 @@ int x509_note_OID(void *context, size_t
 	if (ctx->last_oid == OID__NR) {
 		char buffer[50];
 		sprint_oid(value, vlen, buffer, sizeof(buffer));
-		pr_debug("Unknown OID: [%zu] %s\n",
+		pr_debug("Unknown OID: [%lu] %s\n",
 			 (unsigned long)value - ctx->data, buffer);
 	}
 	return 0;
