Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2DRACz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:02:55 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:58968 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752408Ab2DRACx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:02:53 -0400
Message-ID: <4F8E04D2.7070708@xenotime.net>
Date: Tue, 17 Apr 2012 17:03:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] driver core: fix dma-buf.c kernel-doc warnings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warnings in dma-buf.c:

Warning(drivers/base/dma-buf.c:305): No description found for parameter 'dmabuf'
Warning(drivers/base/dma-buf.c:305): Excess function parameter 'dma_buf' description in 'dma_buf_begin_cpu_access'
Warning(drivers/base/dma-buf.c:332): No description found for parameter 'dmabuf'
Warning(drivers/base/dma-buf.c:332): Excess function parameter 'dma_buf' description in 'dma_buf_end_cpu_access'
Warning(drivers/base/dma-buf.c:350): No description found for parameter 'dmabuf'
Warning(drivers/base/dma-buf.c:350): Excess function parameter 'dma_buf' description in 'dma_buf_kmap_atomic'
Warning(drivers/base/dma-buf.c:367): No description found for parameter 'dmabuf'
Warning(drivers/base/dma-buf.c:367): Excess function parameter 'dma_buf' description in 'dma_buf_kunmap_atomic'
Warning(drivers/base/dma-buf.c:385): No description found for parameter 'dmabuf'
Warning(drivers/base/dma-buf.c:385): Excess function parameter 'dma_buf' description in 'dma_buf_kmap'
Warning(drivers/base/dma-buf.c:402): No description found for parameter 'dmabuf'
Warning(drivers/base/dma-buf.c:402): Excess function parameter 'dma_buf' description in 'dma_buf_kunmap'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/base/dma-buf.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- lnx-34-rc3.orig/drivers/base/dma-buf.c
+++ lnx-34-rc3/drivers/base/dma-buf.c
@@ -293,7 +293,7 @@ EXPORT_SYMBOL_GPL(dma_buf_unmap_attachme
  * cpu in the kernel context. Calls begin_cpu_access to allow exporter-specific
  * preparations. Coherency is only guaranteed in the specified range for the
  * specified access direction.
- * @dma_buf:	[in]	buffer to prepare cpu access for.
+ * @dmabuf:	[in]	buffer to prepare cpu access for.
  * @start:	[in]	start of range for cpu access.
  * @len:	[in]	length of range for cpu access.
  * @direction:	[in]	length of range for cpu access.
@@ -320,7 +320,7 @@ EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_acce
  * cpu in the kernel context. Calls end_cpu_access to allow exporter-specific
  * actions. Coherency is only guaranteed in the specified range for the
  * specified access direction.
- * @dma_buf:	[in]	buffer to complete cpu access for.
+ * @dmabuf:	[in]	buffer to complete cpu access for.
  * @start:	[in]	start of range for cpu access.
  * @len:	[in]	length of range for cpu access.
  * @direction:	[in]	length of range for cpu access.
@@ -340,7 +340,7 @@ EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access
 /**
  * dma_buf_kmap_atomic - Map a page of the buffer object into kernel address
  * space. The same restrictions as for kmap_atomic and friends apply.
- * @dma_buf:	[in]	buffer to map page from.
+ * @dmabuf:	[in]	buffer to map page from.
  * @page_num:	[in]	page in PAGE_SIZE units to map.
  *
  * This call must always succeed, any necessary preparations that might fail
@@ -356,7 +356,7 @@ EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
 
 /**
  * dma_buf_kunmap_atomic - Unmap a page obtained by dma_buf_kmap_atomic.
- * @dma_buf:	[in]	buffer to unmap page from.
+ * @dmabuf:	[in]	buffer to unmap page from.
  * @page_num:	[in]	page in PAGE_SIZE units to unmap.
  * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap_atomic.
  *
@@ -375,7 +375,7 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic)
 /**
  * dma_buf_kmap - Map a page of the buffer object into kernel address space. The
  * same restrictions as for kmap and friends apply.
- * @dma_buf:	[in]	buffer to map page from.
+ * @dmabuf:	[in]	buffer to map page from.
  * @page_num:	[in]	page in PAGE_SIZE units to map.
  *
  * This call must always succeed, any necessary preparations that might fail
@@ -391,7 +391,7 @@ EXPORT_SYMBOL_GPL(dma_buf_kmap);
 
 /**
  * dma_buf_kunmap - Unmap a page obtained by dma_buf_kmap.
- * @dma_buf:	[in]	buffer to unmap page from.
+ * @dmabuf:	[in]	buffer to unmap page from.
  * @page_num:	[in]	page in PAGE_SIZE units to unmap.
  * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap.
  *
