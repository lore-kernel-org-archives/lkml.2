Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1KVPgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:36:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64407 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1KVPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:36:34 -0500
Message-ID: <1321976189.2474.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: [RFC, PATCH] slub: unfreeze_partials() uses a wrong param
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 16:36:29 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unfreeze_partials() calls add_partial(..., 1) while it should use 
DEACTIVATE_TO_TAIL or DEACTIVATE_TO_HEAD

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/mm/slub.c b/mm/slub.c
index 7d2a996..db060b6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1904,7 +1904,7 @@ static void unfreeze_partials(struct kmem_cache *s)
 				if (l == M_PARTIAL)
 					remove_partial(n, page);
 				else
-					add_partial(n, page, 1);
+					add_partial(n, page, DEACTIVATE_TO_HEAD);
 
 				l = m;
 			}


