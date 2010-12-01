Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0LAKZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:25:54 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:43280 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0LAKZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:25:53 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CF6244B.9050703@cam.ac.uk>
Date: Wed, 01 Dec 2010 10:32:43 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101123 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Chethan Krishna N <chethan.krishna@stericsson.com>,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        preetham.rao@stericsson.com, lm-sensors@lm-sensors.org,
        mian-yousaf.kaukab@linaro.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [lm-sensors] [PATCH] lsm303dlh: Adding Accelerometer and Magnetometer
 support
References: <1291180447-16570-1-git-send-email-chethan.krishna@stericsson.com> <20101201100016.22b3ea0d@endymion.delvare>
In-Reply-To: <20101201100016.22b3ea0d@endymion.delvare>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/10 09:00, Jean Delvare wrote:
> On Wed,  1 Dec 2010 10:44:07 +0530, Chethan Krishna N wrote:
>> From: Chethan Krishna N <chethan.krishna@stericsson.com>
>>
>> lsm303dlh accelerometer magnetometer device support added.
>> Also provides input device support through interrupts.
>>
>> Signed-off-by: Chethan Krishna N <chethan.krishna@stericsson.com>
>> ---
>>  drivers/hwmon/Kconfig       |   23 +
>>  drivers/hwmon/Makefile      |    1 +
>>  drivers/hwmon/lsm303dlh_a.c | 1112 +++++++++++++++++++++++++++++++++++++++++++
>>  drivers/hwmon/lsm303dlh_m.c |  764 +++++++++++++++++++++++++++++
>>  include/linux/lsm303dlh.h   |   56 +++
>>  5 files changed, 1956 insertions(+), 0 deletions(-)
>>  mode change 100644 => 100755 drivers/hwmon/Kconfig
>>  create mode 100644 drivers/hwmon/lsm303dlh_a.c
>>  create mode 100644 drivers/hwmon/lsm303dlh_m.c
>>  create mode 100644 include/linux/lsm303dlh.h
> 
> Nack. This isn't a hardware monitoring driver, so it has nothing to do
> in drivers/hwmon. Please find a better place.
> 
Current options are:
* persuade Dmitry it is primarily a human input device and go for drivers/input
* drivers/misc 
* drivers/staging/iio (couple of magnetometers and more general IMU's in there
already, but then if you primary use is input, the input bridge is only at proof
of concept stage at the moment).

Take your pick.

Where ever it physically gets located, the abi needs to ideally match existing
ones (particularly all those sysfs attributes).
If you want to change things in existing abi's then feel free to propose doing
so. What won't be acceptable anywhere in mainline is to add completely
different ones when existing options are in use in other drivers (without
a very good reason and explanation.)

Jonathan

cc'd Dmitry (who, as input maintainer should have been cc'd on original email)
