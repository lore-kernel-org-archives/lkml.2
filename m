Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0EQGeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:34:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:60901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab0EQGeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:34:21 -0400
Date: Mon, 17 May 2010 06:34:06 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1273873281-17489-8-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273873281-17489-8-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: add nop functions to x86_init mpparse functions
Message-ID: <tip-fea24e28c663e62663097f0ed3b8ff1f9a87f15e@git.kernel.org>
Git-Commit-ID: fea24e28c663e62663097f0ed3b8ff1f9a87f15e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 06:34:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fea24e28c663e62663097f0ed3b8ff1f9a87f15e
Gitweb:     http://git.kernel.org/tip/fea24e28c663e62663097f0ed3b8ff1f9a87f15e
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Fri, 14 May 2010 14:41:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 May 2010 22:47:41 -0700

x86, mrst: add nop functions to x86_init mpparse functions

Moorestown does not have BIOS provided MP tables, we can save some time
by avoiding scaning of these tables. e.g.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c00bfff0 for 1024 bytes.

Searching EBDA with the base at 0x40E will also result in random pointer
deferencing within 1MB. This can be a problem in Lincroft if the pointer
hits VGA area and VGA mode is not enabled.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1273873281-17489-8-git-send-email-jacob.jun.pan@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/mrst.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 0aad867..e796448 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -237,4 +237,9 @@ void __init x86_mrst_early_setup(void)
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
 	legacy_pic = &null_legacy_pic;
+
+	/* Avoid searching for BIOS MP tables */
+	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
+
 }
