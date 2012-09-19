Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab2ISS6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:58:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab2ISS6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:58:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to drivers/bus/
Date: Wed, 19 Sep 2012 18:57:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com> <20120917215128.GF11762@atomide.com>
In-Reply-To: <20120917215128.GF11762@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191857.57862.arnd@arndb.de>
X-Provags-ID: V02:K0:SbxGeCZowgOLxzVulrPDI55jzeSZqTma2euxTmrQmJz
 LWMDd409cCJShW2FVDZpdfRtvVQKfuzr2eQiByW407FSsjhcpv
 4FNYp1mYjCgOpmR/pwqPheV6dK6vIYt5dLRKwcRdJUqGPOPIOo
 Nj4Govjj/GuvaV7tpBZtDGFTsGBXlevbZH00fk8Msz7/eFjE5Q
 vGAfOBc1IftW6S3Jr2ePuQMbRLoz7Y2/sDwx+f2+CTLA5seqss
 rwkYNrrExDRuXA9pPYBzYDZ5mWA+ydyO9o6okvVd7O7h9VMyd5
 0LfiX1gZ+L++O/ygavfq8M8Q6BRUmHujOpIyfLTmKjwLIrstlB
 vgpUaU+9APNU8027ptww=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Tony Lindgren wrote:
> * Santosh Shilimkar <santosh.shilimkar@ti.com> [120914 02:21]:
> > OMAP interconnect drivers are used for the interconnect error handling.
> > Since they are bus driver, lets move it to newly created drivers/bus.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > ---
> > Patch just moves OMAP interconnect drivers as is to the newly created
> > driver/bus/* directory. Patch is generated against "arm-soc/drivers/ocp2scp"
> > tree and test on all OMAP boards.
> 
> Great, looks like this should not conflict with other
> omap patches queued, so Arnd should probably take this into
> the bus branch:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

It turns out that the patch actually did conflict and we now have a broken
omap2plus_defconfig. The patch below seems to fix it, but please verify
that this makes sense.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index f447e02..ab911a3 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
-#include "soc.h"
 #include "omap_l3_noc.h"
 
 /*
@@ -191,7 +190,7 @@ static int __devinit omap4_l3_probe(struct platform_device *pdev)
 			IRQF_DISABLED, "l3-dbg-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						9 + OMAP44XX_IRQ_GIC_START);
+						l3->debug_irq);
 		goto err3;
 	}
 
@@ -201,7 +200,7 @@ static int __devinit omap4_l3_probe(struct platform_device *pdev)
 			IRQF_DISABLED, "l3-app-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						10 + OMAP44XX_IRQ_GIC_START);
+						l3->app_irq);
 		goto err4;
 	}
 
