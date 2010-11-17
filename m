Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab0KQP1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:27:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0KQP1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:27:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Laredo <laredo@gnu.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/7] staging/stradis: mark as "depends on BKL"
Date: Wed, 17 Nov 2010 16:26:53 +0100
Message-Id: <1290007619-5787-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290007619-5787-1-git-send-email-arnd@arndb.de>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UwdTF47PoJNfYTRe0De3RWuVUNp5gOUPCvRHLLCcZr/
 jY5tkF4MdAcP/bSBQ1+CzpU5soIhl4q7r8vIvtdrk/HQlZeyll
 rcKj3APT5yscMi6ANswIqyiGxSmoFeTsHHi05veSGX3ahCzHqn
 2B98dZoZuWWJmqxAMzXlWVpvAM/QqG/7k7HNyFjGxNBWQLy2G5
 e22cB1fLGLlTVJvrZrmDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stradis driver is on its way out, but it
should still be marked correctly as depending
on the big kernel lock. It could easily be
changed to not require it if someone decides
to revive the driver and port it to v4l2 in
the process.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Nathan Laredo <laredo@gnu.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/stradis/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/stradis/Kconfig b/drivers/staging/stradis/Kconfig
index 92e8911..02f0fc5 100644
--- a/drivers/staging/stradis/Kconfig
+++ b/drivers/staging/stradis/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_STRADIS
         tristate "Stradis 4:2:2 MPEG-2 video driver (DEPRECATED)"
-        depends on EXPERIMENTAL && PCI && VIDEO_V4L1 && VIRT_TO_BUS
+        depends on EXPERIMENTAL && PCI && VIDEO_V4L1 && VIRT_TO_BUS && BKL
         help
           Say Y here to enable support for the Stradis 4:2:2 MPEG-2 video
           driver for PCI.  There is a product page at
-- 
1.7.1

