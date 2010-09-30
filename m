Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0I3Mhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:37:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33312 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab0I3Mhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p1UQknPQTw0lB5B/25Wrlh2+vl7alr+XFRu1LHgcWHE6F+bYrvGxs1E/OifFwBFRsg
         fveoeDv1QKgs5JB7I8zz1usk3gVGINbtJca9O/K1ZtMXpCMovprDxd28okuNwY2staX0
         ZjOeP6Uexq0AKjh24g9ob/W+nV4/2p96e+mQc=
Date: Thu, 30 Sep 2010 14:33:58 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] x86, nmi: Support NMI watchdog on newer AMD CPU
 families
Message-ID: <20100930123357.GC20545@loge.amd.com>
References: <20100930121839.GA20545@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930121839.GA20545@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

CPU families 0x12, 0x14 and 0x15 support this functionality.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fb329e9..d9f4ff8 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -700,11 +700,10 @@ static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
-			return;
-		wd_ops = &k7_wd_ops;
-		break;
+		if (boot_cpu_data.x86 == 6 ||
+		    (boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x15))
+			wd_ops = &k7_wd_ops;
+		return;
 	case X86_VENDOR_INTEL:
 		/* Work around where perfctr1 doesn't have a working enable
 		 * bit as described in the following errata:
-- 
1.6.4.4

