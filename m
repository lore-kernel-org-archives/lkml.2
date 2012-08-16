Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2HPSmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:42:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59845 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2HPSm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:42:29 -0400
Message-ID: <502D3F10.1020509@wwwdotorg.org>
Date: Thu, 16 Aug 2012 12:42:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/3] pwm_backlight: use power sequences
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com> <1345097337-24170-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1345097337-24170-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 12:08 AM, Alexandre Courbot wrote:
> Make use of the power sequences specified in the device tree or platform
> data to control how the backlight is powered on and off.

> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt

>  Required properties:
>    - compatible: "pwm-backlight"
> -  - pwms: OF device-tree PWM specification (see PWM binding[0])
>    - brightness-levels: Array of distinct brightness levels. Typically these
>        are in the range from 0 to 255, but any range starting at 0 will do.
>        The actual brightness level (PWM duty cycle) will be interpolated
> @@ -10,19 +9,72 @@ Required properties:
>        last value in the array represents a 100% duty cycle (brightest).
>    - default-brightness-level: the default brightness level (index into the
>        array defined by the "brightness-levels" property)
> +  - pwms: OF device-tree PWM specification (see PWM binding[0]). Exactly one PWM
> +      must be specified

There's probably no need to move that entry just to change it?

>  Optional properties:
> -  - pwm-names: a list of names for the PWM devices specified in the
> -               "pwms" property (see PWM binding[0])

> +  - *-supply: regulators used within a power sequence
> +  - *-gpio: GPIOs used within a power sequence

I don't think these really warrant mentioning here; such properties are
part of the standard regulator and GPIO bindings, and are required as a
side-effect of a power sequence using a resource of those types, rather
than being something actively defined or needed directly by the
pwm-backlight binding.

> +  - pwm-names: name for the PWM device specified in the "pwms" property (see PWM
> +      binding[0]). Necessary if power sequences are used

> +  - power-on-sequence: Power sequence (see Power sequences[1]) used to bring the
> +      backlight on. This sequence must reference the PWM specified in the pwms
> +      property by its name. It can also reference other resources supported by
> +      the power sequences mechanism
> +  - power-off-sequence: Power sequence (see Power sequences[1]) used to bring
> +      the backlight off. This sequence must reference the PWM specified in the
> +      pwms property by its name. It can also reference other resources supported
> +      by the power sequences mechanism

For these two, I would personally simply say that the pwm-backlight
binding requires that two power sequences named "on" and "off" must
exists, and are to defined according to [1].

>  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> +[1]: Documentation/devicetree/bindings/power_seq/power_seq.txt
