Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2IIUDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:03:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:33180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab2IIUDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:03:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,126,1344236400"; 
   d="scan'208";a="200318663"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] compat_ioctl: Remove unused local typedef
Date: Sun,  9 Sep 2012 13:03:43 -0700
Message-Id: <1347221023-10841-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

gcc 4.8 always warns

fs/compat_ioctl.c: In function 'serial_struct_ioctl':
fs/compat_ioctl.c:609:38: warning: typedef 'SS' locally defined but not used [-Wunused-local-typedefs]
         typedef struct serial_struct SS;

Indeed that typedef is unused, so just remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/compat_ioctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index debdfe0..e6f11a3 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -606,7 +606,6 @@ struct serial_struct32 {
 static int serial_struct_ioctl(unsigned fd, unsigned cmd,
 			struct serial_struct32 __user *ss32)
 {
-        typedef struct serial_struct SS;
         typedef struct serial_struct32 SS32;
         int err;
         struct serial_struct ss;
-- 
1.7.7.6

