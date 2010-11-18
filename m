Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0KREUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 23:20:18 -0500
Received: from mail4.comsite.net ([205.238.176.238]:11130 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0KREUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 23:20:16 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: ocfs2: char is not always signed
From: Milton Miller <miltonm@bga.com>
To: Tao Ma <tao.ma@oracle.com>, Joel Becker <joel.becker@oracle.com>,
        <ocfs2-devel@oss.oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, <linux-kernel@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 17 Nov 2010 22:20:11 -0600
X-Originating-IP: 71.22.127.106
Message-ID: <1290054011_17741@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1c66b360fe262 (Change some lock status member in ocfs2_lock_res
to char.)  states that these fields need to be signed due to comparision
to -1, but only changed the type from unsigned char to char.   However, it
is a compiler option if char is a signed or unsigned type.  Change these
fields to signed char so the code will work with all compilers.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
I did not look for other fields that might be char.  PowerPC compilers
default to unsigned char, and aparently arm does as well from a quick
google search, to name two examples.

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 1efea36..70dd3b1 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -159,9 +159,9 @@ struct ocfs2_lock_res {
 	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
 	unsigned int             l_ro_holders;
 	unsigned int             l_ex_holders;
-	char			 l_level;
-	char			 l_requested;
-	char			 l_blocking;
+	signed char		 l_level;
+	signed char		 l_requested;
+	signed char		 l_blocking;
 
 	/* Data packed - type enum ocfs2_lock_type */
 	unsigned char            l_type;
