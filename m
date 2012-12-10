Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2LJVmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:42:35 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41993 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2LJVme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:42:34 -0500
Message-ID: <50C65746.8030609@kernel.org>
Date: Mon, 10 Dec 2012 21:42:30 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C63BBD.3080202@ahsoftware.de> <50C64484.4060306@metafoo.de> <50C65381.8010609@ahsoftware.de> <50C6567D.7080303@metafoo.de>
In-Reply-To: <50C6567D.7080303@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 09:39 PM, Lars-Peter Clausen wrote:
> On 12/10/2012 10:26 PM, Alexander Holler wrote:
>> Am 10.12.2012 21:22, schrieb Lars-Peter Clausen:
>>> On 12/10/2012 08:45 PM, Alexander Holler wrote:
>>>> Am 10.12.2012 18:05, schrieb Lars-Peter Clausen:
>>>>
>>>>> Looks pretty good now. But there are still some IIO remnants which should be
>>>>> removed as well. Also the driver should move to drivers/rtc/ since, well,
>>>>> it's a rtc driver not a IIO driver.
>>>>
>>>> I think it still should be stick to iio, because that is where all HID
>>>> sensors currently are found and where the user would expect to find such
>>>> a driver.
>>>
>>> That's because all the current IIO sensor drivers fall in the IIO domain. This
>>> one clearly is a RTC driver, so it belongs in drivers/rtc/
>>
>> Where nobody will find it if he searches for drivers for his HID sensor.
>> I still see it as HID sensor driver and not a rtc-driver.
>> But ...
> 
> I can understand your position, but drivers are usually grouped by function not
> by topology. If there is a proper Kconfig help text people should hopefully be
> find it.
Seconded on this. If it is a pure rtc driver then it definitely belongs in
drivers/rtc.  Now there might have been ways of doing this as a consumer / provider
with the provider being in IIO and the consumer in rtc, but that sounds like
it is over compicating things, at least for now.

> 
>>
>>>
>>>>
>>>>>> +/* Channel definitions */
>>>>>> +static const struct iio_chan_spec hid_time_channels[TIME_RTC_CHANNEL_MAX] = {
>>>>
>>>> And that is imho the last remaining iio-stuff. If necessary I can remove
>>>> it too.
>>>
>>> That and the remaining bits of the read_raw callback.
>>
>> Ok. I will make a v3.
>>
> 
> Btw. have you seen the other comments I had inline in my response to your v2?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
