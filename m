Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1ADMMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:12:25 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:60174 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1ADMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:12:24 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D230ED0.8060008@cam.ac.uk>
Date: Tue, 04 Jan 2011 12:13:04 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101231 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: Urs Fleisch <urs.fleisch@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: driver for Sensirion SHT21 humidity and temperature
 sensor
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>	 <4D1DF097.1080200@cam.ac.uk>	 <20110103081448.f96c413e.urs.fleisch@gmail.com>	 <4D21ADCB.4070206@cam.ac.uk> <1294078159.9786.9.camel@groeck-laptop>
In-Reply-To: <1294078159.9786.9.camel@groeck-laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/11 18:09, Guenter Roeck wrote:
> On Mon, 2011-01-03 at 06:06 -0500, Jonathan Cameron wrote:
>> On 01/03/11 07:14, Urs Fleisch wrote:
>>> Hi Jonathan,
>> When posting an updated driver, use the form
>> [PATCH V2] hwmon: driver...
>>
>> That way it will be obvious to people that it isn't just a repost of the
>> previous code.
>>>
>>> Thanks for reviewing the patch. I have fixed the issues you reported and the
>>> style problems.
>>>
>>>> Sorry, but this isn't going to be acceptable.  Classic case of magic numbers.
>>>> This needs to be broken up into several different attributes.
>>>> We have:
>>>> * control over the measurement resolution (which is somewhat fiddly
>>>> on this device)
>>>> * Battery voltage threshold > 2.25V
>>>> * Enable on chip heater
>>>
>>>> So this one is the only one I have problem with. Other two attributes are
>>>> standard (well humidity is pretty unusual but no one ever complained about
>>>> the sht15 afaik!)
>>>
> I have been thinking about this, and would like to get Jean's input.
> 
> Humidity doesn't really sound like "hardware monitoring"; more like
> environmental monitoring. But on the other side, even though humidity
> doesn't really monitor the HW, it does monitor operational conditions,
> and its reported values may have impact on system operation (eg cause a
> shutdown if humidity is too high, to prevent HW damage).
That was my original argument when I proposed the sht15 driver. No idea
if anyone actually does this though!
> 
> So question is if hwmon should include explicit environmental monitoring
> attributes or not, and if hwmon and environmental monitoring can and
> should be separated to start with (for example, what if any is the
> difference between environment temperature and hw monitoring
> temperature ?).
> 
> Thoughts, anyone ?
I wondered exactly this when we added the sht15 driver.  Never really
came to a firm conclusion though.  If you and Jean decide these shouldn't
be in hwmon, I'm happy to take them both in IIO.  Given our scope is much
broader and we already have things like light sensors (also sometimes environment
monitoring devices), that would work for me.  There are a few sht15 users
out there I know of beyond the imote2 sensor boards (which is how I encountered
them).  The imote2 users should be fine as I maintain the platform and most of
the tools anyway, the others maybe have more issues with a move.
Uses I know of are indeed more general environment monitoring.
Not seen one of these in conventional hardware monitoring but could be wrong.
I guess, Urs will have a better idea of where these tend to be used?

Obviously there is an argument for an 'environment' monitoring subsystem, but
my guess in Linus won't pull based on exactly the same issue he had with ALS
when we proposed that.  Linus won't take small subsystems for sensors given
he wants them all in the same one.  Actually he mostly wanted them to be in input
but Dmitry quite rightly pushed back hard against that for exactly the reason
you are wondering whether they ought to be in hwmon, avoidance of scope spread.

> 
> Guenter
> 
> 
> 

