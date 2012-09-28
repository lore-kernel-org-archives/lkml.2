Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab2I1QKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:10:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41949 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab2I1QKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:10:54 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "hs@denx.de" <hs@denx.de>,
        "mikedunn@newsguy.com" <mikedunn@newsguy.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [REMINDER: PATCH 1/1] mtd:nand:clk: preparation for switch to
 common clock framework
Thread-Topic: [REMINDER: PATCH 1/1] mtd:nand:clk: preparation for switch to
 common clock framework
Thread-Index: AQHNnZPIZ6zk10dzA0GJ1jdD0okYrQ==
Date: Fri, 28 Sep 2012 16:10:32 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041EF679@DFLE12.ent.ti.com>
References: <1347899860-24358-1-git-send-email-m-karicheri2@ti.com>
 <1347899860-24358-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1347899860-24358-2-git-send-email-m-karicheri2@ti.com>
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
>> Sent: Monday, September 17, 2012 12:38 PM
>> To: dwmw2@infradead.org; artem.bityutskiy@linux.intel.com; hs@denx.de;
>> mikedunn@newsguy.com; linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org;
>> davinci-linux-open-source@linux.davincidsp.com; linux-arm-kernel@lists.infradead.org
>> Cc: Karicheri, Muralidharan
>> Subject: [PATCH 1/1] mtd:nand:clk: preparation for switch to common clock framework
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
>> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>> index f386b3c..df1ab7d 100644
>> --- a/drivers/mtd/nand/davinci_nand.c
>> +++ b/drivers/mtd/nand/davinci_nand.c
>> @@ -724,7 +724,7 @@ static int __init nand_davinci_probe(struct platform_device
>> *pdev)
>>  		goto err_clk;
>>  	}
>> 
>> -	ret = clk_enable(info->clk);
>> +	ret = clk_prepare_enable(info->clk);
>>  	if (ret < 0) {
>>  		dev_dbg(&pdev->dev, "unable to enable AEMIF clock, err %d\n",
>>  			ret);
>> @@ -835,7 +835,7 @@ syndrome_done:
>> 
>>  err_scan:
>>  err_timing:
>> -	clk_disable(info->clk);
>> +	clk_disable_unprepare(info->clk);
>> 
>>  err_clk_enable:
>>  	clk_put(info->clk);
>> @@ -872,7 +872,7 @@ static int __exit nand_davinci_remove(struct platform_device
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

Could you please review and apply this patch to mtd subsystem tree for linux-next?

Murali Karicheri
Software Design Engineer


