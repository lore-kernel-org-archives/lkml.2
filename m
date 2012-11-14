Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2KNBFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:05:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61955 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2KNBFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:05:34 -0500
MIME-Version: 1.0
In-Reply-To: <1352755511-28436-2-git-send-email-marek.belisko@open-nandra.com>
References: <1352755511-28436-1-git-send-email-marek.belisko@open-nandra.com> <1352755511-28436-2-git-send-email-marek.belisko@open-nandra.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Nov 2012 17:05:12 -0800
Message-ID: <CAK5ve-L=SBFEfoY8oKYYb-dFCWf=-Eb-qMFdWdiBO3wfaR3tDA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Add documentation for tca6507 devicetree bindings.
To: Marek Belisko <marek.belisko@open-nandra.com>,
        Stephen Warren <swarren@nvidia.com>
Cc: rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks fine to me, but I need a DT maintainer's ack. Stephen, could
you help on this. I will merge this patch via my tree.

Thanks,
-Bryan

On Mon, Nov 12, 2012 at 1:25 PM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:
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
> +                 system
> +    "default-on" - LED will turn on
> +    "heartbeat" - LED "double" flashes at a load average based rate
> +    "ide-disk" - LED indicates disk activity
> +    "timer" - LED flashes at a fixed, configurable rate
> +
> +Examples:
> +
> +tca6507@45 {
> +       compatible = "ti,tca6507";
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +       reg = <0x45>;
> +
> +       led0: red_aux@0 {
> +               label = "red:aux";
> +               reg = <0x0>;
> +       };
> +
> +       led1: green_aux@1 {
> +               label = "green:aux";
> +               reg = <0x5>;
> +               linux,default-trigger = "default-on";
> +       };
> +
> +};
> +
> --
> 1.7.9.5
>
