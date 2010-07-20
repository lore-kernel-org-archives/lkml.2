Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0GTHL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:11:26 -0400
Received: from peer.zerties.org ([188.40.33.175]:39933 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab0GTHLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:11:25 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH] usb/host: Remove dead CONFIG_ARCH_KARO
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<9df7166bb950e7fbc12d1be9f2b9f9cbb9961187.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<4C3E24DE.7050208@bluewatersys.com>
Date: Tue, 20 Jul 2010 09:08:01 +0200
In-Reply-To: <4C3E24DE.7050208@bluewatersys.com> (Ryan Mallon's message of
	"Thu, 15 Jul 2010 08:58:06 +1200")
Message-ID: <86zkxmk4vi.fsf_-_@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CONFIG_ARCH_KARO doesn't exist in Kconfig and is never defined anywhere
else, therefore removing all references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/usb/host/isp1362.h |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/isp1362.h b/drivers/usb/host/isp1362.h
index d995351..0f97820 100644
--- a/drivers/usb/host/isp1362.h
+++ b/drivers/usb/host/isp1362.h
@@ -8,29 +8,7 @@
 /*
  * Platform specific compile time options
  */
-#if defined(CONFIG_ARCH_KARO)
-#include <asm/arch/hardware.h>
-#include <asm/arch/pxa-regs.h>
-#include <asm/arch/karo.h>
-
-#define USE_32BIT              1
-
-
-/* These options are mutually eclusive */
-#define USE_PLATFORM_DELAY    1
-#define USE_NDELAY             0
-/*
- * MAX_ROOT_PORTS: Number of downstream ports
- *
- * The chip has two USB ports, one of which can be configured as
- * an USB device port, so the value of this constant is implementation
- * specific.
- */
-#define MAX_ROOT_PORTS         2
-#define DUMMY_DELAY_ACCESS do {} while (0)
-
-/* insert platform specific definitions for other machines here */
-#elif defined(CONFIG_BLACKFIN)
+#if defined(CONFIG_BLACKFIN)
 
 #include <linux/io.h>
 #define USE_32BIT              0
-- 
1.7.0.4
