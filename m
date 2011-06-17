Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab1FQI5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:57:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374Ab1FQI5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:17 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] (un)xlate_dev_mem_ptr: use phys_addr_t for the @phys parameter
Date: Fri, 17 Jun 2011 10:44:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171044.25005.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To read/write 64-bit physical addresses on 32-bit architectures,
the type must be changed to phys_addr_t. It is also semantically
more exact.

Note that the default xlate_dev_mem_ptr() is defined as a macro,
so no adjustment is needed there.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 drivers/char/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f5cbd4e..7d86bda 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -82,7 +82,7 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 }
 #endif
 
-void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+void __weak unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 {
 }
 
-- 
1.7.3.4
