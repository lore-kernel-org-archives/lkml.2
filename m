Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2IRHVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:21:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:48484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab2IRHVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:21:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,441,1344236400"; 
   d="scan'208";a="223428073"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: anish singh <anish198519851985@gmail.com>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
Thread-Topic: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
Thread-Index: AQHNlW0v+row1Ngd9EiQ8qddTk3fXpePsOyA
Date: Tue, 18 Sep 2012 07:21:03 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1820D5@SHSMSX101.ccr.corp.intel.com>
References: <1347972841.4312.2.camel@cliu38-desktop-build>
	<CAK7N6vqKp0Tcdr0CP4grq12C8-Oe05+uCEyos=mLMitwpet+Zw@mail.gmail.com>
	<27240C0AC20F114CBF8149A2696CBE4A181E13@SHSMSX101.ccr.corp.intel.com>
 <CAK7N6vosWH8HoWCyw_jjubL3CRYr-VRdxi1o9WevXd=stSQkcw@mail.gmail.com>
In-Reply-To: <CAK7N6vosWH8HoWCyw_jjubL3CRYr-VRdxi1o9WevXd=stSQkcw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8I7LDk1024432

> This comment might help.
> kernel/irq/manage.c
> 
>     } else if (new->handler == irq_default_primary_handler) {
> 
>         /*
>          * The interrupt was requested with handler = NULL, so
>          * we use the default primary handler for it. But it
>          * does not have the oneshot flag set. In combination
>          * with level interrupts this is deadly, because the
>          * default primary handler just wakes the thread, then
>          * the irq lines is reenabled, but the device still
>          * has the level irq asserted. Rinse and repeat....
>          *
>          * While this works for edge type interrupts, we play
>          * it safe and reject unconditionally because we can't
>          * say for sure which type this interrupt really
>          * has. The type flags are unreliable as the
>          * underlying chip implementation can override them.
>          */

This is not my case. My request_irq is as below:
request_threaded_irq(drv_data->irq,
					  func1,
					  func2,
					  IRQF_SHARED|IRQS_ONESHOT ,
					  "AAAA",
					  drv_data);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
