Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab2GBLbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:31:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51973 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2GBLa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:30:59 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] NFC: Don't warn when closing uninitialized socket
Date: Mon,  2 Jul 2012 13:31:42 +0200
Message-Id: <1341228702-9924-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to close a NFC socket without initializing it first,
there's no need to warn about it.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 net/nfc/llcp/llcp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 5d503ee..cf84544 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -118,8 +118,6 @@ static void local_release(struct kref *ref)
 
 int nfc_llcp_local_put(struct nfc_llcp_local *local)
 {
-	WARN_ON(local == NULL);
-
 	if (local == NULL)
 		return 0;
 
-- 
1.7.8.6

