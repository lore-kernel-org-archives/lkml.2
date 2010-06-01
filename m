Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0FAViy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:38:54 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:57389 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0FAViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:38:52 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C057E1D.1010309@jic23.retrosnub.co.uk>
Date: Tue, 01 Jun 2010 22:39:41 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hemanth V <hemanthv@ti.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH V2] misc : ROHM BH1780GLI Ambient light sensor Driver
References: <39216.10.24.255.17.1274699065.squirrel@dbdmail.itg.ti.com>	<20100601131244.7164b43c.akpm@linux-foundation.org>	<4C056FEE.3040107@jic23.retrosnub.co.uk> <20100601135430.9c8c28df.akpm@linux-foundation.org>
In-Reply-To: <20100601135430.9c8c28df.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/10 21:54, Andrew Morton wrote:
> On Tue, 01 Jun 2010 21:39:10 +0100
> Jonathan Cameron <kernel@jic23.retrosnub.co.uk> wrote:
> 
>>>
>>> It would be most useful if the changelog were to fully describe the
>>> proposed kernel<->userspace interface.  That's the most important part
>>> of the driver, because it's the only part we can never change.
>>>
>>> There is a desultory effort to maintain sysfs API descriptions under
>>> Documentation/ABI/.  I'd have thought that it would be appropriate to
>>> document this driver's ABI in there.
>> Agreed, but we get back to the debate of what we should standardise on.
> 
> I'd suggest standardising on one of the existing drivers.  That way we
> have two compliant drivers and only need to change (n-2) others.  If we
> pick some new standard then we need to change (n) drivers.
I agree but take into account that we are getting a number of superficially
similar interfaces in kernel (hwmon, various sensors in misc and IIO)
and it makes sense to my mind to share interfaces across these where
possible (this is exactly the argument Greg made when we carried the
equivalent standardization out in IIO - for ref, the spec is in
staging/drivers/iio/Documentation/sysfs-class-iio)
(gah, the name needs a change to reflect our move to a sysfs bus - oops)
> 
> And we can't change the drivers, really.  They'd all end up needing to
> provide two interfaces: one for the shiny-new-standard and one legacy.
True enough.  We argued we could do with out this before because we were
fairly sure that we knew everyone who was using the sensors (also 1 was in staging
and another extremely)
> 
>> The main point of ALS before it died was exactly putting this standardization
>> in place (admittedly the interface was slightly different from what we
>> are proposing in IIO, but that was before Greg pointed out that sharing
>> with hwmon would be a good idea!)
>>
>> I have to admit I'm a little loath to spend too much time on this given
>> the amount of time wasted previously (ALS).
> 
> Well, it's not a waste.  This is very important!  We appear to be
> making a big mess which we can never fix up.
I agree entirely, picking a driver to copy is the way to go.
(personally I'd argue for the tsl2563 for the reasons above)
I'm just moaning about the time wasted the previous time we tried to clean
this stuff up :)

Note that 'if' these drivers do end up in IIO we will have to add the abi
as per the tsl2563 (can keep the others around for a while). We have a consistent
abi over 6+ sensor types so far and we aren't going to want to break it for
this one.  There are still unresolved corners in our abi but
they are all event related so this device is nowhere near them.

Either way, I agree entirely that matching any existing driver is a good thing
even if it isn't the one I'd personally prefer!

Jonathan

