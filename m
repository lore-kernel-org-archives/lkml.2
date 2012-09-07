Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2IGShk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:37:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57280 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2IGShi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:37:38 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH] spi:clk: preparation for switch to common clock
 framework
Thread-Topic: [PATCH] spi:clk: preparation for switch to common clock
 framework
Thread-Index: AQHNhtzSOmzSdAnedU2iN3lCXMLvk5d/Qd0A
Date: Fri, 7 Sep 2012 18:37:30 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041B6EC8@DFLE12.ent.ti.com>
References: <1346351121-27710-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1346351121-27710-1-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Karicheri, Muralidharan
>> Sent: Thursday, August 30, 2012 2:25 PM
>> To: linux-kernel@vger.kernel.org; mturquette@linaro.org; spi-devel-
>> general@lists.sourceforge.net; grant.likely@secretlab.ca
>> Cc: Karicheri, Muralidharan
>> Subject: [PATCH] spi:clk: preparation for switch to common clock framework
>> 
>> As a first step towards migrating davinci platforms to use common clock
>> framework, replace all instances of clk_enable() with clk_prepare_enable()
>> and clk_disable() with clk_disable_unprepare(). Until the platform is
>> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
>> adds a might_sleep() call and would work without any issues.
>> 
>> This will make it easy later to switch to common clk based implementation
>> of clk driver from DaVinci specific driver.
>> 
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>  drivers/spi/spi-davinci.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
>> index 9b2901f..71a6423 100644
>> --- a/drivers/spi/spi-davinci.c
>> +++ b/drivers/spi/spi-davinci.c
>> @@ -873,7 +873,7 @@ static int __devinit davinci_spi_probe(struct platform_device
>> *pdev)
>>  		ret = -ENODEV;
>>  		goto put_master;
>>  	}
>> -	clk_enable(dspi->clk);
>> +	clk_prepare_enable(dspi->clk);
>> 
>>  	master->bus_num = pdev->id;
>>  	master->num_chipselect = pdata->num_chipselect;
>> @@ -959,7 +959,7 @@ free_dma:
>>  	edma_free_channel(dspi->dma.rx_channel);
>>  	edma_free_slot(dspi->dma.dummy_param_slot);
>>  free_clk:
>> -	clk_disable(dspi->clk);
>> +	clk_disable_unprepare(dspi->clk);
>>  	clk_put(dspi->clk);
>>  put_master:
>>  	spi_master_put(master);
>> @@ -995,7 +995,7 @@ static int __devexit davinci_spi_remove(struct platform_device
>> *pdev)
>> 
>>  	spi_bitbang_stop(&dspi->bitbang);
>> 
>> -	clk_disable(dspi->clk);
>> +	clk_disable_unprepare(dspi->clk);
>>  	clk_put(dspi->clk);
>>  	spi_master_put(master);
>>  	free_irq(dspi->irq, dspi);
>> --
>> 1.7.9.5

subsystem owner,

Could you please review and apply this patch as needed? We need to get this upstream before submitting the patch for Common clock framework support for mach-davinci. If I need to follow a specific procedure to get this merged, please direct me to a process page.

Thanks.

Murali Karicheri
Software Design Engineer

