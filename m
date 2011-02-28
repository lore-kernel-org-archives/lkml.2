Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1B1Qoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:44:34 -0500
Received: from kroah.org ([198.145.64.141]:48141 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab1B1Qhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:10 2011
Message-Id: <20110228162410.153457108@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Martin <dave.martin@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [44/68] ARM: Ensure predictable endian state on signal handler entry
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 53399053eb505cf541b2405bd9d9bca5ecfb96fb upstream.

Ensure a predictable endian state when entering signal handlers.  This
avoids programs which use SETEND to momentarily switch their endian
state from having their signal handlers entered with an unpredictable
endian state.

Acked-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/signal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -389,7 +389,9 @@ setup_return(struct pt_regs *regs, struc
 	unsigned long handler = (unsigned long)ka->sa.sa_handler;
 	unsigned long retcode;
 	int thumb = 0;
-	unsigned long cpsr = regs->ARM_cpsr & ~PSR_f;
+	unsigned long cpsr = regs->ARM_cpsr & ~(PSR_f | PSR_E_BIT);
+
+	cpsr |= PSR_ENDSTATE;
 
 	/*
 	 * Maybe we need to deliver a 32-bit signal to a 26-bit task.


