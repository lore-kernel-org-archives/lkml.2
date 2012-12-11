Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2LKJkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:40:07 -0500
Received: from smtp-out-245.synserver.de ([212.40.185.245]:1137 "EHLO
	smtp-out-245.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2LKJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:40:05 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1233
Message-ID: <50C6FF71.1010504@metafoo.de>
Date: Tue, 11 Dec 2012 10:40:01 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
CC: Alexander Holler <holler@ahsoftware.de>,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C63BBD.3080202@ahsoftware.de> <50C64484.4060306@metafoo.de> <50C65381.8010609@ahsoftware.de> <50C6567D.7080303@metafoo.de> <50C65746.8030609@kernel.org> <50C6674D.1000901@ahsoftware.de> <50C6FD60.7080300@jic23.retrosnub.co.uk>
In-Reply-To: <50C6FD60.7080300@jic23.retrosnub.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 10:31 AM, Jonathan Cameron wrote:
> On 10/12/12 22:50, Alexander Holler wrote:
>> Am 10.12.2012 22:42, schrieb Jonathan Cameron:
>>> On 12/10/2012 09:39 PM, Lars-Peter Clausen wrote:
>>>> On 12/10/2012 10:26 PM, Alexander Holler wrote:
>>>>> Am 10.12.2012 21:22, schrieb Lars-Peter Clausen:
>>>>>> On 12/10/2012 08:45 PM, Alexander Holler wrote:
>>>>>>> Am 10.12.2012 18:05, schrieb Lars-Peter Clausen:
>>>>>>>
>>>>>>>> Looks pretty good now. But there are still some IIO remnants
>>>>>>>> which should be
>>>>>>>> removed as well. Also the driver should move to drivers/rtc/
>>>>>>>> since, well,
>>>>>>>> it's a rtc driver not a IIO driver.
>>>>>>>
>>>>>>> I think it still should be stick to iio, because that is where all
>>>>>>> HID
>>>>>>> sensors currently are found and where the user would expect to
>>>>>>> find such
>>>>>>> a driver.
>>>>>>
>>>>>> That's because all the current IIO sensor drivers fall in the IIO
>>>>>> domain. This
>>>>>> one clearly is a RTC driver, so it belongs in drivers/rtc/
>>>>>
>>>>> Where nobody will find it if he searches for drivers for his HID
>>>>> sensor.
>>>>> I still see it as HID sensor driver and not a rtc-driver.
>>>>> But ...
>>>>
>>>> I can understand your position, but drivers are usually grouped by
>>>> function not
>>>> by topology. If there is a proper Kconfig help text people should
>>>> hopefully be
>>>> find it.
>>> Seconded on this. If it is a pure rtc driver then it definitely
>>> belongs in
>>> drivers/rtc.  Now there might have been ways of doing this as a
>>> consumer / provider
>>> with the provider being in IIO and the consumer in rtc, but that
>>> sounds like
>>> it is over compicating things, at least for now.
>>
>> Personally I just want to use it to have HID-USB_RTCs. ;)
>>
>> But in case of HID sensor hubs, the main usage of that driver will be to
>> set the time of such hubs (something I still have to make patches for),
>> and not to read it. So if you think as an HID sensor user, it should
>> belong to iio or wherever those sensor will finally end up (I think they
>> should end up in HID and should be usable by bluetooth devices too), but
>> if you creatively misuse the standard to get a driver for USB-RTCs, as I
>> want, then rtc is the correct place. ;)
> I did wonder what you were up to ;)
>>
>> Because I don't want to do a v4:
>>
>> the driver has an
>>
>> #include "../common/hid-sensors/hid-sensor-attributes.h"
>>
>> so moving it to drivers/rtc/ will make that even more ugly.
>>
> 
>> Suggestions? I don't really care and as I'm currently at the order
>> receiving end ;) I would change it to whatever the maintainers are
>> wanting. Maybe moving that header to include/linux or even integrating
>> it into include/linux/hid-sensor-hubs.h makes sense.
> Yes, move the header or merge into existing one as makes sense.
> I'm not pulling this driver into the IIO tree (unless for some
> reason Alessandro wants me to and I can't think why he would...).
> 

Alessandro has been pretty quiet for quite some time now. Luckily Andrew
Morton usually picks up the stuff for orphaned subsystems. So put him on Cc
for v4.

- Lars
