Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2DYIaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:30:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36203 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab2DYIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:30:20 -0400
MIME-Version: 1.0
Date: Wed, 25 Apr 2012 16:30:19 +0800
Message-ID: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com>
Subject: [BUG]memblock: fix overflow of array index
From: Peter Teoh <htmldeveloper@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the mismatch in signed and unsigned type assignment, which
potentially can lead to integer overflow bug.

Thanks.

Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

diff --git a/mm/memblock.c b/mm/memblock.c
index a44eab3..2c621c5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -553,8 +553,8 @@ void __init_memblock __next_free_mem_range(u64
*idx, int nid,
 {
      struct memblock_type *mem = &memblock.memory;
      struct memblock_type *rsv = &memblock.reserved;
-       int mi = *idx & 0xffffffff;
-       int ri = *idx >> 32;
+       unsigned int mi = *idx & 0xffffffff;
+       unsigned int ri = *idx >> 32;

      for ( ; mi < mem->cnt; mi++) {
              struct memblock_region *m = &mem->regions[mi];



--
Regards,
Peter Teoh
