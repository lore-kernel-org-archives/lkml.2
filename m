Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab2CWSLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 14:11:25 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63649 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2CWSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 14:11:23 -0400
From: Alex Gershgorin <alexgershgorin@gmail.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alex <alexg@meprolight.com>
Subject: [PATCH] regulator: i.MX35-PDK Add regulator support
Date: Fri, 23 Mar 2012 20:11:07 +0200
Message-Id: <1332526267-3236-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex <alexg@meprolight.com>

Hi Marc,

Thanks for the patches.

v4 3/4 not directly applicable to Linux version 3.3,
I installed it manually, you could check it out?

> > I'm not very experienced with the regulator driver, but noticed a couple of 
> > minor things with your patch...

I think that my experience in the regulator driver a little less than you :-)

>  static struct resource mx35pdk_flash_resource = {
>  	.start	= MX35_CS0_BASE_ADDR,
> -	.end	= MX35_CS0_BASE_ADDR + SZ_64M - 1,
> +	.end    = MX35_CS0_BASE_ADDR + SZ_64M - 1,

> > did you mean to change this?

No, I will correct this.

> +static struct regulator_init_data vsd_init = {
> +	.constraints = {
> +		.name = "VSD",
> +		.min_uV = 1800000,
> +		.max_uV = 3150000,
> +		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +	}
> +};

> > I think this is on at power up too (for imx35)

Maybe you're right, but in this case, the i.MX35 PDK
Do not use PMIC "VSD" regulator, but instead it is used 
a different power source.
I think it can be removed from here :-)


Regards,
Alex Gershgorin




