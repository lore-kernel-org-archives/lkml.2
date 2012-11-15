Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768671Ab2KOSMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:12:40 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59603 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768656Ab2KOSMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:12:38 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 2/2] Add documentation for tca6507 devicetree bindings.
To: Marek Belisko <marek.belisko@open-nandra.com>, cooloney@gmail.com,
        rpurdie@rpsys.net
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Marek Belisko <marek.belisko@open-nandra.com>
In-Reply-To: <1352755511-28436-2-git-send-email-marek.belisko@open-nandra.com>
References: <1352755511-28436-1-git-send-email-marek.belisko@open-nandra.com> <1352755511-28436-2-git-send-email-marek.belisko@open-nandra.com>
Date: Thu, 15 Nov 2012 18:12:34 +0000
Message-Id: <20121115181234.37B173E199F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 22:25:11 +0100, Marek Belisko <marek.belisko@open-nandra.com> wrote:
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  Documentation/devicetree/bindings/leds/tca6507.txt |   40 ++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/tca6507.txt
> 
> diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
> new file mode 100644
> index 0000000..a49eb0c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/tca6507.txt
> @@ -0,0 +1,40 @@
> +LEDs conected to tca6507
> +
> +Required properties:
> +- compatible : should be : "ti,tca6507".
> +
> +Each led is represented as a sub-node of the ti,tca6507 device.
> +
> +LED sub-node properties:
> +- label : label for this LED
> +- reg : number of LED line (could be from 0 to 6)
> +- linux,default-trigger :  (optional) This parameter, if present, is a
> +  string defining the trigger assigned to the LED.  Current triggers are:
> +    "backlight" - LED will act as a back-light, controlled by the framebuffer
> +		  system
> +    "default-on" - LED will turn on
> +    "heartbeat" - LED "double" flashes at a load average based rate
> +    "ide-disk" - LED indicates disk activity
> +    "timer" - LED flashes at a fixed, configurable rate

This is cut-and-paste from bindings/gpio/led.txt. It should be split
into a separate file and referenced by both bindings. Otherwise the
binding looks fine.

> +
> +Examples:
> +
> +tca6507@45 {
> +	compatible = "ti,tca6507";
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	reg = <0x45>;
> +
> +	led0: red_aux@0 {
> +		label = "red:aux";
> +		reg = <0x0>;
> +	};
> +
> +	led1: green_aux@1 {

Don't use underscores in node names. Use '-'. (There isn't a technical
reason for this. It is just convention)

g.

