Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab1CNXXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:23:04 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:37497 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab1CNXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:23:02 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7EA38F.5070002@cam.ac.uk>
Date: Mon, 14 Mar 2011 23:23:59 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com>	<4D7E771B.1040804@cam.ac.uk>	<20110314211809.29da8518@endymion.delvare>	<201103142136.43566.arnd@arndb.de> <20110314224244.3d6d23ba@endymion.delvare>
In-Reply-To: <20110314224244.3d6d23ba@endymion.delvare>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/11 21:42, Jean Delvare wrote:
> On Mon, 14 Mar 2011 21:36:43 +0100, Arnd Bergmann wrote:
>> On Monday 14 March 2011 21:18:09 Jean Delvare wrote:
>>> Jonathan is correct. Pressure sensors are not hardware monitoring
>>> devices, their drivers have nothing to do in drivers/hwmon. This is
>>> something for drivers/misc or staging/iio.
>>
>> I generally try to prevent people from adding more ad-hoc interfaces
>> to drivers/misc. Anything that is called a drivers/misc driver to me
>> must qualify as "there can't possibly be a second driver with the
>> same semantics", otherwise it should be part of another subsystem
>> with clear rules, or be put into its own file system.
> 
> I see drivers/misc differently. I see it as "not enough drivers of the
> same type to justify a new subsystem". So I encourage people to put
> things there in the absence of any suitable subsystem, until someone
> gets enough motivation to start such a subsystem. This is more
> pragmatic than requesting subsystems to be created upfront.
To my mind, there will one day be a suitable 'sensors' subsystem so
an important side point is to try and minimise interface changes needed
to move to that (IIO or something better). Sysfs is easy to fix, so
lets at least work on shared interfaces in there.  Hwmon is a mature
and reasonable starting point; it's where we got a lot of IIO's
similar interfaces from.  The trick is convincing people to consider
generality and it's a hard trick to pull off.
> 
> That being said, staging is another option nowadays.
> 
>> While it seems that right now everyone is just trying to keep move
>> the driver to some other subsystem, I think it's worth noting that
>> it is indeed a useful thing to have the driver, I'm optimistic
>> that we can find some place for it. ;-)
>>
>> Now how about the IIO stuff? This is the first time I've even
>> heard about it. Does it have any major disadvantages besides
>> being staging-quality?
To play devil's advocate with my own code...

It's big. If all you want is something that looks like hwmon then
you won't care about maybe 80% of the core and support code. Just
look at hwmon to see how slim a subsystem can be.
Now a key point is to ensure such driver writers don't have to care.
I think we achieve that (though there is room for improvement of
course!)

The issue is that its the heavy 'interesting' bits that the developers
need which are also the reason the whole thing exists in the first place.

The other big issue for contributors is that there is still a reasonable
amount of churn in the core code and that brings a test burden that
continues after a driver is merged (if they use the more complex bits
that is).
> 
> This is indeed the major disadvantage. IIO seems to take a lot of time
> to move out of staging, although I don't know what the current ETA is.
> 
Whilst I'd like to say soon there are a couple more big changes to make
(such as the ongoing changes to allow threaded interrupts for the triggers
- basically implementing what Thomas Gleixner suggested and having virtual
interrupt chips) and some of these will take a fair bit of bedding down. In the
original write I got quite a few things wrong :( Mind you quite a lot of
evolution of requirements has taken place as well.

Usual sob story (50+ drivers of mixed quality to avoid breaking,
little manpower, steady stream of new drivers keeping people busy reviewing
etc etc)

Having said that, for the simple drivers the interfaces are mostly fixed
and nothing much has changed for quite a few months. (e.g. anything that
is slow and only uses hwmon style sysfs interfaces).

Of course, if anyone does have any time (looks around hopefully...)
Particularly helpful are people pointing out what really needs fixing
before attempting to move out of staging.   Much better if we get that
sort of feedback in plenty of time rather than on sending a pull request
to Linus. I like to spread my arguments out ;)

Thanks,

Jonathan
