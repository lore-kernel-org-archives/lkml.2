Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2EPQHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:07:16 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:34975 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab2EPQHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:07:14 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <1337183202.6344.1.camel@jonz-ub2>
User-Agent: K-9 Mail for Android
In-Reply-To: <1337183202.6344.1.camel@jonz-ub2>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH V2] IIO channel type and modifiers for CCT and RGBC data
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Wed, 16 May 2012 17:06:59 +0100
To: Jon Brenner <jbrenner@taosinc.com>
CC: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <dc25012a-f53d-472d-8df5-77f8f6a9855d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jon Brenner <jbrenner@taosinc.com> wrote:

>Add iio channel type and modifiers for Correlated Color Temperature
>(CCT)
>and RGBC (red/green/blue/clear) data.
>Add CCT and RGBC descriptions to documentation.
>
>Changes:
>Revised/condensed RGBC descriptions.
>
>Signed-off-by: Jon Brenner <jbrenner@taosinc.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
>---
> drivers/iio/industrialio-core.c                    |    5 ++++
>.../staging/iio/Documentation/sysfs-bus-iio-light  |   23
>++++++++++++++++++++
> include/linux/iio/types.h                          |    5 ++++
> 3 files changed, 33 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/iio/industrialio-core.c
>b/drivers/iio/industrialio-core.c
>index 1ddd886..34d8cc9 100644
>--- a/drivers/iio/industrialio-core.c
>+++ b/drivers/iio/industrialio-core.c
>@@ -64,6 +64,7 @@ static const char * const iio_chan_type_name_spec[] =
>{
> 	[IIO_TIMESTAMP] = "timestamp",
> 	[IIO_CAPACITANCE] = "capacitance",
> 	[IIO_ALTVOLTAGE] = "altvoltage",
>+	[IIO_CCT] = "cct",
> };
>
> static const char * const iio_modifier_names[] = {
>@@ -72,6 +73,10 @@ static const char * const iio_modifier_names[] = {
> 	[IIO_MOD_Z] = "z",
> 	[IIO_MOD_LIGHT_BOTH] = "both",
> 	[IIO_MOD_LIGHT_IR] = "ir",
>+	[IIO_MOD_LIGHT_CLEAR] = "clear",
>+	[IIO_MOD_LIGHT_RED] = "red",
>+	[IIO_MOD_LIGHT_GREEN] = "green",
>+	[IIO_MOD_LIGHT_BLUE] = "blue",
> };
>
> /* relies on pairs of these shared then separate */
>diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>index 715c74d..83a2876 100644
>--- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>@@ -34,6 +34,15 @@ Description:
> 		it comes back in SI units, it should also include _input else it
> 		should include _raw to signify it is not in SI units.
>
>+What:		/sys/bus/iio/devices/device[n]/in_cct0[_input|_raw]
>+KernelVersion:	3.4.0
>+Contact:	linux-iio@vger.kernel.org
>+Description:
>+		This should return the correlated color temperature from the
>+		light sensor. If it comes back in SI units, it should also
>+		include _input else it should include _raw to signify it is not
>+		in SI units.
>+
>What:		/sys/.../device[n]/proximity_on_chip_ambient_infrared_supression
> KernelVersion:	2.6.37
> Contact:	linux-iio@vger.kernel.org
>@@ -82,3 +91,17 @@ Contact:	linux-iio@vger.kernel.org
> Description:
> 		This property gets/sets the table of coefficients
> 		used in calculating illuminance in lux.
>+
>+What:		/sys/bus/iio/devices/device[n]/in_intensity_clear[_input|_raw]
>+What:		/sys/bus/iio/devices/device[n]/in_intensity_red[_input|_raw]
>+What:		/sys/bus/iio/devices/device[n]/in_intensity_green[_input|_raw]
>+What:		/sys/bus/iio/devices/device[n]/in_intensity_blue[_input|_raw]
>+KernelVersion:	3.4.0
>+Contact:	linux-iio@vger.kernel.org
>+Description:
>+		This property is supported by sensors that have a RGBC
>+		sensing mode. This value should be the output from a reading
>+		and if expressed in SI units, should include _input. If this
>+		value is not in SI units (irradiance, uW/mm), then it should
>+		include _raw.
>+
>diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
>index 1b073b1..a7de5d9 100644
>--- a/include/linux/iio/types.h
>+++ b/include/linux/iio/types.h
>@@ -28,6 +28,7 @@ enum iio_chan_type {
> 	IIO_TIMESTAMP,
> 	IIO_CAPACITANCE,
> 	IIO_ALTVOLTAGE,
>+	IIO_CCT,
> };
>
> enum iio_modifier {
>@@ -45,6 +46,10 @@ enum iio_modifier {
> 	IIO_MOD_X_OR_Y_OR_Z,
> 	IIO_MOD_LIGHT_BOTH,
> 	IIO_MOD_LIGHT_IR,
>+	IIO_MOD_LIGHT_CLEAR,
>+	IIO_MOD_LIGHT_RED,
>+	IIO_MOD_LIGHT_GREEN,
>+	IIO_MOD_LIGHT_BLUE,
> };
>
> #define IIO_VAL_INT 1
>--
>1.7.4.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
