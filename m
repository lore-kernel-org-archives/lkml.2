Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136Ab2KVTYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:24:05 -0500
Received: from dupo.coraid.com ([208.71.232.133]:54701 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964976Ab2KVTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:24:03 -0500
Message-Id: <a5944abc848a1b8e5329a631a84e35a3b0249ecb.1353518444.git.ecashin@coraid.com>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 8/8] aoe: return real minor number for static minors
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 20:08:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value returned by the static minor device number number
allocator is the real minor number, so it must be multiplied by
the supported number of partitions per aoedev.

Without this fix the support for systems without udev is
incomplete, and the few users of aoe on such systems will have
surprising results when device nodes names do not match the AoE
target.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoedev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 80b3d3e..aaaea66 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -95,7 +95,7 @@ minor_get_static(ulong *sysminor, ulong aoemaj, int aoemin)
 	} else
 		set_bit(n, used_minors);
 	spin_unlock_irqrestore(&used_minors_lock, flags);
-	*sysminor = n;
+	*sysminor = n * AOE_PARTITIONS;
 out:
 	return error;
 }
-- 
1.7.1

