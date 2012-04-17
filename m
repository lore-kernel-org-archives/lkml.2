Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2DQL7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:59:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9946 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2DQL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:59:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 17 Apr 2012 04:59:17 -0700
Message-ID: <4F8D5B09.8080309@nvidia.com>
Date: Tue, 17 Apr 2012 17:29:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "max@stro.at" <max@stro.at>,
        "jbrenner@taosinc.com" <jbrenner@taosinc.com>,
        "bfreed@chromium.org" <bfreed@chromium.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: iio: light: isl29018: use regmap for register
 access
References: <1334652631-21032-1-git-send-email-ldewangan@nvidia.com> <4F8D5506.6070105@cam.ac.uk>
In-Reply-To: <4F8D5506.6070105@cam.ac.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


HI Jonathan,

Thanks for fast review.

On Tuesday 17 April 2012 05:03 PM, Jonathan Cameron wrote:
> On 4/17/2012 9:50 AM, Laxman Dewangan wrote:
>> Using regmap for accessing register through i2c bus. This will
>> remove the code for caching registers, read-modify-write logics.
>> Also it will provide the debugfs feature to dump register
>> through regmap debugfs.
> I'd prefer the intial tab fixup for the kconfig file as a separate
> patch, but other than that
> all looks good.
>

Yes, this make sense. I will create fist patch for fixing this and then 
next patch for actual my change.

> This will probably cause issues alongside the series I sent to Greg the
> other day though
> so you may want to sit on it for a day or two and rebase.

I will wait for your change to be in linux-next and then I will create 
next patches.

>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Acked-by: Jonathan Cameron<jic23@kernel.org>
>> ---
>>    drivers/staging/iio/light/Kconfig    |   19 ++--
>>    drivers/staging/iio/light/isl29018.c |  176 +++++++++++++++++-----------------
>>    2 files changed, 99 insertions(+), 96 deletions(-)
>>
>> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
>> index 53b49f7..fd39f72 100644
>> --- a/drivers/staging/iio/light/Kconfig
>> +++ b/drivers/staging/iio/light/Kconfig
>> @@ -4,15 +4,16 @@
>>    menu "Light sensors"
>>
>>    config SENSORS_ISL29018
>> -        tristate "ISL 29018 light and proximity sensor"
>> -        depends on I2C
>> -        default n
>> -        help
>> -         If you say yes here you get support for ambient light sensing and
>> -         proximity infrared sensing from Intersil ISL29018.
>> -         This driver will provide the measurements of ambient light intensity
>> -         in lux, proximity infrared sensing and normal infrared sensing.
>> -         Data from sensor is accessible via sysfs.
>> +     tristate "ISL 29018 light and proximity sensor"
>> +     depends on I2C
>> +     select REGMAP_I2C
>> +     default n
>> +     help
>> +      If you say yes here you get support for ambient light sensing and
>> +      proximity infrared sensing from Intersil ISL29018.
>> +      This driver will provide the measurements of ambient light intensity
>> +      in lux, proximity infrared sensing and normal infrared sensing.
>> +      Data from sensor is accessible via sysfs.
> Down to here is a valid but unconnected change.  Can you break this out
> to a separate patch?

Sure, I will do.
