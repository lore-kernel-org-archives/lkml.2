Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0EaKAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:00:20 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:45179 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab0EaKAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:00:18 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH]internal struct dma_coherent_mem, change type of a member.
Date: Mon, 31 May 2010 13:03:04 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005311303.04788.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

struct dma_coherent_mem in drivers/base/dma-coherent.c
has member 'device_base' that is of type u32,
but is assigned value of type dma_addr_t, which may be 
64 bits for x86_64. Change the type to dma_addr_t.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

==================================================================
--- a/drivers/base/dma-coherent.c	2010-05-31 11:28:35.000000000 +0300
+++ b/drivers/base/dma-coherent.c	2010-05-31 11:29:43.000000000 +0300
@@ -8,7 +8,7 @@
 
 struct dma_coherent_mem {
 	void		*virt_base;
-	u32		device_base;
+	dma_addr_t	device_base;
 	int		size;
 	int		flags;
 	unsigned long	*bitmap;
