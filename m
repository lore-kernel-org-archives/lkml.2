Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab0KLVjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:39:03 -0500
Received: from mail.perches.com ([173.55.12.10]:1028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944Ab0KLViS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:18 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Matt Porter <mporter@kernel.crashing.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] drivers/rapidio: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:38:01 -0800
Message-Id: <efa91e19d588948c8f338c13b932c97be07769d4.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/rapidio/rio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 7b5080c..5b7facd 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1162,8 +1162,8 @@ int __devinit rio_init_mports(void)
 					resource_size(&port->iores),
 					port->name)) {
 			printk(KERN_ERR
-			       "RIO: Error requesting master port region 0x%016llx-0x%016llx\n",
-			       (u64)port->iores.start, (u64)port->iores.end);
+			       "RIO: Error requesting master port region %pR\n",
+			       &port->iores);
 			rc = -ENOMEM;
 			goto out;
 		}
-- 
1.7.3.1.g432b3.dirty

