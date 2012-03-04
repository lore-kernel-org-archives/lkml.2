Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2CDCJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 21:09:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2CDCJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 21:09:18 -0500
Date: Sat, 3 Mar 2012 18:07:28 -0800
From: tip-bot for Jiri Kosina <jkosina@suse.cz>
Message-ID: <tip-e37aade31601cdb9f078f6663cbf887f391bb110@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkosina@suse.cz, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jkosina@suse.cz
In-Reply-To: <alpine.LNX.2.00.1202281614450.31150@pobox.suse.cz>
References: <alpine.LNX.2.00.1202281614450.31150@pobox.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, memblock: Move mem_hole_size() to .init
Git-Commit-ID: e37aade31601cdb9f078f6663cbf887f391bb110
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 03 Mar 2012 18:07:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e37aade31601cdb9f078f6663cbf887f391bb110
Gitweb:     http://git.kernel.org/tip/e37aade31601cdb9f078f6663cbf887f391bb110
Author:     Jiri Kosina <jkosina@suse.cz>
AuthorDate: Tue, 28 Feb 2012 16:16:33 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 3 Mar 2012 15:51:20 -0800

x86, memblock: Move mem_hole_size() to .init

mem_hole_size() is being called only from __init-marked functions, and as
such should be moved to .init section as well. Fixes this warning:

WARNING: vmlinux.o(.text+0x35511): Section mismatch in reference from the function mem_hole_size() to the function .init.text:absent_pages_in_range()

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1202281614450.31150@pobox.suse.cz
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
