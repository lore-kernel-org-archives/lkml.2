Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1CKUnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:43:23 -0500
Received: from kroah.org ([198.145.64.141]:46609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab1CKUnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:43:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 11 12:41:10 2011
Message-Id: <20110311204110.753145113@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 11 Mar 2011 12:40:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roel Kluin <roel.kluin@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [14/17] nfsd: wrong index used in inner loop
In-Reply-To: <20110311204126.GA7223@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: roel <roel.kluin@gmail.com>

commit 3ec07aa9522e3d5e9d5ede7bef946756e623a0a0 upstream.

Index i was already used in the outer loop

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1114,7 +1114,7 @@ nfsd4_decode_create_session(struct nfsd4
 
 	u32 dummy;
 	char *machine_name;
-	int i;
+	int i, j;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1187,7 +1187,7 @@ nfsd4_decode_create_session(struct nfsd4
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (i = 0; i < dummy; ++i)
+			for (j = 0; j < dummy; ++j)
 				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:


