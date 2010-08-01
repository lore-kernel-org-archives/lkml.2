Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0HAGN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:13:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab0HAGNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:13:55 -0400
Message-ID: <4C551058.20509@redhat.com>
Date: Sun, 01 Aug 2010 08:12:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hwmon: f71882fg: Add support for the Fintek F71808E
References: <20100323141718.GA23172@salidar.me.mortis.eu> <1269385936-3440-1-git-send-email-me@mortis.eu> <4BA9CC64.5010807@redhat.com> <20100324092357.GE6368@salidar.me.mortis.eu> <4BA9EA0C.6070200@redhat.com> <20100731233121.GD3711@salidar.me.mortis.eu>
In-Reply-To: <20100731233121.GD3711@salidar.me.mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/01/2010 01:31 AM, Giel van Schijndel wrote:
> On Wed, Mar 24, 2010 at 11:31:40 +0100, Hans de Goede wrote:
>> On 03/24/2010 10:23, Giel van Schijndel wrote:
>>> On Wed, Mar 24, 2010 at 09:25:08 +0100, Hans de Goede wrote:
>>>> See comments inline.
>>>>
>>>> On 03/24/2010 12:12 AM, Giel van Schijndel wrote:
>>>>> Allow device probing to recognise the Fintek F71808E.
>>>>>
>>>>> Sysfs interface:
>>>>>     * Fan/pwm control is the same as for F71889FG
>>>>>     * Temperature and voltage sensor handling is largely the same as for
>>>>>       the F71889FG
>>>>>      - Has one temperature sensor less (doesn't have temp3)
>>>>>      - Misses one voltage sensor (doesn't have V6, thus in6_input refers to
>>>>>        what in7_input refers for F71889FG)
>>>>>
>>>>> For the purpose of the sysfs interface fxxxx_in_temp_attr[] is split up
>>>>> such that it can largely be reused.
>>>>> ---
>>>>>    Documentation/hwmon/f71882fg |    4 ++
>>>>>    drivers/hwmon/Kconfig        |    6 ++--
>>>>>    drivers/hwmon/f71882fg.c     |   80 +++++++++++++++++++++++++++++++++++++----
>>>>>    3 files changed, 79 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
>>>>> index 25e1cad..b290b87 100644
>>>>> --- a/drivers/hwmon/f71882fg.c
>>>>> +++ b/drivers/hwmon/f71882fg.c
>>>>> @@ -1974,8 +2002,27 @@ static int __devinit f71882fg_probe(struct platform_device *pdev)
>>>>> ... snip ...
>>>>> +			/* fall through! */
>>>>
>>>> Ugh, please don't fall through, and then have an if below to only do
>>>> some parts of the case falling through. This is quite confusing at
>>>> first I thought your code was buggy I had to read it twice to notice
>>>> the if. Instead just duplicate the following lines:
>>>>> +			err = f71882fg_create_sysfs_files(pdev,
>>>>> +					fxxxx_temp_attr,
>>>>> +					ARRAY_SIZE(fxxxx_temp_attr));
>>>> In the f71862fg case, end the f71862fg case with a break and remove
>>>> the if test from the f71808fg case.
>>>>
>>>>> +		case f71808fg:
>>>>> +			if (data->type == f71808fg) {
>>>>> +				err = f71882fg_create_sysfs_files(pdev,
>>>>> +						f71808_in_attr,
>>>>> +						ARRAY_SIZE(f71808_in_attr));
>>>>> +				if (err)
>>>>> +					goto exit_unregister_sysfs;
>>>>> +			}
>>>>> +			err = f71882fg_create_sysfs_files(pdev,
>>>>> +					fxxxx_temp_attr,
>>>>> +					ARRAY_SIZE(fxxxx_temp_attr));
>>>>> ... snip ...
>>>
>>> Ack. New and improved patch follows this line.
>>> =====================================================================
>>> hwmon: f71882fg: Add support for the Fintek F71808E
>>
>> This new version looks good to me:
>> Acked-by: Hans de Goede<hdegoede@redhat.com>
>
> Thanks.  Anyone else I need to poke in order to set this on track to
> mainline?
>

No,

Jean should have picked this up, I guess it has fallen through the cracks.

I think it is probably best if you resend this patch and the watchdog patches
re-based against the latest upstream rc, then I'll re-review them and ack
them and Jean can then put them into his tree.

Thanks & Regards,

Hans
