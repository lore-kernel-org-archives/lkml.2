Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2LSLkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:40:42 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41253 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2LSLkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:40:35 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 7/7] leds: leds-pwm: Add device tree bindings
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
In-Reply-To: <1355303092-15523-8-git-send-email-peter.ujfalusi@ti.com>
References: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com> <1355303092-15523-8-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 19 Dec 2012 11:40:30 +0000
Message-Id: <20121219114030.9AC133E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for this work. Comments below...

On Wed, 12 Dec 2012 10:04:52 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Support for device tree booted kernel.
> 
> For usage see:
> Documentation/devicetree/bindings/leds/leds-pwm.txt
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

About commit text: Remember that commit text is the first thing people
are going to see when looking over what changed in a given subsystem. It
is also where maintainers like me look first when trying to decide if a
patch makes sense before applying it. When commit text is bare-bones
like the above and the patch is non-trivial, then I end up trying to
reconstruct your though process or rational for a patch.

So, please, if it is anything beyond a trivial patch then tell us more
than simply "support for device tree booted kernel". What platform did
you make the change for? How was it tested? Are there any notable design
decisions that you made when adding this support? Are there any missing
pieces or possible bugs?

I'm picking on you at the moment, but this is a general comment. The
commit text is where you get to convince me that the patch is needed and
tell me about how it was designed. This is really important information;
particularly for poor random user, bisecting his broken kernel and
landing on your commit. In this small way, you can make her Christmas
merrier this year.


> ---
>  .../devicetree/bindings/leds/leds-pwm.txt          |  48 +++++++++
>  drivers/leds/leds-pwm.c                            | 112 +++++++++++++++++----
>  2 files changed, 140 insertions(+), 20 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt
> 
> diff --git a/Documentation/devicetree/bindings/leds/leds-pwm.txt b/Documentation/devicetree/bindings/leds/leds-pwm.txt
> new file mode 100644
> index 0000000..7297107
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/leds-pwm.txt
> @@ -0,0 +1,48 @@
> +LED connected to PWM
> +
> +Required properties:
> +- compatible : should be "pwm-leds".
> +
> +Each LED is represented as a sub-node of the pwm-leds device.  Each
> +node's name represents the name of the corresponding LED.
> +
> +LED sub-node properties:
> +- pwms : PWM property to point to the PWM device (phandle)/port (id) and to
> +  specify the period time to be used: <&phandle id period_ns>;
> +- pwm-names : (optional) Name to be used by the PWM subsystem for the PWM device
> +  For the pwms and pwm-names property please refer to:
> +  Documentation/devicetree/bindings/pwm/pwm.txt
> +- max-brightness : Maximum brightness possible for the LED
> +- label :  (optional)
> +  see Documentation/devicetree/bindings/leds/common.txt
> +- linux,default-trigger :  (optional)
> +  see Documentation/devicetree/bindings/leds/common.txt
> +
> +Example:
> +
> +twl_pwm: pwm {
> +	/* provides two PWMs (id 0, 1 for PWM1 and PWM2) */
> +	compatible = "ti,twl6030-pwm";
> +	#pwm-cells = <2>;
> +};
> +
> +twl_pwmled: pwmled {
> +	/* provides one PWM (id 0 for Charing indicator LED) */
> +	compatible = "ti,twl6030-pwmled";
> +	#pwm-cells = <2>;
> +};
> +
> +pwmleds {
> +	compatible = "pwm-leds";
> +	kpad {
> +		label = "omap4::keypad";
> +		pwms = <&twl_pwm 0 7812500>;
> +		max-brightness = <127>;
> +	};
> +
> +	charging {
> +		label = "omap4:green:chrg";
> +		pwms = <&twl_pwmled 0 7812500>;
> +		max-brightness = <255>;
> +	};

Acked-by: Grant Likely <grant.likely@secretlab.ca>

