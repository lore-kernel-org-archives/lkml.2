Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2LMAqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:46:35 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58503 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab2LMAqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:46:33 -0500
Date: Thu, 13 Dec 2012 09:46:28 +0900
From: Simon Horman <horms+renesas@verge.net.au>
To: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] ARM: clocksource: Initialise early (repost)
Message-ID: <20121213004628.GA26680@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialise clock sources early, since some subsystems rely on them to initialize

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

---

Repost to add LKML to CC list.

v3
* Initial post
---
 drivers/Makefile |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index a16a8d0..eba9b58 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -37,6 +37,11 @@ obj-$(CONFIG_XEN)		+= xen/
 # regulators early, since some subsystems rely on them to initialize
 obj-$(CONFIG_REGULATOR)		+= regulator/
 
+# clocksource early, since some subsystems rely on them to initialize
+ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
+obj-y				+= clocksource/
+endif
+
 # tty/ comes before char/ so that the VT console is the boot-time
 # default.
 obj-y				+= tty/
@@ -114,9 +119,6 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
-ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
-obj-y				+= clocksource/
-endif
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
-- 
1.7.10.4

