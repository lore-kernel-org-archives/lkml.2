Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab2IGV4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:56:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45432 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab2IGV4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:56:33 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mtd:nand:clk: preparation for switch to common clock
 framework
Thread-Topic: [PATCH] mtd:nand:clk: preparation for switch to common clock
 framework
Thread-Index: AQHNhtupPgQfBcoi0EWgwLIMml+uo5d/xaiA//+zJYA=
Date: Fri, 7 Sep 2012 21:56:22 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041B73E9@DFLE12.ent.ti.com>
References: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
 <20120907212853.20289.86031@nucleus>
In-Reply-To: <20120907212853.20289.86031@nucleus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q87LueRU009710

Mike,

How do these patch get to upstream? Does this get merged through davinci maintainer or through individual subsystem maintainers? 

Thanks.

Murali Karicheri
Software Design Engineer


>> -----Original Message-----
>> From: Mike Turquette [mailto:mturquette@linaro.org]
>> Sent: Friday, September 07, 2012 5:29 PM
>> To: Karicheri, Muralidharan; dwmw2@infradead.org; artem.bityutskiy@linux.intel.com;
>> dbaryshkov@gmail.com; computersforpeace@gmail.com; linux-mtd@lists.infradead.org;
>> linux-kernel@vger.kernel.org
>> Cc: Karicheri, Muralidharan
>> Subject: Re: [PATCH] mtd:nand:clk: preparation for switch to common clock framework
>> 
>> Quoting Murali Karicheri (2012-08-30 11:17:04)
>> > As a first step towards migrating davinci platforms to use common clock
>> > framework, replace all instances of clk_enable() with clk_prepare_enable()
>> > and clk_disable() with clk_disable_unprepare(). Until the platform is
>> > switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
>> > adds a might_sleep() call and would work without any issues.
>> >
>> > This will make it easy later to switch to common clk based implementation
>> > of clk driver from DaVinci specific driver.
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> 
>> Acked-by: Mike Turquette <mturquette@linaro.org>
>> 
>> > ---
>> >  drivers/mtd/nand/davinci_nand.c |    6 +++---
>> >  1 file changed, 3 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>> > index d94b03c..6b8cf27 100644
>> > --- a/drivers/mtd/nand/davinci_nand.c
>> > +++ b/drivers/mtd/nand/davinci_nand.c
>> > @@ -656,7 +656,7 @@ static int __init nand_davinci_probe(struct platform_device
>> *pdev)
>> >                 goto err_clk;
>> >         }
>> >
>> > -       ret = clk_enable(info->clk);
>> > +       ret = clk_prepare_enable(info->clk);
>> >         if (ret < 0) {
>> >                 dev_dbg(&pdev->dev, "unable to enable AEMIF clock, err %d\n",
>> >                         ret);
>> > @@ -767,7 +767,7 @@ syndrome_done:
>> >
>> >  err_scan:
>> >  err_timing:
>> > -       clk_disable(info->clk);
>> > +       clk_disable_unprepare(info->clk);
>> >
>> >  err_clk_enable:
>> >         clk_put(info->clk);
>> > @@ -804,7 +804,7 @@ static int __exit nand_davinci_remove(struct platform_device
>> *pdev)
>> >
>> >         nand_release(&info->mtd);
>> >
>> > -       clk_disable(info->clk);
>> > +       clk_disable_unprepare(info->clk);
>> >         clk_put(info->clk);
>> >
>> >         kfree(info);
>> > --
>> > 1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
