Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab2FCH26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 03:28:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2FCH15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 03:27:57 -0400
Date: Sun, 3 Jun 2012 10:27:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv6 1/8] kvm: document lapic regs field
Message-ID: <b85d91d1e48a7c7531ba07075d81bb18bfdb00c1.1338474301.git.mst@redhat.com>
References: <cover.1338474301.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1338474301.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic in find_highest_vector looks
strange until you realize the reason for the
weird memory layout, which is because this is
what the CPU microcode expects.

Add a comment so this stops tripping people up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/lapic.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6f4ce25..d29da25 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -13,6 +13,11 @@ struct kvm_lapic {
 	u32 divide_count;
 	struct kvm_vcpu *vcpu;
 	bool irr_pending;
+	/**
+	 * APIC register page.  The layout matches the register layout seen by
+	 * the guest 1:1, because it is accessed by the vmx microcode.
+	 * Note: Only one register, the TPR, is used by the microcode.
+	 */
 	void *regs;
 	gpa_t vapic_addr;
 	struct page *vapic_page;
-- 
MST

