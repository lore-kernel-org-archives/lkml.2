Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2HGLNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:13:08 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:51022 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HGLNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:13:06 -0400
Date: Tue, 7 Aug 2012 20:12:32 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: bhutchings@solarflare.com, grundler@parisc-linux.org, arnd@arndb.de,
        benh@kernel.crashing.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 5/5] KVM: Replace test_and_set_bit_le() in
 mark_page_dirty_in_slot() with set_bit_le()
Message-Id: <20120807201232.30aa6242.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120807200759.26ca8faa.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120807200759.26ca8faa.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

Now that we have defined generic set_bit_le() we do not need to use
test_and_set_bit_le() for atomically setting a bit.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
---
 virt/kvm/kvm_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a2e85af..b983f23 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1440,8 +1440,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		/* TODO: introduce set_bit_le() and use it */
-		test_and_set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
-- 
1.7.5.4

