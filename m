Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0KGHlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 02:41:37 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33725 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0KGHlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 02:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lKdV+K64A46WBhx8YDaPpcfVm9Z94cvFNMoJDYeT91MsiU/cUw8cZTdwQ235cAXLiw
         iUKiPEnSj5+Lt7zo0fDjs1/tPrlQPhNwClsm0EuxJoUmmLrOt4JTnwpvDYux3kqq+eVz
         JJ8Tvnjva5gqrctxV01dR1pzSN5uMnB49zG4Y=
MIME-Version: 1.0
Date: Sun, 7 Nov 2010 13:41:34 +0600
Message-ID: <AANLkTimW+GdKZEZdR5DtAp8=D7muTOvVcvuPoiCR2Y2p@mail.gmail.com>
Subject: [PATCH] x86, hw_nmi: Move backtrace_mask declaration under ARCH_HAS_NMI_WATCHDOG.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backtrace_mask has been used under the code context of
ARCH_HAS_NMI_WATCHDOG. So put it into that context.
We were warned by the following warning:

arch/x86/kernel/apic/hw_nmi.c:21: warning: ‘backtrace_mask’ defined but not used


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..62f6e1e 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -17,15 +17,16 @@
 #include <linux/nmi.h>
 #include <linux/module.h>

-/* For reliability, we're prepared to waste bits here. */
-static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
-
 u64 hw_nmi_get_sample_period(void)
 {
 	return (u64)(cpu_khz) * 1000 * 60;
 }

 #ifdef ARCH_HAS_NMI_WATCHDOG
+
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
