Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1FSTGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:06:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1FSTGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:06:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 08/19] OpenRISC: Timekeeping
Date: Sun, 19 Jun 2011 21:06:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-9-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-9-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192106.19667.arnd@arndb.de>
X-Provags-ID: V02:K0:gYIqHJETHBK4Vyfro0LEQaN39yKsFyz55GIVvfgDV7B
 dCkqOFWHf4Y5T9oX8Vf5GtOc3PfbVbXAwgJTCc5MU0QN9FlzeI
 RRi0xgfjgiDGORew192Xrsi/hjdyj09kV6/AJ6aIT6AAKAbG88
 QDQsJ/NXEbhatF8jiWGHbZCfd95ZkXd2wdWt4xH5u/Zf73cpW9
 WA1zQlsMGLGpK1u/JYAVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + arch/openrisc/kernel/time.c       |  182 +++++++++++++++++++++++++++++++++++++

Would this fit into drivers/clocksource, at least partly?

> +static struct clocksource openrisc_timer = {
> +	.name		= "openrisc_timer",
> +        .rating         = 200,
> +	.read		= openrisc_timer_read,
> +        .mask           = CLOCKSOURCE_MASK(32),
> +        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +static int __init openrisc_timer_init(void)
> +{
> +        if (clocksource_register_hz(&openrisc_timer, cpuinfo.clock_frequency))
> +                panic("failed to register clocksource");
> +
> +	/* Enable the incrementer: 'continuous' mode with interrupt disabled */
> +        mtspr(SPR_TTMR, SPR_TTMR_CR);
> +
> +        return 0;
> +}

You have soem whitespace damage here. It would be good to run your patches
through scripts/checkpatch.pl and fix up everything reported there.



	Arnd
