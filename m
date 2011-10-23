Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1JWGga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:36:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1JWGeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:16 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:37 2011
Message-Id: <20111023062537.509020542@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:29 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Bohan <mbohan@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Johan Palsson <johan.palsson@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [01/27] ARM: 7113/1: mm: Align bank start to MAX_ORDER_NR_PAGES
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 002ea9eefec98dada56fd5f8e432a4e8570c2a26 upstream.

The VM subsystem assumes that there are valid memmap entries from
the bank start aligned to MAX_ORDER_NR_PAGES.

On the Ux500 we have a lot of mem=N arguments on the commandline
triggering this bug several times over and causing kernel
oops messages.

Cc: Michael Bohan <mbohan@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Johan Palsson <johan.palsson@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/init.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -473,6 +473,13 @@ static void __init free_unused_memmap(st
 		 */
 		bank_start = min(bank_start,
 				 ALIGN(prev_bank_end, PAGES_PER_SECTION));
+#else
+		/*
+		 * Align down here since the VM subsystem insists that the
+		 * memmap entries are valid from the bank start aligned to
+		 * MAX_ORDER_NR_PAGES.
+		 */
+		bank_start = round_down(bank_start, MAX_ORDER_NR_PAGES);
 #endif
 		/*
 		 * If we had a previous bank, and there is a space


