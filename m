Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2DWOEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:04:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab2DWOEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:04:07 -0400
Date: Mon, 23 Apr 2012 17:04:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/5] apic: fix typo EIO_ACK -> EOI_ACK and document
Message-ID: <18dd3fab74783fe2de4e1ff56795204c1be3fbf0.1334833141.git.mst@redhat.com>
References: <cover.1334833140.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1334833140.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in the macro name and document the
reason it has this value. Update users.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/apicdef.h         |    2 +-
 arch/x86/platform/visws/visws_quirks.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 134bba0..c46bb99 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -37,7 +37,7 @@
 #define		APIC_ARBPRI_MASK	0xFFu
 #define	APIC_PROCPRI	0xA0
 #define	APIC_EOI	0xB0
-#define		APIC_EIO_ACK		0x0
+#define		APIC_EOI_ACK		0x0 /* Docs say 0 for future compat. */
 #define	APIC_RRR	0xC0
 #define	APIC_LDR	0xD0
 #define		APIC_LDR_MASK		(0xFFu << 24)
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index c7abf13..94d8a39 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -445,7 +445,7 @@ static void ack_cobalt_irq(struct irq_data *data)
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	disable_cobalt_irq(data);
-	apic_write(APIC_EOI, APIC_EIO_ACK);
+	apic_write(APIC_EOI, APIC_EOI_ACK);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
-- 
1.7.9.111.gf3fb0

