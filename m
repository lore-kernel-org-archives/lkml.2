Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab0JYSor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759378Ab0JYSm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:42:57 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 04/11] IMA: convert internal flags from long to char
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:41:39 -0400
Message-ID: <20101025184139.20504.46804.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA flags is an unsigned long but there is only 1 flag defined.  Lets
save a little space and make it a char.  This packs nicely next to the array
of u8's.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 000d13a..f7af011 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -96,14 +96,14 @@ static inline unsigned long ima_hash_key(u8 *digest)
 }
 
 /* iint cache flags */
-#define IMA_MEASURED		1
+#define IMA_MEASURED		0x01
 
 /* integrity data associated with an inode */
 struct ima_iint_cache {
 	struct rb_node rb_node; /* rooted in ima_iint_tree */
 	struct inode *inode;	/* back pointer to inode in question */
 	u64 version;		/* track inode changes */
-	unsigned long flags;
+	unsigned char flags;
 	u8 digest[IMA_DIGEST_SIZE];
 	struct mutex mutex;	/* protects: version, flags, digest */
 	unsigned int readcount;	/* measured files readcount */

