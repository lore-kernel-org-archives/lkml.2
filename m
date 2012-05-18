Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab2ERKo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:44:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2ERKoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:44:54 -0400
Date: Fri, 18 May 2012 03:44:43 -0700
From: "tip-bot for Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <tip-c8f64bf7df9e4858c051b6c1c09582359b97677d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, mst@redhat.com, mtosatti@redhat.com,
        tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, mtosatti@redhat.com,
        tglx@linutronix.de, avi@redhat.com
In-Reply-To: <37867b31b9330690af2e60a2a7c4cb4b1b070caf.1337184153.git.mst@redhat.com>
References: <37867b31b9330690af2e60a2a7c4cb4b1b070caf.1337184153.git.mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Fix typo EIO_ACK ->
  EOI_ACK and document it
Git-Commit-ID: c8f64bf7df9e4858c051b6c1c09582359b97677d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:44:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8f64bf7df9e4858c051b6c1c09582359b97677d
Gitweb:     http://git.kernel.org/tip/c8f64bf7df9e4858c051b6c1c09582359b97677d
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Wed, 16 May 2012 19:03:25 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 09:46:07 +0200

x86/apic: Fix typo EIO_ACK -> EOI_ACK and document it

Fix typo in the macro name and document the
reason it has this value. Update users.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: gleb@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/37867b31b9330690af2e60a2a7c4cb4b1b070caf.1337184153.git.mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
