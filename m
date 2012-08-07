Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245Ab2HGWbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:31:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030215Ab2HGWbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 088/122] nfsd4: our filesystems are normally case sensitive
Date: Tue,  7 Aug 2012 15:26:16 -0700
Message-Id: <20120807221957.137604096@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 2930d381d22b9c56f40dd4c63a8fa59719ca2c3c upstream.

Actually, xfs and jfs can optionally be case insensitive; we'll handle
that case in later patches.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


