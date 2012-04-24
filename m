Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2DXWgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:50 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157Ab2DXWgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:46 -0400
Message-Id: <20120424223246.691328006@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: [ 55/62] nfsd: fix endianness breakage in TEST_STATEID handling
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 02f5fde5df0ea930e70f93763dd48beff182b208 upstream.

->ts_id_status gets nfs errno, i.e. it's already big-endian; no need
to apply htonl() to it.  Broken by commit 174568 (NFSD: Added TEST_STATEID
operation) last year...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


