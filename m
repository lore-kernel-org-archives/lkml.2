Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab0GOPMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:12:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59995 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933421Ab0GOPMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:12:49 -0400
Subject: [PATCH 1/3] kmemleak: Show more information for objects found by
 alias
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 15 Jul 2010 16:09:02 +0100
Message-ID: <20100715150901.21793.2120.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com>
References: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 15:09:02.0284 (UTC) FILETIME=[A8B750C0:01CB242F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be situations when an object is freed using a pointer inside
the memory block. Kmemleak should show more information to help with
debugging.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/kmemleak.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..c2c9feb 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -398,7 +398,9 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
 		object = prio_tree_entry(node, struct kmemleak_object,
 					 tree_node);
 		if (!alias && object->pointer != ptr) {
-			kmemleak_warn("Found object by alias");
+			pr_warning("Found object by alias at 0x%08lx\n", ptr);
+			dump_stack();
+			dump_object_info(object);
 			object = NULL;
 		}
 	} else

