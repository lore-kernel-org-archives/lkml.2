Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2DWOEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab2DWOER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:04:17 -0400
Date: Mon, 23 Apr 2012 17:04:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 2/5] apic: use symbolic APIC_EOI_ACK
Message-ID: <163b773ea778c591c03e7b19ea7284db045317a5.1334833141.git.mst@redhat.com>
References: <cover.1334833140.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1334833140.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the symbol instead of hard-coded numbers,
now that the reason for the value is documented
where the constant is defined we don't need to
duplicate this explanation in code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/apic.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d854101..a09e9ab 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -463,9 +463,7 @@ static inline void ack_APIC_irq(void)
 	 * ack_APIC_irq() actually gets compiled as a single instruction
 	 * ... yummie.
 	 */
-
-	/* Docs say use 0 for future compatibility */
-	apic_write(APIC_EOI, 0);
+	apic_write(APIC_EOI, APIC_EOI_ACK);
 }
 
 static inline unsigned default_get_apic_id(unsigned long x)
-- 
1.7.9.111.gf3fb0

