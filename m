Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1KKKyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:54:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58169 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1KKKyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:54:36 -0500
MIME-Version: 1.0
In-Reply-To: <1321005998-17407-1-git-send-email-lars@metafoo.de>
References: <1321005998-17407-1-git-send-email-lars@metafoo.de>
Date: Fri, 11 Nov 2011 18:54:36 +0800
Message-ID: <CAA_GA1cqV9aRtWwrTCG_Yu54js+DnCMeUE94xuN6+_9YTfmX5w@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Fixup export.h includes
From: Bob Liu <lliubbo@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Frysinger <vapier@gentoo.org>, Sonic Zhang <sonic.zhang@analog.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 6:06 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> Commit 8dc7a9c84 ("blackfin: Add export.h to files using
> EXPORT_SYMBOL/THIS_MODULE") inserted some of the include statements into
> sections protected by an unrelated #if CONFIG_... statement. This can cause,
> depending on the configuration used, warnings like this one:
>
>        arch/blackfin/mach-bf537/boards/stamp.c:2940: warning: data definition has no type or storage class
>        arch/blackfin/mach-bf537/boards/stamp.c:2940: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL’
>        arch/blackfin/mach-bf537/boards/stamp.c:2940: warning: parameter names (without types) in function declaration
>
> This patch fixes it by moving the includes out of the #if protected sections.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/blackfin/mach-bf527/boards/cm_bf527.c  |    2 +-
>  arch/blackfin/mach-bf527/boards/ezbrd.c     |    2 +-
>  arch/blackfin/mach-bf537/boards/cm_bf537e.c |    2 +-
>  arch/blackfin/mach-bf537/boards/cm_bf537u.c |    2 +-
>  arch/blackfin/mach-bf537/boards/dnp5370.c   |    2 +-
>  arch/blackfin/mach-bf537/boards/pnav10.c    |    1 +
>  arch/blackfin/mach-bf537/boards/stamp.c     |    2 +-
>  arch/blackfin/mach-bf537/boards/tcm_bf537.c |    2 +-
>  8 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
> index c13065b..cd28969 100644
> --- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
> +++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
> @@ -8,6 +8,7 @@
>  */
>
>  #include <linux/device.h>
> +#include <linux/export.h>
>  #include <linux/platform_device.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
> @@ -811,7 +812,6 @@ static struct platform_device bfin_sport1_uart_device = {
>  #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
>  #include <linux/input.h>
>  #include <linux/gpio_keys.h>
> -#include <linux/export.h>
>
>  static struct gpio_keys_button bfin_gpio_keys_table[] = {
>        {BTN_0, GPIO_PF14, 1, "gpio-keys: BTN0"},
> diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
> index 2963c35..9f792ea 100644
> --- a/arch/blackfin/mach-bf527/boards/ezbrd.c
> +++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
> @@ -7,6 +7,7 @@
>  */
>
>  #include <linux/device.h>
> +#include <linux/export.h>
>  #include <linux/platform_device.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
> @@ -684,7 +685,6 @@ static struct platform_device bfin_sport1_uart_device = {
>  #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
>  #include <linux/input.h>
>  #include <linux/gpio_keys.h>
> -#include <linux/export.h>
>
>  static struct gpio_keys_button bfin_gpio_keys_table[] = {
>        {BTN_0, GPIO_PG0, 1, "gpio-keys: BTN0"},
> diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537e.c b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
> index 82e4cc3..604a430 100644
> --- a/arch/blackfin/mach-bf537/boards/cm_bf537e.c
> +++ b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
> @@ -8,6 +8,7 @@
>  */
>
>  #include <linux/device.h>
> +#include <linux/export.h>
>  #include <linux/etherdevice.h>
>  #include <linux/platform_device.h>
>  #include <linux/mtd/mtd.h>
> @@ -579,7 +580,6 @@ static struct platform_device bfin_sport1_uart_device = {
>
>  #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
>  #include <linux/bfin_mac.h>
> -#include <linux/export.h>
>  static const unsigned short bfin_mac_peripherals[] = P_MII0;
>
>  static struct bfin_phydev_platform_data bfin_phydev_data[] = {
> diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537u.c b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
> index e9f1964..d916b46 100644
> --- a/arch/blackfin/mach-bf537/boards/cm_bf537u.c
> +++ b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
> @@ -9,6 +9,7 @@
>
>  #include <linux/device.h>
>  #include <linux/etherdevice.h>
> +#include <linux/export.h>
>  #include <linux/platform_device.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
> @@ -544,7 +545,6 @@ static struct platform_device bfin_sport1_uart_device = {
>
>  #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
>  #include <linux/bfin_mac.h>
> -#include <linux/export.h>
>  static const unsigned short bfin_mac_peripherals[] = P_MII0;
>
>  static struct bfin_phydev_platform_data bfin_phydev_data[] = {
> diff --git a/arch/blackfin/mach-bf537/boards/dnp5370.c b/arch/blackfin/mach-bf537/boards/dnp5370.c
> index 5b22598..5f30722 100644
> --- a/arch/blackfin/mach-bf537/boards/dnp5370.c
> +++ b/arch/blackfin/mach-bf537/boards/dnp5370.c
> @@ -12,6 +12,7 @@
>  */
>
>  #include <linux/device.h>
> +#include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> @@ -49,7 +50,6 @@ static struct platform_device rtc_device = {
>
>  #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
>  #include <linux/bfin_mac.h>
> -#include <linux/export.h>
>  static const unsigned short bfin_mac_peripherals[] = P_RMII0;
>
>  static struct bfin_phydev_platform_data bfin_phydev_data[] = {
> diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
> index 1567dd8..aebd31c 100644
> --- a/arch/blackfin/mach-bf537/boards/pnav10.c
> +++ b/arch/blackfin/mach-bf537/boards/pnav10.c
> @@ -8,6 +8,7 @@
>
>  #include <linux/device.h>
>  #include <linux/etherdevice.h>
> +#include <linux/export.h>
>  #include <linux/platform_device.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index b04bfb5..13344c7 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -7,6 +7,7 @@
>  */
>
>  #include <linux/device.h>
> +#include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> @@ -2002,7 +2003,6 @@ static struct adp8870_backlight_platform_data adp8870_pdata = {
>
>  #if defined(CONFIG_BACKLIGHT_ADP8860) || defined(CONFIG_BACKLIGHT_ADP8860_MODULE)
>  #include <linux/i2c/adp8860.h>
> -#include <linux/export.h>
>  static struct led_info adp8860_leds[] = {
>        {
>                .name = "adp8860-led7",
> diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
> index e58c9bc..6917ce2 100644
> --- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
> +++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
> @@ -9,6 +9,7 @@
>
>  #include <linux/device.h>
>  #include <linux/etherdevice.h>
> +#include <linux/export.h>
>  #include <linux/platform_device.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
> @@ -546,7 +547,6 @@ static struct platform_device bfin_sport1_uart_device = {
>
>  #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
>  #include <linux/bfin_mac.h>
> -#include <linux/export.h>
>  static const unsigned short bfin_mac_peripherals[] = P_MII0;
>
>  static struct bfin_phydev_platform_data bfin_phydev_data[] = {
> --
> 1.7.7.1
>
>

Thanks!  I'll pick it.

Acked-by: Bob Liu <lliubbo@gmail.com>

-- 
Regards,
--Bob
