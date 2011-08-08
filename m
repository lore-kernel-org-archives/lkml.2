Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1HHPlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:41:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55365 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1HHPlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:41:11 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: abelay@mit.edu, bhelgaas@google.com,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] pnp: replace deprecated __check_region to request_region
Date: Mon,  8 Aug 2011 23:38:21 +0800
Message-Id: <1312817901-5313-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

The function __check_region is deprecated, use proper function request_region to replace it.

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/pnp/resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index b0ecacb..b1d8cae 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -179,7 +179,7 @@ int pnp_check_port(struct pnp_dev *dev, struct resource *res)
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
-		if (__check_region(&ioport_resource, *port, length(port, end)))
+		if (!request_region(*port, length(port, end), "pnp"))
 			return 0;
 	}
 
-- 
1.7.0.4

