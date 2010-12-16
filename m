Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0LPSSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:18:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63490 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0LPSSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:18:14 -0500
Date: Thu, 16 Dec 2010 10:18:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH -next] crypto: fix af_alg memory_allocated data type
Message-Id: <20101216101800.36529e89.randy.dunlap@oracle.com>
In-Reply-To: <20101216173745.264eb2ca.sfr@canb.auug.org.au>
References: <20101216173745.264eb2ca.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Change data type to fix warning:

crypto/af_alg.c:35: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 crypto/af_alg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101216.orig/crypto/af_alg.c
+++ linux-next-20101216/crypto/af_alg.c
@@ -27,7 +27,7 @@ struct alg_type_list {
 	struct list_head list;
 };
 
-static atomic_t alg_memory_allocated;
+static atomic_long_t alg_memory_allocated;
 
 static struct proto alg_proto = {
 	.name			= "ALG",
