Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab1JRIwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:52:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33919 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab1JRIv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:51:58 -0400
Message-ID: <1318927906.25468.2.camel@phoenix>
Subject: [PATCH] unicore32: EXPORT_SYMBOL needs export.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, David Rientjes <rientjes@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 18 Oct 2011 16:51:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include export.h to fix below warning:

  CC      arch/unicore32/mm/init.o
arch/unicore32/mm/init.c:227: warning: data definition has no type or storage class
arch/unicore32/mm/init.c:227: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/unicore32/mm/init.c:227: warning: parameter names (without types) in function declaration

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next 20111014.
export.h only exist in Paul's tree now.
I think this patch should route via Paul's module.h splitup tree.

Axel
 arch/unicore32/mm/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index 2d3e711..3b379cd 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -20,6 +20,7 @@
 #include <linux/memblock.h>
 #include <linux/sort.h>
 #include <linux/dma-mapping.h>
+#include <linux/export.h>
 
 #include <asm/sections.h>
 #include <asm/setup.h>
-- 
1.7.5.4



