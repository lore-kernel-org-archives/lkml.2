Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0DLHpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 03:45:46 -0400
Received: from poutre.nerim.net ([62.4.16.124]:63356 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0DLHpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 03:45:45 -0400
Date: Mon, 12 Apr 2010 09:45:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Boichat <nicolas@boichat.ch>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH]BUG FIX: hwmon applesmc.c add iMac9,  1 and
 MacBookPro2, 2 to fix bug 14429
Message-ID: <20100412094541.21910420@hyperion.delvare>
In-Reply-To: <1271022202-4348-1-git-send-email-justinmattock@gmail.com>
References: <1271022202-4348-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

On Sun, 11 Apr 2010 14:43:22 -0700, Justin P. Mattock wrote:
> This patch adds the iMac9,1 and the MacBookPro2,2
> temperature sensors to hwmon applesmc.c to fix bug entry: 
> https://bugzilla.kernel.org/show_bug.cgi?id=14429

Nicely filled under component IA64, no surprise I didn't see it. I've
just fixed it.

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>  drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index c1605b5..5e762ac 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -142,6 +142,12 @@ static const char *temperature_sensors_sets[][41] = {
>  	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
>  	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
>  	  NULL },
> +/* Set 17: iMac9,1 */
> +	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TH0P", "TL0P",
> +	  "TN0D", "TN0H", "TN0P", "TO0P", "Tm0P", "Tp0P", NULL },
> +/* Set 18: MacBookPro2,2 */
> +	{ "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "TM0P", "TTF0",
> +	  "Th0H", "Th1H", "Tm0P", "Ts0P", NULL },
>  };
>  
>  /* List of keys used to read/write fan speeds */
> @@ -1350,6 +1356,10 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
>  	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
>  /* MacPro3,1: temperature set 16 */
>  	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
> +/* iMac9,1: light sensor only, temperature set 17 */
> +	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
> +/* MacBookPro2,2: accelerometer, backlight and temperature set 18 */
> +	{ .accelerometer = 1, .light = 1, .temperature_set = 18 },
>  };
>  
>  /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
> @@ -1375,6 +1385,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
>  	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>  	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
>  		&applesmc_dmi_data[9]},
> +	{ applesmc_dmi_match, "Apple MacBookPro2,2", {
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Computer, Inc."),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2") },
> +		&applesmc_dmi_data[18]},
>  	{ applesmc_dmi_match, "Apple MacBook Pro", {
>  	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
>  	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
> @@ -1415,6 +1429,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
>  	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>  	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
>  		&applesmc_dmi_data[4]},
> +	{ applesmc_dmi_match, "Apple iMac9,1", {
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1") },
> +		&applesmc_dmi_data[17]},
>  	{ applesmc_dmi_match, "Apple iMac 8", {
>  	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>  	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },

Patch applied, queued for 2.6.34, thanks.

Nicolas, as the maintainer of this driver, I would like to get your
ack, at least.

-- 
Jean Delvare
