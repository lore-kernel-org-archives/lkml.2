Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab0J0Hmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:42:37 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54620 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0J0Hmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:42:35 -0400
From: <samu.p.onkalo@nokia.com>
To: <linus.ml.walleij@gmail.com>
CC: <akpm@linux-foundation.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
Date: Wed, 27 Oct 2010 09:41:32 +0200
Subject: RE: [PATCHv4 1/5] misc: Driver for bh1770glc / sfh7770 ALS and
 proximity sensor
Thread-Topic: [PATCHv4 1/5] misc: Driver for bh1770glc / sfh7770 ALS and
 proximity sensor
Thread-Index: Act1HMgNz3e9ouN/RcKqfD9/fXc21wAjJ+cw
Message-ID: <62697B07E9803846BC582181BD6FB6B836EB299181@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
	<1287472188-10101-2-git-send-email-samu.p.onkalo@nokia.com>
 <AANLkTikWvRKzr+kffcpTHTs3q3TLeUPzdwzuQSR_tSU2@mail.gmail.com>
In-Reply-To: <AANLkTikWvRKzr+kffcpTHTs3q3TLeUPzdwzuQSR_tSU2@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Oct 2010 07:41:35.0773 (UTC) FILETIME=[61E8D4D0:01CB75AA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>-----Original Message-----
>From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-
>owner@vger.kernel.org] On Behalf Of ext Linus Walleij
>Sent: 26 October, 2010 17:48
>To: Onkalo Samu.P (Nokia-MS/Tampere)
>Cc: akpm@linux-foundation.org; linux-i2c@vger.kernel.org; linux-
>kernel@vger.kernel.org; linux-input@vger.kernel.org
>Subject: Re: [PATCHv4 1/5] misc: Driver for bh1770glc / sfh7770 ALS and
>proximity sensor
>
>010/10/19 Samu Onkalo <samu.p.onkalo@nokia.com>:
>
>> This is a driver for ROHM BH1770GLC and OSRAM SFH7770 combined
>> ALS and proximity sensor.
>>
>> Interface is sysfs based. The driver uses interrupts to provide new
>data.
>> The driver supports pm_runtime and regulator frameworks.
>> (...)
>> +static DEVICE_ATTR(prox0_raw_en, S_IRUGO | S_IWUSR,
>bh1770_prox_enable_show,
>> +
>bh1770_prox_enable_store);
>> +static DEVICE_ATTR(prox0_thresh_above1_value, S_IRUGO | S_IWUSR,
>> +
>bh1770_prox_abs_thres_show,
>> +
>bh1770_prox_abs_thres_store);
>> +static DEVICE_ATTR(prox0_thresh_above0_value, S_IRUGO | S_IWUSR,
>> +                                               bh1770_get_prox_thres,
>> +
>bh1770_set_prox_thres);
>> +static DEVICE_ATTR(prox0_raw, S_IRUGO, bh1770_prox_result_show,
>NULL);
>
>So you have sysfs entries for enabling, calibrating hysteris
>(above/below) and the reading the raw value which I assume
>will be 0 (if nothing is in proximity) or 1 (if it is in proximity).

Actually raw gives 0 or 1023 (==sensor_range) when
the reporting mode is "trigger"
or
0 threshold_abovevalue..1023 in periodic mode.

But for Boolean type behavior: 0 is no proximity and != 0 means
proximity 

>
>These entries are pretty OK I think, but the transition from
>0 to 1 which I assume will generate an interrupt and generate
>a new value in this attribute.

It uses sysfs_notify to indicate userspace about the change

>
>But should it not hook into the input framework and generate
>a SW_FRONT_PROXIMITY event as well?
>
>I think this could be pretty helpful for generic userspace
>applications like X that want to use this event.
>
>Of course I can send a patch for this later, but I'd like
>to hear whether you agree on this or not.
>

I think that is makes sense to provide it.

-Samu




