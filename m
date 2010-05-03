Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0ECHok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 03:44:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:43761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0ECHoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 03:44:37 -0400
Date: Mon, 3 May 2010 07:44:02 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, konrad.wilk@oracle.com, liang.li@windriver.com,
       wangchen@cn.fujitsu.com, jeremy.fitzhardinge@citrix.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       liang.li@windriver.com, konrad.wilk@oracle.com, yinghai@kernel.org,
       wangchen@cn.fujitsu.com, jeremy.fitzhardinge@citrix.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
References: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix parse_reservetop() build failure on certain configs
Message-ID: <tip-56f0e74c9cf98941af700b61466648a2d06277bb@git.kernel.org>
Git-Commit-ID: 56f0e74c9cf98941af700b61466648a2d06277bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 07:44:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56f0e74c9cf98941af700b61466648a2d06277bb
Gitweb:     http://git.kernel.org/tip/56f0e74c9cf98941af700b61466648a2d06277bb
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 3 May 2010 09:19:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 3 May 2010 09:22:19 +0200

x86: Fix parse_reservetop() build failure on certain configs

Commit e67a807 ("x86: Fix 'reservetop=' functionality") added a
fixup_early_ioremap() call to parse_reservetop() and declared it
in io.h.

But asm/io.h was only included indirectly - and on some configs
not at all, causing a build failure on those configs.

Cc: Liang Li <liang.li@windriver.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pgtable_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 26eadaa..7928540 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -18,6 +18,7 @@
 #include <asm/e820.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/io.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
