Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab0HBXnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:43:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:36725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab0HBXnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:43:07 -0400
Date: Mon, 2 Aug 2010 23:42:46 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        shaohua.li@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, shaohua.li@intel.com, hpa@linux.intel.com
In-Reply-To: <20100802004934.GA2505@sli10-desk.sh.intel.com>
References: <20100802004934.GA2505@sli10-desk.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Unmap vdso pages
Message-ID: <tip-be783a47214afc5a0aea9dafcbd9f1535ba05e94@git.kernel.org>
Git-Commit-ID: be783a47214afc5a0aea9dafcbd9f1535ba05e94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 23:42:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be783a47214afc5a0aea9dafcbd9f1535ba05e94
Gitweb:     http://git.kernel.org/tip/be783a47214afc5a0aea9dafcbd9f1535ba05e94
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Mon, 2 Aug 2010 08:49:34 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 2 Aug 2010 15:11:59 -0700

x86, vdso: Unmap vdso pages

We mapped vdso pages but never unmapped them and the virtual address
is lost after exiting from the function, so unmap vdso pages here.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <20100802004934.GA2505@sli10-desk.sh.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ac74869..80f23ed 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -67,6 +67,7 @@ static int __init init_vdso_vars(void)
 	*(typeof(__ ## x) **) var_ref(VDSO64_SYMBOL(vbase, x), #x) = &__ ## x;
 #include "vextern.h"
 #undef VEXTERN
+	vunmap(vbase);
 	return 0;
 
  oom:
