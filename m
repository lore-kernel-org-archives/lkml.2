Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1DRJZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:25:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57984 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1DRJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:25:41 -0400
Message-ID: <4DAC0390.9050205@chamonix.reportlab.co.uk>
Date: Mon, 18 Apr 2011 10:25:36 +0100
From: Robin Becker <robin@reportlab.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Nicolas Pitre <nico@fluxnic.net>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: arm: mach-kirkwood: Make the red led available on the eSATA SheevaPlug
References: <20110416220842.GA1518@pequod.mess.org>
In-Reply-To: <20110416220842.GA1518@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/2011 23:08, Sean Young wrote:
> After this patch:
>
>          7780c80 arm: mach-kirkwood: add led in sheevaplug-setup.c
>
> On a eSATA SheevaPlug, neither the red nor the green led can be controlled,
> since probing fails with:
>
> [    6.188278] leds-gpio: probe of leds-gpio failed with error -22
>
> Signed-off-by: Sean Young<sean@mess.org>
>
> diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
> index 17de0bf..92db979 100644
> --- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
> +++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
> @@ -94,6 +94,7 @@ static unsigned int sheevaplug_mpp_config[] __initdata = {
>   static unsigned int sheeva_esata_mpp_config[] __initdata = {
>   	MPP29_GPIO,	/* USB Power Enable */
>   	MPP44_GPIO,	/* SD Write Protect */
> +	MPP46_GPIO,	/* LED Red */
>   	MPP47_GPIO,	/* SD Card Detect */
>   	MPP49_GPIO,	/* LED Green */
>   	0
>

I think my original patch had some changes to gpio_led sheevaplug_led_pins as 
well. It definitely works on my standard sheeva plug. In fact I have three 
controllable leds at 46, 48 & 49. GPIO 45 is also an led, but is also grounded 
so is permanently on. This is something like the patch I am using with plugbox

diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/
index d2eec35..e14893b 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -58,7 +58,19 @@

  static struct gpio_led sheevaplug_led_pins[] = {
     {
-       .name           = "plug:green:health",
+       .name           = "status:red:misc",
+       .default_trigger    = "none",
+       .gpio           = 46,
+       .active_low     = 1,
+   },
+   {
+       .name           = "status:green:health",
+       .default_trigger    = "none",
+       .gpio           = 48,
+       .active_low     = 1,
+   },
+   {
+       .name           = "status:blue:health",
         .default_trigger    = "default-on",
         .gpio           = 49,
         .active_low     = 1,
@@ -80,7 +92,9 @@

  static unsigned int sheevaplug_mpp_config[] __initdata = {
     MPP29_GPIO, /* USB Power Enable */
-   MPP49_GPIO, /* LED */
+   MPP46_GPIO, /* LED Red Misc */
+   MPP48_GPIO, /* LED Green Health */
+   MPP49_GPIO, /* LED Blue Health */
     0
  };


-- 
Robin Becker
