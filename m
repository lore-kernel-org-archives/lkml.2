Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0LIKvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:51:05 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:47226 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab0LIKvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:51:03 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D00B627.6040301@cam.ac.uk>
Date: Thu, 09 Dec 2010 10:57:43 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101123 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [RFC 1/3] IIO: Direct digital synthesis abi documentation
References: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com> <1291292489-32362-2-git-send-email-michael.hennerich@analog.com> <4CF8CED9.9060306@cam.ac.uk> <544AC56F16B56944AEC3BD4E3D591771312F0E1BB3@LIMKCMBX1.ad.analog.com> <4CFE0C03.3010405@cam.ac.uk> <544AC56F16B56944AEC3BD4E3D591771312F0E232B@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D591771312F0E232B@LIMKCMBX1.ad.analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/10 05:48, Hennerich, Michael wrote:
> Jonathan Cameron wrote on 2010-12-07:
>> On 12/07/10 05:18, Hennerich, Michael wrote:
>>>> Jonathan Cameron wrote on 2010-12-03:
>>>> On 12/02/10 12:21, michael.hennerich@analog.com wrote:
>>>>> From: Michael Hennerich <michael.hennerich@analog.com>
>>>>>
>>>>> Proposed ABI documentation
>>>>>
> 
>>>>> What:              /sys/bus/iio/devices/device[n]/ddsX_freqY
>>>> Here we deviate a little from what we did with input channels. In that
>>>> case there was the existing interface (from hwmon) to match so we
>>>> already had an _input designation to tell us that the number was in
>>>> the relevant base units (here it would be Hz).  Hence we added a _raw
>>>> label to say it wasn't and tell userspace to apply scale and offset.
>>>> This is stretching a point somewhat, but looking at the hwmon docs,
>>>> they have pwmX_freq as a value in Hz. That's obviously going to make
>>>> consistency rather tricky to achieve!
>>>>
>>>> Do you think we should leave all _freq without modifier as being in Hz
>>>> and have ddsX_freqY_raw. Or should we rely on userspace verifying if
>>>> there are appropriate scale / offset parameters to be applied and
>>>> hence working out for itself whether the value in ddsX_freqY is in Hz
>>>> or not?
>>>>
>>>> I'm think I marginally favour leaving it as you have it here but
>>>> others may have different opinions.
>>>
>>> Offset is not likely to be used here - but these devices actually
>>> provide sub Hertz resolution. It's very likely to occur, that we
>>> want to have scale being 1000 and the user writes frequency in mHz.
>>> I might even consider using mHz for the sample driver as well.
>> I guess it's a question of whether doing the fixed point arithmetic in
>> kernel is cheap enough to use Hz but allow for a decimal point?  That
>> would remove the need for the _scale parameter which would simplify
>> the user interface slightly.
>>
>> Lets go with what you originally suggested. It works and with clear
>> documentation the difference between it and some of our other
>> 'frequency' elements shouldn't confuse anyone.
> 
> I prefer the _scale parameter.
Fine with me.
> Not aware of any other sysfs files, taking decimal points.
Hmm.. There is at least on in IIO that takes decimal inputs (hmc5834),
though I think only in the category where there is an _available attribute
to list the possibilities. Output wise quite a few use decimals
(your ad799x for starters!)  IIRC there are a few more cases in drivers
Alan Cox has submitted recently (not sure what merge status is on those).



>>>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_out_disable
>>>>> +KernelVersion:     2.6.37
>>>>> +Contact:   linux-iio@vger.kernel.org
>>>>> +Description:
>>>>> +           Disables any signal generation on all outputs.
>>>> With the X in there you need to say for dds X. On everything else so
>>>> far we have tended to go with enable attributes rather than this way
>>>> around.  Why do it as disable here?
>>>
>>> We can change the logic. The sample driver enables the output once the
>>> ddsX_outY_wavetype file is written.
>> Is that a good idea? What if a device is dependant on having a very
>> particular frequency fed to it and the user not knowing that wavetype
>> turns things on might set that before the frequency? The semantics
>> don't make it clear that one must set the wavetype last.  I would
>> think separating the configuration from enable/disable might be more
>> intuitive.
> 
> I agree.

Looks like we've pinned this down so that we are both happy. No one else
has picked up on it, so I guess no one else is currently interested in
DDS support.

I'll be happy to do a final review of an updated patch set.

Thanks,

Jonathan
