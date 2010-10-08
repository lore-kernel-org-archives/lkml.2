Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab0JHKAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:00:38 -0400
Received: from [150.82.175.143] ([150.82.175.143]:53858 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753665Ab0JHKAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:00:35 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 3/5] kvm: stop including asm-generic/bitops/le.h directly
Date: Fri,  8 Oct 2010 19:03:11 +0900
Message-Id: <1286532193-29814-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
References: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/bitops/le.h is only intended to be included directly from
asm-generic/bitops/ext2-non-atomic.h or asm-generic/bitops/minix-le.h
which implements generic ext2 or minix bit operations.

This stops including asm-generic/bitops/le.h directly and use ext2
non-atomic bit operations instead.

An alternative approach is introducing little endian bit operations
in linux/bitops.h. But it needs to touch more files than this change does.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org
---
 virt/kvm/kvm_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5186e72..780b71d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,7 +52,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm-generic/bitops/le.h>
 
 #include "coalesced_mmio.h"
 
@@ -1208,7 +1207,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		generic___set_le_bit(rel_gfn, memslot->dirty_bitmap);
+		ext2_set_bit(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
-- 
1.7.1.231.gd0b16

