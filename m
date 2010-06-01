Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0FAUoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:44:25 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:58303 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab0FAUoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:44:23 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C057156.6020602@jic23.retrosnub.co.uk>
Date: Tue, 01 Jun 2010 21:45:10 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Hemanth V <hemanthv@ti.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH V2] misc : ROHM BH1780GLI Ambient light sensor Driver
References: <39216.10.24.255.17.1274699065.squirrel@dbdmail.itg.ti.com> <20100601131244.7164b43c.akpm@linux-foundation.org> <20100601202715.GV2695@buzzloop.caiaq.de>
In-Reply-To: <20100601202715.GV2695@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/10 21:27, Daniel Mack wrote:
> On Tue, Jun 01, 2010 at 01:12:44PM -0700, Andrew Morton wrote:
>> On Mon, 24 May 2010 16:34:25 +0530 (IST)
>> "Hemanth V" <hemanthv@ti.com> wrote:
>>
>>> This patch adds support for ROHM BH1780GLI Ambient light sensor.
>>>
>>> BH1780 supports I2C interface. Driver supports read/update of power state and
>>> read of lux value (through SYSFS). Writing value 3 to power_state enables the
>>> sensor and current lux value could be read.
>>
>> There are at least two other ambient light sensor drivers:
>> drivers/misc/isl29003.c and drivers/misc/tsl2550.c.
>>
>> Is there any standardisation of the ABIs whcih these drivers offer?  If
>> so, does this new driver comply with that?
> 
> Jonathan proposed the ALS framework for these type of devices, but it
> was rejected (don't know about the reasons, I didn't follow the
> discussions).
Ah the wonder of emails crossing ;)

For the interested... http://lkml.org/lkml/2010/3/1/367
(the main objections are Linus' email)
> The new idea is to put such drivers in the industrial IO
> subsystem, but I don't know how mature that approach is currently.
We haven't lifted any that didn't start there as moving things into staging
due to a dependency being there seemed a controversial thing to do.
> 
> For the time being, these drivers cook up whatever sysfs interface they
> like, and their userspace ABIs are not standardized, unfortunately.
> 
>> It would be most useful if the changelog were to fully describe the
>> proposed kernel<->userspace interface.  That's the most important part
>> of the driver, because it's the only part we can never change.
>>
>> There is a desultory effort to maintain sysfs API descriptions under
>> Documentation/ABI/.  I'd have thought that it would be appropriate to
>> document this driver's ABI in there.
> 
> FWIW, I put some documentation about the isl29003 to
> Documentation/misc-devices when I wrote the driver.
> 
> Daniel
> 
