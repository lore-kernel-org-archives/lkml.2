Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2IGSgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:36:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33383 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2IGSgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:36:47 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>
Subject: RE: [PATCH] wdt:clk: preparation for switch to common clock
 framework
Thread-Topic: [PATCH] wdt:clk: preparation for switch to common clock
 framework
Thread-Index: AQHNht1agLoJWMBRck6ZnlXlycmO6pd/QP2w
Date: Fri, 7 Sep 2012 18:36:44 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041B6EB8@DFLE12.ent.ti.com>
References: <1346351350-28807-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1346351350-28807-1-git-send-email-m-karicheri2@ti.com>
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
>> Sent: Thursday, August 30, 2012 2:29 PM
>> To: linux-kernel@vger.kernel.org; mturquette@linaro.org; linux-
>> watchdog@vger.kernel.org; wim@iguana.be
>> Cc: Karicheri, Muralidharan
>> Subject: [PATCH] wdt:clk: preparation for switch to common clock framework
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
>>  drivers/watchdog/davinci_wdt.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
>> index c8c5c80..eb44b03 100644
>> --- a/drivers/watchdog/davinci_wdt.c
>> +++ b/drivers/watchdog/davinci_wdt.c
>> @@ -208,7 +208,7 @@ static int __devinit davinci_wdt_probe(struct platform_device
>> *pdev)
>>  	if (WARN_ON(IS_ERR(wdt_clk)))
>>  		return PTR_ERR(wdt_clk);
>> 
>> -	clk_enable(wdt_clk);
>> +	clk_prepare_enable(wdt_clk);
>> 
>>  	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
>>  		heartbeat = DEFAULT_HEARTBEAT;
>> @@ -256,7 +256,7 @@ static int __devexit davinci_wdt_remove(struct platform_device
>> *pdev)
>>  		wdt_mem = NULL;
>>  	}
>> 
>> -	clk_disable(wdt_clk);
>> +	clk_disable_unprepare(wdt_clk);
>>  	clk_put(wdt_clk);
>> 
>>  	return 0;
>> --
>> 1.7.9.5

subsystem owner,

Could you please review and apply this patch as needed? We need to get this upstream before submitting the patch for Common clock framework support for mach-davinci. If I need to follow a specific procedure to get this merged, please direct me to a process page.

Thanks.

Murali Karicheri
Software Design Engineer


