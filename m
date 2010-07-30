Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab0G3SgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:36:08 -0400
Received: from kroah.org ([198.145.64.141]:57999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759803Ab0G3Ryn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:37 2010
Message-Id: <20100730175136.936203198@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [037/205] NFSv4: Fix an embarassing typo in encode_attrs()
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d3f6baaa34c54040b3ef30950e59b54ac0624b21 upstream.

Apparently, we have never been able to set the atime correctly from the
NFSv4 client.

Reported-by: 小倉一夫 <ka-ogura@bd6.so-net.ne.jp>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4xdr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -862,8 +862,8 @@ static void encode_attrs(struct xdr_stre
 		bmval1 |= FATTR4_WORD1_TIME_ACCESS_SET;
 		*p++ = cpu_to_be32(NFS4_SET_TO_CLIENT_TIME);
 		*p++ = cpu_to_be32(0);
-		*p++ = cpu_to_be32(iap->ia_mtime.tv_sec);
-		*p++ = cpu_to_be32(iap->ia_mtime.tv_nsec);
+		*p++ = cpu_to_be32(iap->ia_atime.tv_sec);
+		*p++ = cpu_to_be32(iap->ia_atime.tv_nsec);
 	}
 	else if (iap->ia_valid & ATTR_ATIME) {
 		bmval1 |= FATTR4_WORD1_TIME_ACCESS_SET;


