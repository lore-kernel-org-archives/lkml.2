Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab1FQI5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:57:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1FQI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:18 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] valid_phys_addr_range: use phys_addr_t for the @addr parameter
Date: Fri, 17 Jun 2011 10:45:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171045.58576.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct type for physical addresses is phys_addr_t. This is in
fact needed to check 64-bit physical addresses on 32-bit architectures
(such as i386 PAE).

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 drivers/char/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 7d86bda..cbbaf36 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -45,7 +45,7 @@ static inline unsigned long size_inside_page(unsigned long start,
 }
 
 #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
-static inline int valid_phys_addr_range(unsigned long addr, size_t count)
+static inline int valid_phys_addr_range(phys_addr_t addr, size_t count)
 {
 	return addr + count <= __pa(high_memory);
 }
-- 
1.7.3.4
