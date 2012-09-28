Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2I1QLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:11:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48743 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2I1QLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:11:45 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "Chemparathy, Cyril" <cyril@ti.com>
Subject: [REMINDER: PATCH 1/1] spi:clk: preparation for switch to common
 clock framework
Thread-Topic: [REMINDER: PATCH 1/1] spi:clk: preparation for switch to
 common clock framework
Thread-Index: AQHNnZPsuZlcp9ZbkEmJplylLLmX1g==
Date: Fri, 28 Sep 2012 16:11:32 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041EF690@DFLE12.ent.ti.com>
References: <1347900122-25101-1-git-send-email-m-karicheri2@ti.com>
 <1347900122-25101-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1347900122-25101-2-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Karicheri, Muralidharan
>> Sent: Monday, September 17, 2012 12:42 PM
>> To: spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org; davinci-linux-
>> open-source@linux.davincidsp.com; grant.likely@secretlab.ca; linux-arm-
>> kernel@lists.infradead.org
>> Cc: Chemparathy, Cyril; Karicheri, Muralidharan
>> Subject: [PATCH 1/1] spi:clk: preparation for switch to common clock framework
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
>> Reviewed-by: Mike Turquette <mturquette@linaro.org>
>> 
>> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
>> index c1ec52d..3f54f9e 100644
>> --- a/drivers/spi/spi-davinci.c
>> +++ b/drivers/spi/spi-davinci.c
>> @@ -843,7 +843,7 @@ static int __devinit davinci_spi_probe(struct platform_device
>> *pdev)
>>  		ret = -ENODEV;
>>  		goto put_master;
>>  	}
>> -	clk_enable(dspi->clk);
>> +	clk_prepare_enable(dspi->clk);
>> 
>>  	master->bus_num = pdev->id;
>>  	master->num_chipselect = pdata->num_chipselect;
>> @@ -927,7 +927,7 @@ free_dma:
>>  	dma_release_channel(dspi->dma_rx);
>>  	dma_release_channel(dspi->dma_tx);
>>  free_clk:
>> -	clk_disable(dspi->clk);
>> +	clk_disable_unprepare(dspi->clk);
>>  	clk_put(dspi->clk);
>>  put_master:
>>  	spi_master_put(master);
>> @@ -963,7 +963,7 @@ static int __devexit davinci_spi_remove(struct platform_device
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

Could you please review and apply this patch to linux-next?

Murali Karicheri
Software Design Engineer

