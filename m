Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0JOE0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:26:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0JOE0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:26:04 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] types.h: define __aligned_u64 and expose to userspace
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jengelh@medozas.de, davem@davemloft.net,
        andi@firstfloor.org
Date: Fri, 15 Oct 2010 00:24:55 -0400
Message-ID: <20101015042455.12772.27482.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have a kernel internal type called aligned_u64 which aligns
__u64's on 8 bytes boundaries even on systems which would normally align
them on 4 byte boundaries.  This patch creates a new type __aligned_u64
which does the same thing but which is exposed to userspace rather than
being kernel internal.

Based-on-patch-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/types.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 01a082f..194e90b 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -178,6 +178,11 @@ typedef __u64 __bitwise __be64;
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
+/* this is a special 64bit data type that is 8-byte aligned */
+#define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_be64 __be64 __attribute__((aligned(8)))
+#define __aligned_le64 __le64 __attribute__((aligned(8)))
+
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;

