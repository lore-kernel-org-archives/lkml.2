Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1EDJBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:01:07 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:56195 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1EDJBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:01:05 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DC1165C.4000103@cam.ac.uk>
Date: Wed, 04 May 2011 10:03:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [lm-sensors] [RFC 5/5] hwmon: add support for Technologic Systems
 TS-5500 A-D converter
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-6-git-send-email-vivien.didelot@savoirfairelinux.com> <20110430033938.GA14397@ericsson.com> <1304434162-sup-3877@sfl>
In-Reply-To: <1304434162-sup-3877@sfl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/11 16:55, Vivien Didelot wrote:
> Hi Guenter,
> 
> Excerpts from Guenter Roeck's message of 2011-04-29 23:39:38 -0400:
>> Hi Vivien,
>>
>> The headline and file name are a bit misleading, since the driver is really
>> for MAX197 on a TS-5500 board.
>>
>> You should split the driver into two parts, a generic driver
>> for the MAX197 and a platform driver (residing somewhere in arch/
>> or possibly drivers/platform/) to instantiate it.
>>
>> There should be a platform data include file, probably in
>> include/linux/platform_data/.
>>
>> .ioaddr in platform data should not be necessary. The driver's probe
>> function should get the values using platform_get_resource().
>>
>> Having said that, from reading the code it looks like the chip is not really
>> used for hardware monitoring, but for generic ADC functionality. A quick look
>> into the TS-5500 user manual confirms this. So this should not be a hwmon
>> driver in the first place, but a generic ADC driver. Given the ADC conversion rate
>> of the MAX197, the hwmon ABI is not optimal anyway. You should move this driver
>> into the iio subsystem, probably to drivers/staging/iio/adc. Copying the iio
>> mailing list for input.
>>
>> Thanks,
>> Guenter
> 
> I've took a closer look to the manual and that's right, in fact the
> driver doesn't talk to the MAX197 directly. The board uses a CPLD to
> abstract the interface to the MAX197. So all the MAX197 logic is hidden
> by the CPLD.  Therefore, the driver files should probably not have
> function and structure names with a "max197_" prefix. I'll make the code
> a bit clearer. What do you think?
> 
> Ok for iio subsystem, several ADC drivers are in drivers/hwmon/ but
> drivers/staging/iio/adc seems to be the good place now.
Just as a heads up, beware there are a few abi changes (and a lot of core
ones) working their way through review /already in staging-next.
I only mention it because merges against that tree will go through staging-next
and as it's name suggests is sometimes a fast moving target!

Jonathan
> Regards,
> Vivien.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-serial" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

