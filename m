Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416Ab2LITT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 14:19:27 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:53803 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934391Ab2LITTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 14:19:25 -0500
Message-ID: <50C4E464.9070509@metafoo.de>
Date: Sun, 09 Dec 2012 20:20:04 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121027 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3] iio: add rtc-driver for HID sensors of type time
References: <1355055699-2965-1-git-send-email-holler@ahsoftware.de> <1355055699-2965-4-git-send-email-holler@ahsoftware.de> <50C48A42.9070806@metafoo.de> <50C4BEFF.2010304@ahsoftware.de> <50C4D58E.4020702@ahsoftware.de>
In-Reply-To: <50C4D58E.4020702@ahsoftware.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2012 07:16 PM, Alexander Holler wrote:
> Am 09.12.2012 17:40, schrieb Alexander Holler:
>> Am 09.12.2012 13:55, schrieb Lars-Peter Clausen:
>>> On 12/09/2012 01:21 PM, Alexander Holler wrote:
>>>> This driver makes the time from HID sensors (hubs) which are offering
>>>> such available like any other RTC does.
>>>>
>>>> Currently the time can only be read. Setting the time must be done
>>>> through sending a report, which currently isn't supported by
>>>> hid-sensor-hub.
>>>>
>>>> It is necessary that all values like year, month etc, are send as
>>>> 8bit values (1 byte each) and all of them in 1 report. Also the
>>>> spec HUTRR39b doesn't define the range of the year field, we
>>>> tread it as 0 - 99 because that's what most RTCs I know about are
>>>> offering.
>>>
>>> I don't think we should register a IIO device for this. Just an RTC
>>> device
>>> should be fully sufficient.
>>>
>>
>> You would have to implement all the used services hid-sensor-hub offers
>> in the rtc-driver again.
> 
> Besides that, time is part of the spec for HID sensors, which makes
> sense. Making that available as a RTC to read/set the time is imho the
> best to way support that. If you want a driver which doesn't use the HID
> sensor hub framework (or iio), you would either have to define your own
> standard or make sure it is interoperable with the HID sensor hub
> framework, which might not be trivial.

I agree with what you wrote above. It just doesn't make sense to register a IIO
device for a RTC type device. Just rip out all the IIO related bits from the
driver and it will be fine.

- Lars

