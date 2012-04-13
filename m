Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013Ab2DMKFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:05:48 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:47758 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800Ab2DMKFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:05:44 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F87FA6D.7080700@cam.ac.uk>
Date: Fri, 13 Apr 2012 11:05:33 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "jbrenner@taosinc.com" <jbrenner@taosinc.com>,
        Rhyland Klein <rklein@nvidia.com>, "max@stro.at" <max@stro.at>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH V4 2/2] staging: iio: add driver for isl29028
References: <1334239266-29505-1-git-send-email-ldewangan@nvidia.com> <1334239266-29505-3-git-send-email-ldewangan@nvidia.com> <4F86E7F9.7000303@cam.ac.uk> <4F87F662.7040204@nvidia.com>
In-Reply-To: <4F87F662.7040204@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/2012 10:48 AM, Laxman Dewangan wrote:
> On Thursday 12 April 2012 08:04 PM, Jonathan Cameron wrote:
>> On 4/12/2012 3:01 PM, Laxman Dewangan wrote:
>>> Intersil's ISL29028 is concurrent Ambient Light and
>>> Proximity Sensor device.
>>> Add driver to access the light and IR intensity and
>>> proximity value via iio interface.
>> Very nearly there.  The available attributes need to match naming
>> of what they are providing values for. (we need a better way of handling
>> these but that's a job for another day).
>>
>> Otherwise, all good.
>
> Fine, I will do change.
>
>>> +     mutex_unlock(&chip->lock);
>>> +     return ret;
>>> +}
>>> +
>>> +static IIO_CONST_ATTR(proximity_sampling_frequency_available,
>>> +                             "1, 3, 5, 10, 13, 20, 83, 100");
>>> +static IIO_CONST_ATTR(illuminance_scale_available, "125, 2000");
>>> +
>>> +#define ISL29028_DEV_ATTR(name) (&iio_dev_attr_##name.dev_attr.attr)
>>> +#define ISL29028_CONST_ATTR(name) 
>>> (&iio_const_attr_##name.dev_attr.attr)
>>> +static struct attribute *isl29028_attributes[] = {
>>> +     ISL29028_CONST_ATTR(proximity_sampling_frequency_available),
>> tiny disconnect now that you have in_proximity0_sampling frequency, this
>> should be in_proximity0_sampling_frequency_available
>>
>
> I saw the attribute appear as
> in_illuminance_input
> in_illuminance_scale
> in_intensity_raw
> in_proximity_raw
> in_proximity_sampling_frequency
>
>
> As I have not set  the .indexed to non-zero,  I will go as non-indexd 
> name like
> in_proximity_sampling_frequency_available.
Fair enough.
>
>>> +     ISL29028_CONST_ATTR(illuminance_scale_available),
>> snap here (sorry, missed that last time).
>>
>> in_illuminance0_scale_available
>>
>
> I think should be in_illuminance_scale_available
yup
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

