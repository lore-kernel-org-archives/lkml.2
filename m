Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2GOM55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 08:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2GOM4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:56:51 -0400
Date: Sun, 15 Jul 2012 15:56:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        gleb@redhat.com
Subject: [PATCH 3/3] Revert "apic: fix kvm build on UP without IOAPIC"
Message-ID: <879c167f131de93e1312c321a56444652d9934fc.1342356186.git.mst@redhat.com>
References: <cover.1342356186.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342356186.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f9808b7fd422b965cea52e05ba470e0a473c53d3.
After commit 'kvm: switch to apic_set_eoi_write, apic_write'
the stubs are no longer needed as kvm does not look at apicdrivers anymore.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/apic.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ff8dff6..839b8f5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -417,12 +417,7 @@ extern struct apic *apic;
 	__aligned(sizeof(struct apic *))				\
 	__section(.apicdrivers) = { &sym1, &sym2 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
 extern struct apic *__apicdrivers[], *__apicdrivers_end[];
-#else
-#define __apicdrivers ((struct apic **)NULL)
-#define __apicdrivers_end ((struct apic **)NULL)
-#endif
 
 /*
  * APIC functionality to boot other CPUs - only used on SMP:
-- 
MST
