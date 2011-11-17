Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab1KQTbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:31:07 -0500
Received: from re04.intra2net.com ([82.165.46.26]:46431 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1KQTbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:31:06 -0500
Message-ID: <4EC560F6.9050906@intra2net.com>
Date: Thu, 17 Nov 2011 20:31:02 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix comparison using wrong pointer variable in dma debug
 code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reported:
[lib/dma-debug.c:248] -> [lib/dma-debug.c:248]: (style) Same expression on both sides of '=='.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 lib/dma-debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 74c6c7f..fea790a 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -245,7 +245,7 @@ static void put_hash_bucket(struct hash_bucket *bucket,
 
 static bool exact_match(struct dma_debug_entry *a, struct dma_debug_entry *b)
 {
-	return ((a->dev_addr == a->dev_addr) &&
+	return ((a->dev_addr == b->dev_addr) &&
 		(a->dev == b->dev)) ? true : false;
 }
 
-- 
1.7.6.4

