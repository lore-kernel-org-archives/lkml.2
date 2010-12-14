Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab0LNAtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:49:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:45804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717Ab0LNAtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:49:15 -0500
Date: Tue, 14 Dec 2010 00:48:56 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
References: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] bootmem: Add alloc_bootmem_align()
Message-ID: <tip-53dde5f385bc56e312f78b7cb25ffaf8efd4735d@git.kernel.org>
Git-Commit-ID: 53dde5f385bc56e312f78b7cb25ffaf8efd4735d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 00:48:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53dde5f385bc56e312f78b7cb25ffaf8efd4735d
Gitweb:     http://git.kernel.org/tip/53dde5f385bc56e312f78b7cb25ffaf8efd4735d
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 16 Nov 2010 13:23:50 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:11:13 -0800

bootmem: Add alloc_bootmem_align()

Add an alloc_bootmem_align() interface to allocate bootmem with
specified alignment.  This is necessary to be able to allocate the
xsave area in a subsequent patch.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org>
---
 include/linux/bootmem.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 266ab92..499dfe9 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -105,6 +105,8 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_align(x, align) \
+	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_nopanic(x) \
 	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages(x) \
