Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1KKUqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 15:46:50 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:42028 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KKUqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 15:46:49 -0500
Subject: Re: [RFC PATCH 0/2] HWMON: add in-kernel interfaces to read sensor
 values.
From: Ben Hutchings <bhutchings@solarflare.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, <dg77.kim@samsung.com>,
        <kyungmin.park@samsung.com>, <myungjoo.ham@gmail.com>
In-Reply-To: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
References: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 11 Nov 2011 20:46:43 +0000
Message-ID: <1321044403.2757.23.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18508.005
X-TM-AS-Result: No--13.401200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 11 Nov 2011 20:46:48.0651 (UTC) FILETIME=[085881B0:01CCA0B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 15:50 +0900, MyungJoo Ham wrote:
> We have been reading hwmon values (TMU, the SoC-core temperature sensor,
> and NTC, the ambient or battery surface temperature sensor) for
> Charger-Manager. However, because hwmon does not have in-kernel interface,
> we have been using undesired method, including "../../../fs/*.h".
> 
> This patch is to provide in-kernel interface for hwmon:
> hwmon_get_value and hwmon_set_value. In order to use these two functions,
> the hwmon driver should provide its sysfs attributes to hwmon framework
> as well. If the hwmon driver does not provide (by providing NULL), the users
> of the hwmon won't be able to use hwmon_get/set_value();
> The sysfs attribute (struct attribuyte_group *) is provided with
> hwmon_device_register; adding the second parameter to hwmon_device_register().
> The 2/2 patch shows the changes in device drivers due to this.
[...]

This is an improvement, but I don't think it is quite enough.  As I
understand the hwmon sysfs interface, all sensor values should be
integers.  So the in-kernel interface should also work with integers,
not strings.

As a first implementation you could perhaps parse the strings back to
integers.  However in the longer term the driver API should be changed
so that hwmon drivers fully describe their sensors to the core and the
core takes care of exposing them through sysfs and the in-kernel API.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

