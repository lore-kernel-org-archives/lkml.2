Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0IFM5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:57:08 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:44094 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0IFM5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:57:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C84E64D.4040600@jic23.retrosnub.co.uk>
Date: Mon, 06 Sep 2010 14:02:05 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [IIO] Proposal for sysfs attributes
References: <4C84A93B.2050507@iis.fraunhofer.de>
In-Reply-To: <4C84A93B.2050507@iis.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/10 09:41, Manuel Stahl wrote:
> Hi all,
> 
> there were some sysfs userspace questions on linux-iio where we would like to get some more comments on.
> 
> First thing, there are some attributes describing the layout of a
> ring buffer that can be read out via a char device. The buffer
> contains several entries with each containing so called scan
> elements. All entries have the same layout. It is described in a
> directory scan_elements (see below) that contains three attributes
> per scan element.
> 
>> OK, no packed buffers for now, but we should implement variable
>> sample sizes for standard types. Indeed we already have this for
>> the timestamp, which is always 64 bit.
>>
>> To be compatible with future extensions we could have:
>>    |- /sys/bus/iio/device0/buffer0/scan_elements/
>>       |- accel_x_en    (0 or 1)
>>       |- accel_x_type  (i.e. s14/16, see *)
>>       |- accel_x_index (position inside the buffer entry)
>>
>> * s14/16 means signed 14 bits, stored in 16 bits, right aligned.
>>   If it's left aligned we can just modify the scale attribute and
>>   give the 16 bit interpretation in <channel>_raw.
> 
> Is the 's14/16' self explaining or should we use some other format?
> Is 'type' a good postfix for the attribute?

One additional point here.  What we currently have that the enable
parameters are currently [m]_accel_x_en etc with m being an indicator
of the position of a parameter within the buffer.  Note not all channels
are enabled at a time.  For all devices we have so far, the ordering
is fixed, so this naming is constant.  Basically we roll the accel_x_index
attribute into the naming of the enable attribute.  Manuel, could you summarize
what you have against that approach? (I'm not particularly tied to it, but
it is in place and it does work).
> 
> 
> Next question: how strictly we want to resamble the hwmon ABI?
> 
> To sum up the discussion:
> Hwmon has files with the postfix _input to read values scaled to
> reasonable units for fixed point representation. So the units are
> sometimes scaled down to 'millis' e.g. millivolt, millidegree Celsius.
> We agreed that we want to keep this, whenever we use the _input postfix.
> For IIO there is also the postfix triple _raw, _scale and _offset,
> where the final value is calculated by (_raw + _offset) * _scale.
> Floating point values are allowed for any of these files.
(other than _raw obviously!)
> 
> The question in place was:
> Do we want to resemble the 'milli' units or should we stick to
> standard SI units (radians, kelvin, etc.) as floating point math is
> necessary anyway.
I've cc'd a few people who have contributed to previous abi discussions
for IIO in ways that make me think they may have opinions on this.

