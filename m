Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab1COOhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:37:42 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:42350 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab1COOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:37:41 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7F79F1.1000306@cam.ac.uk>
Date: Tue, 15 Mar 2011 14:38:41 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <20110314224244.3d6d23ba@endymion.delvare> <4D7EA38F.5070002@cam.ac.uk> <201103151038.40559.arnd@arndb.de> <4D7F4944.4070507@cam.ac.uk> <20110315125149.GC17277@sirena.org.uk>
In-Reply-To: <20110315125149.GC17277@sirena.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/11 12:51, Mark Brown wrote:
> On Tue, Mar 15, 2011 at 11:11:00AM +0000, Jonathan Cameron wrote:
>> On 03/15/11 09:38, Arnd Bergmann wrote:
> 
> [Reflowed Jonathan's text into 80 columns for legibility.]
> 
>>> Do you think it would help to split the iio codebase into a smaller part
>>> for the relatively clean drivers that can be put into shape for
>>> drivers/iio, and the bulk of the code that stays in staging for a bit
>>> longer, until it gets converted to the new one in small chunks?
> 
>> 1) Spit functionality out in staging. This would give a core set that
>> is basically the sysfs only stuff.  To do that we'd have to define a
>> struct iio_dev_basic and make it an element of the iio_dev.  Prior to
>> that we'd probably need to make pretty much all accesses into iio_dev
>> via macros / inline functions which would not be a trivial
>> undertaking.
> 
>> Then we could switch those drivers doing the minimum to the _basic
>> form.  At that point we could perhaps attempt to move a couple of
>> drivers and the abi docs out of staging.
> 
>> The disadvantages of this that come to mind are: * Makes the path to
>> driver addition that I'd prefer trickier.  You write a basic sysfs
>> only driver first, then add on stuff like events and buffering as
>> separate patches. We could go the other way around like v4l2-subdev
>> and have a base structure with the option of pointers to structures
>> offering different combinations of features.  * Not many of the
>> drivers I'd consider to be ready to go at the moment are actually in
>> this _basic class. 
> 
> For what it's worth I have a few drivers I'd like to do which fall into
> this category.  I've been put off working on them by the fact that I'm
> not seeing a route out of staging for the subsystem.
> 
>> 2) Basically make a copy.  This would look like the original patch set did when we went
> 
> A third option is just to lift everything out of staging roughly as it
> is now with anything that definitely needs redoing dropped, addressing
> any review comments for mainline but not doing much else, and then
> resume working on adding additional stuff.  It sounds like the userspace
> interfaces that are there at present are mostly OK and most of the
> issues are in-kernel?
Mostly, though I suspect our events interface will cause some 'discussion'
and that sits one step above the absolute minimum driver.

Right now I want to push out the rewrite of the triggers, then I'll start
putting together a patch set to try and move some stuff over and see how
well things break up.



