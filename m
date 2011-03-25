Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab1CZAXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:23:34 -0400
Received: from kroah.org ([198.145.64.141]:41582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab1CYXwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:10 2011
Message-Id: <20110325234510.539745531@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H.J. Lu" <hjl.tools@gmail.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [26/63] x86: Fix binutils-2.21 symbol related build failures
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sedat Dilek <sedat.dilek@googlemail.com>

commit 2ae9d293b14d17f35eff624272cfecac7979a2ee upstream.
[only 1/2 of the upstream commit was needed for stable - gkh]

New binutils version 2.21.0.20110302-1 started checking that the symbol
parameter to the .size directive matches the entry name's
symbol parameter, unearthing two mismatches:

  AS      arch/x86/kernel/acpi/wakeup_rm.o
  arch/x86/kernel/acpi/wakeup_rm.S: Assembler messages:
  arch/x86/kernel/acpi/wakeup_rm.S:12: Error: .size expression with symbol `wakeup_code_start' does not evaluate to a constant

  arch/x86/kernel/entry_32.S: Assembler messages:
  arch/x86/kernel/entry_32.S:1421: Error: .size expression with
  symbol `apf_page_fault' does not evaluate to a constant

The problem was discovered while using Debian's binutils
(2.21.0.20110302-1) and experimenting with binutils from
upstream.

Thanks Alexander and H.J. for the vital help.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1299620364-21644-1-git-send-email-sedat.dilek@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/entry_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


