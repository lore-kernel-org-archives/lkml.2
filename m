Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0IUKV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:21:57 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:46183 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0IUKVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:21:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C988880.4060609@jic23.retrosnub.co.uk>
Date: Tue, 21 Sep 2010 11:27:12 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Hemanth V <hemanthv@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH V3 1/2] input: CMA3000 Accelerometer driver
References: <61033.10.24.255.18.1283926671.squirrel@dbdmail.itg.ti.com> <4C877584.7000902@jic23.retrosnub.co.uk> <20100914080003.GD15167@core.coreip.homeip.net> <4C8F7429.1080105@jic23.retrosnub.co.uk> <007601cb5950$55d52980$LocalHost@wipblrx0099946>
In-Reply-To: <007601cb5950$55d52980$LocalHost@wipblrx0099946>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/10 06:46, Hemanth V wrote:
> ----- Original Message ----- From: "Jonathan Cameron" <kernel@jic23.retrosnub.co.uk>
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> Cc: "Hemanth V" <hemanthv@ti.com>; <linux-input@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <linux-omap@vger.kernel.org>
> Sent: Tuesday, September 14, 2010 6:40 PM
> Subject: Re: [PATCH V3 1/2] input: CMA3000 Accelerometer driver
> 
> 
>> On 09/14/10 09:00, Dmitry Torokhov wrote:
>>> On Wed, Sep 08, 2010 at 12:37:40PM +0100, Jonathan Cameron wrote:
>>>>
>>>> I'm happy to see your driver go in as it is currently, what bothers me is that we will end
>>>> up with incompatible interfaces for all the accelerometers Dmitry takes!
>>>>
>>>
>>> This is a valid concern. How about I chicken out and will not merge any
>>> new sysfs knobs until you guys decide on reasonable interface? Most set
>>> up is done by board code anyways, sysfs is more of nice-to-have?
>> Hemanth, would removing the sysfs hooks from this driver be ok with you?
>> I'd personally have favoured a merge, add new interfaces when agreed and
>> deprecate old ones approach, but it is Dmitry's call.  Perhaps it is better
>> to get the majority of the device functionality in place now and add
>> the bells and whistles later.
>>
>> For input device things are probably mostly fixed for a particular board
>> design.  There are definitely interesting things one can do if the knobs
>> are available but they (I think) mostly fall outside of using the device
>> for input!
>>
> 
> Dmitry, Jonathan
> 
> I am ok to remove the sysfs entries for now, but would cause some limitations
> like not being able to change sampling frequency / disabling interrupts runtime.
> 
> Wanted to clarify if the intention is to come up with a standard sysfs interface
> for all accelerometer drivers under input/misc including adxl34x.
The intent is to come up with an interface covering a much wider range of devices
if at all possible. I've proposed options for conventional threshold and rate of
change interrupts on IIO (you were cc'd IIRC). I'll propose those on to lkml shortly
and suggest that others suggest the interfaces they would like to see added (or
object to the syntax for the ones I've covered!)

To be honest, sampling frequency is much more general and I would imagine applies to
lots of input drivers.  Do you already have a standard for this Dmitry?

Jonathan
