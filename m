Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2EPQDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab2EPQD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:03:27 -0400
Date: Wed, 16 May 2012 19:03:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5 1/4] apic: fix typo EIO_ACK -> EOI_ACK and document
Message-ID: <37867b31b9330690af2e60a2a7c4cb4b1b070caf.1337184153.git.mst@redhat.com>
References: <cover.1337184153.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337184153.git.mst@redhat.com>
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
MST

