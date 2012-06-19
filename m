Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2FSKqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:46:35 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3298 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab2FSKqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:46:34 -0400
Message-ID: <1340102787.1936.19.camel@x61.thuisdomein>
Subject: [PATCH] ARM: sa1100: remove lart.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Jun 2012 12:46:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Jun 2012 10:46:27.0345 (UTC) FILETIME=[C7442810:01CD4E08]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No file includes this header. It has never been included since at least
v2.6.12-rc2. It can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested only by using various git commands on the (history of the)
tree.

1) One other (potential) cleanup that I discovered while looking at the
effects of removing this header can be found in
arch/arm/mach-sa1100/lart.c:
- outdated warning, referring to a header that (in short) got removed in
commit c36167de652f8acdf0b374c78805e662646cd327 ("ide: remove dead
<asm-arm/arch-sa1100/ide.h>");
- quite a bit of code depends on macros that seem to be never defined
anywhere (eg, LART_GREY_LCD).

So that code is in need of some cleaning up. But does anyone still care
about the LART related code? Especially that outdated warning suggests
this code has seriously bit rotted.

2) While I'm at it, I might as well add some more details on the history
of lart.h, which are not really relevant for the commit explanation (or
anything else, for that matter):
- it got added in v2.4.9-pre1 and was only included by
include/asm-arm/arch-sa1100/hardware.h;
- its sole #include got removed in a patch called "[ARM] Clean up sa1100
hardware specific headers.". That patch got merged in release v2.5.47.
So it is actually unused since v2.5.47, ie it's unused for almost ten
years!

 arch/arm/mach-sa1100/include/mach/lart.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)
 delete mode 100644 arch/arm/mach-sa1100/include/mach/lart.h

diff --git a/arch/arm/mach-sa1100/include/mach/lart.h b/arch/arm/mach-sa1100/include/mach/lart.h
deleted file mode 100644
index 8a5482d..0000000
--- a/arch/arm/mach-sa1100/include/mach/lart.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef _INCLUDE_LART_H
-#define _INCLUDE_LART_H
-
-#define LART_GPIO_ETH0			GPIO_GPIO0
-#define LART_IRQ_ETH0			IRQ_GPIO0
-
-#define LART_GPIO_IDE			GPIO_GPIO1
-#define LART_IRQ_IDE			IRQ_GPIO1
-
-#define LART_GPIO_UCB1200		GPIO_GPIO18
-#define LART_IRQ_UCB1200		IRQ_GPIO18
-
-#endif
-- 
1.7.7.6

