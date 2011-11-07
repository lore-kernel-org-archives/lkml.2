Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab1KGNow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:44:52 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:41408 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1KGNou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:44:50 -0500
Subject: [PATCH] [TRIVIAL] 8250_hp300: Fix warning typo 'CONFIG_8250'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 14:44:36 +0100
Message-ID: <1320673476.14409.367.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This patch is untested: I have neither the hardware nor the toolchain
needed. It should be correct (though it makes an already too long line
even longer). Nevertheless I think a proper solution is a patch that
drops this warning entirely. I've CC'd the m68k people for further
feedback.

1) If SERIAL_8250_HP300 is set but neither HPDCA nor HPAPCI are set we
end up with an elaborate nop, don't we? Initialization should always
fail in that case. So effectively SERIAL_8250_HP300 depends on HPDCA
and/or HPAPCI. Was there perhaps some problem in translating that
dependency into a Kconfig dependency?

2) Related question: is it useful to have both HPDCA and HPAPCI set?

 drivers/tty/serial/8250_hp300.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250_hp300.c b/drivers/tty/serial/8250_hp300.c
index c13438c..dc41fbb 100644
--- a/drivers/tty/serial/8250_hp300.c
+++ b/drivers/tty/serial/8250_hp300.c
@@ -21,7 +21,7 @@
 #include "8250.h"
 
 #if !defined(CONFIG_HPDCA) && !defined(CONFIG_HPAPCI)
-#warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
+#warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
 #endif
 
 #ifdef CONFIG_HPAPCI
-- 
1.7.4.4

