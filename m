Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab0DGLVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:21:25 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:51518 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab0DGLVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:21:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BBC6B52.5030908@cam.ac.uk>
Date: Wed, 07 Apr 2010 12:24:02 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, Jean Delvare <khali@linux-fr.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without CONFIG_REGULATOR
 set
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com>	<1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>	<20100402160058.GE27613@sirena.org.uk>	<20100402184403.2ea1263e@hyperion.delvare>	<20100402185138.GA12817@opensource.wolfsonmicro.com>	<20100402213010.4a64e50f@hyperion.delvare>	<20100402204503.GA15237@opensource.wolfsonmicro.com>	<20100403173745.2bf17ee6@hyperion.delvare>	<20100405132347.GA6580@rakim.wolfsonmicro.main> <1270567639.3229.56.camel@odin> <4BBB6083.2070903@cam.ac.uk> (sfid-20100406_172304_064433_7FBC3A75) <1F9C625F-0467-4C6D-B57F-2E4FCAC76031@opensource.wolfsonmicro.com>
In-Reply-To: <1F9C625F-0467-4C6D-B57F-2E4FCAC76031@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/10 19:19, Mark Brown wrote:
> On 6 Apr 2010, at 17:25, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> 
>> On 04/06/10 16:27, Liam Girdwood wrote:
>>>>
>>>>
>>>>
>>>
>>> I suppose this is something we may look into more when we have more
>>> clients.
>> Makes sense.  There will probably be quite a few IIO drivers over the
>> next
>> few months doing much the same as sht15, where the voltage ref for
>> devices
>> may well be fed by a regulator.  In that case, we may only offer the
>> option
>> of using an external v_ref if the regulator is available.  Many
>> devices have
>> an internal regulator to provide it so typically we'll start them up
>> using that
>> and provide an interface to switch to external regulator if one is
>> available.
>> I haven't thought through exactly how this will work as yet. I'll cc
>> people in
>> when this comes up.
> 
> TBH this seems like a very vanilla use case - there may be some small
> advantage to representing the internal regulator via the regulator API
> but that's about the only thing I can think might be a bit odd.
> 
I wasn't thinking of representing the internal regulator using the regulator
framework (though if it is externally available I guess that would make sense
though probably only if anyone is actually using this to supply something else
- most likely case I can think of is daisy chaining multiple adc's and ensuring
they have the same reference value).

The case I'm interested in is the externally supplied voltage reference. This
typically comes off a fixed regulator or a spare regulator on a pmic.
The use case is getting this voltage (and indeed buffering it using the
same notifier approach as in sht15). This is needed to provide api compliant info
to userspace (which needs sufficient info to work out what the actual value is).

I'd imagine similar cases occur in some hwmon devices.

Basically all these uses look just like that in sht15.

Nothing new here, but there will be a number of consumers that care about changes
in voltage (rather than typically controlling it.)  Hence I'm welcoming the change
just agreed upon.

Thanks,

Jonathan
