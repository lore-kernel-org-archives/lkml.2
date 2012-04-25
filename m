Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab2DYPsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:48:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55710 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2DYPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:48:37 -0400
Message-ID: <4F981CD1.2050007@wwwdotorg.org>
Date: Wed, 25 Apr 2012 09:48:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCHv4 1/2] drivers: input: keypad: Add device tree support
References: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 03:26 AM, Sourav Poddar wrote:
> Update the Documentation with omap4 keypad device tree
> binding information.
> Add device tree support for omap4 keypad driver.

> diff --git a/Documentation/devicetree/bindings/input/omap-keypad.txt b/Documentation/devicetree/bindings/input/omap-keypad.txt

> +Required Board Specific Properties, in addition to those specified by
> +the shared matrix-keyboard bindings:
> +- keypad,num-rows: Number of row lines connected to the keypad
> +  controller.
> +
> +- keypad,num-columns: Number of column lines connected to the
> +  keypad controller.

I'm not sure if "keypad," is the appropriate prefix here. If the
properties are specific to this one TI/OMAP binding, "ti," might be a
better prefix. However, if they're more generally applicable, maybe
"linux," to match "linux,keymap"?

> +Optional Properties specific to linux:
> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.

It's probably worth considering whether num-rows/columns should be part
of matrix-keyboard.txt, and whether linux,keypad-no-autorepeat should be
part of some core keyboard binding. Some of the properties in
tegra-kbc.txt might be worth generalizing too (debounce/repeat delay,
ghost filter)?

> +Example:
> +        keypad@4ae1c000{
> +                compatible = "ti,omap4-keypad";
> +                keypad,num-rows = <2>;
> +                keypad,num-columns = <8>;
> +		linux,keypad-no-autorepeat;
> +	};
