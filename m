Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0JTXIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:08:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:37499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0JTXIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:08:43 -0400
Date: Wed, 20 Oct 2010 23:07:43 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201010202255.o9KMtZXu009370@imap1.linux-foundation.org>
References: <201010202255.o9KMtZXu009370@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Enable ARCH_DMA_ADDR_T_64BIT with X86_64 || HIGHMEM64G
Message-ID: <tip-66f2b061546974b96b7b238a92ce89a87ecf0754@git.kernel.org>
Git-Commit-ID: 66f2b061546974b96b7b238a92ce89a87ecf0754
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 23:07:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66f2b061546974b96b7b238a92ce89a87ecf0754
Gitweb:     http://git.kernel.org/tip/66f2b061546974b96b7b238a92ce89a87ecf0754
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Wed, 20 Oct 2010 15:55:35 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Oct 2010 16:02:42 -0700

x86, mm: Enable ARCH_DMA_ADDR_T_64BIT with X86_64 || HIGHMEM64G

Set CONFIG_ARCH_DMA_ADDR_T_64BIT when we set dma_addr_t to 64 bits in
<asm/types.h>; this allows Kconfig decisions based on this property.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <201010202255.o9KMtZXu009370@imap1.linux-foundation.org>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..2924f4e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1148,6 +1148,9 @@ config X86_PAE
 config ARCH_PHYS_ADDR_T_64BIT
 	def_bool X86_64 || X86_PAE
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool X86_64 || HIGHMEM64G
+
 config DIRECT_GBPAGES
 	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
 	default y
