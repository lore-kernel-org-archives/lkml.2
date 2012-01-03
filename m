Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2ACW6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:58:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab2ACWiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:35 2012
Message-Id: <20120103223034.943625126@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [43/67] sparc32: Be less strict in matching %lo part of relocation.
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit b1f44e13a525d2ffb7d5afe2273b7169d6f2222e ]

The "(insn & 0x01800000) != 0x01800000" test matches 'restore'
but that is a legitimate place to see the %lo() part of a 32-bit
symbol relocation, particularly in tail calls.

Signed-off-by: David S. Miller <davem@davemloft.net>
Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/mm/btfixup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/sparc/mm/btfixup.c
+++ b/arch/sparc/mm/btfixup.c
@@ -302,8 +302,7 @@ void __init btfixup(void)
 				case 'i':	/* INT */
 					if ((insn & 0xc1c00000) == 0x01000000) /* %HI */
 						set_addr(addr, q[1], fmangled, (insn & 0xffc00000) | (p[1] >> 10));
-					else if ((insn & 0x80002000) == 0x80002000 &&
-					         (insn & 0x01800000) != 0x01800000) /* %LO */
+					else if ((insn & 0x80002000) == 0x80002000) /* %LO */
 						set_addr(addr, q[1], fmangled, (insn & 0xffffe000) | (p[1] & 0x3ff));
 					else {
 						prom_printf(insn_i, p, addr, insn);


