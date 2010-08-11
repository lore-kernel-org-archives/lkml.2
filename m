Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab0HKHoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:44:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:45519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0HKHoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:44:37 -0400
Date: Wed, 11 Aug 2010 07:44:12 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1281508661-29507-1-git-send-email-namhyung@gmail.com>
References: <1281508661-29507-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Document __phys_reloc_hide() usage in __pa_symbol()
Message-ID: <tip-8fd49936a8cac246fc9ed85508556c82cd44cf68@git.kernel.org>
Git-Commit-ID: 8fd49936a8cac246fc9ed85508556c82cd44cf68
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:44:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fd49936a8cac246fc9ed85508556c82cd44cf68
Gitweb:     http://git.kernel.org/tip/8fd49936a8cac246fc9ed85508556c82cd44cf68
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 11 Aug 2010 15:37:41 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Aug 2010 08:43:49 +0200

x86: Document __phys_reloc_hide() usage in __pa_symbol()

Until all supported versions of gcc recognize
-fno-strict-overflow, we should keep the RELOC_HIDE() magic in
__pa_symbol(). Comment it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
LKML-Reference: <1281508661-29507-1-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/page.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 625c3f0..8ca8283 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -37,6 +37,13 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 #define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
+/*
+ * We need __phys_reloc_hide() here because gcc may assume that there is no
+ * overflow during __pa() calculation and can optimize it unexpectedly.
+ * Newer versions of gcc provide -fno-strict-overflow switch to handle this
+ * case properly. Once all supported versions of gcc understand it, we can
+ * remove this Voodoo magic stuff. (i.e. once gcc3.x is deprecated)
+ */
 #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
 
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
