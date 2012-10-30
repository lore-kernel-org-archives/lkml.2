Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab2J3T1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:27:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab2J3TUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:20:23 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/23] KEYS: Store public key algo ID in public_key_signature
 struct
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:20:15 +0000
Message-ID: <20121030192015.11000.87499.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store public key algorithm ID in public_key_signature struct for reference
purposes.  This allows a public_key_signature struct to be embedded in
struct x509_certificate and struct pkcs7_message more easily.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/crypto/public_key.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 05778df..b34fda4 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -90,6 +90,7 @@ struct public_key_signature {
 	u8 *digest;
 	u8 digest_size;			/* Number of bytes in digest */
 	u8 nr_mpi;			/* Occupancy of mpi[] */
+	enum pkey_algo pkey_algo : 8;
 	enum pkey_hash_algo pkey_hash_algo : 8;
 	union {
 		MPI mpi[2];

