Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab2EIFxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38873 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103Ab2EIFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:12 -0400
Message-Id: <20120509055036.788842023@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 051/167] nfsd: fix endianness breakage in TEST_STATEID handling
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 02f5fde5df0ea930e70f93763dd48beff182b208 upstream.

->ts_id_status gets nfs errno, i.e. it's already big-endian; no need
to apply htonl() to it.  Broken by commit 174568 (NFSD: Added TEST_STATEID
operation) last year...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3410,7 +3410,7 @@ nfsd4_encode_test_stateid(struct nfsd4_c
 		nfsd4_decode_stateid(argp, &si);
 		valid = nfs4_validate_stateid(cl, &si);
 		RESERVE_SPACE(4);
-		*p++ = htonl(valid);
+		*p++ = valid;
 		resp->p = p;
 	}
 	nfs4_unlock_state();


