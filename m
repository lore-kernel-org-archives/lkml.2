Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2ASRPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:15:44 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:56307 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2ASRPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:15:42 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com> <201201181403.47806.arnd@arndb.de> <20120118213635.GB3401@gmail.com> <201201191426.45923.arnd@arndb.de>
User-Agent: K-9 Mail for Android
In-Reply-To: <201201191426.45923.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Thu, 19 Jan 2012 17:15:10 +0000
To: Arnd Bergmann <arnd@arndb.de>, Andi <andi.shyti@gmail.com>
CC: "AnilKumar, Chimata" <anilkumar@ti.com>, "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Message-ID: <b5adb97c-8b5a-43ed-a750-cf5c5b6adb0c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann <arnd@arndb.de> wrote:

>On Wednesday 18 January 2012, Andi wrote:
>> What do you mean with "kernel-wide policy for accelerometer drivers"?
>> As far as I know, accelerometer drivers are written between the i2c
>driver and the
>> input driver.
>> The input driver provides already some accelerometer specific event
>types, ABS_X, ABS_Y, ABS_Z,
>> in your opinion isn't it enough?
>> If you mean something like collecting common properties like g range
>or frequency or whatever in a
>> standard interface, then I think that accelerometers are quite
>different as devices and sometimes
>> it could be difficult to arrange a common interface.
>
>The problem is that we have some drivers using the input subsystem,
>some
>drivers using the iio subsystem and some drivers using none of these
>but
>interfacing with user space using some homegrown method, see my list:
>
>> > $ git grep -l accelerometer drivers/ | manual_grep
>> > drivers/hwmon/applesmc.c
>> >    (one hwmon sysfs attribute for x/y/z)
>> > drivers/input/misc/adxl34x.c
>> >    (lots of sysfs attributes, input_report_key)
>> > drivers/input/misc/cma3000_d0x.c
>> >    (input_report_abs)
>> > drivers/input/misc/kxtj9.c
>> >    (input_report_abs, plus one aux sysfs attribute)
>> > drivers/macintosh/ams/ams-core.c
>> >    (one sysfs attribute for x/y/z)
>> > drivers/misc/lis3lv02d/
>> >    (multiple sysfs attributes)
>> > drivers/platform/x86/hdaps.c
>> >    (multiple sysfs attributes, only x/y)
>> > drivers/platform/x86/hp_accel.c
>> >    (hooks into drivers/misc/lis3lv02d/)
>> > drivers/staging/iio/accel/kxsd9.c
>> >    (iio)
>> > drivers/staging/iio/accel/sca3000_core.c
>> >    (iio plus extra attributes)
>
>If all drivers were using the input subsystem in the way you describe,
>that would be a good solution, but right now the majority of the
>drivers don't do this.
Also worth noting that there are numerous devices that are completely inappropriate for human input. Take specialised impact and vibration accelerometers. Very high speed sampling for short time periods. I agree that your bog standard 3 axis sub 10 g accelerometer belongs in input. The kxsd9 and lis3lo2dq in iio are there for historical reasons and because they are very handy for testing our bridging to input. That said it should ultimately make very little difference to user space if they are accessing a true input device or a iio device via an input bridge.  I also think that actually there is very little in the way of unusual controls for accelerometers particularly those designed for human input. Not standardizing gain or sampling frequency control is lazy. Even filtering and fft controls can and should be standardised. Doing that is a large part of what iio is about.
>
>	Arnd

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
