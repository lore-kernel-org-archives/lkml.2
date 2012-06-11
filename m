Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2FKMxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:53:13 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:54955 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2FKMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:53:09 -0400
X-Greylist: delayed 1918 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2012 08:53:09 EDT
Date: Mon, 11 Jun 2012 21:32:21 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: bhutchings@solarflare.com, grundler@parisc-linux.org, arnd@arndb.de,
        linux-net-drivers@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: [PATCH 4/4] KVM: Replace test_and_set_bit_le() in
 mark_page_dirty_in_slot() with set_bit_le()
Message-Id: <20120611213221.a48fc664.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp>
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
---
 virt/kvm/kvm_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 02cb440..560c502 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1485,8 +1485,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		/* TODO: introduce set_bit_le() and use it */
-		test_and_set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
-- 
1.7.5.4

