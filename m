Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0LIMGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:06:33 -0500
Received: from mail.atmel.fr ([81.80.104.162]:45302 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0LIMGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:06:31 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH] scatterlist: Initialize the dma_address field with invalid dma address
Date: Thu,  9 Dec 2010 14:15:14 +0100
Message-Id: <1291900514-7290-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the the dma_address field so that it will be possible to test
its value while using scatterlists. This field will be compatible with
testing by dma_mapping_error().

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi,

I wonder why this field is not initialized in the scatterlist: is it
intentional and is there a different way to check if dma_address is a
valid field?

 lib/scatterlist.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 4ceb05d..ca69409 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -85,6 +85,7 @@ EXPORT_SYMBOL(sg_last);
 void sg_init_table(struct scatterlist *sgl, unsigned int nents)
 {
 	memset(sgl, 0, sizeof(*sgl) * nents);
+	sgl->dma_address = (~(dma_addr_t)0);
 #ifdef CONFIG_DEBUG_SG
 	{
 		unsigned int i;
-- 
1.7.3

