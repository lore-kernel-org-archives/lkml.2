Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1EaJfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:35:48 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:56679 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1EaJfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:35:47 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <dagenaisj@sonatest.com>,
        Matt Reimer <mreimer@vpop.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] w1: W1_MASTER_DS1WM should depend on GENERIC_HARDIRQS
Date: Tue, 31 May 2011 11:35:43 +0200
Message-Id: <1306834543-15336-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k (which doesn't support generic hardirqs yet):

drivers/w1/masters/ds1wm.c: In function ‘ds1wm_probe’:
drivers/w1/masters/ds1wm.c: error: implicit declaration of function ‘irq_set_irq_type’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/w1/masters/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 00d615d..979d6ee 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -42,7 +42,7 @@ config W1_MASTER_MXC
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1
+	depends on W1 && GENERIC_HARDIRQS
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
-- 
1.7.0.4

