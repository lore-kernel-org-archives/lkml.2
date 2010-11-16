Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902Ab0KPGg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:36:26 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50673 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0KPGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:36:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6168"; a="63000529"
Message-ID: <4CE22665.50209@codeaurora.org>
Date: Tue, 16 Nov 2010 12:06:21 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC v1 PATCH 5/6] input: pmic8058-othc: Add support for PM8058
 based OTHC
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-6-git-send-email-tsoni@codeaurora.org> <0680EC522D0CC943BC586913CF3768C003FF9009B6@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003FF9009B6@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Shubhrajyoti,

On 11/16/2010 11:06 AM, Datta, Shubhrajyoti wrote:
> Hi Anirudh,
> 
>> -----Original Message-----
>> From: linux-input-owner@vger.kernel.org [mailto:linux-input-
>> owner@vger.kernel.org] On Behalf Of Trilok Soni
>> Sent: Wednesday, November 10, 2010 6:18 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: linux-input@vger.kernel.org; rtc-linux@googlegroups.com; linux-arm-
>> msm@vger.kernel.org; Anirudh Ghayal; Dmitry Torokhov
>> Subject: [RFC v1 PATCH 5/6] input: pmic8058-othc: Add support for PM8058
>> based OTHC
>>
>> From: Anirudh Ghayal <aghayal@codeaurora.org>
>>
>> One-touch headset controller is a hardware module in Qualcomm's PMIC8058.
>> It supports headset insert/remove and switch press/release detection
>> events
>> over 3 MIC BIAS lines. The MIC BIAS lines can be configured to support
>> headset detection or act as regular BIAS lines.
> Could  you help with the datasheet link if it is free.
> 

datasheets are not available for open access.

>> +
>> +static int
> If this is called only at init it can also be a devinit ?

Ok.

>> +     if (rc) {
>> +             dev_dbg(&pd->dev, "Headset inserted during boot up!\n");
>> +             dd->othc_ir_state = true;
>> +             input_report_switch(dd->othc_ipd, SW_HEADPHONE_INSERT, 1);
>> +             input_sync(dd->othc_ipd);
>> +     }
> Not a comment. However I did not understand why the status at boot is required here.

We need to report right status when the system boots up with headset inserted.

>> +
>> +fail_sw_irq:
>> +     free_irq(dd->othc_irq_ir, dd);
>> +fail_ir_irq:
>> +     input_unregister_device(ipd);
> Unregister and then falling back to free may not be what you intended.
> 

Nope. Please see we are making othc_ipd = NULL, so everything should be fine.

Thanks for the review comments.

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
