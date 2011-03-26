Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab1CZAJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:09:54 -0400
Received: from kroah.org ([198.145.64.141]:35913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab1CZAGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:58 2011
Message-Id: <20110326000458.255631928@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mi Jinlong <mijinlong@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [23/35] nfsd: wrong index used in inner loop
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mi Jinlong <mijinlong@cn.fujitsu.com>

commit 5a02ab7c3c4580f94d13c683721039855b67cda6 upstream.

We must not use dummy for index.
After the first index, READ32(dummy) will change dummy!!!!

Signed-off-by: Mi Jinlong <mijinlong@cn.fujitsu.com>
[bfields@redhat.com: Trond points out READ_BUF alone is sufficient.]
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1106,7 +1106,7 @@ nfsd4_decode_create_session(struct nfsd4
 
 	u32 dummy;
 	char *machine_name;
-	int i, j;
+	int i;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1179,8 +1179,6 @@ nfsd4_decode_create_session(struct nfsd4
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (j = 0; j < dummy; ++j)
-				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
 			dprintk("RPC_AUTH_GSS callback secflavor "
@@ -1196,7 +1194,6 @@ nfsd4_decode_create_session(struct nfsd4
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy);
-			p += XDR_QUADLEN(dummy);
 			break;
 		default:
 			dprintk("Illegal callback secflavor\n");


