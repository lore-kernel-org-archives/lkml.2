Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2EKEig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:38:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40182 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2EKEie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:38:34 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] usb: gadget: dummy_hcd: fix build when BUG is not set
Date: Fri, 11 May 2012 06:39:37 +0200
Message-Id: <1336711177-26826-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use WARN_ON() instead of __WARN, which also means we won't use any
internal macros.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/usb/gadget/dummy_hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 83bb2e3..b799106 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -598,7 +598,7 @@ static void dummy_free_request(struct usb_ep *_ep, struct usb_request *_req)
 	struct dummy_request	*req;
 
 	if (!_ep || !_req) {
-		__WARN();
+		WARN_ON(1);
 		return;
 	}
 
-- 
1.7.8.5

