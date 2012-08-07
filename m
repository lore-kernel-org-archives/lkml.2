Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2HGDiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:38:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757264Ab2HGDiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:07 -0400
Message-Id: <20120807032757.577439863@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 10/70] nfsd4: our filesystems are normally case sensitive
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 2930d381d22b9c56f40dd4c63a8fa59719ca2c3c upstream.

Actually, xfs and jfs can optionally be case insensitive; we'll handle
that case in later patches.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4949667..6322df3 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2259,7 +2259,7 @@ out_acl:
 	if (bmval0 & FATTR4_WORD0_CASE_INSENSITIVE) {
 		if ((buflen -= 4) < 0)
 			goto out_resource;
-		WRITE32(1);
+		WRITE32(0);
 	}
 	if (bmval0 & FATTR4_WORD0_CASE_PRESERVING) {
 		if ((buflen -= 4) < 0)


