Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0JWJuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 05:50:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50280 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab0JWJuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 05:50:52 -0400
Date: Sat, 23 Oct 2010 11:50:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        amit.kucheria@canonical.com, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCHv6 1/3] ARM: imx: Add gpio-keys to plat-mxc
Message-ID: <20101023095049.GC8554@pengutronix.de>
References: <1287801976-5324-1-git-send-email-Dinh.Nguyen@freescale.com> <4CC2977D.8060409@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CC2977D.8060409@eukrea.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

On Sat, Oct 23, 2010 at 10:06:21AM +0200, Eric Bénard wrote:
> Le 23/10/2010 04:46, Dinh.Nguyen@freescale.com a écrit :
>> +struct platform_device *__init imx_add_gpio_keys(
>> +		const struct gpio_keys_platform_data *pdata)
>> +{
>> +	return imx_add_platform_device("gpio-keys", -1, NULL,
>> +		 0, pdata, sizeof(*pdata));
>> +}
>
> What is the added value of this ?
Is is (more or less) in line with the other imx functions that
dynamically add platform devices.

> gpio-keys is not i.MX specific so why should that land in plat-mxc ?
I consider it OK for now.  I know Eric does/wants something similar for
pxa.  If you want to push forward unification here that's great, but
IMHO this is nothing that should stop this patch which is a good step
forward.

BTW another low hanging fruit is to use use
platform_device_register_resndata to implement imx_add_platform_device
and add a few additional checks, like warn if CONFIG_DEBUG_SOMETHING is
enabled and data is non-NULL and doesn't point to .init-memory.)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
