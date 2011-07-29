Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1G2DRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 23:17:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40505 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1G2DRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 23:17:43 -0400
Date: Fri, 29 Jul 2011 13:17:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Drokin <green@linuxhacker.ru>, Tony Lindgren <tony@atomide.com>,
        Linus <torvalds@linux-foundation.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20110729131735.911ce0d16367933036fa9e6f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/mach-omap2/board-rx51-peripherals.c between commit 786b01a8c1db
("cleanup regulator supply definitions in mach-omap2") from Linus' tree
and commit 75ccf268d504 ("[media] OMAP3: RX-51: define vdds_csib
regulator supply") from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary.  I am sure
Linus' will cope with this merge fixup as well, so you do not need to
rebase/merge to his current tree before sending a pull request.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-rx51-peripherals.c
index cc503aa,17e5685..0000000
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@@ -414,17 -358,17 +414,21 @@@ static struct omap2_hsmmc_info mmc[] __
  	{}	/* Terminator */
  };
  
 -static struct regulator_consumer_supply rx51_vmmc1_supply =
 -	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
 +static struct regulator_consumer_supply rx51_vmmc1_supply[] = {
 +	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0"),
 +};
  
 -static struct regulator_consumer_supply rx51_vaux2_supply =
 -	REGULATOR_SUPPLY("vdds_csib", "omap3isp");
++static struct regulator_consumer_supply rx51_vaux2_supply[] = {
++	REGULATOR_SUPPLY("vdds_csib", "omap3isp"),
++};
+ 
 -static struct regulator_consumer_supply rx51_vaux3_supply =
 -	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
 +static struct regulator_consumer_supply rx51_vaux3_supply[] = {
 +	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1"),
 +};
  
 -static struct regulator_consumer_supply rx51_vsim_supply =
 -	REGULATOR_SUPPLY("vmmc_aux", "omap_hsmmc.1");
 +static struct regulator_consumer_supply rx51_vsim_supply[] = {
 +	REGULATOR_SUPPLY("vmmc_aux", "omap_hsmmc.1"),
 +};
  
  static struct regulator_consumer_supply rx51_vmmc2_supplies[] = {
  	/* tlv320aic3x analog supplies */
@@@ -479,6 -427,8 +483,8 @@@ static struct regulator_init_data rx51_
  		.valid_ops_mask		= REGULATOR_CHANGE_MODE
  					| REGULATOR_CHANGE_STATUS,
  	},
 -	.num_consumer_supplies	= 1,
 -	.consumer_supplies	= &rx51_vaux2_supply,
++	.num_consumer_supplies	= ARRAY_SIZE(rx51_vaux2_supply),
++	.consumer_supplies	= rx51_vaux2_supply,
  };
  
  /* VAUX3 - adds more power to VIO_18 rail */
