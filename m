Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1I1XdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:33:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab1I1WiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:25 2011
Message-Id: <20110928220125.556861936@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liu Gang <Gang.Liu@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [003/244] arch/powerpc/sysdev/fsl_rio.c: correct IECSR register clear value
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Liu Gang-B34182 <B34182@freescale.com>

commit 671ee7f0ce62e4b991b47fcf1c161c3f710dabbc upstream.

This bug causes the IECSR register clear failure.  In this case, the RETE
(retry error threshold exceeded) interrupt will be generated and cannot be
cleared.  So the related ISR may be called persistently.

The RETE bit in IECSR is cleared by writing a 1 to it.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/sysdev/fsl_rio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -54,6 +54,7 @@
 #define ODSR_CLEAR		0x1c00
 #define LTLEECSR_ENABLE_ALL	0xFFC000FC
 #define ESCSR_CLEAR		0x07120204
+#define IECSR_CLEAR		0x80000000
 
 #define RIO_PORT1_EDCSR		0x0640
 #define RIO_PORT2_EDCSR		0x0680
@@ -1089,11 +1090,11 @@ static void port_error_handler(struct ri
 
 	if (offset == 0) {
 		out_be32((u32 *)(rio_regs_win + RIO_PORT1_EDCSR), 0);
-		out_be32((u32 *)(rio_regs_win + RIO_PORT1_IECSR), 0);
+		out_be32((u32 *)(rio_regs_win + RIO_PORT1_IECSR), IECSR_CLEAR);
 		out_be32((u32 *)(rio_regs_win + RIO_ESCSR), ESCSR_CLEAR);
 	} else {
 		out_be32((u32 *)(rio_regs_win + RIO_PORT2_EDCSR), 0);
-		out_be32((u32 *)(rio_regs_win + RIO_PORT2_IECSR), 0);
+		out_be32((u32 *)(rio_regs_win + RIO_PORT2_IECSR), IECSR_CLEAR);
 		out_be32((u32 *)(rio_regs_win + RIO_PORT2_ESCSR), ESCSR_CLEAR);
 	}
 }


