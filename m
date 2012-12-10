Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2LJWvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:51:53 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:48625 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2LJWvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:51:51 -0500
Message-ID: <50C6674D.1000901@ahsoftware.de>
Date: Mon, 10 Dec 2012 23:50:53 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C63BBD.3080202@ahsoftware.de> <50C64484.4060306@metafoo.de> <50C65381.8010609@ahsoftware.de> <50C6567D.7080303@metafoo.de> <50C65746.8030609@kernel.org>
In-Reply-To: <50C65746.8030609@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.12.2012 22:42, schrieb Jonathan Cameron:
> On 12/10/2012 09:39 PM, Lars-Peter Clausen wrote:
>> On 12/10/2012 10:26 PM, Alexander Holler wrote:
>>> Am 10.12.2012 21:22, schrieb Lars-Peter Clausen:
>>>> On 12/10/2012 08:45 PM, Alexander Holler wrote:
>>>>> Am 10.12.2012 18:05, schrieb Lars-Peter Clausen:
>>>>>
>>>>>> Looks pretty good now. But there are still some IIO remnants which should be
>>>>>> removed as well. Also the driver should move to drivers/rtc/ since, well,
>>>>>> it's a rtc driver not a IIO driver.
>>>>>
>>>>> I think it still should be stick to iio, because that is where all HID
>>>>> sensors currently are found and where the user would expect to find such
>>>>> a driver.
>>>>
>>>> That's because all the current IIO sensor drivers fall in the IIO domain. This
>>>> one clearly is a RTC driver, so it belongs in drivers/rtc/
>>>
>>> Where nobody will find it if he searches for drivers for his HID sensor.
>>> I still see it as HID sensor driver and not a rtc-driver.
>>> But ...
>>
>> I can understand your position, but drivers are usually grouped by function not
>> by topology. If there is a proper Kconfig help text people should hopefully be
>> find it.
> Seconded on this. If it is a pure rtc driver then it definitely belongs in
> drivers/rtc.  Now there might have been ways of doing this as a consumer / provider
> with the provider being in IIO and the consumer in rtc, but that sounds like
> it is over compicating things, at least for now.

Personally I just want to use it to have HID-USB_RTCs. ;)

But in case of HID sensor hubs, the main usage of that driver will be to 
set the time of such hubs (something I still have to make patches for), 
and not to read it. So if you think as an HID sensor user, it should 
belong to iio or wherever those sensor will finally end up (I think they 
should end up in HID and should be usable by bluetooth devices too), but 
if you creatively misuse the standard to get a driver for USB-RTCs, as I 
want, then rtc is the correct place. ;)

Because I don't want to do a v4:

the driver has an

#include "../common/hid-sensors/hid-sensor-attributes.h"

so moving it to drivers/rtc/ will make that even more ugly.

Suggestions? I don't really care and as I'm currently at the order 
receiving end ;) I would change it to whatever the maintainers are 
wanting. Maybe moving that header to include/linux or even integrating 
it into include/linux/hid-sensor-hubs.h makes sense.

Regards,

Alexander
