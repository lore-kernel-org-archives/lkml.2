Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2ATPPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:15:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51151 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2ATPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:15:18 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] percpu: use bitmap_clear
Date: Sat, 21 Jan 2012 00:15:23 +0900
Message-Id: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_clear rather than clearing individual bits in a memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/percpu-vm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 12a48a88..405d331 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -184,8 +184,7 @@ static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 				   page_end - page_start);
 	}
 
-	for (i = page_start; i < page_end; i++)
-		__clear_bit(i, populated);
+	bitmap_clear(populated, page_start, page_end - page_start);
 }
 
 /**
-- 
1.7.4.4

