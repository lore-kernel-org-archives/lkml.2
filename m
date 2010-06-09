Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0FITze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:55:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60550 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab0FITzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:55:32 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, mingo@redhat.com,
       "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>
References: <20100609140000.60975b2f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100609110719.270634a9@hyperion.delvare>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 09 Jun 2010 12:54:58 -0700
In-Reply-To: <20100609110719.270634a9@hyperion.delvare> (Jean Delvare's message of "Wed\, 9 Jun 2010 11\:07\:19 +0200")
Message-ID: <m14ohcyoa5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: khali@linux-fr.org, jkosina@suse.cz, akpm@linux-foundation.org, mingo@redhat.com, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] fix hwmon/i5k_amb.c sysfs attribute for lockdep
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> writes:

> Hi Kame-san,
>
> On Wed, 9 Jun 2010 14:00:00 +0900, KAMEZAWA Hiroyuki wrote:
>> I'm not familiar with this area but I need this patch for lockdep in mmotm.
>> please check.
>> -Kame
>> ==
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> 
>> i5k_amb.ko uses dynamically allocated memory (by kmalloc) for
>> attributes passed to sysfs. So, sysfs_attr_init() should be called
>> for working happy with lockdep.
>
> Such a fix is needed, yes. I though Jiri was working on it... Jiri?
>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  drivers/hwmon/i5k_amb.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> Index: mmotm-2.6.34-Jun6/drivers/hwmon/i5k_amb.c
>> ===================================================================
>> --- mmotm-2.6.34-Jun6.orig/drivers/hwmon/i5k_amb.c
>> +++ mmotm-2.6.34-Jun6/drivers/hwmon/i5k_amb.c
>> @@ -289,6 +289,7 @@ static int __devinit i5k_amb_hwmon_init(
>>  			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
>>  			iattr->s_attr.dev_attr.show = show_label;
>>  			iattr->s_attr.index = k;
>> +			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
>>  			res = device_create_file(&pdev->dev,
>>  						 &iattr->s_attr.dev_attr);
>>  			if (res)
>> @@ -303,6 +304,7 @@ static int __devinit i5k_amb_hwmon_init(
>>  			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
>>  			iattr->s_attr.dev_attr.show = show_amb_temp;
>>  			iattr->s_attr.index = k;
>> +			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
>>  			res = device_create_file(&pdev->dev,
>>  						 &iattr->s_attr.dev_attr);
>>  			if (res)
>> @@ -318,6 +320,7 @@ static int __devinit i5k_amb_hwmon_init(
>>  			iattr->s_attr.dev_attr.show = show_amb_min;
>>  			iattr->s_attr.dev_attr.store = store_amb_min;
>>  			iattr->s_attr.index = k;
>> +			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
>>  			res = device_create_file(&pdev->dev,
>>  						 &iattr->s_attr.dev_attr);
>>  			if (res)
>> @@ -333,6 +336,7 @@ static int __devinit i5k_amb_hwmon_init(
>>  			iattr->s_attr.dev_attr.show = show_amb_mid;
>>  			iattr->s_attr.dev_attr.store = store_amb_mid;
>>  			iattr->s_attr.index = k;
>> +			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
>>  			res = device_create_file(&pdev->dev,
>>  						 &iattr->s_attr.dev_attr);
>>  			if (res)
>> @@ -348,6 +352,7 @@ static int __devinit i5k_amb_hwmon_init(
>>  			iattr->s_attr.dev_attr.show = show_amb_max;
>>  			iattr->s_attr.dev_attr.store = store_amb_max;
>>  			iattr->s_attr.index = k;
>> +			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
>>  			res = device_create_file(&pdev->dev,
>>  						 &iattr->s_attr.dev_attr);
>>  			if (res)
>> @@ -362,6 +367,7 @@ static int __devinit i5k_amb_hwmon_init(
>>  			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
>>  			iattr->s_attr.dev_attr.show = show_amb_alarm;
>>  			iattr->s_attr.index = k;
>> +			sysfs_attr_init(&iattr->s_attr.dev_attr.attr);
>>  			res = device_create_file(&pdev->dev,
>>  						 &iattr->s_attr.dev_attr);
>>  			if (res)
>> 
>
> Looks good, applied, thanks.
>
> That being said, I don't quite get how this is supposed to work.
> Looking at the implementation of sysfs_attr_init(), it is a macro which
> declares a static variable and uses it as a reference. Whether this
> reference is shared amongst different attributes solely depends on how
> the driver is written. If the driver has a helper function, or an
> iterative loop, to create the attributes, they all share the reference.
> If all file creations are explicit, each attribute has its reference.
> I'm not sure how you can come up with anything useful in the end. Eric?

So far attributes that are initialized together have a similar locking
requirements.  If that is not the case with sysfs_attr_init you don't
have to call things in a loop, and you can break the false lockdep
sharing if you need to.  So far I haven't heard of that coming up.

The flip side of this is that there are some really nasty deadlocks
you can get with using locks in sysfs attributes.  The common pattern
of death is holding a lock in a sysfs attribute, and holding that same
lock when you remove the sysfs attribute.  Even realizing you might
have a bug like that is insane.  Tracking a bug like that without
lockdep to help you is not fun at all.

I got lucky and had a reproducible test case for one of those bugs
and managed to track it down.

> As a side note, I am really not a big fan of the current implementation
> anyway. Having to add sysfs_attr_init() all around the place for
> debugging purposes only is bad. We have 50 calling sites already and
> more are inevitably coming. I would love to see this all folded into
> device_create_file() so that it is transparent to the callers.

I would love to see all of the sysfs attributes be declared
statically which is overwhelming the common practice for sysfs
attributes.

And that 46 approaching 50 call sites just barely exceeds the number
of call sites who have had lockdep problems fixed.

Furthermore it does make sense to have a special initialization helper
for dynamically allocated sysfs attributes.

It doesn't really make sense to add sysfs_attr_init into
device_create_file.  The vast majority of sysfs attributes are
declared statically and thus get a very fine grained locking analysis,
by virtue of each one having their very own lock_class_key.
device_create_file is by and large used on those static files.  So
we would likely reduce the quality of the lockdep coverage if we folded
sysfs_attr_init into device_create_file.

Right now the burden of sysfs_attr_init is placed on drivers that do
strange things with their sysfs files, and need to dynamically
allocate them, which is maybe 5% of the sysfs files, that are not
automatically generated.  Apparently the hwmon drivers seem to
standout in that regard.  With two different drivers needing this
treatment.

Eric
