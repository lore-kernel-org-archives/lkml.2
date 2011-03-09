Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1CIAbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:31:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56105 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734Ab1CIAbg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:31:36 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Modra <amodra@gmail.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299630111.4146.15.camel@localhost>
References: <1299630111.4146.15.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 00:31:16 +0000
Message-ID: <1299630676.4146.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/5] x86: Fix .size directive for async_page_fault
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Modra <amodra@gmail.com>

[bwh: This is my summary.]

gas used to accept (and ignore?) .size directives which referred to
undefined symbols, as this does.  In binutils 2.21 these are treated
as errors.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
If this is already headed to Linus by some other route, sorry for the
dupe.

Alan: Care to add your S-o-b?  (I can't believe this is even subject to
copyright, so I'm signing it off myself anyway.)

Ben.

 arch/x86/kernel/entry_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c8b4efa..9ca3b0e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1413,7 +1413,7 @@ ENTRY(async_page_fault)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
-END(apf_page_fault)
+END(async_page_fault)
 #endif
 
 /*
-- 
1.7.4.1



