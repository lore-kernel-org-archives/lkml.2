Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab0GBMeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:34:05 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:56598 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab0GBMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:34:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C2DDD2B.5090401@jic23.retrosnub.co.uk>
Date: Fri, 02 Jul 2010 13:35:55 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
       "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
       "sfking@fdwdc.com" <sfking@fdwdc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] digital compass hmc5843
References: <0680EC522D0CC943BC586913CF3768C003B360319D@dbde02.ent.ti.com> <4C2CBB40.5070104@cam.ac.uk> <0680EC522D0CC943BC586913CF3768C003B3603331@dbde02.ent.ti.com> <4C2DBBE3.1020804@cam.ac.uk> <0680EC522D0CC943BC586913CF3768C003B360338A@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B360338A@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/10 11:53, Datta, Shubhrajyoti wrote:
>>
>> <snip>
>>>
>>> I think that having a Hz as units will have its own issues. First the
>> decimal implementation. However I am open to the implementation.
>>> Also do you know of a driver that takes care of this.
>> None of the current drivers go below 1Hz so not quite the same.
>> lis3l02dq (accelerometer) does the match against a list, but it
>> is done numerically rather than via string matches as would be needed
>> here.
>>>
>>>>
>>>> static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("0.5 1 2 5 10 20 50");
>>>>
>>>>
>>>> Then strncmp with the options to set the value up.  The rounding
>> approach
>>>> gets tricky with a non integer value so probably easier to only allow
>>>> these
>>>> values.
> 
> What is a recommended way of getting a double or float
> Is there any Strict_srttod etc.
> 
You can't, hence the suggestion of comparing strings not numerical values.

>>>
>>> Allowing only this value will result in default/ reject case and will
>> keep the previous value, may confuse the application
>> Then the application is ignoring the interface spec that says it must read
>> _available files if they are there.
>> This way the rounding behaviour is left to userspace and what the
>> application prefers rather
>> than in kernel actually making it the most flexible option.
> 
> Agree 
>>>
>>>>
>>>>> +static IIO_DEV_ATTR_AVAIL_SAMP_FREQ(show_avail_samp_freq);
>>>>> +
>>>>> +static s32 hmc5843_set_rate(struct i2c_client *client,
>>>>> +                               u8 rate)
>>>>> +{
>>>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>>>> +       u8 reg_val;
>>>>> +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

