Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab2J3TZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:25:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934310Ab2J3TVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:21:05 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/23] X.509: Export certificate parse and free functions
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:20:57 +0000
Message-ID: <20121030192057.11000.14373.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export certificate parse and free functions for use by modules.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_cert_parser.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 931f069..9cf0e16 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -11,6 +11,7 @@
 
 #define pr_fmt(fmt) "X.509: "fmt
 #include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
@@ -52,6 +53,7 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert);
 	}
 }
+EXPORT_SYMBOL_GPL(x509_free_certificate);
 
 /*
  * Parse an X.509 certificate
@@ -97,6 +99,7 @@ error_no_ctx:
 error_no_cert:
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(x509_cert_parse);
 
 /*
  * Note an OID when we find one for later processing when we know how

