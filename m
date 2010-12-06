Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0LFXZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26941 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0LFXZN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 23/23] agp/generic: Set the dma_addr[i] to DMA_ERROR_CODE
Date: Mon,  6 Dec 2010 18:24:35 -0500
Message-Id: <1291677875-30493-24-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the dma_addr[i] to DMA_ERROR_CODE so it will be the
responsibility of the caller to set the dma_addr[i] to the right
value. Currently the callers that would utililize this are then ones
that set the type to AGP_USER_TYPES are the TTM and DRM APIs.


Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/generic.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 534dccb..77ff3bd 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1221,8 +1221,10 @@ struct agp_memory *agp_generic_alloc_user(size_t page_count, int type)
 	if (new == NULL)
 		return NULL;
 
-	for (i = 0; i < page_count; i++)
+	for (i = 0; i < page_count; i++) {
 		new->pages[i] = NULL;
+		new->dma_addr[i] = DMA_ERROR_CODE;
+	}
 	new->page_count = 0;
 	new->type = type;
 	new->num_scratch_pages = pages;
-- 
1.7.1

