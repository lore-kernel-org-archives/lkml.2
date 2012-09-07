Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2IGSj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:39:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35148 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab2IGSj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:39:27 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH] mtd:nand:clk: preparation for switch to common clock
 framework
Thread-Topic: [PATCH] mtd:nand:clk: preparation for switch to common clock
 framework
Thread-Index: AQHNhtupPgQfBcoi0EWgwLIMml+uo5d/Qjsw
Date: Fri, 7 Sep 2012 18:39:16 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041B6EDA@DFLE12.ent.ti.com>
References: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
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
>> Sent: Thursday, August 30, 2012 2:17 PM
>> To: dwmw2@infradead.org; artem.bityutskiy@linux.intel.com; dbaryshkov@gmail.com;
>> computersforpeace@gmail.com; linux-mtd@lists.infradead.org; linux-
>> kernel@vger.kernel.org; mturquette@linaro.org
>> Cc: Karicheri, Muralidharan
>> Subject: [PATCH] mtd:nand:clk: preparation for switch to common clock framework
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
>>  drivers/mtd/nand/davinci_nand.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>> index d94b03c..6b8cf27 100644
>> --- a/drivers/mtd/nand/davinci_nand.c
>> +++ b/drivers/mtd/nand/davinci_nand.c
>> @@ -656,7 +656,7 @@ static int __init nand_davinci_probe(struct platform_device
>> *pdev)
>>  		goto err_clk;
>>  	}
>> 
>> -	ret = clk_enable(info->clk);
>> +	ret = clk_prepare_enable(info->clk);
>>  	if (ret < 0) {
>>  		dev_dbg(&pdev->dev, "unable to enable AEMIF clock, err %d\n",
>>  			ret);
>> @@ -767,7 +767,7 @@ syndrome_done:
>> 
>>  err_scan:
>>  err_timing:
>> -	clk_disable(info->clk);
>> +	clk_disable_unprepare(info->clk);
>> 
>>  err_clk_enable:
>>  	clk_put(info->clk);
>> @@ -804,7 +804,7 @@ static int __exit nand_davinci_remove(struct platform_device
>> *pdev)
>> 
>>  	nand_release(&info->mtd);
>> 
>> -	clk_disable(info->clk);
>> +	clk_disable_unprepare(info->clk);
>>  	clk_put(info->clk);
>> 
>>  	kfree(info);
>> --
>> 1.7.9.5

subsystem owner,

Could you please review and apply this patch as needed? We need to get this upstream before submitting the patch for Common clock framework support for mach-davinci. If I need to follow a specific procedure to get this merged, please direct me to a process page.

Thanks.

Murali Karicheri
Software Design Engineer

