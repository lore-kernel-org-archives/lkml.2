Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab2DYG1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:27:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52721 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2DYG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:27:12 -0400
MIME-Version: 1.0
Date: Wed, 25 Apr 2012 14:27:11 +0800
Message-ID: <CAHnt0GWDqsGsj_i1u3aRSMa1ie4EAhS9GN_D=m1jx5gk6nYgwg@mail.gmail.com>
Subject: A potential bug in mm/memblock.c?
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments please.   Thanks.

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
