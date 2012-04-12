Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471Ab2DLKBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 06:01:10 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:39363 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab2DLKBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 06:01:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F86A7DE.5040203@cam.ac.uk>
Date: Thu, 12 Apr 2012 11:01:02 +0100
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
Subject: Re: [PATCH V2 2/2] staging: Documentation: add proximity_sampling_period
 as sysfs details
References: <1334214492-23044-1-git-send-email-ldewangan@nvidia.com> <1334214492-23044-3-git-send-email-ldewangan@nvidia.com> <4F86A26B.1090209@cam.ac.uk> <4F86A4EB.4040202@nvidia.com>
In-Reply-To: <4F86A4EB.4040202@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 10:48 AM, Laxman Dewangan wrote:
> On Thursday 12 April 2012 03:07 PM, Jonathan Cameron wrote:
>> On 4/12/2012 8:08 AM, Laxman Dewangan wrote:
>>> +What:        /sys/bus/iio/devices/device[n]/proximity_sampling_period
>>> +KernelVersion:    3.5
>>> +Contact:    linux-iio@vger.kernel.org
>>> +Description:
>>> +        Hardware dependent mode for proximity sensor device to set/get
>>> +        the sampling rate of proximity sensing and conversion.
>> Ah, that explains what it is.  Sorry, use
>> in_proximitiy0_sampling_frequency to provide equivalent
>> control please.  Might be a pain here, but this interface will just
>> provide the same info as the existing
>> one in a different form.  Note that sampling_frequency is documented as
>> a general one, but can
>> be extended to individual channels.
>>
>
> Ooop, I did not realize that it is there as part of sysfs.h. I was 
> looking for other header to get
> support for this. I can use this for proximity only but I think I 
> should go with you other
> suggestion to implement this on channel basis. This will help also in 
> future for other
> drivers to have different sampling on different channel.
Great!
>> Actually add it to the iio-core as an element in the info_mask as I
>> doubt this will be the last time
>> we see this control. This will need to be a precursor patch to the
>> driver obviously.
>>
>> IIO_CHAN_INFO_SAMP_FREQ and the relevant shared and separate macros need
>> to go in
>> iio.h + the text entry in industrialio-core.c
>>
>> If you like I can do this but it'll be quicker if you do :)
>
> I will send the patch for implementing this first and then modified 
> version of my driver which actually uses this one.
Cool
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

