Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab0HEWg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:36:58 -0400
Received: from kroah.org ([198.145.64.141]:37708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760855Ab0HEWYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Marin Mitov <mitov@issp.bas.bg>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/28] Driver core: internal struct dma_coherent_mem, change type of a member.
Date: Thu,  5 Aug 2010 15:23:55 -0700
Message-Id: <1281047058-23716-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marin Mitov <mitov@issp.bas.bg>

struct dma_coherent_mem in drivers/base/dma-coherent.c
has member 'device_base' that is of type u32,
but is assigned value of type dma_addr_t, which may be
64 bits for x86_64. Change the type to dma_addr_t.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dma-coherent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index d4d8ce5..f369e27 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -8,7 +8,7 @@
 
 struct dma_coherent_mem {
 	void		*virt_base;
-	u32		device_base;
+	dma_addr_t	device_base;
 	int		size;
 	int		flags;
 	unsigned long	*bitmap;
-- 
1.7.2

