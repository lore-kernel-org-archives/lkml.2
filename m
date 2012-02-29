Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2B2Nhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:37:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44001 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab2B2Nh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:37:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.213.20.220 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120229083845.GU3852@pengutronix.de>
References: <1329756590-19993-1-git-send-email-festevam@gmail.com>
	<20120229083845.GU3852@pengutronix.de>
Date: Wed, 29 Feb 2012 10:37:28 -0300
Message-ID: <CAOMZO5AFmGhkhrZ5RpT4Wi0_LtosDsS_1_Tg--f=Yh-PgFGMkw@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-sdma: Add error check on sdma_get_firmware
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        shawn.guo@freescale.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 5:38 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
...
>> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
>> index bf736ad..52a4e6a 100644
>> --- a/drivers/dma/imx-sdma.c
>> +++ b/drivers/dma/imx-sdma.c
>> @@ -1388,7 +1388,11 @@ static int __init sdma_probe(struct platform_device *pdev)
>>               sdma_add_scripts(sdma, pdata->script_addrs);
>>
>>       if (pdata) {
>> -             sdma_get_firmware(sdma, pdata->fw_name);
>> +             ret = sdma_get_firmware(sdma, pdata->fw_name);
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "failed to get firmware from pdata\n");
>> +                     goto err_init;
>> +             }
>
> No, you shouldn't bail out here. A failure in sdma_get_firmware only
> means that we don't have the RAM scripts, but we can continue with the
> ROM scripts and still do useful things in the driver.

Ok, the dt case also does a "goto err_init" and I just followed it on
the pdata case.

So I plan to do the following:

1. Send a patch for removing the "goto err_init" from the
sdma_get_firmware error check in the dt case
2. Send a patch that adds the error check for the pdata case.

Regards,

Fabio Estevam
