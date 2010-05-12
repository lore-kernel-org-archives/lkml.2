Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab0ELVS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:18:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab0ELVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=iTPZhAcy61QJvtzQXdyH+KtS/wXY+Mcd3BfI10wcZmMtuq378T2G55gfnGhmJ9SD3/
         nYE+CDXW8lLPM2sbvR61ArwLZDHsBW2Xadnb3n6otfHC8qHlYH5bwyz4fsBKA+9kHfQS
         NydOWhUQLjxA94dlAUy7iL+S5AFSzXvmXiLqs=
Date: Thu, 13 May 2010 01:20:27 +0400
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
To: joern@logfs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] lib/btree: Fix possible NULL pointer dereference
Message-ID: <20100512212026.GA5513@coldcone>
Reply-To: kirjanov@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mempool_alloc can return null in atomic case.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
diff --git a/lib/btree.c b/lib/btree.c
index 41859a8..542c904 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -95,7 +94,8 @@ static unsigned long *btree_node_alloc(struct btree_head *head, gfp_t gfp)
 	unsigned long *node;
 
 	node = mempool_alloc(head->mempool, gfp);
-	memset(node, 0, NODESIZE);
+	if (likely(node))
+		memset(node, 0, NODESIZE);
 	return node;
 }
 
