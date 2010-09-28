Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0I1MzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:55:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59578 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0I1MzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:55:10 -0400
Message-ID: <040c01cb5f0c$29bcb3b0$LocalHost@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Arun Murthy" <arun.murthy@stericsson.com>, <lars@metafoo.de>,
        "Andrew Morton" <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>,
        "Arun MURTHY" <arun.murthy@stericsson.com>,
        <STEricsson_nomadik_linux@list.st.com>
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com> <1285670134-18063-2-git-send-email-arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/7] pwm: Add pwm core driver
Date: Tue, 28 Sep 2010 18:23:24 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Arun Murthy" <arun.murthy@stericsson.com>


> The existing pwm based led and backlight driver makes use of the
> pwm(include/linux/pwm.h). So all the board specific pwm drivers will
> be exposing the same set of function name as in include/linux/pwm.h.
> As a result build fails in case of multi soc environments where each soc
> has a pwm device in it.

This seems very specific to ST environment,  looking at the driver list from
( [PATCH 4/7] pwm: Align existing pwm drivers with pwm-core ) it seems
most multi SOC environments might support PWM in either one of the SOC.

arch/arm/plat-mxc/pwm.c
arch/arm/plat-pxa/pwm.c
arch/arm/plat-samsung/pwm.c
arch/mips/jz4740/pwm.c
drivers/mfd/twl6030-pwm.c

Unless people have examples of other SOCs which might use this,
the better approach might be to go for a custom driver rather than changing
the framework.

Thanks
Hemanth 

