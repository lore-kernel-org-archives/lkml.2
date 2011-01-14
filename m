Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1ANHnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:43:37 -0500
Received: from ebb05.tieto.com ([131.207.168.36]:57644 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1ANHnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:43:31 -0500
X-AuditID: 83cfa824-b7b83ae000001097-ba-4d2ffea1f758
Date: Fri, 14 Jan 2011 15:51:04 +0800
From: Yang Ruirui <ruirui.r.yang@tieto.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: smbfs building fix
Message-ID: <20110114075104.GA7255@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building error for smbfs:

drivers/staging/smbfs/dir.c:286: error: static declaration of 'smbfs_dentry_operations' follows non-static declaration
drivers/staging/smbfs/proto.h:42: error: previous declaration of 'smbfs_dentry_operations' was here
drivers/staging/smbfs/dir.c:294: error: static declaration of 'smbfs_dentry_operations_case' follows non-static declaration
drivers/staging/smbfs/proto.h:41: error: previous declaration of 'smbfs_dentry_operations_case' was here
make[3]: *** [drivers/staging/smbfs/dir.o] Error 1
make[2]: *** [drivers/staging/smbfs] Error 2
make[1]: *** [drivers/staging] Error 2
make[1]: *** Waiting for unfinished jobs....

Fix it by removing static keywords

Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
---
 drivers/staging/smbfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/staging/smbfs/dir.c	2011-01-14 14:37:19.000000000 +0800
+++ linux-2.6/drivers/staging/smbfs/dir.c	2011-01-14 15:35:41.756037133 +0800
@@ -283,7 +283,7 @@ static int smb_compare_dentry(const stru
 		unsigned int, const char *, const struct qstr *);
 static int smb_delete_dentry(const struct dentry *);
 
-static const struct dentry_operations smbfs_dentry_operations =
+const struct dentry_operations smbfs_dentry_operations =
 {
 	.d_revalidate	= smb_lookup_validate,
 	.d_hash		= smb_hash_dentry,
@@ -291,7 +291,7 @@ static const struct dentry_operations sm
 	.d_delete	= smb_delete_dentry,
 };
 
-static const struct dentry_operations smbfs_dentry_operations_case =
+const struct dentry_operations smbfs_dentry_operations_case =
 {
 	.d_revalidate	= smb_lookup_validate,
 	.d_delete	= smb_delete_dentry,
