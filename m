Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0IXRJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:09:30 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:51219 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0IXRJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:09:28 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C9CDC70.5020508@cam.ac.uk>
Date: Fri, 24 Sep 2010 18:14:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
CC: Jean Delvare <khali@linux-fr.org>, Takashi Iwai <tiwai@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [lm-sensors] [PATCH v2] lis3: Fix Oops with NULL platform data
References: <s5heiclngqe.wl%tiwai@suse.de>	<20100924135802.GA18109@ericsson.com>	<s5hlj6r1b5p.wl%tiwai@suse.de>	<20100924163005.7704f63e@endymion.delvare> <4C9CC219.4090304@tremplin-utc.net>
In-Reply-To: <4C9CC219.4090304@tremplin-utc.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/10 16:22, Éric Piel wrote:
> Op 24-09-10 16:30, Jean Delvare schreef:
>> Well, as long as the driver lives in drivers/hwmon and the hwmon
>> subsystem is maintained, it seems fair to consider the driver
>> maintained.
>>
>> That being said, I indeed would like all non-hwmon drivers to go away
>> from drivers/hwmon. Originally we were waiting for iio to settle first,
>> but apparently this is taking forever. The 4 drivers I would like to
>> kick are: ams, hdaps, lis3lv02d and applesmc. They are primarily
>> accelerometer device drivers. Not sure where to put them,
>> drivers/accel(erometer), drivers/misc, drivers/misc/accel(erometer),
>> drivers/input/accel(erometer)... Opinions welcome.
> As maintainer of the lis3lv02d driver, I'd completely support the move too.
> 
> IMHO, an accelerometer is just another input device (usually with 2 or 3
> axes),
That is not actually all that true in general. There are an awful lot of parts
that aren't even vaguely designed for 'human' input.
In some restricted cases I'm happy to agree though and that definitely includes
3 axis sensors with input specific features like those your driver covers.

> so moving them to drivers/input/accel would make sense.
Propose a move on linux-input and see what the response is.  Currently
they are going in drivers/input/misc, but that is probably just because there
aren't enough of them yet to justify their own directory.

Dmitry is taking them slowly (mainly I think because he wants the interfaces to
be more pinned down).   The adxl34x driver is already there, Hemanth's
cma3000 is close (either dropping some knobs in sysfs or working out
naming that everyone interested can agree on).  I would imagine the awkward
bits will be things like freefall detectors that no one can reasonably argue
are a conventional form of 'human' input.

As an aside, we are trying to work out a unified interface between IIO and
input for some elements and a userspace bridge where that doesn't make sense.
There are ongoing (if rather quiet) discussions on this on linux-input / lkml.
http://lkml.org/lkml/2010/9/21/167 I would certainly welcome any comments / 
suggestions anyone would like to make.  The intent here is to pin down the
naming conventions as independently as possible of the actual subsystem handling
the device, but to keep them general enough as to be able to cover a wide range
of different sensors.
 
Cheers,

Jonathan
