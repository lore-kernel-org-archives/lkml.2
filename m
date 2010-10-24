Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab0JXTRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 15:17:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab0JXTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 15:17:04 -0400
Date: Sun, 24 Oct 2010 21:17:01 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        amit.kucheria@canonical.com, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCHv6 1/3] ARM: imx: Add gpio-keys to plat-mxc
Message-ID: <20101024191701.GA25810@pengutronix.de>
References: <1287801976-5324-1-git-send-email-Dinh.Nguyen@freescale.com> <4CC2977D.8060409@eukrea.com> <20101023095049.GC8554@pengutronix.de> <4CC2C94A.9040700@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CC2C94A.9040700@eukrea.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 01:38:50PM +0200, Eric Bénard wrote:
> Hi Uwe,
>
> Le 23/10/2010 11:50, Uwe Kleine-König a écrit :
>> On Sat, Oct 23, 2010 at 10:06:21AM +0200, Eric Bénard wrote:
>>> Le 23/10/2010 04:46, Dinh.Nguyen@freescale.com a écrit :
>>>> +struct platform_device *__init imx_add_gpio_keys(
>>>> +		const struct gpio_keys_platform_data *pdata)
>>>> +{
>>>> +	return imx_add_platform_device("gpio-keys", -1, NULL,
>>>> +		 0, pdata, sizeof(*pdata));
>>>> +}
>>>
>>> What is the added value of this ?
>> Is is (more or less) in line with the other imx functions that
>> dynamically add platform devices.
>>
>>> gpio-keys is not i.MX specific so why should that land in plat-mxc ?
>> I consider it OK for now.  I know Eric does/wants something similar for
>> pxa.  If you want to push forward unification here that's great, but
>> IMHO this is nothing that should stop this patch which is a good step
>> forward.
>>
> Does that mean that, for example, for cpuimx51 and cpuimx51sd boards, I 
> should create : imx_add_gpio_leds, imx_add_serial_8250 and 
> imx_add_i2c_gpio functions instead of creating the platform_device 
> structure in the board's files and using platform_add_devices to register 
> it ?
The added benefit is that if you (or someone else) do(es) they don't
occupy memory when a different machine is booted because the functions
and their input data can live in .init sections.  I didn't measure the
impact on booting time, but I think it doesn't make much difference.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
