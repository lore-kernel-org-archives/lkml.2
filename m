Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab2FPDgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:36:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48101 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab2FPDgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:36:16 -0400
Message-ID: <1339817768.10000.2.camel@phoenix>
Subject: [PATCH] extcon: Fix wrong index in max8997_extcon_cable[]
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 16 Jun 2012 11:36:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the index of "Dock-desk" and "Dock-card" are the same.
Thus the latter one overrides the first one.
Then we have problem when calling extcon_find_cable_index() because
edev->supported_cable[7] only matches "Dock-card".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/extcon/extcon-max8997.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 23416e4..5ecf176 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -116,8 +116,8 @@ const char *max8997_extcon_cable[] = {
 	[5] = "Charge-downstream",
 	[6] = "MHL",
 	[7] = "Dock-desk",
-	[7] = "Dock-card",
-	[8] = "JIG",
+	[8] = "Dock-card",
+	[9] = "JIG",
 
 	NULL,
 };
-- 
1.7.9.5



