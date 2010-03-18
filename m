Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0CRJIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:08:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60065 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0CRJH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tRRDsM2Lxs8RnPTeD8n62WTmsxRSuQLyKg8kgG7bUtWk1s2wViVSDD1lST7M6VeiAj
         gg4QEqVrgvzuOo7XHiP5eLjte6p1thhFioNSFKtDrc5mvYC9hMx2yuQuzHE1Z8hZ22vg
         uOhX+VyJtVtxEx+qCfz2Bw63PKkY6Etf89d5o=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org
Subject: [PATCH 07/12] slab: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:19 +0900
Message-Id: <1268903124-10237-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for slab.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: linux-mm@kvack.org
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index a9f325b..d57309e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1324,7 +1324,7 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
 		mutex_unlock(&cache_chain_mutex);
 		break;
 	}
-	return err ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __cpuinitdata cpucache_notifier = {
-- 
1.6.0.6

