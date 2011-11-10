Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab1KJFSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:18:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51484 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934342Ab1KJFSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 00:18:52 -0500
Date: Wed, 9 Nov 2011 21:18:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pau Oliva Fora <pof@eslack.org>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: htcpen - add #ifdef CONFIG_PNP guard for pnp_ids
Message-ID: <20111110051846.GA3079@core.coreip.homeip.net>
References: <1320899091.6118.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320899091.6118.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 12:24:51PM +0800, Axel Lin wrote:
> Fix below build warning if CONFIG_PNP is disabled.
> 
>   CC      drivers/input/touchscreen/htcpen.o
> drivers/input/touchscreen/htcpen.c:50: warning: 'pnp_ids' defined but not used
> 

Does not seem to help, How about below instead?

Thanks.

-- 
Dmitry


Input: htcpen - switch to DMI-based autoloading

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Having module device table based on PNP id produces the following warning:

  CC      drivers/input/touchscreen/htcpen.o
drivers/input/touchscreen/htcpen.c:50: warning: 'pnp_ids' defined but not used

This happens because it is not a PNP driver, bit rather ISA driver and
pnp_ids table is not used anywhere. To fix this issue let's switch to
DMI-based module table instead,

Reported-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/htcpen.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)


diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
index 62811de..81e3386 100644
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -47,12 +47,6 @@ static int invert_y;
 module_param(invert_y, bool, 0644);
 MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
 
-static struct pnp_device_id pnp_ids[] = {
-	{ .id = "PNP0cc0" },
-	{ .id = "" }
-};
-MODULE_DEVICE_TABLE(pnp, pnp_ids);
-
 static irqreturn_t htcpen_interrupt(int irq, void *handle)
 {
 	struct input_dev *htcpen_dev = handle;
@@ -237,6 +231,7 @@ static struct dmi_system_id __initdata htcshift_dmi_table[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(dmi, htcshift_dmi_table);
 
 static int __init htcpen_isa_init(void)
 {
