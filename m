Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1CVJY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:24:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48564 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1CVJYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N8UsXA2eTa7rporGZ3mWuW5s8Y6yCItvcvjYIhpGc6U/AFQkv9rf5dtyEQawvht4vu
         wyaWYann2/nheoF6faPHEcpR0n+Ijb3JuDU0F4Px/YYE5rqOigMX9dFbbLht9BrPHq9k
         bbWcrYuRMbz0j3SHve27WKXzfeZ8BKIgqNQdk=
MIME-Version: 1.0
Date: Tue, 22 Mar 2011 15:24:54 +0600
Message-ID: <AANLkTinsUfGc=NG_GeH_B+zFVu+DXJzZbJKdQLscqfuH@mail.gmail.com>
Subject: [PATCH] x86, mpparse: Move check_slot into CONFIG_X86_IO_APIC context.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_X86_MPPARSE=y and CONFIG_X86_IO_APIC=n, then we get the
following warning:

arch/x86/kernel/mpparse.c:723: warning: ‘check_slot’ defined but not used

So, put check_slot into CONFIG_X86_IO_APIC context. Its only called
from CONFIG_X86_IO_APIC=y context.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6f789a8..5a532ce 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -714,10 +714,6 @@ static void __init check_irq_src(struct
mpc_intsrc *m, int *nr_m_spare)
 		*nr_m_spare += 1;
 	}
 }
-#else /* CONFIG_X86_IO_APIC */
-static
-inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
-#endif /* CONFIG_X86_IO_APIC */

 static int
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
@@ -731,6 +727,10 @@ check_slot(unsigned long mpc_new_phys, unsigned
long mpc_new_length, int count)

 	return ret;
 }
+#else /* CONFIG_X86_IO_APIC */
+static
+inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+#endif /* CONFIG_X86_IO_APIC */

 static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
