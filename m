Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3AHSFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:05:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51483 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab3AHSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:05:28 -0500
Date: Tue, 8 Jan 2013 19:05:26 +0100
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, sam@ravnborg.org, james.hogan@imgtec.com,
        lliubbo@gmail.com
Subject: [PATCH] scripts/link-vmlinux.sh: source variables from KCONFIG_CONFIG
Message-ID: <20130108180525.GA23773@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Uptime: 19:00:06 up 199 days,  9:11, 83 users,  load average: 0,75, 1,23,
 1,46
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its possible to superseed the config file with KCONFIG_CONFIG and have
completely no .config in the tree. The current script is sourcing
.config in every case, so the kernel will never build succesfully. This
patch fixes that issue by sourcing KCONFIG_CONFIG instead.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 scripts/link-vmlinux.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index b3d907e..e62f1e0 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -132,7 +132,7 @@ if [ "$1" = "clean" ]; then
 fi
 
 # We need access to CONFIG_ symbols
-. ./.config
+. ${KCONFIG_CONFIG}
 
 #link vmlinux.o
 info LD vmlinux.o
-- 
1.7.10.4

