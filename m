Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533Ab2B1PQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:16:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965090Ab2B1PQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:16:35 -0500
Date: Tue, 28 Feb 2012 16:16:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] x86: memblock: move mem_hole_size() to .init
Message-ID: <alpine.LNX.2.00.1202281614450.31150@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_hole_size() is being called only from __init-marked functions, and as 
such should be moved to .init section as well. Fixes this warning:

WARNING: vmlinux.o(.text+0x35511): Section mismatch in reference from the function mem_hole_size() to the function .init.text:absent_pages_in_range()

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/mm/numa_emulation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 46db568..2fff651 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -28,7 +28,7 @@ static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
 	return -ENOENT;
 }
 
-static u64 mem_hole_size(u64 start, u64 end)
+static u64 __init mem_hole_size(u64 start, u64 end)
 {
 	unsigned long start_pfn = PFN_UP(start);
 	unsigned long end_pfn = PFN_DOWN(end);
-- 
1.7.3.1

