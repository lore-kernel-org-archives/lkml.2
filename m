Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0LTQXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:23:39 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:53872 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab0LTQXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:23:38 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add forward declaration of struct device
Date: Mon, 20 Dec 2010 17:23:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.2-desktop; KDE/4.5.3; x86_64; ; )
Cc: Dan Williams <dan.j.williams@intel.com>, trivial@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201012201723.30133.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes this warning when including linux/dmapool.h first:

warning: ‘struct device’ declared inside parameter list
warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 include/linux/dmapool.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmapool.h b/include/linux/dmapool.h
index 022e34f..52456aa 100644
--- a/include/linux/dmapool.h
+++ b/include/linux/dmapool.h
@@ -14,6 +14,8 @@
 #include <asm/io.h>
 #include <asm/scatterlist.h>
 
+struct device;
+
 struct dma_pool *dma_pool_create(const char *name, struct device *dev, 
 			size_t size, size_t align, size_t allocation);
 
-- 
1.6.4.2

