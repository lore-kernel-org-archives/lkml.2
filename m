Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422971Ab2LFKBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:01:42 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab2LFKBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:01:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 3/3] leds: leds-pwm: Add device tree bindings
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1352731270-27534-4-git-send-email-peter.ujfalusi@ti.com>
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-4-git-send-email-peter.ujfalusi@ti.com>
Date: Thu, 06 Dec 2012 10:00:52 +0000
Message-Id: <20121206100052.EC8293E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 15:41:10 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Support for device tree booted kernel.
> When the kernel is booted with DeviceTree blob we support one led per
> leds-pwm device to have cleaner integration with the PWM subsystem.
> 
> For usage see:
> Documentation/devicetree/bindings/leds/leds-pwm.txt
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  .../devicetree/bindings/leds/leds-pwm.txt          |  34 ++++++
>  drivers/leds/leds-pwm.c                            | 125 +++++++++++++++------
>  2 files changed, 127 insertions(+), 32 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt
> 
> diff --git a/Documentation/devicetree/bindings/leds/leds-pwm.txt b/Documentation/devicetree/bindings/leds/leds-pwm.txt
> new file mode 100644
> index 0000000..9fe3040
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/leds-pwm.txt
> @@ -0,0 +1,34 @@
> +LED connected to PWM
> +
> +Required properties:
> +- compatible : should be "pwm-leds".
> +- pwms : PWM property, please refer to: 
> +  Documentation/devicetree/bindings/pwm/pwm.txt
> +- pwm-names : (optional) Name to be used by the PWM subsystem for the PWM device
> +- label : (optional) The label for this LED.  If omitted, the label is
> +  taken from the node name (excluding the unit address).
> +- max-brightness : Maximum brightness possible for the LED
> +- linux,default-trigger :  (optional) This parameter, if present, is a
> +  string defining the trigger assigned to the LED.  Current triggers are:
> +    "backlight" - LED will act as a back-light, controlled by the framebuffer
> +		  system
> +    "default-on" - LED will turn on, but see "default-state" below
> +    "heartbeat" - LED "double" flashes at a load average based rate
> +    "ide-disk" - LED indicates disk activity
> +    "timer" - LED flashes at a fixed, configurable rate

The binding mostly looks good. However, it seems to be gratuitously
different from the gpio-leds binding and it duplicates property
definitions. Please match the gpio-leds behaviour with each led defined
as a sub node of the pwm-leds node.

Also, please reference the common properties in bindings/leds/common.txt
(This is a new file in linux-next. See how leds-gpio references it).

Otherwise the binding looks okay to me.

