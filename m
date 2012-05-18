Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031093Ab2ERKps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:45:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab2ERKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:45:44 -0400
Date: Fri, 18 May 2012 03:45:33 -0700
From: "tip-bot for Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <tip-4ebcc243901c48ee3baba6bdf179c7315fa8806f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, mst@redhat.com, mtosatti@redhat.com,
        tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, mtosatti@redhat.com,
        tglx@linutronix.de, avi@redhat.com
In-Reply-To: <ecbe4c79d69c172378e47e5a587ff5cd10293c9f.1337184153.git.mst@redhat.com>
References: <ecbe4c79d69c172378e47e5a587ff5cd10293c9f.1337184153.git.mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Use symbolic APIC_EOI_ACK
Git-Commit-ID: 4ebcc243901c48ee3baba6bdf179c7315fa8806f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:45:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ebcc243901c48ee3baba6bdf179c7315fa8806f
Gitweb:     http://git.kernel.org/tip/4ebcc243901c48ee3baba6bdf179c7315fa8806f
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Wed, 16 May 2012 19:03:44 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 09:46:08 +0200

x86/apic: Use symbolic APIC_EOI_ACK

Use the symbol instead of hard-coded numbers,
now that the reason for the value is documented
where the constant is defined we don't need to
duplicate this explanation in code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: gleb@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/ecbe4c79d69c172378e47e5a587ff5cd10293c9f.1337184153.git.mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
