Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab1DSVIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:08:50 -0400
Received: from kroah.org ([198.145.64.141]:39380 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab1DSVEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:23 2011
Message-Id: <20110419210323.446436205@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Mark Langsdorf <mark.langsdorf@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [11/26] x86, AMD: Set ARAT feature on AMD processors
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit b87cf80af3ba4b4c008b4face3c68d604e1715c6 upstream.

Support for Always Running APIC timer (ARAT) was introduced in
commit db954b5898dd3ef3ef93f4144158ea8f97deb058. This feature
allows us to avoid switching timers from LAPIC to something else
(e.g. HPET) and go into timer broadcasts when entering deep
C-states.

AMD processors don't provide a CPUID bit for that feature but
they also keep APIC timers running in deep C-states (except for
cases when the processor is affected by erratum 400). Therefore
we should set ARAT feature bit on AMD CPUs.

Tested-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
LKML-Reference: <1300205624-4813-1-git-send-email-ostr@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -564,6 +564,10 @@ static void __cpuinit init_amd(struct cp
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
 }
 
 #ifdef CONFIG_X86_32


