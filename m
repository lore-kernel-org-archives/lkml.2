Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2JAVxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:53:22 -0400
Received: from lunge.queued.net ([173.255.254.236]:58895 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2JAVwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:52:43 -0400
Date: Mon, 1 Oct 2012 14:45:37 -0700
From: Andres Salomon <dilinger@queued.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Nettleton <jon.nettleton@gmail.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 1/5] staging/olpc_dcon: drop useaa module arg
Message-ID: <20121001144537.641bdd85@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The 'useaa' module parameter was a workaround for a buggy DCON prototype
not supporting the optional anti-aliasing mode properly.  There's no
reason to disable it any more, so drop the option.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index d49c32a..7dcd060 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -39,10 +39,6 @@
 static ushort resumeline = 898;
 module_param(resumeline, ushort, 0444);
 
-/* Default off since it doesn't work on DCON ASIC in B-test OLPC board */
-static int useaa = 1;
-module_param(useaa, int, 0444);
-
 static struct dcon_platform_data *pdata;
 
 /* I2C structures */
@@ -103,9 +99,7 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 	/* Colour swizzle, AA, no passthrough, backlight */
 	if (is_init) {
 		dcon->disp_mode = MODE_PASSTHRU | MODE_BL_ENABLE |
-				MODE_CSWIZZLE;
-		if (useaa)
-			dcon->disp_mode |= MODE_COL_AA;
+				MODE_CSWIZZLE | MODE_COL_AA;
 	}
 	dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode);
 
@@ -191,9 +185,7 @@ static int dcon_set_mono_mode(struct dcon_priv *dcon, bool enable_mono)
 		dcon->disp_mode |= MODE_MONO_LUMA;
 	} else {
 		dcon->disp_mode &= ~(MODE_MONO_LUMA);
-		dcon->disp_mode |= MODE_CSWIZZLE;
-		if (useaa)
-			dcon->disp_mode |= MODE_COL_AA;
+		dcon->disp_mode |= MODE_CSWIZZLE | MODE_COL_AA;
 	}
 
 	dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode);
-- 
1.7.10.4

