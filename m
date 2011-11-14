Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1KNBbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:31:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57836 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1KNBbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:31:20 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1321044403.2757.23.camel@bwh-desktop>
References: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
	<1321044403.2757.23.camel@bwh-desktop>
Date: Mon, 14 Nov 2011 10:31:19 +0900
X-Google-Sender-Auth: IpSuS9YB9qQ9XJ7Q08RbzTB3U4I
Message-ID: <CAJ0PZbQsTYZvoVMgZ_L5uPUxCTbzH72zzUqUkvXNnmqiDOGY=g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] HWMON: add in-kernel interfaces to read sensor values.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, dg77.kim@samsung.com,
        kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 5:46 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Fri, 2011-11-04 at 15:50 +0900, MyungJoo Ham wrote:
>> We have been reading hwmon values (TMU, the SoC-core temperature sensor,
>> and NTC, the ambient or battery surface temperature sensor) for
>> Charger-Manager. However, because hwmon does not have in-kernel interface,
>> we have been using undesired method, including "../../../fs/*.h".
>>
>> This patch is to provide in-kernel interface for hwmon:
>> hwmon_get_value and hwmon_set_value. In order to use these two functions,
>> the hwmon driver should provide its sysfs attributes to hwmon framework
>> as well. If the hwmon driver does not provide (by providing NULL), the users
>> of the hwmon won't be able to use hwmon_get/set_value();
>> The sysfs attribute (struct attribuyte_group *) is provided with
>> hwmon_device_register; adding the second parameter to hwmon_device_register().
>> The 2/2 patch shows the changes in device drivers due to this.
> [...]
>
> This is an improvement, but I don't think it is quite enough.  As I
> understand the hwmon sysfs interface, all sensor values should be
> integers.  So the in-kernel interface should also work with integers,
> not strings.
>
> As a first implementation you could perhaps parse the strings back to
> integers.  However in the longer term the driver API should be changed
> so that hwmon drivers fully describe their sensors to the core and the
> core takes care of exposing them through sysfs and the in-kernel API.

I agree.

I'll let it the in-kernel interfaces provide integer value although it will
simply parse strings as you've addressed until we have some other
interfaces for sysfs entries in hwmon device drivers.


MyungJoo.

>
> Ben.
>
> --
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
>
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
