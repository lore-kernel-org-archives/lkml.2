Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2EBC1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:27:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48938 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab2EBC1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:27:37 -0400
From: Matt Turner <mattst88@gmail.com>
To: linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: [PATCH 1/4] alpha: VGA_HOSE depends on VGA_CONSOLE
Date: Tue,  1 May 2012 22:27:21 -0400
Message-Id: <1335925644-5192-1-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/alpha/kernel/console.c:locate_and_init_vga uses vga_con, causing
build failures if VGA_CONSOLE was not set and MARVEL, TITAN, DP264, or
GENERIC alpha system types were set.

Reported-by: Raúl Porcel <armin76@gentoo.org>
Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 56a4df9..22e58a9 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -477,7 +477,7 @@ config ALPHA_BROKEN_IRQ_MASK
 
 config VGA_HOSE
 	bool
-	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL || ALPHA_TSUNAMI
+	depends on VGA_CONSOLE && (ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL || ALPHA_TSUNAMI)
 	default y
 	help
 	  Support VGA on an arbitrary hose; needed for several platforms
-- 
1.7.3.4

