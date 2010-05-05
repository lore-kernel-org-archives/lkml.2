Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0EEVDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:03:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57956 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0EEVDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:03:13 -0400
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: mroberto@cpti.cetuc.puc-rio.br, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] MM: Fix NR_SECTION_ROOTS == 0 when using using sparsemem extreme.
Date: Wed,  5 May 2010 18:02:46 -0300
Message-Id: <1273093366-3388-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this while compiling for ARM/SA1100:

mm/sparse.c: In function '__section_nr':
mm/sparse.c:135: warning: 'root' is used uninitialized in this function

This patch follows Russell King's suggestion for a new calculation for
NR_SECTION_ROOTS. Thanks also to Sergei Shtylyov for pointing out the
existence of the macro DIV_ROUND_UP.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 include/linux/mmzone.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index cf9e458..e90ad64 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -972,7 +972,7 @@ struct mem_section {
 #endif
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
-#define NR_SECTION_ROOTS	(NR_MEM_SECTIONS / SECTIONS_PER_ROOT)
+#define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
 #define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-- 
1.7.1

