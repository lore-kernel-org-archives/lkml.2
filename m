Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1KJStr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:49:47 -0500
Received: from www17.your-server.de ([213.133.104.17]:41606 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1KJSto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:49:44 -0500
Message-ID: <1320950975.20155.115.camel@localhost.localdomain>
Subject: [PATCH] dlm: Use kmemdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 19:49:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
--- a/fs/dlm/lowcomms.c 2011-11-07 19:38:22.277139918 +0100
+++ b/fs/dlm/lowcomms.c 2011-11-08 10:35:11.176833032 +0100
@@ -1086,10 +1086,9 @@ static void init_local(void)
 		if (dlm_our_addr(&sas, i))
 			break;
 
-		addr = kmalloc(sizeof(*addr), GFP_NOFS);
+		addr = kmemdup(&sas, sizeof(*addr), GFP_NOFS);
 		if (!addr)
 			break;
-		memcpy(addr, &sas, sizeof(*addr));
 		dlm_local_addr[dlm_local_count++] = addr;
 	}
 }


