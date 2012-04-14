Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2DNJsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:48:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35820 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2DNJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:48:22 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        Jens Axboe <axboe@kernel.dk>, Dan Carpenter <dan.carpenter@oracle.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] CodingStyle: add kmalloc_array() to memory allocators
Date: Sat, 14 Apr 2012 05:48:14 -0400
Message-Id: <1334396894-27176-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new kmalloc_array() to the list of general-purpose memory
allocators in chapter 14.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
---
 Documentation/CodingStyle |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index c58b236..cb9258b 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -671,8 +671,9 @@ ones already enabled by DEBUG.
 		Chapter 14: Allocating memory
 
 The kernel provides the following general purpose memory allocators:
-kmalloc(), kzalloc(), kcalloc(), vmalloc(), and vzalloc().  Please refer to
-the API documentation for further information about them.
+kmalloc(), kzalloc(), kmalloc_array(), kcalloc(), vmalloc(), and
+vzalloc().  Please refer to the API documentation for further information
+about them.
 
 The preferred form for passing a size of a struct is the following:
 
@@ -686,6 +687,17 @@ Casting the return value which is a void pointer is redundant. The conversion
 from void pointer to any other pointer type is guaranteed by the C programming
 language.
 
+The preferred form for allocating an array is the following:
+
+	p = kmalloc_array(n, sizeof(...), ...);
+
+The preferred form for allocating a zeroed array is the following:
+
+	p = kcalloc(n, sizeof(...), ...);
+
+Both forms check for overflow on the allocation size n * sizeof(...),
+and return NULL if that occurred.
+
 
 		Chapter 15: The inline disease
 
-- 
1.7.5.4

