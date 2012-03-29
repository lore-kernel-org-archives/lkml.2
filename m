Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934992Ab2C3VGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:06:11 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934877Ab2C3VFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:55 -0400
Message-Id: <201203302105.q2UL56hT006296@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:44:10 -0400
Subject: [PATCH] arch/tile: don't leak kernel memory when we unload modules
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>, Jonas Bonn <jonas@southpole.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:06.0350 (UTC) FILETIME=[C87514E0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were failing to track the memory when we allocated it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index bb2dc1e..001cbfa 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -67,6 +67,8 @@ void *module_alloc(unsigned long size)
 	area = __get_vm_area(size, VM_ALLOC, MEM_MODULE_START, MEM_MODULE_END);
 	if (!area)
 		goto error;
+	area->nr_pages = npages;
+	area->pages = pages;
 
 	if (map_vm_area(area, prot_rwx, &pages)) {
 		vunmap(area->addr);
-- 
1.6.5.2

