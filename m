Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2LNNJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:09:20 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58436 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2LNNJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:09:19 -0500
Message-ID: <50CB24D4.3030606@ahsoftware.de>
Date: Fri, 14 Dec 2012 14:08:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4 v4] rtc: add rtc-driver for HID sensors of type time
References: <50C8591A.3030301@ahsoftware.de> <1355310680-2466-1-git-send-email-holler@ahsoftware.de> <50CAF473.6040901@metafoo.de>
In-Reply-To: <50CAF473.6040901@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.12.2012 10:42, schrieb Lars-Peter Clausen:
> On 12/12/2012 12:11 PM, Alexander Holler wrote:
>> This driver makes the time from HID sensors (hubs) which are offering
>> such available like any other RTC does.
>>
>> Currently the time can only be read. Setting the time must be done
>> through sending a report, which currently isn't supported by
>> hid-sensor-hub. (I've planned to submit patches.)
>>
>> It is necessary that all values like year, month etc, are send as
>> 8bit values (1 byte each) and all of them in 1 report. Also the
>> spec HUTRR39b doesn't define the range of the year field, we
>> tread it as 0 - 99 because that's what most RTCs I know about are
>> offering.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>
> Hi,
>
> sorry for the delay. There is still the __devinit in front of
> hid_time_remove left.
>
> And another thing I've overlooked before:
> wait_for_completion_interruptible_timeout can either return a positive
> number when the completion was completed, 0 in case of an timeout, or a
> negative error code in case it was interrupted. You need to handle all
> three. E.g. something like this.
>
> ret = wait_for_completion_interruptible_timeout(...)
> if (ret == 0)
> 	return -EIO;
> if (ret < 0)
> 	return ret
>

Hmpf, the only working approach to use some in kernel functions really 
is to the read source yourself and don't trust anything else. :/

And that ping-ping is stressing my patience, I think I will write a rfc 
to introduce (at least allow) maintainer-patches.

Will make a v5.

Regards,

Alexander
