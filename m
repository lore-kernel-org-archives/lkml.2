Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab1C3VVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:21:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:41846 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965087Ab1C3VJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278973"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mijinlong@cn.fujitsu.com, bhalevy@panasas.com, bfields@redhat.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [231/275] nfsd41: modify the members value of nfsd4_op_flags
Message-Id: <20110330210756.E6E773E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mi Jinlong <mijinlong@cn.fujitsu.com>

commit 5ece3cafbd88d4da5c734e1810c4a2e6474b57b2 upstream.

The members of nfsd4_op_flags, (ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS)
equals to  ALLOWED_AS_FIRST_OP, maybe that's not what we want.

OP_PUTROOTFH with op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
can't appears as the first operation with out SEQUENCE ops.

This patch modify the wrong value of ALLOWED_WITHOUT_FH etc which
was introduced by f9bb94c4.

Reviewed-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Mi Jinlong <mijinlong@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfsd/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/nfsd/nfs4proc.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfsd/nfs4proc.c	2011-03-29 22:50:22.719677080 -0700
+++ linux-2.6.35.y/fs/nfsd/nfs4proc.c	2011-03-29 23:03:03.035222507 -0700
@@ -954,8 +954,8 @@
 			      void *);
 enum nfsd4_op_flags {
 	ALLOWED_WITHOUT_FH = 1 << 0,	/* No current filehandle required */
-	ALLOWED_ON_ABSENT_FS = 2 << 0,	/* ops processed on absent fs */
-	ALLOWED_AS_FIRST_OP = 3 << 0,	/* ops reqired first in compound */
+	ALLOWED_ON_ABSENT_FS = 1 << 1,	/* ops processed on absent fs */
+	ALLOWED_AS_FIRST_OP = 1 << 2,	/* ops reqired first in compound */
 };
 
 struct nfsd4_operation {
