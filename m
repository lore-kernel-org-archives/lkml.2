Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2ARQsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:48:10 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:40433 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab2ARQsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:48:08 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com> <331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com> <201201181403.47806.arnd@arndb.de>
User-Agent: K-9 Mail for Android
In-Reply-To: <201201181403.47806.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Wed, 18 Jan 2012 16:47:41 +0000
To: Arnd Bergmann <arnd@arndb.de>, "AnilKumar, Chimata" <anilkumar@ti.com>
CC: "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Message-ID: <b659db7b-2ef1-49b8-9752-a0601226cc6e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann <arnd@arndb.de> wrote:

>On Tuesday 17 January 2012, AnilKumar, Chimata wrote:
>> Hi All,
>> 
>> Recalling the patch, provide the comments if there are any if not
>please include
>> this patch to v3.3 kernel.
>
>As Mark and Greg said, 3.4 would be appropriate.
>
>> +static ssize_t lis3lv02d_range_set(struct device *dev,
>> +				struct device_attribute *attr, const char *buf,
>> +				size_t count)
>> +{
>> +	unsigned long range;
>> +
>> +	if (strict_strtoul(buf, 0, &range))
>> +		return -EINVAL;
>> +
>> +	lis3_dev.g_range = range;
>> +	lis3lv02d_update_g_range(&lis3_dev);
>> +
>> +	return count;
>> +}
>> +
>>  static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show,
>NULL);
>>  static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show,
>NULL);
>>  static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
>>  					    lis3lv02d_rate_set);
>> +static DEVICE_ATTR(range, S_IRUGO | S_IWUSR, lis3lv02d_range_show,
>> +					    lis3lv02d_range_set);
>
>I think you need to document this new attribute in the Documentation
>directory, unless I missed the other patch doing this.
>
>On a more general topic, do we have a kernel-wide policy for
>accelerometer
>drivers? AFAICT, we currently have three subsystems that contain 
>accelerometer drivers, plus a few ad-hoc ones like this, which is a
>rather unpleasant situation. What I found are these:
>
>$ git grep -l accelerometer drivers/ | manual_grep
>drivers/hwmon/applesmc.c
>   (one hwmon sysfs attribute for x/y/z)
>drivers/input/misc/adxl34x.c
>   (lots of sysfs attributes, input_report_key)
>drivers/input/misc/cma3000_d0x.c
>   (input_report_abs)
>drivers/input/misc/kxtj9.c
>   (input_report_abs, plus one aux sysfs attribute)
>drivers/macintosh/ams/ams-core.c
>   (one sysfs attribute for x/y/z)
>drivers/misc/lis3lv02d/
>   (multiple sysfs attributes)
>drivers/platform/x86/hdaps.c
>   (multiple sysfs attributes, only x/y)
>drivers/platform/x86/hp_accel.c
>   (hooks into drivers/misc/lis3lv02d/)
>drivers/staging/iio/accel/kxsd9.c
>   (iio)
>drivers/staging/iio/accel/sca3000_core.c
>   (iio plus extra attributes)
>
For what it is worth there are a total of nine iio acceleration drivers. Some are special purpose though.
>While I'm not blaming you for the current situation, but I think the
>situation is no longer sustainable and we need to decide on one place
>and interface for these to go in the long run so we don't grow even
>more nonstandard interfaces.
>
>Any opinions where they should live? input, iio or a new subsystem?
>
Personal thought is that straight 3d devices very directed at input should go there. Iio has a few wrinkles left for the in kernel interfaces needed for a bridge to input. For starters the pull and push data interfaces have not merged yet (in staging) and we have not started on in kernel acess to non data events yet(thresholds).  Still happy to take them when we can support usecases fully. 
Of course any help getting there would be most welcome!

Jonathan

>	Arnd

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
