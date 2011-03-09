Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1CIAaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:30:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56084 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739Ab1CIAaS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:30:18 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299630111.4146.15.camel@localhost>
References: <1299630111.4146.15.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 00:29:53 +0000
Message-ID: <1299630593.4146.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/5] x86: Fix .size directive for xen_do_hypervisor_callback
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H.J. Lu <hjl.tools@gmail.com>

[bwh: This is my summary.]

gas used to accept (and ignore?) .size directives which referred to
undefined symbols, as this does.  In binutils 2.21 these are treated
as errors.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
If this is already headed to Linus by some other route, sorry for the
dupe.

HJL: Care to add your S-o-b?  (I can't believe this is even subject to
copyright, so I'm signing it off myself anyway.)

Ben.

 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..bbd5c80 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1248,7 +1248,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
-END(do_hypervisor_callback)
+END(xen_do_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
-- 
1.7.4.1



