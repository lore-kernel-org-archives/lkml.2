Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1HHLIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:08:30 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:44711 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1HHLI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:08:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Cc: Jonas Bonn <jonas@southpole.se>, Arnd Bergmann <arnd@arndb.de>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] tpm: TCG_ATMEL should depend on HAS_IOPORT
Date: Mon,  8 Aug 2011 13:08:19 +0200
Message-Id: <1312801699-17474-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k, I get:

drivers/char/tpm/tpm_atmel.h: In function ‘atmel_get_base_addr’:
drivers/char/tpm/tpm_atmel.h:129: error: implicit declaration of function ‘ioport_map’
drivers/char/tpm/tpm_atmel.h:129: warning: return makes pointer from integer without a cast

The code in tpm_atmel.h supports PPC64 (using the device tree and ioremap())
and "anything else" (using ioport_map()). However, ioportmap() is only
available on platforms that set HAS_IOPORT.

Although PC64 seems to have HAS_IOPORT, a "depends on HAS_IOPORT" should work,
but I think it's better to expose the special PPC64 handling explicit using
"depends on PPC64 || HAS_IOPORT".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/tpm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f6595ab..fa567f1 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -43,6 +43,7 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
+	depends on PPC64 || HAS_IOPORT
 	---help---
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
-- 
1.7.0.4

