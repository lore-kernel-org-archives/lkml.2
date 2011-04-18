Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1DRNMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:12:39 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54412 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068Ab1DRNMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:12:35 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 18 Apr 2011 06:12:25 -0700
Subject: RE: [PATCH 01/13] input: touchscreen: use polling mode in 88pm860x
Thread-Topic: [PATCH 01/13] input: touchscreen: use polling mode in 88pm860x
Thread-Index: Acv8QP/B5pVNEK+jQiyXS/lcbnveFQBiStWQ
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B235@SC-VEXCH1.marvell.com>
References: <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
            <1302957980-27343-1-git-send-email-haojian.zhuang@marvell.com>
 <60599.1302963433@localhost>
In-Reply-To: <60599.1302963433@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3IDChjO007171



>-----Original Message-----
>From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
>Sent: 2011Äê4ÔÂ16ÈÕ 10:17 PM
>To: Haojian Zhuang
>Cc: haojian.zhuang@gmail.com; sameo@linux.intel.com; linux-
>kernel@vger.kernel.org; Dmitry Torokhov
>Subject: Re: [PATCH 01/13] input: touchscreen: use polling mode in
>88pm860x
>
>On Sat, 16 Apr 2011 20:46:20 +0800, Haojian Zhuang said:
>> Measuring point on touchscreen with IRQ mode can only monitor pen-down
>> event. If finger is moving on touchscreen, it can't be monitored by
>> IRQ pen-down event. So switch to polling mode after pen-down event.
>
>>  drivers/input/touchscreen/88pm860x-ts.c |   79
>++++++++++++++++++++++++------
>
>> +/*
>> + * While 32KHz hardware timer is used for scheduler, we always assign
>HZ
>> + * to 128. It means that 1 tick costs 7.8msec.
>> + */
>> +#define MEASURE_INTERVAL_MS	(7)
>
>Is it guaranteed that this hardware part will only ever be used on
>systems
>where this is true?  How big a bug would it be if somebody tried to glue
>this
>touchscreen into some random embedded-ARM where HZ was something else,
>and
>should this be computed as a function of HZ instead of hardcoding 7?
It's 7msec whatever you choose any silicon. So it's not a problem.

>
>It *looks* like the intent of the schedule_delayed_work() call is "let's
>run
>this once a tick when we're awake *anyhow*" - but looking at the code, I
>can't
>convince myself a rounding error in computing 'interval' won't schedule
>1ms
>before or after the next tick would have been.  Isn't there a better API
>with
>slack timers or something that would do a better "next tick" job?
>
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
