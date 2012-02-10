Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab2BJXW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:22:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384Ab2BJWkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:40:51 -0500
MIME-Version: 1.0
Message-Id: <20120210222946.287969756@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yegor Yefremov <yegorslists@googlemail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [patch 14/86] ARM: OMAP2+: GPMC: fix device size setup
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yegor Yefremov <yegor_sub1@visionsystems.de>

commit 8ef5d844cc3a644ea6f7665932a4307e9fad01fa upstream.

following statement can only change device size from 8-bit(0) to 16-bit(1),
but not vice versa:

regval |= GPMC_CONFIG1_DEVICESIZE(wval);

so as this field has 1 reserved bit, that could be used in future,
just clear both bits and then OR with the desired value

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/gpmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -528,7 +528,13 @@ int gpmc_cs_configure(int cs, int cmd, i
 
 	case GPMC_CONFIG_DEV_SIZE:
 		regval  = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
+
+		/* clear 2 target bits */
+		regval &= ~GPMC_CONFIG1_DEVICESIZE(3);
+
+		/* set the proper value */
 		regval |= GPMC_CONFIG1_DEVICESIZE(wval);
+
 		gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, regval);
 		break;
 


