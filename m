Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2FLKiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:38:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14400 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2FLKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:37:51 -0400
Date: Tue, 12 Jun 2012 12:38:16 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH] i2c-s3c2410: Fix pointer type passed to of_match_node()
In-reply-to: <20120611182925.GJ3887@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: m.szyprowski@samsung.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4FD71C18.9090209@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510
 Icedove/10.0.4
References: <1338370985-6950-1-git-send-email-k.lewandowsk@samsung.com>
 <20120611182925.GJ3887@pengutronix.de>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.06.2012 20:29, Wolfram Sang wrote:

> On Wed, May 30, 2012 at 11:43:05AM +0200, Karol Lewandowski wrote:
>> This commit fixes warning introduced in 27452498a ("i2c-s3c2410: Rework
>> device type handling"):
>>
>>   drivers/i2c/busses/i2c-s3c2410.c: In function 's3c24xx_get_device_quirks':
>>   drivers/i2c/busses/i2c-s3c2410.c:125: warning: passing argument 1 of 'of_match_node' from incompatible pointer type
>>   include/linux/of.h:245: note: expected 'const struct of_device_id *' but argument is of type 'const struct of_device_id (*)[4]'
>>
>> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Ah, now I understand why my build-test didn't spot the warning.
> What config can I use to test CONFIG_OF with s3c?


Currently no config for samsung hardware has OF enabled by default.
However, you could use exynos4_defconfig plus following (that's what
I use):

--- a/arch/arm/configs/exynos4_defconfig
+++ b/arch/arm/configs/exynos4_defconfig
@@ -14,6 +14,7 @@ CONFIG_MACH_ORIGEN=y
 CONFIG_MACH_SMDK4412=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_MACH_EXYNOS4_DT=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_PREEMPT=y
@@ -37,6 +38,7 @@ CONFIG_SERIAL_SAMSUNG=y
 CONFIG_SERIAL_SAMSUNG_CONSOLE=y
 CONFIG_HW_RANDOM=y
 CONFIG_I2C=y
+CONFIG_I2C_S3C2410=y
 # CONFIG_HWMON is not set
 # CONFIG_MFD_SUPPORT is not set
 # CONFIG_HID_SUPPORT is not set

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
